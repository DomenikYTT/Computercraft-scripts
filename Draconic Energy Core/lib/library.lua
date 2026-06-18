function getMonitors()
    while true do
        local monitors = { peripheral.find("monitor") }

        if #monitors > 0 then
            return monitors
        end

        print("no Monitor found, retrying in 5 seconds...")
        sleep(5)
    end
end


function setBestScale(mon)
    local scales = {5,4,3,2,1.5,1,0.5}

    for _, scale in ipairs(scales) do

        mon.setTextScale(scale)

        local w,h = mon.getSize()

        if w >= 35 and h >= 18 then
            return
        end
    end

    mon.setTextScale(0.5)
end


function formatNumber(num)
    local suffix = {
        "",
        "K",
        "M",
        "G",
        "T",
        "P",
        "E",
        "Z",
        "Y"
    }

    local index = 1

    while num >= 1000 and index < #suffix do
        num = num / 1000
        index = index + 1
    end

    return string.format("%.2f%s", num, suffix[index])
end