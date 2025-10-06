--[[
    https://github.com/alp1x/um-ped-scale 
    Main scaling function based off of this script

    ███╗   ██╗ █████╗ ███████╗███████╗        ██████╗ ███████╗██████╗ ███████╗ ██████╗ █████╗ ██╗     ███████╗██████╗ 
    ████╗  ██║██╔══██╗██╔════╝██╔════╝        ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██║     ██╔════╝██╔══██╗
    ██╔██╗ ██║███████║███████╗███████╗        ██████╔╝█████╗  ██║  ██║███████╗██║     ███████║██║     █████╗  ██████╔╝
    ██║╚██╗██║██╔══██║╚════██║╚════██║        ██╔═══╝ ██╔══╝  ██║  ██║╚════██║██║     ██╔══██║██║     ██╔══╝  ██╔══██╗
    ██║ ╚████║██║  ██║███████║███████║███████╗██║     ███████╗██████╔╝███████║╚██████╗██║  ██║███████╗███████╗██║  ██║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝      
    
    https://discord.gg/nass 

    Please support the development of this script by joining our discord server.
]]

RegisterNetEvent('nass_pedscaler:syncScale', function(scale)
    local src = source
    playerScaling[getPlayerIdentifier(src)] = scale

    TriggerClientEvent('nass_pedscaler:syncScale', -1, src, scale)
end)

if Config.commands.openMenu.enabled then
    RegisterCommand(Config.commands.openMenu.command, function(source, args)
        local id = tonumber(args[1]) or source
        if hasPermission(source, id == source and "openSelf" or "openOther") then
            TriggerClientEvent('nass_pedscaler:openMenu', id)
        end
    end, false)
end

if Config.commands.resetScale.enabled then
    RegisterCommand(Config.commands.resetScale.command, function(source, args)
        local id = tonumber(args[1]) or source
        if hasPermission(source, id == source and "resetSelf" or "resetOther") then
            playerScaling[getPlayerIdentifier(id)] = nil
            TriggerClientEvent('nass_pedscaler:syncScale', -1, id, nil)
        end
    end, false)
end

function hasPermission(source, permission)
    if not Config.permissions.enabled then return true end
    local hasAccess = Config.permissions.defaultPermissions[permission]
    if hasAccess then return true end
    for k, v in pairs(Config.permissions.acePermissions or {}) do
        if IsPlayerAceAllowed(source, k) then
            if v[permission] then
                return true
            end
        end
    end
    return false
end