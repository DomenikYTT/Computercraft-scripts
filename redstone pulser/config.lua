-- ==================== --
--      All Sides       --
--------------------------
--        bottom        --
--        right         --
--        left          --
--        top           --
--        front         --
--        back          --
-- ==================== --
local redstoneInputSide = "right" -- default: "right"
local redstoneOutputSide = "left" -- default: "left"

local redstoneOutputTimeInTicks = 1 -- default: 20 (20 ticks = 1 second)


-- ==================== --
--   DON'T TOUCH THIS   --
-- ==================== --
function getTime()
    return redstoneOutputTimeInTicks
end

function getOutputSide()
    return redstoneOutputSide
end

function getInputSide()
    return redstoneInputSide
end