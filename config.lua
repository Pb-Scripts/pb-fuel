Config = {}

Config.BankRemove = function(fueltofill) --> Qbcore Example
	return lib.callback.await('pb-fuel:removeBankMoney', false, fueltofill*Config.PricePerL)
end

Config.MoneyRemove = function(fueltofill) --> ox_inventory example
	if not lib.callback.await('pb-fuel:removeItem', false, 'money', fueltofill*Config.PricePerL) then 
		lib.notify({
			type = 'error',
			title = locale('error'),
			description = locale('not_enough_money')
		})
		return
	end
	return true
end

Config.PricePerL = 10 --max tank 100*this
Config.FuelTime = 250

Config.Classes = { -- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
	[0] = 0.2, -- Compacts
	[1] = 0.3, -- Sedans
	[2] = 0.55, -- SUVs
	[3] = 0.35, -- Coupes
	[4] = 0.4, -- Muscle
	[5] = 0.45, -- Sports Classics
	[6] = 0.5, -- Sports
	[7] = 0.6, -- Super
	[8] = 0.25, -- Motorcycles
	[9] = 0.4, -- Off-road
	[10] = 0.6, -- Industrial
	[11] = 0.6, -- Utility
	[12] = 0.6, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 0.75, -- Boats
	[15] = 8.0, -- Helicopters
	[16] = 0.4, -- Planes
	[17] = 0.35, -- Service
	[18] = 0.3, -- Emergency
	[19] = 0.3, -- Military
	[20] = 0.5, -- Commercial
	[21] = 0.7, -- Trains
}

Config.FuelUsage = { -- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
	[1.0] = 0.9,
	[0.9] = 0.75,
	[0.8] = 0.6,
	[0.7] = 0.5,
	[0.6] = 0.4,
	[0.5] = 0.35,
	[0.4] = 0.3,
	[0.3] = 0.2,
	[0.2] = 0.1,
	[0.1] = 0.1,
	[0.0] = 0.0,
}
