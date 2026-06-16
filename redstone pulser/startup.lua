os.loadAPI("lib/f.lua")
os.loadAPI("config.lua")


local Time = config.getTime()

local input = config.getInputSide()

local output = config.getOutputSide()

Time = Time / 20

while true do
    os.pullEvent("redstone")
    if rs.getInput(input) == true then
        print("Firing a redstone pulse for " .. Time .. " Seconds...")
        rs.setOutput(output, true)
        sleep(Time)
        rs.setOutput(output, false)
        print("redstone signal was successfully send for " .. Time .. " Seconds...")
    end
    sleep(1)
end