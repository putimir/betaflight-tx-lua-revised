
return {
   read           = 94, -- MSP_PID_ADVANCED
   write          = 95, -- MSP_SET_PID_ADVANCED
   title          = "Rates (2/2)",
   reboot         = false,
   eepromWrite    = true,
   minBytes       = 23,
   text = {
      { t = "Anti-Gravity",       x =  35, y =  68, to = NORMSIZE },
      { t = "Gain",               x =  35, y =  96, to = SMLSIZE },
      { t = "Threshold",          x =  35, y = 124, to = SMLSIZE },
      { t = "Dterm Setpoint",     x = 200, y =  68, to = NORMSIZE },
      { t = "Weight",             x = 200, y =  96, to = SMLSIZE },
      { t = "Transition",         x = 200, y = 124, to = SMLSIZE },
      { t = "VBAT Compensation",  x =  35, y = 172, to = SMLSIZE }
   },
   fields = {
      --  GAIN
      { x = 129, y =  96, min = 1000, max = 30000, vals = { 22, 23 }, scale = 1000, mult = 1000, to = SMLSIZE },
      --  THRESHOLD
      { x = 129, y = 124, min = 20, max = 1000, vals = { 20, 21 }, to = SMLSIZE },
      --  WEIGHT
      { x = 300, y =  96, min = 0, max = 254, vals = { 10 }, scale = 100, to = SMLSIZE },
      --  TRANSITION
      { x = 300, y = 124, min = 0, max = 100, vals = { 9 }, scale = 100, to = SMLSIZE },
      --  VBAT COMPENSATION
      { x = 200, y = 172, min = 0, max = 1, vals = { 8 }, table = { [0]="OFF", "ON" }, to = SMLSIZE },
   }
}