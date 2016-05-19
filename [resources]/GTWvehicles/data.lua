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

-- Global settings
vehicles 	= { }
spawn_prices	= { }
trailers 	= { }
peds 		= { }
syncTimers 	= { }
gearTimers 	= { }
currVehTopSpeed = { }
paymentsHolder 	= { }
paymentsCounter = { }

-- Define police vehlices (cars and helicopters including army, swat, sapd and fbi)
veh_police = {
	[596]=true,
	[597]=true,
	[598]=true,
	[599]=true,
	[490]=true,
	[528]=true,
	[523]=true,
	[427]=true,
	[432]=true,
	[601]=true,
	[428]=true,
	[433]=true,
	[470]=true,
	[497]=true,
	[425]=true,
	[520]=true
}

-- Emergency lights vehicles
veh_fireman = {
	[407]=true,
	[544]=true
}
veh_medic = {
	[416]=true
}

-- *****************************************************************************
-- Extra options (train cars attached, truck trailers etc)
veh_extra = {
	["Freight"] = {1,2,3,4,5,6,7,8,9},
	["Streak"] = {1,2,3,4,5,6,7,8},
	["Tram"] = {1,2,3},
	["Tanker"] = {"", "Fuel", "Trailer 1", "Trailer 2", "Trailer 3"},
	["Roadtrain"] = {"", "Fuel", "Trailer 1", "Trailer 2", "Trailer 3"},
	["Linerunner"] = {"", "Trailer 1", "Trailer 2", "Trailer 3"},
}
veh_extra_plr = {
	["Freight"] = {1,2,3,4,5,6},
	["Streak"] = {1,2,3,4,5},
	["Tram"] = {1,2},
	["Tanker"] = {"", "Fuel", "Trailer 1", "Trailer 2", "Trailer 3"},
	["Roadtrain"] = {"", "Fuel", "Trailer 1", "Trailer 2", "Trailer 3"},
	["Linerunner"] = {"", "Trailer 1", "Trailer 2", "Trailer 3"},
}
-- *****************************************************************************

--[[ List of vehicles not allowed to use the Race gear !(deprecated) ]]--
slow_vehicles = {
	[531] = true,
	[532] = true,
}

-- Table over vehicles to display in the list
spawn_names = {
	-- veh1-name, veh2-name, veh3-name, ...
	[1]={ "Caddy", "Faggio", "Moonbeam", "Oceanic", "Premier", "Remington", "Sanchez" },
	[2]={ "Taxi", "Cabbie" },
	[3]={ "Cement Truck", "DFT-30", "Flatbed", "Linerunner", "Packer", "Roadtrain", "Tanker" },
	[4]={ "Police LS", "Police SF", "Police LV", "Police Ranger", "HPV1000" },
	[5]={ "Fire Truck" },
	[6]={ "Barracks", "Enforcer", "Hydra", "Hunter", "HPV1000", "Patriot" },
	[7]={ "Ambulance" },
	[8]={ "Bus", "Coach" },
	[9]={ "Towtruck" },
	[10]={ "Ambulance", "Enforcer", "FBI Rancher", "HPV1000", "Police LS", "Police SF", "Police LV", "Police Ranger", "S.W.A.T." },
	[11]={ "Ambulance", "Enforcer", "HPV1000", "Police LS", "Police SF", "Police LV", "Police Ranger", "FBI Rancher" },
	--[[[12]={ } (Slot 12 is reserved for staff) ]]
	[13]={ "Andromada", "AT-400", "Beagle", "Dodo", "Maverick", "Nevada" },
	[14]={ "Tram" },
	[15]={ "Freight", "Streak" },
	[16]={ "Baggage", "Tug" },
	[17]={ "Police Maverick", "Seasparrow" },
	[18]={ "Ambulance", "Enforcer", "HPV1000", "Police LS", "Police SF", "Police LV", "Police Ranger", "FBI Rancher", "FBI Truck" },
	--[[[19]={ } (Slot 19 is reserved for staff) ]]
	[20]={ "Predator" },
	[21]={ "Caddy", "Mountain Bike", "HPV1000" },
}

