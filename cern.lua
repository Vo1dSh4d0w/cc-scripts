local help = [[
USAGE: cern

CERN by Vo1dS4hd0w

Automation for Oritech Particle Accelerator.

Requirements:
- Turtle with environment detector

How to use:
Put two distinct items in the turtle's inventory.
Connect two inventories to the turtle (left and right).
Left inventory is used for the first item, right inventory is used for the second item.
Connect a redstone signal to the front of the turtle, connect it to a Particle Accelerator Speed Sensor set to "> [required speed]".

The turtle will automatically put the items at the correct timing.

]]

local function arrContains(arr, wanted)
    for _, value in ipairs(arr) do
        if value == wanted then
            return true
        end
    end
    return false
end

local function getFirstDistinctIndices()
    local indices = {}
    local processedItemNames = {}
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item ~= nil then
            local itemName = item["name"]
            if not arrContains(processedItemNames, itemName) then
                table.insert(indices, i)
                table.insert(processedItemNames, itemName)

                if #indices == 2 then
                    return indices
                end
            end
        end
    end
    return false
end

local function runAccelerator(indices)
    print("Running particle accelerator..")
    turtle.turnLeft()
    turtle.select(indices[1])
    print("Inserting first item..")
    turtle.drop(1)
    turtle.turnRight()

    os.sleep(0.2)
    turtle.turnRight()

    print("Waiting for speed..")

    while not redstone.getInput("left") do
        os.sleep(0.01)
    end

    print("Inserting second item..")
    turtle.select(indices[2])
    turtle.drop(1)
    turtle.turnLeft()
    print("Done.")
end

local function main()
    if arg[1] == "--help" or arg[1] == "-h" or arg[1] == "help" then
        print(help)
        return
    end
    
    print("CERN v1.0.0")
    print("Made by Vo1dS4hd0w")
    while true do
        local indices = getFirstDistinctIndices()
        if indices ~= false then
            runAccelerator(indices)
        end
        os.sleep(0.01)
    end
end

main()
