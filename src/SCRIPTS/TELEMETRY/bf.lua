SCRIPT_HOME = "/SCRIPTS/BF"

SetupPages = {}
protocol = {}
radio = {}

supportedRadios = 
{
    ["x9d"] =     
    {
        templateHome    = SCRIPT_HOME.."/X9/",
        preLoad         = SCRIPT_HOME.."/X9/x9pre.lua"
    },
    ["x9d+"] =
    {
        templateHome    = SCRIPT_HOME.."/X9/",
        preLoad         = SCRIPT_HOME.."/X9/x9pre.lua"
    }
}

supportedProtocols =
{
    smartPort =
    {
        transport       = SCRIPT_HOME.."/MSP/sp.lua",
        rssi            = function() return getValue("RSSI") end,
        exitFunc        = function() return 0 end
    },
    crsf =
    {
        transport       = SCRIPT_HOME.."/MSP/crsf.lua",
        rssi            = function() return getValue("TQly") end,
        exitFunc        = function() return "/CROSSFIRE/crossfire.lua" end
    }
}

function getProtocol()
    if sportTelemetryPush() then
        return supportedProtocols.smartPort
    elseif crossfireTelemetryPush() then
        return supportedProtocols.crsf
    end
end

protocol = getProtocol()
local ver, rad, maj, min, rev = getVersion()
radio = supportedRadios[rad]

if not protocol then
    error("Telemetry protocol not supported!")
elseif not radio then
    error("Radio not supported: "..rad)
end

assert(loadScript(radio.preLoad))()
assert(loadScript(protocol.transport))()
local run = assert(loadScript(SCRIPT_HOME.."/ui.lua"))()

return { run=run }
