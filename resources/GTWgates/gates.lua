--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status: 			Stable release
********************************************************************************
]]--

-- All gates and their data
gate = {
	-- ObjectID		closeX 		closeY 		closeZ 		openX 		openY 		openZ 		rotX 	rotY 	rotZ 	colX 	colY 	colZ	colRad	Group			Scale
	[1]={ 2957, 	1588.6, 	-1638.4,	14.8, 		1588.6, 	-1638.4, 	20,			0, 		0, 		0, 		1588, 	-1638, 	10, 	15,		"Government", 	1.8 },
	[2]={ 10671,  	-1631, 		688.4, 		8.587, 		-1631, 		688.4, 		20.187, 	0, 		0, 		90, 	-1631, 	688, 	7.187, 	25,		"Government", 	2 },
	[3]={ 11327,  	2334.6, 	2443.7, 	7.70, 		2334.6, 	2443.7, 	15.70, 		0, 		0, 		-30, 	2334.6, 2443.7, 5.70, 	25,		"Government", 	1.3 },
	[4]={ 2957,  	2294, 		2498.8, 	5.1, 		2294, 		2498.8, 	14.3, 		0, 		0, 		90,	 	2294, 	2498.8, 5.1, 	25,		"Government", 	1.8 },
	[5]={ 980, 		3159, 		-1962.8, 	12.5,  		3159, 		-1947.8, 	12.5, 		0, 		0, 		90,	 	3159, 	-1967, 	10, 	20,		"SAPD", 		1 },
	[6]={ 2938, 	97.5, 		508.5, 		13.6,  		97.5, 		508.5, 		3.6, 		0, 		0, 		90,	 	97.5, 	508.5, 	13.6, 	15,		"SWAT", 		1 },
	[7]={ 2938,		107.6, 		414.9,		13.6, 		107.6, 		414.9,		3.6, 		0, 		0, 		90,	 	107.6, 	414.9,	13.6, 	15,		"SWAT", 		1 },
	[8]={ 16773, 	60.8, 		504.4, 		24.9,  		70.8, 		504.4, 		24.9, 		90, 	0, 		0,	 	60.8, 	504.4, 	24.9, 	15,		"SWAT", 		1 },
	[9]={ 986, 		-1571.8, 	662.1, 		7.4,  		-1571.8, 	654.6, 		7.4, 		0,	 	0, 		90,	 	-1571,	661.8, 	6.8, 	20,		"Government", 	1 },
	[10]={ 985, 	-1641.4, 	689, 		7.4,  		-1641.4, 	689, 		7.4, 		0,	 	0, 		90,	 	-1643, 	682, 	7.5, 	20,		"Government", 	1 },
	[11]={ 986, 	-1641.4, 	681, 		7.4,  		-1641.4, 	673.1, 		7.4, 		0,	 	0, 		90,	 	-1643, 	682, 	7.5, 	20,		"Government", 	1 },
	[12]={ 985, 	-2991.4, 	2359.1, 	7.1,  		-2984, 		2359.1, 	7.1, 		0,	 	0, 		0,	 	-2991, 	2359, 	7.2, 	25,		"Government", 	1 },
	[13]={ 985, 	2237.5, 	2453.3, 	8.55,  		2237.5, 	2461.1, 	8.55, 		0,	 	0, 		90,	 	2237, 	2454, 	10.6, 	25,		"Government", 	1 },
	[14]={ 985, 	1543.65, 	-1627.2, 	13.1,  		1543.65, 	-1634.7, 	13.1, 		0,	 	0, 		90,	 	1543, 	-1627, 	13.1, 	25,		"Government", 	1 },
	[15]={ 985, 	-2228.5, 	2373.3, 	4.1,  		-2234.8, 	2379.6, 	4.1, 		0,	 	0, 		135,	-2228, 	2373, 	4.9, 	25,		"Government", 	1 },
	[16]={ 985, 	284.7, 		1818.0, 	17.0,  		284.7, 		1811.6, 	17.0, 		0,	 	0, 		270,	284.7, 	1818.0, 16.6, 	10,		"Government", 	1 },
	[17]={ 986, 	284.7, 		1826.0, 	17.0,  		284.7, 		1831.2, 	17.0, 		0,	 	0, 		270,	284.7, 	1826.0, 16.6, 	10,		"Government", 	1 },
	[18]={ 985, 	131, 		1941.8, 	17.8,  		123, 		1941.8, 	17.8, 		0,	 	0, 		180,	131, 	1941.4, 18.0, 	10,		"Government", 	1 },
	[19]={ 986, 	139, 		1941.8, 	17.8,  		147, 		1941.8, 	17.8, 		0,	 	0, 		180,	139, 	1941.4, 18.0, 	10,		"Government", 	1 },
	[20]={ 986, 	-2974.8, 	2239.4, 	7.0,  		-2974.8, 	2247.0, 	7.0, 		0,	 	0, 		270,	-2974, 	2239.4, 7.0, 	10,		"Government", 	1 },
}

-- Global data members
gates = { }
cols = 	{ }
ocpenSpeed = 3000

-- Add all gates
function mapLoad ( name )
   	for k=1, #gate do
		-- Create objects
		local gat = createObject( gate[k][1], gate[k][2], gate[k][3], gate[k][4], gate[k][8], gate[k][9], gate[k][10] )
		local col = createColCircle( gate[k][11], gate[k][12], gate[k][13]+2, gate[k][14] )
		setObjectScale( gat, gate[k][16] )
	
		-- Assign arrays of object pointers
		gates[col] = gat
		cols[col] = k
		
		-- Add event handlers
		addEventHandler("onColShapeHit", col, openGate )
		addEventHandler("onColShapeLeave", col, closeGate )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement(), mapLoad )

-- Gates open                           
function openGate(plr)
	local ID = cols[source]
    if plr and isElement(plr) and getElementType(plr) == "player" and ( getElementData(plr, "Group" ) == gate[ID][15] or 
    	getPlayerTeam(plr) == getTeamFromName(gate[ID][15]) or getPlayerTeam(plr) == getTeamFromName("Staff")) then
        moveObject(gates[source], ocpenSpeed, gate[ID][5], gate[ID][6], gate[ID][7] ) 
	end
end  
-- Gates close
function closeGate(plr)
    local ID = cols[source]
    if plr and isElement(plr) and getElementType(plr) == "player" and ( getElementData(plr, "Group" ) == gate[ID][15] or 
    	getPlayerTeam(plr) == getTeamFromName(gate[ID][15]) or getPlayerTeam(plr) == getTeamFromName("Staff")) then
        moveObject(gates[source], ocpenSpeed, gate[ID][2], gate[ID][3], gate[ID][4] ) 
	end
end
