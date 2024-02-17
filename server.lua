RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler("baseevents:enteredVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
    TriggerClientEvent("pb-fuel:enteredVehicle", source, targetVehicle, vehicleSeat)
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler("baseevents:leftVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
    TriggerClientEvent("pb-fuel:leftVehicle", source, targetVehicle)
end)