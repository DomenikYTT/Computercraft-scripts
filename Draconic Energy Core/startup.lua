
-- DONT TOUCH --
os.loadAPI("lib/library.lua")
os.loadAPI("config.lua")

local INPUT_GATES = config.INPUT_GATES

local OUTPUT_GATES = config.OUTPUT_GATES

local core_name = config.core_name

-- ==================== --
--        Code          --
-- ==================== --
local core = peripheral.wrap(core_name)

if not core then
    error("No Draconic Energy Core was Found!")
end

local monitors = {}
local initialized = {}

local function refreshMonitors()
    local found = library.getMonitors()

    for _, mon in ipairs(found) do
        local name = peripheral.getName(mon) or tostring(mon)

        if not initialized[name] then
            library.setBestScale(mon)
            initialized[name] = true
        end
    end

    monitors = found
end
local function getTier(maxStorage)
    local tiers = {
        {45000000, 1},
        {273000000, 2},
        {1640000000, 3},
        {9800000000, 4},
        {59000000000, 5},
        {355000000000, 6},
        {2147000000000, 7},
        {9223372036854775807, 8}
    }

    for _, t in ipairs(tiers) do
        if maxStorage <= t[1] then
            return t[2]
        end
    end

    return bestTier
end



local function sumFlow(gates)
    local total = 0

    for _, name in ipairs(gates) do
        local gate = peripheral.wrap(name)

        if gate and gate.getFlow then
            local ok, value = pcall(gate.getFlow)

            if ok and value then
                total = total + value
            end
        end
    end
    return total
end



local function updateMonitor(mon)
    local gateInput = sumFlow(INPUT_GATES)
    local gateOutput = sumFlow(OUTPUT_GATES)

    
    local energy = core.getEnergyStored()
    local maxEnergy = core.getMaxEnergyStored()

    local input = core.getInputPerTick()
    local output = core.getOutputPerTick()

    local tier = getTier(maxEnergy)

    local w, h = mon.getSize()

    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)
    mon.clear()

    local title = "DRACONIC ENERGY CORE"

    local centerX = math.floor((w - #title) / 2)

    local yTitle = math.max(1, math.floor(h * 0.05))
    local yInfo = math.max(5, math.floor(h * 0.35))

    mon.setCursorPos(centerX, yTitle)
    mon.write(title)

    local left = math.max(2, math.floor(w * 0.08))
    local value = math.max(14, math.floor(w * 0.35))

    local line = yInfo * 1.0

    mon.setCursorPos(left, line)
    mon.write("Tier:")
    mon.setCursorPos(value, line)
    mon.write(tostring(tier))

    line = line + 2

    mon.setCursorPos(left, line)
    mon.write("Stored:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(energy) .. " RF")

    line = line + 1

    mon.setCursorPos(left, line)
    mon.write("Capacity:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(maxEnergy) .. " RF")

    line = line + 2

    mon.setCursorPos(left, line)
    mon.write("Core In:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(input) .. " RF/t")

    line = line + 1

    mon.setCursorPos(left, line)
    mon.write("Core Out:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(output) .. " RF/t")

    line = line + 2

    mon.setCursorPos(left, line)
    mon.write("Gate In:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(gateInput) .. " RF/t")

    line = line + 1

    mon.setCursorPos(left, line)
    mon.write("Gate Out:")
    mon.setCursorPos(value, line)
    mon.write(library.formatNumber(gateOutput) .. " RF/t")
end

print("Displaying now the Informations.")
while true do
    refreshMonitors()
    for _, mon in ipairs(monitors) do
        local ok, err = pcall(function()
            updateMonitor(mon)
            
        end)

        if not ok then
            error(err)
        end
    end

    sleep(1)
end



--