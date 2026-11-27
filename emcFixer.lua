local ACTIVE_FUEL_SLOT = 17

local function main()
    local dst = peripheral.wrap("front")

    while true do
        local activeFuel = dst.getItemCount(ACTIVE_FUEL_SLOT)
        if activeFuel == 0 then
            turtle.suckDown()
            turtle.drop()
        end
        
        os.sleep(1)
    end
end

main()