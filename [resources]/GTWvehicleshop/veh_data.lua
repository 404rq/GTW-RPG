--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Multiplier value ]]--
priceMultiplier = 0.7

--[[ List of vehicles, ids, names and their prices ]]--
car_data = { }
car_data[1] = {
	-- Category, price
	-- Compact two-door cars
	{ 602, "compact", 125300 },
	{ 496, "compact", 109800 },
	{ 401, "compact", 119800 },
	{ 518, "compact", 105300 },
	{ 527, "compact", 94500 },
	{ 589, "compact", 132800 },
	{ 419, "compact", 105500 },
	{ 533, "compact", 164200 },
	{ 526, "compact", 123200 },
	{ 474, "compact", 119800 },
	{ 545, "compact", 112800 },
	{ 517, "compact", 98600 },
	{ 410, "compact", 88200 },
	{ 600, "compact", 108600 },
	{ 436, "compact", 89300 },
	{ 580, "compact", 189800 },
	{ 439, "compact", 156600 },
	{ 549, "compact", 124400 },
	{ 491, "compact", 118600 },
}

car_data[2] = {
	-- Category, price
	-- 4 door and luxury cars
	{ 445, "regular", 85300 },
	{ 507, "regular", 99800 },
	{ 585, "regular", 79800 },
	{ 587, "regular", 105300 },
	{ 466, "regular", 44500 },
	{ 492, "regular", 52800 },
	{ 546, "regular", 85500 },
	{ 551, "regular", 94200 },
	{ 516, "regular", 93200 },
	{ 467, "regular", 49800 },
	{ 426, "regular", 72800 },
	{ 547, "regular", 68600 },
	{ 405, "regular", 88200 },
	{ 409, "regular", 398600 },
	{ 550, "regular", 89300 },
	{ 566, "regular", 89800 },
	{ 540, "regular", 76600 },
	{ 421, "regular", 54400 },
	{ 529, "regular", 58600 },
}

car_data[3] = {
	-- Aircraft
	{ 592, "aircraft", 1122000 },
	{ 577, "aircraft", 1122000 },
	{ 511, "aircraft", 322000 },
	{ 548, "aircraft", 282000 },
	{ 512, "aircraft", 433000 },
	{ 593, "aircraft", 498000 },
	{ 417, "aircraft", 311000 },
	{ 487, "aircraft", 382000 },
	{ 553, "aircraft", 652000 },
	{ 488, "aircraft", 338000 },
	{ 563, "aircraft", 411300 },
	{ 519, "aircraft", 788200 },
	{ 469, "aircraft", 422000 },
	{ 513, "aircraft", 344000 },
}

car_data[4] = {
	-- Bikes and bicycles
	{ 581, "bike", 32000 },
	{ 509, "bike", 800 },
	{ 481, "bike", 1100 },
	{ 462, "bike", 2760 },
	{ 521, "bike", 26600 },
	{ 463, "bike", 28700 },
	{ 510, "bike", 990 },
	{ 522, "bike", 103200 },
	{ 461, "bike", 66300 },
	{ 448, "bike", 4400 },
	{ 468, "bike", 43300 },
	{ 586, "bike", 31220 },
}

car_data[5] = {
	-- Watercraft
	{ 472, "watercraft", 53220 },
	{ 473, "watercraft", 17320 },
	{ 493, "watercraft", 322600 },
	{ 595, "watercraft", 110320 },
	{ 484, "watercraft", 298300 },
	{ 453, "watercraft", 98300 },
	{ 452, "watercraft", 162320 },
	{ 446, "watercraft", 42320 },
	{ 454, "watercraft", 87500 },
}

car_data[6] = {
	-- Trucks and vans
	{ 431, "trucks", 298800 },
	{ 437, "trucks", 339500 },
	{ 403, "trucks", 298800 },
	{ 414, "trucks", 199500 },
	{ 423, "trucks", 378800 },
	{ 443, "trucks", 328800 },
	{ 444, "trucks", 345500 },
	{ 455, "trucks", 448800 },
	{ 456, "trucks", 198800 },
	{ 486, "trucks", 324500 },
	{ 498, "trucks", 175500 },
	{ 499, "trucks", 165500 },
	{ 514, "trucks", 348800 },
	{ 515, "trucks", 338800 },
	{ 524, "trucks", 348800 },
	{ 531, "trucks", 227400 },
	{ 532, "trucks", 363300 },
	{ 573, "trucks", 438800 },
	{ 578, "trucks", 378800 },
	{ 588, "trucks", 387700 },

	-- Vans
	{ 413, "vans", 44200 },
	{ 418, "vans", 52300 },
	{ 422, "vans", 48300 },
	{ 440, "vans", 50700 },
	{ 478, "vans", 65300 },
	{ 482, "vans", 54300 },
	{ 530, "vans", 27800 },
	{ 543, "vans", 64400 },
	{ 554, "vans", 46300 },
	{ 572, "vans", 87300 },
	{ 582, "vans", 94300 },
	{ 583, "vans", 34300 },

	-- Trailers
	{ 606, "trailer", 8200 },
	{ 607, "trailer", 6300 },
	{ 608, "trailer", 7500 },
	{ 610, "trailer", 4300 },
	{ 611, "trailer", 6500 },
	{ 584, "trailer", 53200 },
	{ 435, "trailer", 53400 },
	{ 450, "trailer", 52100 },
	{ 591, "trailer", 48900 },
}

car_data[7] = {
	-- Muscle Cars
	{ 402, "muscle", 122300 },
	{ 542, "muscle", 122300 },
	{ 603, "muscle", 122300 },
	{ 475, "muscle", 122300 },

	-- Lowriders
	{ 412, "lowrider", 78800 },
	{ 534, "lowrider", 77600 },
	{ 535, "lowrider", 73200 },
	{ 536, "lowrider", 69700 },
	{ 567, "lowrider", 66500 },
	{ 575, "lowrider", 82300 },
	{ 576, "lowrider", 74400 },
}

car_data[8] = {
	-- Category, price
	-- Street Racers
	{ 411, "sport", 198300 },
	{ 415, "sport", 144300 },
	{ 429, "sport", 167300 },
	{ 434, "sport", 114300 },
	{ 451, "sport", 96300 },
	{ 477, "sport", 104300 },
	{ 494, "sport", 122300 },
	{ 502, "sport", 122500 },
	{ 503, "sport", 122400 },
	{ 506, "sport", 101100 },
	{ 541, "sport", 124300 },
	{ 555, "sport", 99600 },
	{ 558, "sport", 98900 },
	{ 559, "sport", 109900 },
	{ 560, "sport", 166300 },
	{ 561, "sport", 133400 },
	{ 562, "sport", 97700 },
	{ 565, "sport", 98800 },
}

car_data[9] = {
	-- Category, price
	-- SUVs and Wagons
	{ 579, "suvs", 178300 },
	{ 400, "suvs", 114300 },
	{ 404, "suvs", 117300 },
	{ 489, "suvs", 114300 },
	{ 479, "suvs", 126300 },
	{ 442, "suvs", 134300 },
	{ 458, "suvs", 122300 },
}

car_data[10] = {
	-- Railroad cars
	{ 537, "train", 998300 },
	{ 538, "train", 998400 },
	{ 449, "train", 583300 },
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
