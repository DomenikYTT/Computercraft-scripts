local startupURL = "https://github.com/DomenikYTT/Computercraft-scripts/raw/refs/heads/main/train%20announcer%20Create%20Mod/startup.lua"
local configURL = "https://github.com/DomenikYTT/Computercraft-scripts/raw/refs/heads/main/train%20announcer%20Create%20Mod/config.lua"
local startup, config
local startupFile, configFile


startup = http.get(startupURL)
startupFile = startup.readAll()

local file1 = fs.open("startup.lua", "w")
file1.write(startupFile)
file1.close()


config = http.get(configURL)
configFile = config.readAll()

local file2 = fs.open("config.lua", "w")
file2.write(configFile)
file2.close()

print("The script was successfully installed.")
