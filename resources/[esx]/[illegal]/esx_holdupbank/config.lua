Config = {}
Config.Locale = 'fr'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 0
Config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 10   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	['fleeca_test'] = {
		position = vector3(-2957.62, 481.55, 14.77),
		reward = math.random(5000, 35000),
		nameOfStore = 'Fleeca Bank. (Highway)',
		secondsRemaining = 350, -- seconds
		lastRobbed = 0
	},
	['pacific_standard'] = {
		position = vector3(254.36, 225.22, 100.88),
		reward = math.random(1000000, 5000000),
		nameOfStore = 'Pacific Standard (Banque centrale)',
		secondsRemaining = 20, -- seconds
		lastRobbed = 0
	}
}
