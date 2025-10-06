
local function norm(vec)
    local mag = math.sqrt(vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2)
    if mag > 0 then
        return vec / mag
    end
    return vec
end

local function applyScaleToEntity(ped, scale)
    local forward, right, upVector, position = GetEntityMatrix(ped)

    local forwardNorm = norm(forward) * scale
    local rightNorm = norm(right) * scale
    local upNorm = norm(upVector) * scale

    local zOffset = (1.0 - scale) * 1.0 * 0.5
    local adjustedZ = position.z - zOffset

    if GetEntitySpeed(ped) > 0 then
        adjustedZ = adjustedZ - zOffset
    else
        adjustedZ = adjustedZ + zOffset
    end

    SetEntityMatrix(ped,
        forwardNorm.x, forwardNorm.y, forwardNorm.z,
        rightNorm.x, rightNorm.y, rightNorm.z,
        upNorm.x, upNorm.y, upNorm.z,
        position.x, position.y, adjustedZ
    )
end


local syncedScales = {}

RegisterNetEvent('nass_pedscaler:syncScale', function(src, scale)
    if syncedScales[tostring(src)] ~= nil then
        syncedScales[tostring(src)] = nil
        applyScaleToEntity(PlayerPedId(), 1.0)
        Wait(100)
    end

    syncedScales[tostring(src)] = scale
    if scale ~= nil then
        local playerId = GetPlayerFromServerId(src)
        startScale(src, playerId, scale)
    else
        applyScaleToEntity(PlayerPedId(), 1.0)
    end
end)

function startScale(src, playerId, scale)
    CreateThread(function()
        while syncedScales[tostring(src)] ~= nil do
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) then
                applyScaleToEntity(ped, scale)
                if Config.scaling.scaleSpeed.enabled then
                    SetPedMoveRateOverride(ped, Config.scaling.scaleSpeed.inverse and (1 / scale) or scale)
                end
            end

            Wait(0)
        end
    end)
end

RegisterNUICallback('slider_updated', function(data, cb)
    local serverId = GetPlayerServerId(PlayerId())
    if syncedScales[tostring(serverId)] ~= nil then
        syncedScales[tostring(serverId)] = nil
    end

    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        applyScaleToEntity(playerPed, data.value)
    end
    
    cb('ok')
end)

RegisterNUICallback('save_scale', function(data, cb)
    TriggerServerEvent('nass_pedscaler:syncScale', tonumber(data.scale))
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('close_menu', function(data, cb)
    closeMenu()
    cb('ok')
end)

function closeMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "visible",
        data = false
    })
end

RegisterNUICallback('get_config', function(data, cb)
    local serverId = GetPlayerServerId(PlayerId())
    SendNUIMessage({
        action = "config_data",
        data = {
            scaling = Config.scaling,
            currentScale = syncedScales[tostring(serverId)] or 1.0 -- Default to 1.0, you could store current scale in a variable
        }
    })
    cb('ok')
end)

RegisterNetEvent('nass_pedscaler:openMenu', function()
    print("Opening ped scaler menu...")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "visible",
        data = true,
    })
end)

RegisterNUICallback('getLocale', function(data, cb)
    cb(Config.locale)
end)