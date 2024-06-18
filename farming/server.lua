-- Server script for advanced computer
-- Pastebin code: 2ZPGz1h4
-- Define farm dimensions
local width = 5
local length = 5

-- Define modem side
local modemSide = "left"
rednet.open(modemSide)

-- Initialize farm state
local farm = {}
for x = 1, width do
    farm[x] = {}
    for y = 1, length do
        farm[x][y] = "empty"
    end
end

-- Function to handle messages from turtles
local function handleRequest(senderID, message)
    if message == "request_task" then
        for x = 1, width do
            for y = 1, length do
                if farm[x][y] == "empty" then
                    farm[x][y] = "assigned"
                    rednet.send(senderID, {task = "farm", x = x, y = y})
                    return
                end
            end
        end
        rednet.send(senderID, {task = "wait"})
    elseif type(message) == "table" and message.task == "done" then
        farm[message.x][message.y] = "empty"
    end
end

-- Main loop
while true do
    local senderID, message = rednet.receive()
    handleRequest(senderID, message)
end
