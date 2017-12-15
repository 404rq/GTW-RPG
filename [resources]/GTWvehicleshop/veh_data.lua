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
	{ 602, "compact", 60000 },
	{ 496, "compact", 65000 },
	{ 401, "compact", 35000 },
	{ 518, "compact", 30000 },
	{ 527, "compact", 25000 },
	{ 589, "compact", 36000 },
	{ 419, "compact", 29000 },
	{ 587, "compact", 45000 },
	{ 533, "compact", 31000 },
	{ 526, "compact", 26000 },
	{ 474, "compact", 30000 },
	{ 545, "compact", 42000 },
	{ 517, "compact", 25000 },
	{ 410, "compact", 20000 },
	{ 600, "compact", 20000 },
	{ 436, "compact", 21000 },
	{ 439, "compact", 30000 },
	{ 549, "compact", 18000 },
	{ 491, "compact", 25000 },
}

car_data[2] = {
	-- Category, price
	-- 4 door and luxury cars
	{ 445, "regular", 65000 },
	{ 604, "regular", 10000 },
	{ 507, "regular", 54000 },
	{ 585, "regular", 56000 },
	{ 466, "regular", 35000 },
	{ 492, "regular", 40000 },
	{ 546, "regular", 31000 },
	{ 551, "regular", 52000 },
	{ 516, "regular", 50000 },
	{ 467, "regular", 45000 },
	{ 426, "regular", 75000 },
	{ 547, "regular", 48000 },
	{ 405, "regular", 70000 },
	{ 580, "regular", 75000 },
	{ 409, "regular", 250000 },
	{ 550, "regular", 70000 },
	{ 566, "regular", 50000 },
	{ 540, "regular", 55000 },
	{ 421, "regular", 60000 },
	{ 529, "regular", 43000 },
}

car_data[3] = {
	-- Aircraft
	{ 592, "aircraft", 1800000 },
	{ 577, "aircraft", 2000000 },
	{ 511, "aircraft", 230000 },
	{ 512, "aircraft", 180000 },
	{ 593, "aircraft", 240000 },
	{ 553, "aircraft", 1100000 },
	{ 476, "aircraft", 900000 },
	{ 519, "aircraft", 1000000 },
	{ 460, "aircraft", 450000 },
	{ 513, "aircraft", 380000 },
}

car_data[4] = {
	-- Bikes and bicycles
	{ 581, "bike", 35000 },
	{ 509, "bike", 2000 },
	{ 481, "bike", 3000 },
	{ 462, "bike", 15000 },
	{ 521, "bike", 20000 },
	{ 463, "bike", 13000 },
	{ 510, "bike", 2500 },
	{ 522, "bike", 50000 },
	{ 461, "bike", 40000 },
	{ 448, "bike", 3000 },
	{ 468, "bike", 38000 },
	{ 586, "bike", 15000 },
}

car_data[5] = {
	-- Watercraft
	{ 472, "watercraft", 120000 },
	{ 473, "watercraft", 100000 },
	{ 493, "watercraft", 800000 },
	{ 595, "watercraft", 200000 },
	{ 484, "watercraft", 600000 },
	{ 430, "watercraft", 110000 },
	{ 453, "watercraft", 150000 },
	{ 452, "watercraft", 200000 },
	{ 446, "watercraft", 700000 },
	{ 454, "watercraft", 200000 },
}

car_data[6] = {
	-- Civilian & worker vehicles
	{ 485, "trucks", 20000 },
	{ 431, "trucks", 110000 },
	{ 438, "trucks", 70000 },
	{ 437, "trucks", 140000 },
	{ 574, "trucks", 18000 },
	{ 420, "trucks", 80000 },
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
	{ 536, "lowrider", 45000 },
	{ 575, "lowrider", 60000 },
	{ 534, "lowrider", 50000 },
	{ 567, "lowrider", 40000 },
	{ 535, "lowrider", 46000 },
	{ 576, "lowrider", 35000 },
	{ 412, "lowrider", 43000 },
}

car_data[8] = {
	-- Category, price
	-- Street Racers
	{ 429, "sport", 85000 },
	{ 541, "sport", 120000 },
	{ 415, "sport", 130000 },
	{ 480, "sport", 96000 },
	{ 562, "sport", 105000 },
	{ 565, "sport", 98000 },
	{ 434, "sport", 82000 },
	{ 494, "sport", 130000 },
	{ 502, "sport", 130000 },
	{ 503, "sport", 130000 },
	{ 411, "sport", 200000 },
	{ 559, "sport", 135000 },
	{ 561, "sport", 103000 },
	{ 560, "sport", 160000 },
	{ 506, "sport", 165000 },
	{ 451, "sport", 180000 },
	{ 555, "sport", 110000 },
	{ 477, "sport", 100000 },
}

car_data[9] = {
	-- Category, price
	-- SUVs and Wagons
	{ 579, "suvs", 94000 },
	{ 400, "suvs", 65000 },
	{ 404, "suvs", 45000 },
	{ 489, "suvs", 85000 },
	{ 505, "suvs", 85000 },
	{ 479, "suvs", 60000 },
	{ 442, "suvs", 54000 },
	{ 458, "suvs", 55000 },
}

car_data[10] = {
	-- Railroad cars
	{ 537, "train", 300000 },
	{ 538, "train", 290000 },
	{ 449, "train", 150000 },
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
