RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler("baseevents:enteredVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
    TriggerClientEvent("pb-fuel:enteredVehicle", source, targetVehicle, vehicleSeat)
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler("baseevents:leftVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
    TriggerClientEvent("pb-fuel:leftVehicle", source, targetVehicle)
end)

lib.callback.register('pb-fuel:removeItem', function(source, item, count, inv, metadata, slot)
    return exports.ox_inventory:RemoveItem(inv or source, item, count, metadata, slot)
end)

lib.callback.register('pb-fuel:removeBankMoney', function(source, money)
    local qb = exports['qbx-core']:GetCoreObject()
    local Player = qb.Functions.GetPlayer(source)
    return Player.Functions.RemoveMoney("bank", money)
end)