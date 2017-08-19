
return {
   read = 112, -- MSP_PID
   write = 202, -- MSP_SET_PID
   title = "PIDs",
   eepromWrite    = true,
   text = {
      { t = "P",      x =  72,  y = 14 },
      { t = "I",      x = 100,  y = 14 },
      { t = "D",      x = 128,  y = 14 },
      { t = "ROLL",   x =  25,  y = 26 },
      { t = "PITCH",  x =  25,  y = 36 },
      { t = "YAW",    x =  25,  y = 46 },
   },
   fields = {
      -- P
      { x =  66, y = 26, i =  1 },
      { x =  66, y = 36, i =  4 },
      { x =  66, y = 46, i =  7 },
      -- I
      { x =  94, y = 26, i =  2 },
      { x =  94, y = 36, i =  5 },
      { x =  94, y = 46, i =  8 },
      -- D
      { x = 122, y = 26, i =  3 },
      { x = 122, y = 36, i =  6 },
      --{ x = 122, y = 46, i =  9 },
   },
}