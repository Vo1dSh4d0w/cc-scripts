local ACTIVE_FUEL_SLOT = 17

local function main()
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