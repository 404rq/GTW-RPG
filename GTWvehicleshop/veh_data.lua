--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

--[[ Multiplier value ]]--
priceMultiplier = 0.3

--[[ List of vehicles, ids, names and their prices ]]--
car_data = { }
car_data[1] = {
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
car_data[2] = {	
	-- Muscle Cars
	{ 402, "muscle", 122300 },
	{ 542, "muscle", 122300 },
	{ 603, "muscle", 122300 },
	{ 475, "muscle", 122300 },
	
	{ 412, "lowrider", 78800 },
	{ 534, "lowrider", 77600 },
	{ 535, "lowrider", 73200 },
	{ 536, "lowrider", 69700 },
	{ 567, "lowrider", 66500 },
	{ 575, "lowrider", 82300 },
	{ 576, "lowrider", 74400 },
}
car_data[3] = {	
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
car_data[4] = {	
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
	{ 403, "trucks", 298800 },
	{ 414, "trucks", 199500 },
	{ 423, "trucks", 378800 },
	{ 443, "trucks", 328800 },
	{ 455, "trucks", 448800 },
	{ 456, "trucks", 198800 },
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
}

car_data[7] = {	
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
}