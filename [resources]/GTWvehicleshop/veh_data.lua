--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Multiplier value ]]--
priceMultiplier = 1

--[[ List of vehicles, ids, names and their prices ]]--
car_data = { }
car_data[1] = {
	-- Category, price
	-- Compact two-door cars
	{ 602, "compact", 25000 },
	{ 496, "compact", 19000 },
	{ 401, "compact", 20000 },
	{ 518, "compact", 22000 },
	{ 527, "compact", 23000 },
	{ 589, "compact", 32000 },
	{ 419, "compact", 29000 },
	{ 587, "compact", 36000 },
	{ 533, "compact", 24000 },
	{ 526, "compact", 22000 },
	{ 474, "compact", 23000 },
	{ 545, "compact", 34000 },
	{ 517, "compact", 20000 },
	{ 410, "compact", 18000 },
	{ 600, "compact", 19000 },
	{ 436, "compact", 21000 },
	{ 439, "compact", 26000 },
	{ 549, "compact", 16000 },
	{ 491, "compact", 22000 },
}

car_data[2] = {
	-- Category, price
	-- 4 door and luxury cars
	{ 445, "regular", 30000 },
	{ 604, "regular", 9000 },
	{ 507, "regular", 33000 },
	{ 585, "regular", 35000 },
	{ 466, "regular", 28000 },
	{ 492, "regular", 33000 },
	{ 546, "regular", 31000 },
	{ 551, "regular", 39000 },
	{ 516, "regular", 36000 },
	{ 467, "regular", 34000 },
	{ 426, "regular", 37000 },
	{ 547, "regular", 30000 },
	{ 405, "regular", 29000 },
	{ 580, "regular", 75000 },
	{ 409, "regular", 115000 },
	{ 550, "regular", 40000 },
	{ 566, "regular", 38000 },
	{ 540, "regular", 37000 },
	{ 421, "regular", 42000 },
	{ 529, "regular", 34000 },
}

car_data[3] = {
	-- Aircraft
	{ 592, "aircraft", 1800000 },
	{ 577, "aircraft", 2000000 },
	{ 511, "aircraft", 230000 },
	{ 512, "aircraft", 180000 },
	{ 593, "aircraft", 240000 },
	{ 520, "aircraft", 1400000 },
	{ 553, "aircraft", 1100000 },
	{ 476, "aircraft", 900000 },
	{ 519, "aircraft", 800000 },
	{ 460, "aircraft", 450000 },
	{ 513, "aircraft", 380000 },
}

car_data[4] = {
	-- Bikes and bicycles
	{ 581, "bike", 9000 },
	{ 509, "bike", 100 },
	{ 481, "bike", 200 },
	{ 462, "bike", 800 },
	{ 521, "bike", 8000 },
	{ 463, "bike", 7000 },
	{ 510, "bike", 150 },
	{ 522, "bike", 11000 },
	{ 461, "bike", 7500 },
	{ 448, "bike", 1100 },
	{ 468, "bike", 4000 },
	{ 586, "bike", 3000 },
}

car_data[5] = {
	-- Watercraft
	{ 472, "watercraft", 80000 },
	{ 473, "watercraft", 5000 },
	{ 493, "watercraft", 800000 },
	{ 595, "watercraft", 200000 },
	{ 484, "watercraft", 600000 },
	{ 430, "watercraft", 110000 },
	{ 453, "watercraft", 90000 },
	{ 452, "watercraft", 200000 },
	{ 446, "watercraft", 700000 },
	{ 454, "watercraft", 200000 },
}

car_data[6] = {
	-- Civilian & worker vehicles
	{ 485, "trucks", 60000 },
	{ 431, "trucks", 110000 },
	{ 438, "trucks", 25000 },
	{ 437, "trucks", 140000 },
	{ 574, "trucks", 18000 },
	{ 420, "trucks", 24000 },
	{ 525, "trucks", 80000 },
	{ 408, "trucks", 120000 },
	{ 552, "trucks", 45000 },

	-- Trucks & big rigs
	{ 524, "trucks", 130000 },
	{ 532, "trucks", 110000 },
	{ 578, "trucks", 90000 },
	{ 486, "trucks", 280000 },
	{ 573, "trucks", 180000 },
	{ 455, "trucks", 130000 },
	{ 588, "trucks", 80000 },
	{ 403, "trucks", 115000 },
	{ 423, "trucks", 90000 },
	{ 443, "trucks", 150000 },
	{ 515, "trucks", 120000 },
	{ 514, "trucks", 120000 },
	{ 531, "trucks", 40000 },

	-- Vans
	{ 499, "vans", 70000 },
	{ 609, "vans", 60000 },
	{ 498, "vans", 60000 },
	{ 414, "vans", 65000 },
	{ 456, "vans", 75000 },

	{ 459, "vans", 50000 },
	{ 422, "vans", 35000 },
	{ 482, "vans", 48000 },
	{ 605, "vans", 8000 },

	{ 530, "vans", 40000 },
	{ 418, "vans", 28000 },
	{ 572, "vans", 7000 },
	{ 582, "vans", 75000 },
	{ 413, "vans", 56000 },
	{ 440, "vans", 48000 },
	{ 543, "vans", 27000 },
	{ 583, "vans", 16000 },
	{ 478, "vans", 12000 },
	{ 554, "vans", 29000 },

	-- Trailers
	{ 606, "trailer", 5000 },
	{ 607, "trailer", 5000 },
	{ 608, "trailer", 6000 },
	{ 610, "trailer", 3000 },
	{ 611, "trailer", 5000 },
	{ 584, "trailer", 100000 },
	{ 435, "trailer", 90000 },
	{ 450, "trailer", 90000 },
	{ 591, "trailer", 80000 },
}

