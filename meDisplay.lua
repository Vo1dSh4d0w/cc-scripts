SI_UNITS = { "B", "KB", "MB", "GB", "TB" }

local function cellCapacity(cells)
    local total = 0
    for _, cell in ipairs(cells) do
        total = total + cell.bytes
    end
    return total
end

local function cellUsage(cells)
    local total = 0
    for _, cell in ipairs(cells) do
        total = total + cell.usedBytes
    end
    return total
end

local function format_si(number)
    local unit = 1
    while number >= 1024 do
        number = number / 1024
        unit = unit + 1
    end
    return number, SI_UNITS[unit]
end

local function drivesUsage(drives)
    local total = 0
    for _, drive in ipairs(drives) do
        total = total + #drive.cells
    end
    return total
end

local function colorByUsage(usage, capacity)
    if usage / capacity < 0.5 then
        return colors.green
    elseif usage / capacity < 0.8 then
        return colors.yellow
    else
        return colors.red
    end
end

local function format_int(number, decimals)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    -- reverse the int-string back remove an optional comma and put the
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction:sub(1, decimals)
end

local function writeWithColor(monitor, color, text)
    monitor.setTextColor(color)
    monitor.write(text)
    monitor.setTextColor(colors.white)
end

local function findPeripheralByType(peripherals, type)
    for _, peripheralAddress in ipairs(peripherals) do
        if peripheral.hasType(peripheralAddress, type) then
            return peripheralAddress
        end
    end
    return nil
end

local function main()
    local refreshRate = 5

    if #arg == 1 then
        refreshRate = tonumber(arg[1])
    end

    print("ME Display v1.0.0")
    print("Made by Vo1dSh4d0w")

    print("Scanning network for peripherals...")
    local peripherals = peripheral.getNames()

    local meBridgeAddress = findPeripheralByType(peripherals, "me_bridge")
    local monitorAddress = findPeripheralByType(peripherals, "monitor")

    local meBridge = peripheral.wrap(meBridgeAddress)
    if meBridge ~= nil then
        print("Connected to ME bridge: " .. meBridgeAddress)
    else
        print("No ME bridge found in network.")
    end
    local monitor = peripheral.wrap(monitorAddress)
    if monitor ~= nil then
        print("Connected to monitor: " .. monitorAddress)
    else
        print("No monitor found in network.")
    end

    monitor.setTextScale(2.5)

    while true do
        local cells = meBridge.getCells()
        local capacity, capacity_suffix = format_si(cellCapacity(cells))
        local usage, usage_suffix = format_si(cellUsage(cells))
        local free, free_suffix = format_si(cellCapacity(cells) - cellUsage(cells))

        local drives = meBridge.getDrives()
        local drives_count = #drives
        local drives_capacity = drives_count * 10
        local drives_usage = drivesUsage(drives)

        monitor.clear()
        monitor.setCursorPos(1, 1)
        writeWithColor(monitor, colors.lightBlue, format_int(usage, 3) .. " ")
        writeWithColor(monitor, colors.orange, usage_suffix)
        writeWithColor(monitor, colors.yellow, " / ")
        writeWithColor(monitor, colors.lightBlue, format_int(capacity, 3) .. " ")
        writeWithColor(monitor, colors.orange, capacity_suffix)
        monitor.setCursorPos(1, 3)

        writeWithColor(monitor, colors.purple, "Usage")
        writeWithColor(monitor, colors.yellow, ":  ")
        writeWithColor(monitor, colorByUsage(usage, capacity), format_int(usage / capacity * 100, 2))
        writeWithColor(monitor, colors.yellow, "%")

        monitor.setCursorPos(1, 4)
        writeWithColor(monitor, colors.purple, "Free")
        writeWithColor(monitor, colors.yellow, ":   ")
        writeWithColor(monitor, colors.lightBlue, format_int(free, 3) .. " ")
        writeWithColor(monitor, colors.orange, free_suffix)

        monitor.setCursorPos(1, 5)
        writeWithColor(monitor, colors.purple, "Drives")
        writeWithColor(monitor, colors.yellow, ": ")
        writeWithColor(monitor, colors.lightBlue, drives_count)

        monitor.setCursorPos(1, 7)
        writeWithColor(monitor, colors.purple, "Cells in drives")
        writeWithColor(monitor, colors.yellow, ":")
        monitor.setCursorPos(1, 9)
        writeWithColor(monitor, colors.lightBlue, drives_usage)
        writeWithColor(monitor, colors.yellow, " / ")
        writeWithColor(monitor, colors.lightBlue, drives_capacity)

        os.sleep(refreshRate)
    end
end

main()
