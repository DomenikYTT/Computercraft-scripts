local libURL = "https://raw.githubusercontent.com/DomenikYTT/Computercraft-scripts/refs/heads/main/Draconic%20Energy%20Core/lib/library.lua"
local configURL = "https://raw.githubusercontent.com/DomenikYTT/Computercraft-scripts/refs/heads/main/Draconic%20Energy%20Core/config.lua"
local startupURL = "https://raw.githubusercontent.com/DomenikYTT/Computercraft-scripts/refs/heads/main/Draconic%20Energy%20Core/startup.lua"



local lib, config, startup
local libFile, configFile, startupFile


fs.makeDir("lib")

lib = http.get(libURL)
libFile = lib.readAll()

local file1 = fs.open("lib/library.lua", "w")
file1.write(libFile)
file1.close()


config = http.get(configURL)
configFile = config.readAll()

local file2 = fs.open("config.lua", "w")
file2.write(configFile)
file2.close()

startup = http.get(startupURL)
startupFile = startup.readAll()

local file3 = fs.open("startup.lua", "w")
file3.write(startupFile)
file3.close()