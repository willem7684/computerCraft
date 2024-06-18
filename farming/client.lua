-- Client script for farming turtle
-- Define modem side and seed slot
local modemSide = "left"
local seedSlot = 1
rednet.open(modemSide)

-- Function to plant a seed
local function plantSeed()
    turtle.select(seedSlot)
    turtle.placeDown()
end

-- Function to check if a crop is ready to be harvested
local function isCropReady()
    local success, data = turtle.inspectDown()
    if success and data.name == "minecraft:wheat" and data.metadata == 7 then
        return true
    end
    return false
end

-- Function to farm a specific position
local function farmPosition(x, y)
    turtle.forward()
    if isCropReady() then
        turtle.digDown()
        plantSeed()
    end
end

-- Main loop
while true do
    rednet.send(rednet.lookup("server"), "request_task")
    local senderID, message = rednet.receive()
    if message.task == "farm" then
        -- Move to the assigned position (x, y)
        for i = 1, message.x - 1 do
            turtle.forward()
        end
        turtle.turnRight()
        for i = 1, message.y - 1 do
            turtle.forward()
        end
        turtle.turnLeft()
        
        farmPosition(message.x, message.y)
        
        -- Return to start position
        for i = 1, message.y - 1 do
            turtle.back()
        end
        turtle.turnLeft()
        for i = 1, message.x - 1 do
            turtle.back()
        end
        turtle.turnRight()
        
        rednet.send(senderID, {task = "done", x = message.x, y = message.y})
    elseif message.task == "wait" then
        sleep(10)
    end
end
