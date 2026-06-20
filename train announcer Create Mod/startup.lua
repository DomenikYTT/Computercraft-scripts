local dfpwm = require("cc.audio.dfpwm")

os.loadAPI("config.lua")


local pollInterval = config.getPollInterval()

local stations = config.getStations()


local ShouldConfigLive = config.getUpdateLive()

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function trim(s)
    if type(s) ~= "string" then return s end
    return s:match("^%s*(.-)%s*$")
end



local function updateConfig()
    if ShouldConfigLive == true then
        os.unloadAPI("config")
        os.loadAPI("config.lua")
        stations = config.getStations(
            pollInterval.getPollInterval()
        )
    end
end

--------------------------------------------------
-- SPEAKERS
--------------------------------------------------

local function wrapSpeakers(list)
    local out = {}
    for _, name in ipairs(list) do
        local s = peripheral.wrap(name)
        if s then
            table.insert(out, s)
        else
            print("WARNUNG: Speaker '" .. tostring(name) .. "' konnte nicht gefunden werden.")
        end
    end
    return out
end

--------------------------------------------------
-- AUDIO PLAYER
--------------------------------------------------

local function playAudio(url, speakerNames)

    local res = http.get(url, nil, true)
    if not res then
        print("FEHLER: Audio konnte nicht geladen werden: " .. tostring(url))
        return
    end

    local speakers = wrapSpeakers(speakerNames)

    if #speakers == 0 then
        print("FEHLER: Keine Speaker gefunden fuer: " .. tostring(url))
        res.close()
        return
    end

    local decoder = dfpwm.make_decoder()
    local chunkSize = 16 * 1024

    while true do
        local chunk = res.read(chunkSize)
        if not chunk then break end

        local buffer = decoder(chunk)

        local ready = false
        while not ready do
            ready = true

            for _, s in ipairs(speakers) do
                if not s.playAudio(buffer) then
                    ready = false
                end
            end

            if not ready then
                os.pullEvent("speaker_audio_empty")
            end
        end
    end

    res.close()
end

--------------------------------------------------
-- CORE LOGIC
--------------------------------------------------

local function handleDeparture(s, trainName)

    local trainData = nil
    for _, t in ipairs(s.trains) do
        if trim(t.train) == trim(trainName) then
            trainData = t
            break
        end
    end

    if not trainData then
        print("FEHLER: Kein Audio fuer Zug '" .. tostring(trainName) .. "' an Station '" .. s.station .. "' hinterlegt.")
        return
    end

    local waitTime = s.time or 10

    print("Zug: " .. trainName)
    print("Ziel: " .. s.station)
    print("Wartezeit: " .. waitTime)

    sleep(waitTime)

    playAudio(trainData.audio, s.speakers)
end

--------------------------------------------------
-- PRO-STATION POLLING WORKER
--------------------------------------------------

local function stationWorker(s)
    updateConfig()
    local wasPresent = false

    while true do
        local p = peripheral.wrap(s.peripheralName)

        if not p then
            print("WARNUNG: Peripheral '" .. s.peripheralName .. "' (" .. s.station .. ") nicht erreichbar.")
        else
            local ok, present = pcall(p.isTrainPresent)

            if not ok then
                print("FEHLER bei isTrainPresent() an " .. s.peripheralName .. ": " .. tostring(present))
            else
                if present and not wasPresent then
                    -- Zug ist neu angekommen
                    local ok2, trainName = pcall(p.getTrainName)

                    if not ok2 or not trainName then
                        print("FEHLER: getTrainName() an " .. s.peripheralName .. " fehlgeschlagen.")
                    else
                        local ok3, err = pcall(handleDeparture, s, trainName)
                        if not ok3 then
                            print("FEHLER in handleDeparture (" .. s.station .. "): " .. tostring(err))
                        end
                    end
                end

                wasPresent = present
            end
        end

        sleep(pollInterval)
    end
end

--------------------------------------------------
-- START
--------------------------------------------------

print("Rail announcement system started (Polling-Modus)")

local workers = {}
for _, s in ipairs(stations) do
    table.insert(workers, function() stationWorker(s) end)
end

parallel.waitForAll(table.unpack(workers))