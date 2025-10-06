if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports["qb-core"]:GetCoreObject()

function getPlayerIdentifier(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    return xPlayer.PlayerData.citizenid
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    onPlayerLoaded(Player.PlayerData.citizenid, Player.PlayerData.source)
end)