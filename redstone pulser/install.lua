local configURL = "https://raw.githubusercontent.com/DomenikYTT/Computercraft-scripts/refs/heads/main/redstone%20pulser/config.lua"
local startupURL = "https://raw.githubusercontent.com/DomenikYTT/Computercraft-scripts/refs/heads/main/redstone%20pulser/startup.lua"

local config, startup
local configFile, startupFile

config = http.get(configURL)
configFile = config.readAll()

local file1 = fs.open("config.lua", "w")
file1.write(configFile)
file1.close()

startup = http.get(startupURL)
startupFile = startup.readAll()

local file2 = fs.open("startup.lua", "w")
file2.write(startupFile)
file2.close()