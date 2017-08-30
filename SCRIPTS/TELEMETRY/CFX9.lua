assert(loadScript("/SCRIPTS/BF/ui_crsf.lua"))()

screenPath = "/SCRIPTS/BF/X9/"

logFile = "/SCRIPTS/BF/crsfOut.log"

SetupPages = {
   { screen = "pids.lua" },
   { screen = "rates1.lua" },
   { screen = "rates2.lua" },
   { screen = "filters.lua" },
   { screen = "pwm.lua" },
   { screen = "vtx.lua" }
}

MenuBox = { x=40, y=12, w=120, x_offset=36, h_line=8, h_offset=3 }
SaveBox = { x=40, y=12, w=120, x_offset=4,  h=30, h_offset=5 }
NoTelem = { 70, 55, "No Telemetry", BLINK }

menuStates = { ["Crossfire"] = 1, ["Betaflight"] = 2 }
currentMenuState = 2

debug = false

local devices = {}
local lineIndex = 1
local pageOffset = 0

local function createDevice(id, name)
  local device = {
    id = id,
    name = name,
    timeout = 0
  }
  return device
end

local function getDevice(name)
  for i=1, #devices do
    if devices[i].name == name then
      return devices[i]
    end
  end
  return nil
end

local function parseDeviceInfoMessage(data)
  local id = data[2]
  local name = ""
  local i = 3
  while data[i] ~= 0 do
    name = name .. string.char(data[i])
    i = i + 1
  end
  local device = getDevice(name)
  if device == nil then
    device = createDevice(id, name)
    devices[#devices + 1] = device
  end
  local time = getTime()
  device.timeout = time + 3000 -- 30s
  if lineIndex == 0 then
    lineIndex = 1
  end
end

local devicesRefreshTimeout = 0
local function refreshNext()
  local command, data = crossfireTelemetryPop()
  if command == nil then
    local time = getTime()
    if time > devicesRefreshTimeout then
      devicesRefreshTimeout = time + 100 -- 1s
      crossfireTelemetryPush(0x28, { 0x00, 0xEA })
    end
  elseif command == 0x29 then
    parseDeviceInfoMessage(data)
  end
end

local function selectDevice(step)
  lineIndex = 1 + ((lineIndex + step - 1 + #devices) % #devices)
end

-- Init
local function init()
  lineIndex = 0
  pageOffset = 0
  currentMenuState = 2
  if debug then
    local device = createDevice(0xC8,"Betaflight")
    devices[#devices+1]=device
  end
end

-- Main
local function run(event)
  if currentMenuState == menuStates["Crossfire"] then 
    if event == nil then
      error("Cannot be run as a model script!")
      return 2
    elseif event == EVT_EXIT_BREAK then
      return 2
    elseif event == EVT_PLUS_FIRST or event == EVT_PLUS_REPT then
      selectDevice(-1)
    elseif event == EVT_MINUS_FIRST or event == EVT_MINUS_REPT then
      selectDevice(1)
    end

    lcd.clear()
    --lcd.drawScreenTitle("CROSSFIRE SETUP", 0, 0)
    lcd.drawFilledRectangle(0, 0, LCD_W, 10)
    lcd.drawText(1,1,"Crossfire Setup",INVERS)
    if #devices == 0 then
      lcd.drawText(24, 28, "Waiting for Crossfire devices...")
    else
      for i=1, #devices do
        local attr = (lineIndex == i and INVERS or 0)     
        if event == EVT_ENTER_BREAK and attr == INVERS then 
            if devices[i].id == 0xC8 then
              currentMenuState = menuStates["Betaflight"]        
              break
            else
              crossfireTelemetryPush(0x28, { devices[i].id, 0xEA })
              return "/SCRIPTS/CROSSFIRE/device.lua"
            end
        end
        lcd.drawText(0, i*8+9, devices[i].name, attr)
      end
    end

    refreshNext()
    return 0
  else
    return run_bf_ui(event)
  end
end

return { init=init, run=run }
