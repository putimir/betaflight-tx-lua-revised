
-- Protocol version
MSP_VERSION = bit32.lshift(1,5)

MSP_STARTFLAG = bit32.lshift(1,4)

-- CRSF Devices
CRSF_ADDRESS_BETAFLIGHT          = 0xC8
CRSF_ADDRESS_RADIO_TRANSMITTER   = 0xEA

-- CRSF Frame Types
CRSF_FRAMETYPE_MSP_REQ           = 0x7A      -- response request using msp sequence as command
CRSF_FRAMETYPE_MSP_RESP          = 0x7B      -- reply with 60 byte chunked binary
CRSF_FRAMETYPE_MSP_WRITE         = 0x7C      -- write with 60 byte chunked binary 

MSP_PAYLOAD_SIZE                = 58

-- Sequence number for next MSP packet
local mspSeq = 0
local mspRemoteSeq = 0

local crsfMspCmd = 0
local crsfMspHeader = {}
local mspRxBuf = {}
local mspRxIdx = 1
local mspRxCRC = 0
local mspStarted = false
local mspLastReq = 0
local debug = true

-- Stats
mspRequestsSent    = 0
mspRepliesReceived = 0
mspPkRxed = 0
mspErrorPk = 0
mspStartPk = 0
mspOutOfOrder = 0
mspCRCErrors = 0
mspPendingRequest = false

local function mspResetStats()
   mspRequestsSent    = 0
   mspRepliesReceived = 0
   mspPkRxed = 0
   mspErrorPk = 0
   mspStartPk = 0
   mspOutOfOrderPk = 0
   mspCRCErrors = 0
end

local mspTxBuf = {}
local mspTxIdx = 1
local mspTxCRC = 0

local mspTxPk = 0

local function mspSendCrossfire(payload)

   local payloadOut = { CRSF_ADDRESS_BETAFLIGHT, CRSF_ADDRESS_RADIO_TRANSMITTER }

   for i=1, #(payload) do
      payloadOut[i+2] = payload[i]
   end

   if debug then
      local f = io.open(logFile,"a")
      local out = string.format("TX:0x%0X,", crsfMspCmd)
      if f then
         for i=1, #(payloadOut) do
            out = out .. string.format("0x%0X",payloadOut[i])
            if i < #(payloadOut) then
               out = out .. ","
            end
         end
      end
      out = out .. "\n"
      io.write(f, out)
      io.close(f)
   end

   crossfireTelemetryPush(crsfMspCmd, payloadOut)
   mspTxPk = mspTxPk + 1

end

function mspProcessTxQ()

   if (#(mspTxBuf) == 0) then
      return false
   end

   if not crossfireTelemetryPush() then
      return true
   end

   local payload = {}
   payload[1] = mspSeq + MSP_VERSION
   mspSeq = bit32.band(mspSeq + 1, 0x0F)

   if mspTxIdx == 1 then
      -- start flag
      payload[1] = payload[1] + MSP_STARTFLAG
   end

   local i = 2
   while (i <= MSP_PAYLOAD_SIZE) do
      if mspTxIdx > #(mspTxBuf) then
         break
      end
      payload[i] = mspTxBuf[mspTxIdx]
      mspTxIdx = mspTxIdx + 1
      mspTxCRC = bit32.bxor(mspTxCRC,payload[i])  
      i = i + 1
   end

   if i <= MSP_PAYLOAD_SIZE then
      payload[i] = mspTxCRC
      --i = i + 1

      -- zero fill
      --while i <= MSP_PAYLOAD_SIZE do
      --   payload[i] = 0
      --   i = i + 1
      --end

      mspSendCrossfire(payload)
      
      mspTxBuf = {}
      mspTxIdx = 1
      mspTxCRC = 0
      
      return false
   end
      
   mspSendCrossfire(payload)
   return true
end

function mspReadPackage(cmd)
   crsfMspCmd = CRSF_FRAMETYPE_MSP_REQ
   return mspSendRequest(cmd, {})
end

function mspWritePackage(cmd, payload)
   crsfMspCmd = CRSF_FRAMETYPE_MSP_WRITE
   return mspSendRequest(cmd, payload)
end

function mspSendRequest(cmd, payload)

   -- busy
   if #(mspTxBuf) ~= 0 or not cmd then
      return nil
   end

   mspTxBuf[1] = #(payload)
   mspTxBuf[2] = bit32.band(cmd,0xFF)  -- MSP command

   for i=1,#(payload) do
      mspTxBuf[i+2] = bit32.band(payload[i],0xFF)
   end

   mspLastReq = cmd
   mspRequestsSent = mspRequestsSent + 1
   return mspProcessTxQ()
end

local function mspReceivedReply(payload)

   mspPkRxed = mspPkRxed + 1
   
   local idx      = 1
   local head     = payload[idx]
   local err_flag = (bit32.band(head,0x20) ~= 0)
   idx = idx + 1

   if err_flag then
      -- error flag set
      mspStarted = false

      mspErrorPk = mspErrorPk + 1

      return nil
   end
   
   local start = (bit32.band(head,0x10) ~= 0)
   local seq   = bit32.band(head,0x0F)

   if start then
      -- start flag set
      mspRxIdx = 1
      mspRxBuf = {}

      mspRxSize = payload[idx]
      mspRxCRC  = bit32.bxor(mspRxSize,mspLastReq)
      idx = idx + 1
      mspStarted = true
      
      mspStartPk = mspStartPk + 1

   elseif not mspStarted then
      mspOutOfOrder = mspOutOfOrder + 1
      return nil

   elseif bit32.band(mspRemoteSeq + 1, 0x0F) ~= seq then
      mspOutOfOrder = mspOutOfOrder + 1
      mspStarted = false
      return nil
   end

   while (idx <= MSP_PAYLOAD_SIZE) and (mspRxIdx <= mspRxSize) do
      mspRxBuf[mspRxIdx] = payload[idx]
      mspRxCRC = bit32.bxor(mspRxCRC,payload[idx])
      mspRxIdx = mspRxIdx + 1
      idx = idx + 1
   end

   if idx > MSP_PAYLOAD_SIZE then
      mspRemoteSeq = seq
      return true
   end

   -- check CRC
   if mspRxCRC ~= payload[idx] then
      mspStarted = false
      mspCRCErrors = mspCRCErrors + 1
      return nil
   end

   mspRepliesReceived = mspRepliesReceived + 1
   mspStarted = false
   return mspRxBuf
end

function mspPollReply()
   while true do
      local command, data = crossfireTelemetryPop()
      if debug and command then
         local f = io.open(logFile,"a")
         local out = string.format("RX:0x%0X,", command)
         if f then
            for i=1, #(data) do
               out = out .. string.format("0x%0X",data[i])
               if i < #(data) then
                  out = out .. ","
               end
            end
         end
         out = out .. "\n"
         io.write(f, out)
         io.close(f)
      end
      if command == CRSF_FRAMETYPE_MSP_RESP then
         if data[1] == CRSF_ADDRESS_RADIO_TRANSMITTER and data[2] == CRSF_ADDRESS_BETAFLIGHT then

            local mspData = {}

            for i=3, #(data) do
                mspData[i-2] = data[i]
            end

            local ret = mspReceivedReply(mspData)

            if type(ret) == "table" then
               return mspLastReq,ret
            end
         end
      else
         break
      end
   end

   return nil
end

--
-- End of MSP/SPORT code
--
