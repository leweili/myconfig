local application = require "hs.application"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local alert = require "hs.alert"
local grid = require "hs.grid"
local hints = require "hs.hints"
local applescript = require "hs.applescript"
-- hyper
-------------
--Spoons0
-------------
--speaker = hs.speech.new()
--speaker:speak("Hammerspoon is online")
--hotkey.bind("ctrl","0", function() speaker:speak("Hammerspoon is online")  end)

--hs.hotkey.bind({}, 'f', function()
--    hs.eventtap.keyStroke({'fn','ctrl'},'right')
--end)



-- hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.systemDefined}, function(event)
--     local type = event:getType()
--     if type == hs.eventtap.event.types.keyDown then
--         print(hs.keycodes.map[event:getKeyCode()])
--     elseif type == hs.eventtap.event.types.systemDefined then
--         local t = event:systemKey()
--         if t.down then
--             print("System key: " .. t.key)
--         end
--     end
-- end):start()



-- right shift to switch input source

local map = hs.keycodes.map
local keyDown = hs.eventtap.event.types.keyDown
local flagsChanged = hs.eventtap.event.types.flagsChanged
local keyStroke = hs.eventtap.keyStroke
local isCmdAsModifier = false
local function switchInputSourceEvent(event)
    local eventType = event:getType()
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()
    local isCmd = flags['shift']

    if eventType == keyDown then
        if isCmd then
            isCmdAsModifier = true
        end
    elseif eventType == flagsChanged then
        if not isCmd then
            if isCmdAsModifier == false then
                if keyCode == map['shift'] then
                    -- alert.show('left shift')
                elseif keyCode == map['rightShift'] then
                	-- alert.show('right shift')
                    -- hs.eventtap.keyStroke({"cmd"},"space",0)
                     hs.eventtap.event.newKeyEvent({'cmd'}, 'space', true):post()
                     hs.eventtap.event.newKeyEvent({''}, 'space', false):post()
                end
            end
            isCmdAsModifier = false
        end
    end
end
eventTap = hs.eventtap.new({keyDown, flagsChanged}, switchInputSourceEvent)
eventTap:start()


--rightcmd

hotkey.bind({}, 110, function() 
    local point = hs.mouse.getAbsolutePosition() 
    local clickState = hs.eventtap.event.properties.mouseEventClickState
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseDown"], point):setProperty(clickState, 1):post()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseUp"], point):setProperty(clickState, 1):post() 
end)




-- right mouse press start
local rightMouseDown = function()
    local point = hs.mouse.getAbsolutePosition() 
    local clickState = hs.eventtap.event.properties.mouseEventPressure
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseDown"], point):setProperty(clickState, 1):post()
end


local rightMouseUp = function() 
    local point = hs.mouse.getAbsolutePosition() 
    local clickState = hs.eventtap.event.properties.mouseEventPressure
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseUp"], point):setProperty(clickState, 0):post()
end

hotkey.bind({'alt'}, 110, rightMouseDown,rightMouseUp,nil)
-- hotkey.bind({'ctrl','shift'}, 'down', function() 
--     local point = hs.mouse.getAbsolutePosition() 
--     local clickState = hs.eventtap.event.properties.mouseEventPressure
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseDown"], point):setProperty(clickState, 1):post()
-- end)



-- hotkey.bind({'ctrl','shift'}, 'up', function() 
--     local point = hs.mouse.getAbsolutePosition() 
--     local clickState = hs.eventtap.event.properties.mouseEventPressure
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["rightMouseUp"], point):setProperty(clickState, 0):post()
-- end)
-- -- right mouse press end 


-- -- middle mouse press start

local middleMouseDown = function()
    local point = hs.mouse.getAbsolutePosition() 
    local clickState = hs.eventtap.event.properties.mouseEventPressure
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["otherMouseDown"], point):setProperty(clickState, 1):post()
end


local middleMouseUp = function() 
    local point = hs.mouse.getAbsolutePosition() 
    local clickState = hs.eventtap.event.properties.mouseEventPressure
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["otherMouseUp"], point):setProperty(clickState, 0):post()
end

hotkey.bind({'ctrl'}, 110, middleMouseDown,middleMouseUp,nil)

-- hotkey.bind({'ctrl','alt'}, 'down', function() 
--     local point = hs.mouse.getAbsolutePosition() 
--     local clickState = hs.eventtap.event.properties.mouseEventPressure
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["otherMouseDown"], point):setProperty(clickState, 1):post()
-- end)

-- hotkey.bind({'ctrl','alt'}, 'up', function() 
--     local point = hs.mouse.getAbsolutePosition() 
--     local clickState = hs.eventtap.event.properties.mouseEventPressure
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["otherMouseUp"], point):setProperty(clickState, 0):post()
-- end)
-- middle mouse press end 




-- Bind ctrl+t to open terminal in currentDir
hotkey.bind({"ctrl"}, "t", function()
    local app = hs.application.frontmostApplication()
    local windows = app:allWindows()
    local nextWin = nil
    -- Finder somehow has one more invisible window, so don't take it into account
    -- (only tested on Yosemite 10.10.1)
    if app:bundleID() == "com.apple.finder" then
        --hs.alert.show(hs.fs.currentDir())
        --hs.application.launchOrFocus("Terminal")
        local file = io.open("terminal", "r")
        local data = file:read("*a")
        file:close()
        applescript.applescript(data)
    end
end)


-- Bind ctrl+v to open vscode with currentDir
hotkey.bind({"ctrl"}, "v", function()
    local app = hs.application.frontmostApplication()
    local windows = app:allWindows()
    local nextWin = nil
    -- Finder somehow has one more invisible window, so don't take it into account
    -- (only tested on Yosemite 10.10.1)
    if app:bundleID() == "com.apple.finder" then
        --hs.alert.show(hs.fs.currentDir())
        --hs.application.launchOrFocus("Terminal")
        local file = io.open("vscode", "r")
        local data = file:read("*a")
        file:close()
        applescript.applescript(data)
    end
end)




-- -- Map the middle mouse to the alt key
-- eventtapOtherMouseDown = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(event)
--     if (event:getType() == hs.eventtap.event.types.otherMouseDown) then
--         hs.alert.show("otherMouseDown" .. event:getType())
--         return true, { hs.eventtap.event.newKeyEvent({ 'alt' }, hs.keycodes.map.alt, true) }
--     end
--     return false -- shouldn't ever reach here, but just in case
-- end):start()

-- eventtapOtherMouseUp = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp }, function(event)
--     if (event:getType() == hs.eventtap.event.types.otherMouseUp) then
--         hs.alert.show("otherMouseUp" .. event:getType())
--         return true, { hs.eventtap.event.newKeyEvent({ }, hs.keycodes.map.alt, false) }
--     end
--     return false -- shouldn't ever reach here, but just in case
-- end):start()