--[[ Rental price definitions (amount of $/minute) ]]--
spawn_prices = {
	-- veh1-price, veh2-price, veh3-price, ...
	[1]={ 2, 1, 2, 3, 4, 5, 6 },
	[2]={ 1, 1 },
	[3]={ 2, 2, 2, 2, 3, 3, 3 },
	[4]={ 0, 0, 0, 0, 0 },
	[5]={ 0 },
	[6]={ 0, 0, 0, 0, 0, 0 },
	[7]={ 0 },
	[8]={ 4, 4 },
	[9]={ 1 },
	[10]={ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	[11]={ 0, 0, 0, 0, 0, 0, 0, 0 },
	[13]={ 11, 11, 3, 4, 5, 8 },
	[14]={ 4 },
	[15]={ 8, 7 },
	[16]={ 1, 1 },
	[17]={ 0, 0 },
	[18]={ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	[20]={ 0 },
	[21]={ 0, 0, 0 },
}

--[[ Spawner marker colors ]]--
spawn_colors = {
	-- R,G,B
	[1]={ 255,255,255 },
	[2]={ 255,200,0 },
	[3]={ 255,200,0 },
	[4]={ 135,135,135 },
	[5]={ 0,200,255 },
	[6]={ 0,150,0 },
	[7]={ 0,200,255 },
	[8]={ 255,200,0 },
	[9]={ 255,200,0 },
	[10]={ 0,0,150 },
	[11]={ 160,160,160 },
	[13]={ 255,200,0 },
	[14]={ 255,200,0 },
	[15]={ 255,200,0 },
	[16]={ 255,200,0 },
	[17]={ 135,135,135 },
	[18]={ 100,100,100 },
	[20]={ 135,135,135 },
	[21]={ 135,135,135 },
}

--[[ ACL for spawner types: team, occupation and max allowed wanted level
	is defined here, ("" means anyone) ]]--
spawn_rights = {
	-- occupation, team, wanted-level
	[1]={ "", "", 50 },
	[2]={ "Taxi Driver", "Civilians", 2 },
	[3]={ "Trucker", "Civilians", 1 },
	[4]={ "", "Police", 0 },
	[5]={ "Fireman", "Emergency service", 0 },
	[6]={ "ArmedForces", "Government", 0 },
	[7]={ "Paramedic", "Emergency service", 0 },
	[8]={ "Bus Driver", "Civilians", 1 },
	[9]={ "Mechanic", "Civilians", 3 },
	[10]={ "SWAT officer", "Government", 0 },
	[11]={ "SAPD officer", "Government", 0 },
	[12]={ "", "Staff", 10 },
	[13]={ "Pilot", "Civilians", 0 },
	[14]={ "Tram Driver", "Civilians", 0 },
	[15]={ "Train Driver", "Civilians", 0 },
	[16]={ "Pilot", "Civilians", 0 },
	[17]={ "", "Government", 0 },
	[18]={ "FBI officer", "Government", 0 },
	[19]={ "", "Staff", 0 },
	[20]={ "", "Government", 0 },
	[21]={ "", "Government", 0 },
}

--[[ Text on number plates, free fuel and colors
	(-1 means default color) ]]--
properties = {
	[1]={"Rental",false, -1,-1,-1, -1,-1,-1},
	[2]={"",true, -1,-1,-1, -1,-1,-1},
	[3]={"",true, -1,-1,-1, -1,-1,-1},
	[4]={"SAPD 911",true, 50,50,50, 255,255,255},
	[5]={"SAFD 911",true, 135,135,135, 50,50,50},
	[6]={"GTW Army",true, -1,-1,-1, -1,-1,-1},
	[7]={"SAMD 911",true, 135,135,135, 50,50,50},
	[8]={"",true, -1,-1,-1, -1,-1,-1},
	[9]={"",true, -1,-1,-1, -1,-1,-1},
	[10]={"SWAT 911",true, 30,30,100, 150,150,150},
	[11]={"SAPD 911",true, 135,135,135, 255,255,255},
	[12]={"RageQuit",true, 50,50,50, 255,255,255},
	[13]={"",true, 255,255,255, 255,255,255},
	[14]={"",true, -1,-1,-1, -1,-1,-1},
	[15]={"",true, -1,-1,-1, -1,-1,-1},
	[16]={"",true, 255,255,255, 255,255,255},
	[17]={"SAPD 911",true, 50,50,50, 255,255,255},
	[18]={"FBI 911",true, 135,135,135, 255,255,255},
	[19]={"RageQuit",true, 50,50,50, 255,255,255},
	[20]={"SAPD 911",true, 50,50,50, 255,255,255},
	[21]={"SAPD 911",true, 50,50,50, 255,255,255},
}

--[[ A list of valid keys to use while filtering the list ]]--
valid_search_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
 	"l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "num_0", "num_1", "num_2", "num_3", "num_4", "num_5",
 	"num_6", "num_7", "num_8", "num_9", "backspace", "enter", "arrow_u", "arrow_d" }
