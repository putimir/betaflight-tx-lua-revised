
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

local ver, rad, maj, min, rev = getVersion()
local radio = supportedRadios[rad]

if not radio then
    error("Radio not supported: "..rad)
end

radio.persistHome = radio.templateHome.."PERSIST/"

return radio
