Config = {}

Config.BankRemove = function() --> Qbcore Example
	return pb.callback.await('pb-utils:removeBankMoney', fueltofill*Config.PricePerL)
end

Config.MoneyRemove = function(fueltofill) --> ox_inventory example
	if not pb.hasItem("money", fueltofill*Config.PricePerL) then
		pb.notify({
			type = 'error',
			title = locale('error'),
			description = locale('not_enough_money')
		})
		return
	end
	if not pb.callback.await('pb-utils:removeItem', false, 'money', fueltofill*Config.PricePerL) then return end
	return true
end

Config.PricePerL = 10 --max tank 100*this
Config.FuelTime = 5000

Config.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

Config.FuelUsage = {
	[1.0] = 1.3,
	[0.9] = 1.1,
	[0.8] = 0.9,
	[0.7] = 0.8,
	[0.6] = 0.7,
	[0.5] = 0.5,
	[0.4] = 0.3,
	[0.3] = 0.2,
	[0.2] = 0.1,
	[0.1] = 0.1,
	[0.0] = 0.0,
}
