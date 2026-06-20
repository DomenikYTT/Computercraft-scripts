-- Seconds between all stations
local pollInterval = 1

local ShouldTheConfigUpdateLive = true -- requires a script restart everytime the other values not.

-- List with all Stations.
local stations = {
    {
        peripheralName = "Create_Station_2", -- Wired Modem Name
        station = "RFI HBF", -- Station Name
        time = 2, -- time to wait after departure
        speakers = { "speaker_5" }, -- all speakers as a list example: { "Speaker_X", "Speaker_Y" } (are the modem names)
        trains = { -- list of all trains that are coming into the station example "RE70" is coming into the station and the audio plays
            {
                train = "RE70", -- train name
                audio = "https://github.com/DomenikYTT/private/raw/refs/heads/main/RE70_zu_RFI_HBF.dfpwm" -- Audio Link must be a dfpwm file!
            }
        }
    },
    {
        peripheralName = "Create_Station_1",
        station = "Domify HBF",
        time = 2,
        speakers = { "speaker_6" },
        trains = {
            {
                train = "RE70",
                audio = "https://github.com/DomenikYTT/private/raw/refs/heads/main/RE70_zu_Domify_HBF.dfpwm"
            }
        }
    }
}


-- DON'T TOUCH THIS only if you don't know what you are doing! --
function getStations()
    return stations
end

function getPollInterval()
    return pollInterval
end

function getUpdateLive()
    if not ShouldTheConfigUpdateLive == true or not ShouldTheConfigUpdateLive == false then
        return false
    end
    return ShouldTheConfigUpdateLive
end