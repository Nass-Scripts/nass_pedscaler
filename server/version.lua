local resourceName = GetCurrentResourceName()
local currentVersion = GetResourceMetadata(resourceName, "version")
local isOutdated = false

CreateThread(function()
    if resourceName ~= "nass_pedscaler" then
        print("nass_pedscaler (" .. resourceName .. ") Please do not change the name of the resource, this causes issues with version checking")
    end
    isOutdated = true

    while isOutdated do
        versionCheckScript()
        Wait(3600000)
    end
end)

function versionCheckScript()
    PerformHttpRequest('https://raw.githubusercontent.com/Nass-Scripts/nass_versions/main/'..resourceName,function(error, data, headers)
        if not data then return end
        local result = json.decode(data:sub(1, -2))
        local newVersion = result.version

        local separator = "════════════════════════════════════════════════════════════"
        if not isOnLatest(currentVersion, newVersion) then
            print(separator.."\n"..string.format("^1%s ^7update available!^0", resourceName).."\n"..separator..
                "\n"..string.format("^6Current Version:^5 %s^0", currentVersion)..
                "\n"..string.format("^6New Version:^5 %s^0", newVersion)..
                "\n"..string.format("^6Changelog:^5 %s^0", result.changelog or "No changelog provided")..
                "\n^3Please update here: ^5https://github.com/Nass-Scripts/nass_pedscaler^0"..
                "\n^4Support development & get help: ^5https://discord.gg/nass^0\n"..separator
            )
        else
            isOutdated = false
            print(separator.."\n"..string.format("^2%s ^7initialized successfully!^0", resourceName).."\n"..separator..
                "\n"..string.format("^6You are running the latest version:^5 %s^0", currentVersion)..
                "\n^3Thank you for using nass_pedscaler!^0\n"..
                "\n^4Support development & get help: ^5https://discord.gg/nass^0\n"..separator
            )
        end
    end, 'GET')
end


function isOnLatest(currentVersion, latestVersion)
    local currentParts = {}
    for part in currentVersion:gmatch("%d+") do
        table.insert(currentParts, tonumber(part))
    end

    local latestParts = {}
    for part in latestVersion:gmatch("%d+") do
        table.insert(latestParts, tonumber(part))
    end

    for i = 1, math.max(#currentParts, #latestParts) do
        local currentPart = currentParts[i] or 0
        local latestPart = latestParts[i] or 0

        if currentPart < latestPart then
            return false
        elseif currentPart > latestPart then
            return true
        end
    end

    return true
end