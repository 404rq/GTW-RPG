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

--[[ Fast food trucks ]]--
fastfood_trucks = {
	[423] = true,
	[588] = true
}

-- Menu choices table
menu_choices = {
	["cluckin_bell"] = {
		["title"] = "Clucki'n Bell menu",
		["choice_1"]={ "Cluckin' Little Meal", 	"img/CLUHEAL.png"},
		["choice_2"]={ "Cluckin' Big Meal", 	"img/CLUHIG.png"},
		["choice_3"]={ "Cluckin' Big Meal", 	"img/CLULOW.png"},
		["choice_4"]={ "Cluckin' Big Meal", 	"img/CLUMED.png"},
	},
	["burger"] = {
		["title"] = "Burger Shot menu",
		["choice_1"]={ "Moo kids Meal", 	"img/BURHEAL.png"},
		["choice_2"]={ "Beef Tower Meal", 	"img/BURHIG.png"},
		["choice_3"]={ "Meat Stack Meal", 	"img/BURLOW.png"},
		["choice_4"]={ "Salad Meal", 		"img/BURMED.png"},
	},
	["pizza"] = {
		["title"] = "Well Stacked Pizza Co. menu",
		["choice_1"]={ "Buster", 		"img/BURHEAL.png"},
		["choice_2"]={ "Double D-Luxe", 	"img/BURHIG.png"},
		["choice_3"]={ "Full rack", 		"img/BURLOW.png"},
		["choice_4"]={ "Salad Meal", 		"img/BURMED.png"},
	},
	["icecream"] = {
		["title"] = "Mr. Whoopee menu",
		["choice_1"]={ "Whoopee's special",	"img/ICEPLATE.jpg"},
		["choice_2"]={ "Whoopee's six pack", 	"img/ICESIX.jpg"},
		["choice_3"]={ "Whoopee's choice", 	"img/ICETREE.jpg"},
		["choice_4"]={ "Whoopee's all in", 	"img/ICEALL.jpg"},
	},
	["hotdogs"] = {
		["title"] = "Hotdog van menu",
		["choice_1"]={ "Small hotdog", 		"img/HOTSMALL.jpg"},
		["choice_2"]={ "Big hotdog", 		"img/HOTBIG.jpg"},
		["choice_3"]={ "Skinny hotdog", 	"img/HOTMED.jpg"},
		["choice_4"]={ "Beer", 			"img/BEER.jpg"},
	},
}

