return {
   read              = 90, -- MSP_ADVANCED_CONFIG
   write             = 91, -- MSP_SET_ADVANCED_CONFIG
   eepromWrite       = true,
   postRead          = postReadAdvanced,
   getWriteValues    = getWriteValuesAdvanced,
   title             = "PWM",
   text= {
      { t = "32K", x = 48, y = 14, to = SMLSIZE },
      { t = "Gyro Rt", x = 29, y = 24, to = SMLSIZE },
      { t = "PID Rt", x = 35, y = 34, to = SMLSIZE },
      { t = "Inversion", x = 20, y = 44, to = SMLSIZE },
      { t = "Protocol", x = 107, y = 14, to = SMLSIZE },
      { t = "Unsynced", x = 106, y = 24, to = SMLSIZE },
      { t = "PWM Rate", x = 105, y = 34, to = SMLSIZE },
      { t = "Idle Offset", x =94, y = 44, to = SMLSIZE }
   },
   fields = {
      { x = 65, y = 14, i = 9, min = 0, max = 1, to = SMLSIZE, table = { [0] = "OFF", "ON" }, upd = updateGyroTables },
      { x = 65, y = 24, i = 1, min = 1, max = 8, to = SMLSIZE },
      { x = 65, y = 34, i = 2, min = 1, max = 8, to = SMLSIZE },
      { x = 65, y = 44, i = 10, min = 0, max = 1, to = SMLSIZE, table = { [0] = "OFF", "ON" } },
      { x = 148, y = 14, i = 4, min = 0, max = 9, to = SMLSIZE, 
         table = { [0]="OFF", "ONESHOT125", "ONESHOT42", "MULTISHOT", 
                       "BRUSHED", "DSHOT150", "DSHOT300", "DSHOT600", 
                       "DSHOT1200", "PROSHOT1000" } },
      { x = 148, y = 24, i = 3, min = 0, max = 1, to = SMLSIZE, table = { [0] = "OFF", "ON" } },
      { x = 148, y = 34, i = 5, min = 200, max = 32000, to = SMLSIZE },
      { x = 148, y = 44, i = 7, min = 2000, max = 32000, to = SMLSIZE },
   },
   gyroTables = {
      [0] = { "8K", "4K", "2.67K", "2K", "1.6K", "1.33K", "1.14K", "1K" },
      [1] = { "32K", "16K", "10.67K", "8K", "4K", "2.67K", "2K", "1.6K" },
   },
}