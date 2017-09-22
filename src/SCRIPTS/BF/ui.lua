
local MSP_REBOOT = 68
local MSP_EEPROM_WRITE = 250
local REQ_TIMEOUT = 80 -- 800ms request timeout

local PAGE_DISPLAY = 2
local EDITING      = 3
local PAGE_SAVING  = 4
local MENU_DISP    = 5

local gState = PAGE_DISPLAY

local currentPage = 1
local currentLine = 1
local saveTS = 0
local saveTimeout = 0
local saveRetries = 0
local saveMaxRetries = 0
local pageRequested = false

backgroundFill = backgroundFill or ERASE
foregroundColor = foregroundColor or SOLID
globalTextOptions = globalTextOptions or 0

local function saveSettings(new)
    local page = SetupPages[currentPage]
    if page.values then
        if page.preSave then
            page.preSave(page)
        end
        protocol.mspWrite(page.write, page.values)
        saveTS = getTime()
        if gState == PAGE_SAVING then
            saveRetries = saveRetries + 1
        else
            gState = PAGE_SAVING
            saveRetries = 0
            saveMaxRetries = protocol.saveMaxRetries or 2 -- default 2
            saveTimeout = protocol.saveTimeout or 150     -- default 1.5s
        end
    end
end

local function invalidatePages()
    SetupPages = {}
    gState = PAGE_DISPLAY
    saveTS = 0
end

local function rebootFc()
    protocol.mspRead(MSP_REBOOT)
    invalidatePages()
end

local function eepromWrite()
    protocol.mspRead(MSP_EEPROM_WRITE)
end

local menuList = {
    {   
        t = "save page",
        f = saveSettings 
    },
    {
        t = "reload",
        f = invalidatePages 
    },
    {
        t = "reboot",
        f = rebootFc 
    }
}

local telemetryScreenActive = false
local menuActive = false

local function processMspReply(cmd,rx_buf)

    if cmd == nil or rx_buf == nil then
        return
    end

    local page = SetupPages[currentPage]

    if cmd == page.write then
        if page.eepromWrite then
            eepromWrite()
        end
        pageRequested = false
        return
    end

    if cmd == MSP_EEPROM_WRITE then
        if page.reboot then
            rebootFc()
        end
        invalidatePages()
        gState = PAGE_DISPLAY
        saveTS = 0
        return
    end

    if cmd ~= page.read then
        return
    end

    if #(rx_buf) > 0 then
        page.values = {}
        for i=1,#(rx_buf) do
            page.values[i] = rx_buf[i]
        end
        if page.postLoad then
            page.postLoad(page)
        end
    end
end

local function MaxLines()
    return #(SetupPages[currentPage].fields)
end

local function incPage(inc)
    currentPage = currentPage + inc
    if currentPage > #(PageFiles) then
        currentPage = 1
    elseif currentPage < 1 then
        currentPage = #(PageFiles)
    end
    currentLine = 1
end

local function incLine(inc)
    currentLine = currentLine + inc
    if currentLine > MaxLines() then
        currentLine = 1
    elseif currentLine < 1 then
        currentLine = MaxLines()
    end
end

local function incMenu(inc)
    menuActive = menuActive + inc
     if menuActive > #(menuList) then
        menuActive = 1
    elseif menuActive < 1 then
        menuActive = #(menuList)
    end
end

local function requestPage(page)
    if page.read and ((page.reqTS == nil) or (page.reqTS + REQ_TIMEOUT <= getTime())) then
        page.reqTS = getTime()
        protocol.mspRead(page.read)
    end
end

function drawScreenTitle(screen_title)
    lcd.drawFilledRectangle(0, 0, LCD_W, 10)
    lcd.drawText(1,1,screen_title,INVERS)
end

