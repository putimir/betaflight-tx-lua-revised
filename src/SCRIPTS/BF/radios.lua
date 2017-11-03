
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
    },
    ["x12s"] = 
    {
        templateHome=SCRIPT_HOME.."/X12S/",
        preLoad=SCRIPT_HOME.."/X12S/x12spre.lua"
    },
    ["x12s-simu"] = 
    {
        templateHome=SCRIPT_HOME.."/X12S/",
        preLoad=SCRIPT_HOME.."/X12S/x12spre.lua"
    }
}

local ver, rad, maj, min, rev = getVersion()
local radio = supportedRadios[rad]

if not radio then
    error("Radio not supported: "..rad)
end

return radio
