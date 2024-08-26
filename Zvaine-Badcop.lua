local ExeFlowwFramework = "qbcore" -- "qbcore", "QBX", "esx", "ndcore" Altyapın Hangisi İse

local Core
local framework

if ExeFlowwFramework == "qbcore" then
    Core = exports['qb-core']:GetCoreObject()
    framework = 'qb'
elseif ExeFlowwFramework == "QBX" then
    Core = exports['qbx_core']:GetCoreObject()
    framework = 'QBX'
elseif ExeFlowwFramework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) Core = obj end)
    framework = 'esx'
elseif ExeFlowwFramework == "ndcore" then
    Core = exports['nd-core']:GetCoreObject()
    framework = 'nd'
else
    print("Hatalı framework seçimi.")
    return
end

AddEventHandler(framework == 'esx' and 'esx:playerLoaded' or 'QBCore:Client:OnPlayerLoaded', function()
    PlayerData = framework == 'esx' and Core.GetPlayerData() or Core.Functions.GetPlayerData()
    isPlayerWhitelisted = PlayerWhitelisted()
end)

RegisterNetEvent(framework == 'esx' and 'esx:setJob' or 'QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData = framework == 'esx' and Core.GetPlayerData() or Core.Functions.GetPlayerData()
    isPlayerWhitelisted = PlayerWhitelisted()
end)

ExeFlowwFrameworkSilahlar = {
    "weapon_pistol",
    "weapon_smg",
    "weapon_stungun",
    "weapon_nightstick"
}

ExeFlowwFrameworkMeslekler = {
    "police"
}

CreateThread(function()
    while true do
        Wait(2000)
        local player = PlayerPedId()
        if not isPlayerWhitelisted then
            for k,v in pairs(ExeFlowwFrameworkSilahlar) do
                local weapon = GetHashKey(v)
                if HasPedGotWeapon(player, weapon, false) then
                    RemoveWeaponFromPed(player, weapon)
                    TriggerServerEvent("ExeFlowwFramework:antibadcop:server:RemoveItem", v, 1)
                    TriggerEvent("inventory:client:ItemBox", Core.Shared.Items[v], "remove", 1) 
                end
            end
        end
    end
end)

function PlayerWhitelisted()
    for k,v in ipairs(ExeFlowwFrameworkMeslekler) do
        if v == PlayerData.job.name then
            return true
        end
    end
    return false
end