-- Markers inside to buy fast food
markers = {
	-- x, y, z, dimension, interior, type, storeLocation
	-- Well stacked pizza Co.
	[1]={ 373.9, -118.8, 1000.4, 0, 5, "pizza" },
	[2]={ 373.9, -118.8, 1000.4, 1, 5, "pizza" },
	[3]={ 373.9, -118.8, 1000.4, 2, 5, "pizza" },
	[4]={ 373.9, -118.8, 1000.4, 3, 5, "pizza" },
	[5]={ 373.9, -118.8, 1000.4, 4, 5, "pizza" },
	[6]={ 373.9, -118.8, 1000.4, 5, 5, "pizza" },
	[7]={ 373.9, -118.8, 1000.4, 6, 5, "pizza" },
	[8]={ 373.9, -118.8, 1000.4, 7, 5, "pizza" },
	[9]={ 373.9, -118.8, 1000.4, 8, 5, "pizza" },
	[10]={ 373.9, -118.8, 1000.4, 9, 5, "pizza" },
	[11]={ 373.9, -118.8, 1000.4, 10, 5, "pizza" },
	[12]={ 373.9, -118.8, 1000.4, 11, 5, "pizza" },

	-- Cluckin' Bell
	[13]={ 369, -6, 1000.8515625, 2, 9, "cluckin_bell" },
	[14]={ 369, -6, 1000.8515625, 1, 9, "cluckin_bell" },
	[15]={ 369, -6, 1000.8515625, 5, 9, "cluckin_bell" },
	[16]={ 369, -6, 1000.8515625, 9, 9, "cluckin_bell" },
	[17]={ 369, -6, 1000.8515625, 10, 9, "cluckin_bell" },
	[18]={ 369, -6, 1000.8515625, 11, 9, "cluckin_bell" },
	[19]={ 369, -6, 1000.8515625, 8, 9, "cluckin_bell" },
	[20]={ 369, -6, 1000.8515625, 6, 9, "cluckin_bell" },
	[21]={ 369, -6, 1000.8515625, 7, 9, "cluckin_bell" },
	[22]={ 369, -6, 1000.8515625, 4, 9, "cluckin_bell" },
	[23]={ 369, -6, 1000.8515625, 3, 9, "cluckin_bell" },
	[24]={ 369, -6, 1000.8515625, 0, 9, "cluckin_bell" },

	-- Burger shot
	[25]={ 375.6, -67.5, 1000.5, 0, 10, "burger" },
	[26]={ 375.6, -67.5, 1000.5, 1, 10, "burger" },
	[27]={ 375.6, -67.5, 1000.5, 5, 10, "burger" },
	[28]={ 375.6, -67.5, 1000.5, 6, 10, "burger" },
	[29]={ 375.6, -67.5, 1000.5, 7, 10, "burger" },
	[30]={ 375.6, -67.5, 1000.5, 8, 10, "burger" },
	[31]={ 375.6, -67.5, 1000.5, 9, 10, "burger" },
	[32]={ 375.6, -67.5, 1000.5, 2, 10, "burger" },
	[33]={ 375.6, -67.5, 1000.5, 3, 10, "burger" },
	[34]={ 375.6, -67.5, 1000.5, 4, 10, "burger" },
	[35]={ 375.6, -67.5, 1000.5, 10, 10, "burger" },

	-- Drive thru's at the end
	[36]={ 1214, -905, 41.922645568848, 0, 0, "burger" },
	[37]={ 799.91015625, -1629.6396484375, 12.109879493713, 0, 0, "burger" },
	[38]={ 2376.5595703125, -1906.7158203125, 12.3828125, 0, 0, "cluckin_bell" },
	[39]={ 2411.6103515625, -1487.3779296875, 22.555204391479, 0, 0, "cluckin_bell" },
	[40]={ -2352.6015625, -156.41796875, 34.945182800293, 0, 0, "burger" },
	[41]={ 1168.9736328125, 2085.4736328125, 10.714609146118, 0, 0, "burger" },
	[42]={ 1856.7373046875, 2082.8876953125, 10.716941833496, 0, 0, "burger" },
}

-- Blips are client sided: using custom blips resource

-- Peds behind the desk to sell
peds = {
	-- x, y, z, dimension, interior, rotation, skinID, name of store
	-- Well stacked pizza Co.
	[1]={ 373.8, -117.27, 1000.4, 0, 5, 180, 155, "Well Stack Pizza Co." },
	[2]={ 373.8, -117.27, 1000.4, 1, 5, 180, 155, "Well Stack Pizza Co." },
	[3]={ 373.8, -117.27, 1000.4, 2, 5, 180, 155, "Well Stack Pizza Co." },
	[4]={ 373.8, -117.27, 1000.4, 3, 5, 180, 155, "Well Stack Pizza Co." },
	[5]={ 373.8, -117.27, 1000.4, 4, 5, 180, 155, "Well Stack Pizza Co." },
	[6]={ 373.8, -117.27, 1000.4, 5, 5, 180, 155, "Well Stack Pizza Co. (Idlewood)" },
	[7]={ 373.8, -117.27, 1000.4, 6, 5, 180, 155, "Well Stack Pizza Co." },
	[8]={ 373.8, -117.27, 1000.4, 7, 5, 180, 155, "Well Stack Pizza Co." },
	[9]={ 373.8, -117.27, 1000.4, 8, 5, 180, 155, "Well Stack Pizza Co." },
	[10]={ 373.8, -117.27, 1000.4, 9, 5, 180, 155, "Well Stack Pizza Co." },
	[11]={ 373.8, -117.27, 1000.4, 10, 5, 180, 155, "Well Stack Pizza Co." },
	[12]={ 373.8, -117.27, 1000.4, 11, 5, 180, 155, "Well Stack Pizza Co." },

	-- Cluckin' Bell
	[13]={ 369, -4.4, 1001.8, 2, 9, 180, 167, "Cluckin' Bell" },
	[14]={ 369, -4.4, 1001.8, 1, 9, 180, 167, "Cluckin' Bell" },
	[15]={ 369, -4.4, 1001.8, 5, 9, 180, 167, "Cluckin' Bell" },
	[16]={ 369, -4.4, 1001.8, 9, 9, 180, 167, "Cluckin' Bell" },
	[17]={ 369, -4.4, 1001.8, 10, 9, 180, 167, "Cluckin' Bell" },
	[18]={ 369, -4.4, 1001.8, 11, 9, 180, 167, "Cluckin' Bell" },
	[19]={ 369, -4.4, 1001.8, 8, 9, 180, 167, "Cluckin' Bell" },
	[20]={ 369, -4.4, 1001.8, 6, 9, 180, 167, "Cluckin' Bell" },
	[21]={ 369, -4.4, 1001.8, 7, 9, 180, 167, "Cluckin' Bell" },
	[22]={ 369, -4.4, 1001.8, 4, 9, 180, 167, "Cluckin' Bell" },
	[23]={ 369, -4.4, 1001.8, 3, 9, 180, 167, "Cluckin' Bell" },
	[24]={ 369, -4.4, 1001.8, 0, 9, 180, 167, "Cluckin' Bell" },

	-- Burger shot
	[25]={ 376, -66, 1000.5, 0, 10, 180, 205, "Burger Shot" },
	[26]={ 376, -66, 1000.5, 1, 10, 180, 205, "Burger Shot" },
	[27]={ 376, -66, 1000.5, 5, 10, 180, 205, "Burger Shot" },
	[28]={ 376, -66, 1000.5, 6, 10, 180, 205, "Burger Shot" },
	[29]={ 376, -66, 1000.5, 7, 10, 180, 205, "Burger Shot" },
	[30]={ 376, -66, 1000.5, 8, 10, 180, 205, "Burger Shot" },
	[31]={ 376, -66, 1000.5, 9, 10, 180, 205, "Burger Shot" },
	[32]={ 376, -66, 1000.5, 2, 10, 180, 205, "Burger Shot" },
	[33]={ 376, -66, 1000.5, 3, 10, 180, 205, "Burger Shot (Garcia)" },
	[34]={ 376, -66, 1000.5, 4, 10, 180, 205, "Burger Shot" },
	[35]={ 376, -66, 1000.5, 10, 10, 180, 205, "Burger Shot" },
}