local function drawScreen(page,page_locked)

    local screen_title = page.title

    drawScreenTitle("Betaflight / "..screen_title)

    for i=1,#(page.text) do
        local f = page.text[i]
        if f.to == nil then
            lcd.drawText(f.x, f.y, f.t, globalTextOptions)
        else
            lcd.drawText(f.x, f.y, f.t, f.to)
        end
    end

    local val = "---"

    for i=1,#(page.fields) do
        local f = page.fields[i]

        local text_options = globalTextOptions
        if i == currentLine then
            text_options = INVERS
            if gState == EDITING then
              text_options = text_options + BLINK
            end
        end

        local spacing = 20

        if f.t ~= nil then
            lcd.drawText(f.x, f.y, f.t .. ":", globalTextOptions)
            if f.sp ~= nil then
                spacing = f.sp
            end
        else
            spacing = 0
        end

        if page.values then
            if (#(page.values) or 0) >= page.minBytes then
                if not f.value and f.vals then
                    for idx=1, #(f.vals) do
                        f.value = bit32.bor((f.value or 0), bit32.lshift(page.values[f.vals[idx]], (idx-1)*8))
                    end
                    f.value = f.value/(f.scale or 1)
                end
            end
        end
   
        val = "---"
   
        if f.value then
            if f.upd and page.values then
                f.upd(page)
            end
            val = f.value
            if f.table and f.table[f.value] then
                val = f.table[f.value]
            end
        end
        lcd.drawText(f.x + spacing, f.y, val, text_options)

    end
end

local function clipValue(val,min,max)
    if val < min then
        val = min
    elseif val > max then
        val = max
    end
    return val
end

local function getCurrentField()
    local page = SetupPages[currentPage]
    return page.fields[currentLine]
end

local function incValue(inc)
    local page = SetupPages[currentPage]
    local f = page.fields[currentLine]
    local idx = f.i or currentLine
    local scale = (f.scale or 1)
    f.value = clipValue(f.value + ((inc*(f.mult or 1))/scale), (f.min/scale) or 0, (f.max/scale) or 255)
    for idx=1, #(f.vals) do
        page.values[f.vals[idx]] = bit32.rshift(f.value * scale, (idx-1)*8)
    end
    if f.upd and page.values then
        f.upd(page) 
    end
end

local function drawMenu()
    local x = MenuBox.x
    local y = MenuBox.y
    local w = MenuBox.w
    local h_line = MenuBox.h_line
    local h_offset = MenuBox.h_offset
    local h = #(menuList) * h_line + h_offset*2

    lcd.drawFilledRectangle(x,y,w,h,backgroundFill)
    lcd.drawRectangle(x,y,w-1,h-1,foregroundColor)
    lcd.drawText(x+h_line/2,y+h_offset,"Menu:",globalTextOptions)

    for i,e in ipairs(menuList) do
        local text_options = globalTextOptions
        if menuActive == i then
            text_options = text_options + INVERS
        end
        lcd.drawText(x+MenuBox.x_offset,y+(i-1)*h_line+h_offset,e.t,text_options)
    end
end

local lastRunTS = 0
local killEnterBreak = 0

function run_ui(event)

    local now = getTime()

    -- if lastRunTS old than 500ms
    if lastRunTS + 50 < now then
        invalidatePages()
    end
    lastRunTS = now

    if (gState == PAGE_SAVING) then
        if (saveTS + saveTimeout < now) then
            if saveRetries < saveMaxRetries then
                saveSettings()
            else
                -- max retries reached
                gState = PAGE_DISPLAY
                invalidatePages()
            end
        end
    end

    -- process send queue
    mspProcessTxQ()

    -- navigation
    if (event == EVT_MENU_LONG) then -- Taranis QX7 / X9
        menuActive = 1
        gState = MENU_DISP

    elseif EVT_PAGEUP_FIRST and (event == EVT_ENTER_LONG) then -- Horus
        menuActive = 1
        killEnterBreak = 1
        gState = MENU_DISP

    -- menu is currently displayed
    elseif gState == MENU_DISP then
        if event == EVT_EXIT_BREAK then
            gState = PAGE_DISPLAY
        elseif event == EVT_PLUS_BREAK or event == EVT_ROT_LEFT then
            incMenu(-1)
        elseif event == EVT_MINUS_BREAK or event == EVT_ROT_RIGHT then
            incMenu(1)
        elseif event == EVT_ENTER_BREAK then
            if killEnterBreak == 1 then
                killEnterBreak = 0
            else
                gState = PAGE_DISPLAY
                menuList[menuActive].f()
            end
        end
   -- normal page viewing
    elseif gState <= PAGE_DISPLAY then
        if event == EVT_PAGEUP_FIRST then
            SetupPages[currentPage] = nil
            incPage(-1)
        elseif event == EVT_MENU_BREAK or event == EVT_PAGEDN_FIRST then
            SetupPages[currentPage] = nil
            incPage(1)
        elseif event == EVT_PLUS_BREAK or event == EVT_ROT_LEFT then
            incLine(-1)
        elseif event == EVT_MINUS_BREAK or event == EVT_ROT_RIGHT then
            incLine(1)
        elseif event == EVT_ENTER_BREAK then
            local page = SetupPages[currentPage]
            local field = page.fields[currentLine]
            local idx = field.i or currentLine
            if page.values and page.values[idx] and (field.ro ~= true) then
                gState = EDITING
            end
        elseif event == EVT_EXIT_BREAK then
            return protocol.exitFunc();
        end
    -- editing value
    elseif gState == EDITING then
        if (event == EVT_EXIT_BREAK) or (event == EVT_ENTER_BREAK) then
            gState = PAGE_DISPLAY
        elseif event == EVT_PLUS_FIRST or event == EVT_PLUS_REPT or event == EVT_ROT_RIGHT then
            incValue(1)
        elseif event == EVT_MINUS_FIRST or event == EVT_MINUS_REPT or event == EVT_ROT_LEFT then
            incValue(-1)
        end
    end

    if SetupPages[currentPage] == nil then
        SetupPages[currentPage] = assert(loadScript(radio.templateHome .. PageFiles[currentPage]))()
    end

    local page_locked = false
    local page = SetupPages[currentPage]

    if not page.values and gState == PAGE_DISPLAY then
        requestPage(page)
        page_locked = true
    end

    lcd.clear()
    if TEXT_BGCOLOR then
        lcd.drawFilledRectangle(0, 0, LCD_W, LCD_H, TEXT_BGCOLOR)
    end

    drawScreen(page,page_locked)

    if protocol.rssi() == 0 then
        lcd.drawText(NoTelem[1],NoTelem[2],NoTelem[3],NoTelem[4])
    end

    if gState == MENU_DISP then
        drawMenu()
    elseif gState == PAGE_SAVING then
        lcd.drawFilledRectangle(SaveBox.x,SaveBox.y,SaveBox.w,SaveBox.h,backgroundFill)
        lcd.drawRectangle(SaveBox.x,SaveBox.y,SaveBox.w,SaveBox.h,SOLID)
        lcd.drawText(SaveBox.x+SaveBox.x_offset,SaveBox.y+SaveBox.h_offset,"Saving...",DBLSIZE + BLINK + (globalTextOptions))
    end

    processMspReply(mspPollReply())
    return 0
end

return run_ui 
