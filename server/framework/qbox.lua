--This was added for future proofing, in case qbx removes qbcore bridge
if GetResourceState('qbx_core') ~= 'started' then return end

function getPlayerIdentifier(source)
    local xPlayer = exports.qbx_core:GetPlayer(source)
    return xPlayer.PlayerData.citizenid
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player) --Hopefully they don't remove this event when the remove the bridge
    onPlayerLoaded(Player.PlayerData.citizenid, Player.PlayerData.source)
end)