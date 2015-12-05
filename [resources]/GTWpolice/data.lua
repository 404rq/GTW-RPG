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

-- Government color
local r,g,b = 110,110,110

-- May be outdated, stored here temporary
function restore_weapons(plr )
	-- Remove and restore weapons
	setElementData(plr, "onWorkDuty", false)
end
addCommandHandler("endwork", restore_weapons)
addEvent("GTWdata_onEndWork", true)
addEventHandler("GTWdata_onEndWork", root, restore_weapons)

-- List of prison cells
cells = {
	-- PD_ID, interior, dimension, x, y, z, rotation
    	-- LSPD
	[1]={ "LSPD", 6, 0, 264, 77.5, 1001.5, 271.39666748047, 1 },
	[2]={ "LSPD", 6, 1, 264, 77.5, 1001.5, 271.39666748047, 1 },
	[3]={ "LSPD", 6, 2, 264, 77.5, 1001.5, 271.39666748047, 1 },
	[4]={ "LSPD", 6, 0, 264, 82.3, 1001.5, 271.39666748047, 1 },
	[5]={ "LSPD", 6, 1, 264, 82.3, 1001.5, 271.39666748047, 1 },
	[6]={ "LSPD", 6, 2, 264, 82.3, 1001.5, 271.39666748047, 1 },
	[7]={ "LSPD", 6, 0, 264, 87.1, 1001.5, 271.39666748047, 1 },
	[8]={ "LSPD", 6, 1, 264, 87.1, 1001.5, 271.39666748047, 1 },
	[9]={ "LSPD", 6, 2, 264, 87.1, 1001.5, 271.39666748047, 1 },

	-- SFPD
	[10]={ "SFPD", 10, 0, 227, 111, 999.5, 0, 2 },
	[11]={ "SFPD", 10, 0, 223, 111, 999.5, 0, 2 },
	[12]={ "SFPD", 10, 0, 219, 111, 999.5, 0, 2 },
	[13]={ "SFPD", 10, 0, 215, 111, 999.5, 0, 2 },
	[14]={ "SFPD", 10, 1, 227, 111, 999.5, 0, 2 },
	[15]={ "SFPD", 10, 1, 223, 111, 999.5, 0, 2 },
	[16]={ "SFPD", 10, 1, 219, 111, 999.5, 0, 2 },
	[17]={ "SFPD", 10, 1, 215, 111, 999.5, 0, 2 },

	-- LVPD
	[18]={ "LVPD", 3, 0, 198.27734375, 161, 1003.1, 0, 3 },
	[19]={ "LVPD", 3, 0, 193.87890625, 175, 1003.1, 180, 3 },
	[20]={ "LVPD", 3, 0, 198.27734375, 175, 1003.1, 180, 3 },
	[21]={ "LVPD", 3, 1, 198.27734375, 161, 1003.1, 0, 3 },
	[22]={ "LVPD", 3, 1, 193.87890625, 175, 1003.1, 180, 3 },
	[23]={ "LVPD", 3, 1, 198.27734375, 175, 1003.1, 180, 3 },

	-- Fort Carson
	[24]={ "FCPD", 5, 1, 318, 312, 999.4, 270, 4 },
	[25]={ "FCPD", 5, 1, 318, 316, 999.4, 270, 4 },

	-- El Quebrados
	[26]={ "EQPD", 5, 0, 318, 312, 999.4, 270, 5 },
	[27]={ "EQPD", 5, 0, 318, 316, 999.4, 270, 5 },

	-- Angel pine
	[28]={ "APPD", 5, 2, 318, 312, 999.4, 270, 6 },
	[29]={ "APPD", 5, 2, 318, 316, 999.4, 270, 6 },

	-- Jail
	[30]={ "LSPD", 0, 0, -3028, 2360, 6.26, 180, 1 },
	[31]={ "LSPD", 0, 0, -2975, 2204, 0.8, 270, 1 },
}
blips = {
	-- x, y, z
	[1]={ 1554.888671875, -1676.361328125, 16.1953125 },
	[2]={ 608.1591796875, -1464.5869140625, 14.475978851318 },
	[3]={ 3189.169921875, -1986.0263671875, 12.162068367004 },
	[4]={ 2339.080078125, 2458.01171875, 14.96875 },
	[5]={ -1606.740234375, 713.4453125, 13.466968536377 },
	[6]={ -214.4169921875, 979.3056640625, 19.33715057373 },
	[7]={ -1394.369140625, 2631.3583984375, 56.92106628418 },
	[8]={ -2161.7001953125, -2385.3994140625, 30.7 }
}

-- Marker and blips data
marker = {{ }}
blipList = {{ }}

-- Sync timers
lastAnim = {}
prisonerSyncTimers = {}

-- Define emergency lights timer
light2 = {}
light1 = {}

-- Define a table indexed by cops telling how many arrests he got
arrested_players = { }

-- Define law
lawTeams = {
	["Staff"] = true,
	["Government"] = true,
	["Emergency service"] = true
}

-- Define police vehlices (cars and helicopters including army, swat, sapd and fbi)
policeVehicles = {
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
fireVehicles = {
	[407]=true,
	[544]=true
}
medicVehicles = {
	[416]=true
}
trainVeh = {
	[449]=true,
	[537]=true,
	[538]=true,
	[569]=true,
	[570]=true
}
