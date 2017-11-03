
return {
   read           = 112, -- MSP_PID
   write          = 202, -- MSP_SET_PID
   title          = "PIDs",
   reboot         = false,
   eepromWrite    = true,
   minBytes       = 8,
   text = {
      { t = "P",      x = 129,  y =  68, to = SMLSIZE },
      { t = "I",      x = 209,  y =  68, to = SMLSIZE },
      { t = "D",      x = 289,  y =  68, to = SMLSIZE },
      { t = "ROLL",   x =  35,  y =  96, to = SMLSIZE },
      { t = "PITCH",  x =  35,  y = 124, to = SMLSIZE },
      { t = "YAW",    x =  35,  y = 152, to = SMLSIZE },
   },
   fields = {
      -- P
      { x = 129, y =  96, min = 0, max = 200, vals = { 1 }, to = SMLSIZE },
      { x = 129, y = 124, min = 0, max = 200, vals = { 4 }, to = SMLSIZE },
      { x = 129, y = 152, min = 0, max = 200, vals = { 7 }, to = SMLSIZE },
      -- I
      { x = 209, y =  96, min = 0, max = 200, vals = { 2 }, to = SMLSIZE },
      { x = 209, y = 124, min = 0, max = 200, vals = { 5 }, to = SMLSIZE },
      { x = 209, y = 152, min = 0, max = 200, vals = { 8 }, to = SMLSIZE },
      -- D
      { x = 289, y =  96, min = 0, max = 200, vals = { 3 }, to = SMLSIZE },
      { x = 289, y = 124, min = 0, max = 200, vals = { 6 }, to = SMLSIZE },
      --{ x = 289, y = 152, i =  9 },
   },
}