local help = [[
USAGE: emcFixer

EMC Fixer by Vo1dS4hd0w

Stupid ProjectE Energy Collector only pulls fuel from left to right when left inventory updates.
This will make sure that the collector receives an update when the fuel is empty.

Pulls fuel from the bottom into the Energy Collector in front.
]]

local ACTIVE_FUEL_SLOT = 17

local function main()
    if arg[1] == "--help" or arg[1] == "-h" or arg[1] == "help" then
        print(help)
        return
    end

    print("EMC Fixer v1.0.0")
    print("Made by Vo1dS4hd0w")

    local dst = peripheral.wrap("front")

    while true do
        local activeFuel = dst.getItemDetail(ACTIVE_FUEL_SLOT)
        if activeFuel == nil or activeFuel.count == 0 then
            turtle.suckDown()
            turtle.drop()
        end

        os.sleep(1)
    end
end

main()
