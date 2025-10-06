playerScaling = json.decode(LoadResourceFile(GetCurrentResourceName(), "./playerScaling.json")) or {}

function onPlayerLoaded(identifier, source)
    local playerscale = playerScaling[identifier]
    if playerscale and playerscale ~= 1.0 then
        TriggerClientEvent('nass_pedscaler:syncScale', -1, source, playerscale)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    Wait(1000)
    for _, player in pairs(GetPlayers()) do
        onPlayerLoaded(getPlayerIdentifier(player), player)
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

    SaveResourceFile(GetCurrentResourceName(), "playerScaling.json", json.encode(playerScaling), -1)
end)