-- Fast food blips
blips = {
	-- x, y, z, blipID
	-- Well stacked pizza Co.
	[1]={ 2105, -1808, 14, 29 },
	[2]={ 2084, 2224, 12, 29 },
	[3]={ 2352, 2532, 12, 29 },
	[4]={ -1721, 1359, 8, 29 },
	[5]={ -1809, 946, 25, 29 },
	[6]={ 203, -202, 2, 29 },
	[7]={ 2756, 2477, 12, 29 },
	[8]={ 1367, 249, 20, 29 },
	[9]={ 2333, 75, 26, 29 },
	[10]={ 2638, 1850, 12, 29 },
	[11]={ -2543, 2340, 4, 29 },
	[12]={  282, -1600, 33, 29 },

	-- Cluckin' Bell
	[13]={ -2155, -2460, 31, 14 },
	[14]={ -1214, 1830, 42, 14 },
	[15]={ 929, -1353, 14, 14 },
	[16]={ 2393, 2042, 12, 14 },
	[17]={ 2838, 2407, 12, 14 },
	[18]={ 2102, 2229, 12, 14 },
	[19]={ 2638, 1671, 12, 14 },
	[20]={ -1816, 619, 36, 14 },
	[21]={ -2671, 258, 5, 14 },
	[22]={ 2398, -1899, 14, 14 },
	[23]={ 2420, -1510, 25, 14 },
	[24]={ 173, 1177, 15, 14 },

	-- Burger shot
	[25]={ 812, -1616, 14, 10 },
	[26]={ 1199, -918, 44, 10 },
	[27]={ 2367, 2071, 12, 10 },
	[28]={ 2473, 2034, 12, 10 },
	[29]={ 1872, 2042, 12, 10 },
	[30]={ 2170, 2796, 12, 10 },
	[31]={ 1158, 2072, 12, 10 },
	[32]={ -1912, 828, 36, 10 },
	[33]={ -2356, 1008, 51, 10 },
	[34]={ -2336, -167, 36, 10 },
	[35]={ -2953, 2335, 8, 10 },
}

-- Food prices
prices = {
	6,12,14,8
}
-- Food health increase
health = {
	6,12,14,8
}

-- object arrays
marker 	= { }
blip 	= { }
ped 	= { }