-- CHANGED FROM HERE

car_data[7] = {
	-- Muscle Cars
	{ 402, "muscle", 62000 },
	{ 542, "muscle", 59000 },
	{ 603, "muscle", 68000 },
	{ 475, "muscle", 57000 },

	-- Lowriders
	{ 536, "lowrider", 23000 },
	{ 575, "lowrider", 24000 },
	{ 534, "lowrider", 22000 },
	{ 567, "lowrider", 21000 },
	{ 535, "lowrider", 26000 },
	{ 576, "lowrider", 25000 },
	{ 412, "lowrider", 20000 },
}

car_data[8] = {
	-- Category, price
	-- Street Racers
	{ 429, "sport", 42000 },
	{ 541, "sport", 46000 },
	{ 415, "sport", 49000 },
	{ 480, "sport", 44000 },
	{ 562, "sport", 39000 },
	{ 565, "sport", 40000 },
	{ 434, "sport", 32000 },
	{ 492, "sport", 80000 },
	{ 502, "sport", 80000 },
	{ 503, "sport", 78000 },
	{ 411, "sport", 60000 },
	{ 559, "sport", 43000 },
	{ 561, "sport", 38000 },
	{ 560, "sport", 37000 },
	{ 506, "sport", 33000 },
	{ 451, "sport", 31000 },
	{ 555, "sport", 23000 },
	{ 477, "sport", 34000 },
}

car_data[9] = {
	-- Category, price
	-- SUVs and Wagons
	{ 579, "suvs", 28000 },
	{ 400, "suvs", 29000 },
	{ 404, "suvs", 24000 },
	{ 489, "suvs", 23000 },
	{ 505, "suvs", 23000 },
	{ 479, "suvs", 21000 },
	{ 442, "suvs", 34000 },
	{ 458, "suvs", 32000 },
}

car_data[10] = {
	-- Railroad cars
	{ 537, "train", 300000 },
	{ 538, "train", 290000 },
	{ 449, "train", 85000 },
}

-- Inventory details
supported_cars = {
	[445] = -4,
	[604] = -4,
	[507] = -4,
	[585] = -4,
	[587] = -4,
	[466] = -4,
	[492] = -4,
	[546] = -4,
	[551] = -4,
	[516] = -4,
	[467] = -4,
	[426] = -4,
	[547] = -4,
	[405] = -4,
	[409] = -4,
	[550] = -4,
	[566] = -4,
	[540] = -4,
	[421] = -4,
	[529] = -4,

	[402] = -4,
	[542] = -4,
	[603] = -4,
	[475] = -4,

	[602] = -3,
	[496] = -3,
	[401] = -3,
	[518] = -3,
	[527] = -3,
	[589] = -3,
	[419] = -3,
	[533] = -3,
	[526] = -3,
	[474] = -3,
	[545] = -3,
	[517] = -3,
	[410] = -3,
	[600] = -3,
	[436] = -3,
	[580] = -3,
	[439] = -3,
	[549] = -3,
	[491] = -3,

	[536] = -4,
	[575] = -4,
	[534] = -4,
	[567] = -4,
	[535] = -4,
	[576] = -4,
	[412] = -4,

	[411] = -4,
	[415] = -4,
	[429] = -4,
	[434] = -4,
	[451] = -4,
	[477] = -4,
	[494] = -4,
	[502] = -4,
	[503] = -4,
	[506] = -4,
	[541] = -4,
	[555] = -4,
	[558] = -4,
	[559] = -4,
	[560] = -4,
	[561] = -4,
	[562] = -4,
	[565] = -4,

	[579] = -4,
	[400] = -4,
	[404] = -4,
	[489] = -4,
	[479] = -4,
	[442] = -4,
	[458] = -4,
}
