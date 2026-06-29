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



local function norm(vec)
    local mag = math.sqrt(vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2)
    if mag > 0 then
        return vec / mag
    end
    return vec
end

-- Per-ped smoothed Z, keyed by ped entity handle
local smoothedZ = {}

local function applyScaleToEntity(ped, scale)
    local forward, right, upVector, position = GetEntityMatrix(ped)

    local forwardNorm = norm(forward) * scale
    local rightNorm = norm(right) * scale
    local upNorm = norm(upVector) * scale

    -- Only look ahead when moving up, cast straight down when descending
    local vel = GetEntityVelocity(ped)
    local isMovingUp = vel.z > 0.1
    local lookAhead = isMovingUp and 0.3 or 0.0

    local rayStart = vector3(position.x + vel.x * lookAhead, position.y + vel.y * lookAhead, position.z + 2.0)
    local rayEnd   = vector3(position.x + vel.x * lookAhead, position.y + vel.y * lookAhead, position.z - 2.5)
    local ray = StartShapeTestRay(rayStart.x, rayStart.y, rayStart.z, rayEnd.x, rayEnd.y, rayEnd.z, 1 | 16, ped, 0)
    local _, hit, groundPos = GetShapeTestResult(ray)

    -- Fallback: straight down with longer range for flat ground / last step
    if hit ~= 1 then
        local rayStart2 = vector3(position.x, position.y, position.z + 2.0)
        local rayEnd2   = vector3(position.x, position.y, position.z - 5.0)
        local ray2 = StartShapeTestRay(rayStart2.x, rayStart2.y, rayStart2.z, rayEnd2.x, rayEnd2.y, rayEnd2.z, 1 | 16, ped, 0)
        _, hit, groundPos = GetShapeTestResult(ray2)
    end

    local groundZ
    if hit == 1 then
        groundZ = groundPos.z
    else
        local found, gz = GetGroundZFor_3dCoord(position.x, position.y, position.z, false)
        groundZ = found and gz or position.z
    end

    local targetZ = groundZ + scale + 0.04

    local pedKey = tostring(ped)
    if smoothedZ[pedKey] == nil then
        smoothedZ[pedKey] = targetZ
    end

    if targetZ > smoothedZ[pedKey] then
        -- Going up: snap for large steps, lerp for small ones
        local diff = targetZ - smoothedZ[pedKey]
        if diff > 0.3 then
            smoothedZ[pedKey] = targetZ
        else
            smoothedZ[pedKey] = smoothedZ[pedKey] + diff * 0.3
        end
    else
        -- Going down: always lerp smoothly
        smoothedZ[pedKey] = smoothedZ[pedKey] + (targetZ - smoothedZ[pedKey]) * 0.18
    end

    SetEntityMatrix(ped,
        forwardNorm.x, forwardNorm.y, forwardNorm.z,
        rightNorm.x, rightNorm.y, rightNorm.z,
        upNorm.x, upNorm.y, upNorm.z,
        position.x, position.y, smoothedZ[pedKey]
    )
end


local syncedScales = {}

RegisterNetEvent('nass_pedscaler:syncCurrentScaling', function(players)
    for k, v in pairs(players) do
        TriggerEvent('nass_pedscaler:syncScale', tonumber(k), v)
    end
end)

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
            currentScale = syncedScales[tostring(serverId)] or 1.0
        }
    })
    cb('ok')
end)

RegisterNUICallback('getLocale', function(data, cb)
    cb(Config.locale)
end)

RegisterNetEvent('nass_pedscaler:openMenu', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "visible",
        data = true,
    })
end)
