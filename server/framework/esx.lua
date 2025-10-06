if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports["es_extended"]:getSharedObject()

function getPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.identifier
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
    onPlayerLoaded(xPlayer.identifier, playerId)
end)