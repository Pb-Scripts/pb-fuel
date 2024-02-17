local fuel_props = {
	"prop_gas_pump_1d",
	"prop_gas_pump_1a",
	"prop_gas_pump_1b",
	"prop_gas_pump_1c",
	"prop_vintage_pump",
	"prop_gas_pump_old2",
	"prop_gas_pump_old3",
    "denis3d_prop_gas_pump"
}

local FuelDecor = "_FUEL_LEVEL"

local usingpump, isrefulling = false, false
local bocal

lib.locale()

local function DeleteBocal()
    DeleteObject(bocal)
    bocal = nil
end

local function GetFuel(vehicle)
	return DecorGetFloat(vehicle, FuelDecor)
end

local function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

exports('GetFuel', GetFuel)
exports('SetFuel', SetFuel)

Citizen.CreateThread(function()
    DecorRegister(FuelDecor, 1)
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
                local coords = GetEntityCoords(data.entity)

                lib.playAnim('anim@am_hold_up@male', 'shoplift_high', 50, 1000)

                bocal  = lib.AttachProp('prop_cs_fuel_nozle', GetPedBoneIndex(PlayerPedId(), 18905), 1, 0.13, 0.04, 0.01, -42.0, -115.0, -63.42)
                usingpump = true

                local point = lib.points.new(coords, 20)
                function point:onEnter()
                    function point:onExit()
                        AddExplosion(coords, 9, 200.0, true, false, true)
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
                lib.playAnim('anim@am_hold_up@male', 'shoplift_high', 50, 1000)
                DeleteBocal()
                usingpump = false
            end
        },
    }
    lib.addTargetToEntity(fuel_props, options)

    lib.addGlobalVehicleTarget({
        {
            label = locale('fuelvehicle'),
            name = 'fuelvehiclenozzle',
            icon = 'fa-solid fa-oil-can',
            canInteract = function()
                return (not IsPedInAnyVehicle(PlayerPedId()) and usingpump)
            end,
            onSelect = function(data)
                local fuel = Round(100.0 - GetVehicleFuelLevel(data.entity))
                local input = lib.inputDialog(locale('payfuelmenu'), {
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
                    if not Config.MoneyRemove(fueltofill) then return end
                end
                isrefulling = true
                local time = GetVehicleClass(data.entity) == 15 and 60000 or Config.FuelTime * fueltofill
                FreezeEntityPosition(PlayerPedId(), true)
                lib.playAnim('timetable@gardener@filling_can', 'gar_ig_5_filling_can', 1, time)
                FreezeEntityPosition(PlayerPedId(), false)
                fuel = GetVehicleFuelLevel(data.entity) + (input[1] + 0.0)
                if fuel > 100.0 then fuel = 100.0 end
                SetFuel(data.entity, fuel)
                isrefulling = false            
            end
        }
    })
end)

local fuelSynced = false

RegisterNetEvent('pb-fuel:enteredVehicle')
AddEventHandler('pb-fuel:enteredVehicle', function(targetVehicle)
    while IsPedInAnyVehicle(PlayerPedId()) do
        
        if not DecorExistOn(targetVehicle, FuelDecor) then
            SetFuel(targetVehicle, math.random(200, 800) / 10)
        elseif not fuelSynced then
            SetFuel(targetVehicle, GetFuel(targetVehicle))
            fuelSynced = true
        end

        if IsVehicleEngineOn(targetVehicle) then
            local fueltoremove = GetVehicleClass(targetVehicle) == 15 and (0.7/10) or Config.FuelUsage[Round(GetVehicleCurrentRpm(targetVehicle), 1)] * (Config.Classes[GetVehicleClass(targetVehicle)] or 1.0) / 10
            SetFuel(targetVehicle, GetVehicleFuelLevel(targetVehicle)-fueltoremove)
        end 
        Wait(1000)
    end
end)

RegisterNetEvent('pb-fuel:leftVehicle')
AddEventHandler('pb-fuel:leftVehicle', function(targetVehicle)
    if fuelSynced then fuelSynced = false end
end)