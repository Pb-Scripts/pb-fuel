RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler("baseevents:enteredVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
    TriggerClientEvent("pb-fuel:enteredVehicle", source, targetVehicle, vehicleSeat)
end)