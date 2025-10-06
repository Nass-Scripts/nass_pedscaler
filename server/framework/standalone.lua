if GetResourceState('qb-core') == 'started' then return end
if GetResourceState('es_extended') == 'started' then return end

function getPlayerIdentifier(source)
    return GetPlayerIdentifierByType(source, 'license')
end

AddEventHandler('playerJoining', function(playerId)
    local identifier = getPlayerIdentifier(playerId)
    onPlayerLoaded(identifier, playerId)
end)