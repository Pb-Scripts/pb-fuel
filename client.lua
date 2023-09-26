local fuel_props = {
	"prop_gas_pump_1d",
	"prop_gas_pump_1a",
	"prop_gas_pump_1b",
	"prop_gas_pump_1c",
	"prop_vintage_pump",
	"prop_gas_pump_old2",
	"prop_gas_pump_old3",
}

local usingpump, isrefulling = false, false
local bocal

pb.locale()

local function DeleteBocal()
    DeleteObject(bocal)
    bocal = nil
end

Citizen.CreateThread(function()
    local options = {
        {
            label = locale('getnozzle'),
            name = 'getnozzle',
            icon = 'fa-solid fa-oil-can',
            distance = 2.0,
            canInteract = function()
                return (not IsPedInAnyVehicle(PlayerPedId()) and not usingpump and not isrefulling)
            end,
            onSelect = function(data)
                pb.playAnim('anim@am_hold_up@male', 'shoplift_high', 50, 1000)
                bocal  = pb.AttachProp('prop_cs_fuel_nozle', GetPedBoneIndex(PlayerPedId(), 18905), 1, 0.13, 0.04, 0.01, -42.0, -115.0, -63.42)
                usingpump = true
                local point = pb.points.new(GetEntityCoords(data.entity), 20)
                function point:onEnter()
                    function point:onExit()
                        DeleteBocal()
                        usingpump = false
                        point:remove()
                    end
                end
            end
        },
        {
            label = locale('putnozzle'),
            name = 'putnozzle',
            icon = 'fa-solid fa-oil-can',
            distance = 2.0,
            canInteract = function()
                return (not IsPedInAnyVehicle(PlayerPedId()) and usingpump and not isrefulling)
            end,
            onSelect = function()
                pb.playAnim('anim@am_hold_up@male', 'shoplift_high', 50, 1000)
                DeleteBocal()
                usingpump = false
            end
        },
    }
    pb.addTargetToEntity(fuel_props, options)

    pb.addGlobalVehicleTarget({
        {
            label = locale('fuelvehicle'),
            name = 'fuelvehiclenozzle',
            icon = 'fa-solid fa-oil-can',
            canInteract = function()
                return (not IsPedInAnyVehicle(PlayerPedId()) and usingpump)
            end,
            onSelect = function(data)
                local fuel = Round(100.0 - GetVehicleFuelLevel(data.entity))
                local input = pb.inputDialog(locale('payfuelmenu'), {
                    {type = 'number', label = locale('fuel_quantity'), description = locale('fuel_quantity_desc', fuel), min = 0.1, max = fuel, required = true, icon = "fa-solid fa-droplet"},
                    {type = 'select', label = locale('type_payment'), options = 
                        {
                            {
                                label = locale('cash'),
                                value = false
                            },
                            {
                                label = locale('bank'),
                                value = true
                            }
                        }
                    }
                })
                if not input then return end
                local fueltofill = input[1]
                if input[2] then --Bank
                    if not Config.BankRemove(fueltofill) then return end
                else --Cash
                    if Config.MoneyRemove(fueltofill) then return end
                end
                isrefulling = true
                pb.playAnim('timetable@gardener@filling_can', 'gar_ig_5_filling_can', 1, Config.FuelTime)
                fuel = GetVehicleFuelLevel(data.entity) + (input[1] + 0.0)
                if fuel > 100.0 then fuel = 100.0 end
                SetVehicleFuelLevel(data.entity, fuel)
                isrefulling = false            
            end
        }
    })
end)

RegisterNetEvent('pb-fuel:enteredVehicle')
AddEventHandler('pb-fuel:enteredVehicle', function(targetVehicle)
    while IsPedInAnyVehicle(PlayerPedId()) do
        if IsVehicleEngineOn(targetVehicle) then
            local fuel = GetVehicleFuelLevel(targetVehicle)
            if fuel > 0 then
                SetVehicleFuelLevel(targetVehicle, fuel - Config.FuelUsage[Round(GetVehicleCurrentRpm(targetVehicle), 1)] * (Config.Classes[GetVehicleClass(targetVehicle)] or 1.0) / 10)
            else
                SetVehicleFuelLevel(targetVehicle, 0.0)
            end
        end
        Wait(1000)
    end
end)
