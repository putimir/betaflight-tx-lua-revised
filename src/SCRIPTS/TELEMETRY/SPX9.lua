screenPath = "/SCRIPTS/BF/X9/"

SetupPages = {}

PageFiles = {
    "pids.lua",
    "rates1.lua",
    "rates2.lua",
    "filters.lua",
    "pwm.lua",
    "vtx.lua"
}

MenuBox = { x=40, y=12, w=120, x_offset=36, h_line=8, h_offset=3 }
SaveBox = { x=40, y=12, w=120, x_offset=4,  h=30, h_offset=5 }
NoTelem = { 70, 55, "No Telemetry", BLINK }

local run_ui = assert(loadScript("/SCRIPTS/BF/ui_sp.lua"))()
return {run=run_ui}
