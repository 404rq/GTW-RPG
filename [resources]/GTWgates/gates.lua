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

-- *****************************************************************************
-- BELOW TABLE ARE MADE FOR SERVERS OWNED BY GRAND THEFT WALRUS, USE IT ONLY AS
-- AN EXAMPLE OF THE LAYOUT TO UNDERSTAND HOW THIS SYSTEM WORKS
-- *****************************************************************************
gate_data = {
	-- ObjectID	closeX 		closeY 		closeZ 		openX 		openY 		openZ 		rotX 	rotY 	rotZ 	colX 	colY 	colZ	colRad	Group		Scale	Interior	Dimension
	[1]={ 	986, 	1588.6, 	-1638.4,	13.4, 		1578.6, 	-1638.4, 	13.4,		0, 	0, 	0, 	1588, 	-1638, 	10, 	5,	"Government", 	1,	0,		0 },
	[2]={ 	10671,  -1631, 		688.4, 		8.587, 		-1631, 		688.4, 		20.187, 	0, 	0, 	90, 	-1631, 	688, 	7.187, 	10,	"Government", 	2,	0,		0 },
	[3]={ 	11327,  2334.6, 	2443.7, 	7.70, 		2334.6, 	2443.7, 	15.70, 		0, 	0, 	-30, 	2334.6, 2443.7, 5.70, 	10,	"Government", 	1.3,	0,		0 },
	[4]={ 	2957,  	2294, 		2498.8, 	5.1, 		2294, 		2498.8, 	14.3, 		0, 	0, 	90,	2294, 	2498.8, 5.1, 	10,	"Government", 	1.8,	0,		0 },
	[5]={ 	980, 	3159, 		-1962.8, 	12.5,  		3159, 		-1947.8, 	12.5, 		0, 	0, 	90,	3159, 	-1967, 	10, 	10,	"SAPD", 	1,	0,		0 },
	[6]={ 	986, 	-1571.8, 	662.1, 		7.4,  		-1571.8, 	654.6, 		7.4, 		0, 	0, 	90,	-1571,	661.8, 	6.8, 	10,	"Government", 	1,	0,		0 },
	[7]={ 	985, 	-1641.4, 	689, 		7.4,  		-1641.4, 	689, 		7.4, 		0, 	0, 	90,	-1643, 	682, 	7.5, 	10,	"Government", 	1,	0,		0 },
	[8]={ 	986, 	-1641.4, 	681, 		7.4,  		-1641.4, 	673.1, 		7.4, 		0, 	0, 	90,	-1643, 	682, 	7.5, 	10,	"Government", 	1,	0,		0 },
	[9]={ 	985, 	-2990.75, 	2358.6, 	7.6,  		-2984.2, 	2358.6, 	7.6, 		0, 	0, 	0,	-2991, 	2359, 	7.2, 	5,	"Government", 	0.83,	0,		0 },
	[10]={ 	985, 	2237.5, 	2453.3, 	8.55,  		2237.5, 	2461.1, 	8.55, 		0, 	0, 	90,	2237, 	2454, 	10.6, 	15,	"Government", 	1,	0,		0 },
	[11]={ 	986, 	1543.55, 	-1627.1, 	13.6,  		1543.55, 	-1634.7, 	13.6, 		0, 	0,	90,	1543, 	-1627, 	13.1, 	15,	"Government", 	0.93,	0,		0 },
	[12]={ 	985, 	-2228.5, 	2373.3, 	4.1,  		-2234.8, 	2379.6, 	4.1, 		0, 	0, 	135,	-2228, 	2373, 	4.9, 	15,	"Government", 	1,	0,		0 },
	[13]={ 	985, 	284.7, 		1818.0, 	17.0,  		284.7, 		1811.6, 	17.0, 		0, 	0, 	270,	284.7, 	1818.0, 16.6, 	20,	"Government", 	1,	0,		0 },
	[14]={ 	986, 	284.7, 		1826.0, 	17.0,  		284.7, 		1831.2, 	17.0, 		0, 	0, 	270,	284.7, 	1826.0, 16.6, 	20,	"Government", 	1,	0,		0 },
	[15]={ 	985, 	131, 		1941.8, 	17.8,  		123, 		1941.8, 	17.8, 		0, 	0, 	180,	131, 	1941.4, 18.0, 	20,	"Government", 	1,	0,		0 },
	[16]={ 	986, 	139, 		1941.8, 	17.8,  		147, 		1941.8, 	17.8, 		0, 	0, 	180,	139, 	1941.4, 18.0, 	20,	"Government", 	1,	0,		0 },
	[17]={ 	986, 	-2995.7, 	2252.7, 	6.9, 		-2999.7, 	2252.7, 	6.9,		0,	0,	0,	-2995.7, 2252.6, 7.0,	5,	"Government",	1,	0,		0 },
	[18]={ 	986, 	-2954.8, 	2136.5, 	7.0,  		-2949.0, 	2138, 		7.0,		0,	0,	190,	-2954,	2136.7, 7.0,	6,	"Government",	1,	0,		0 },
	[19]={ 	986, 	-2996.1, 	2305.1, 	7.9,  		-2995.86, 	2306.6, 	7.9,		0,	0,	268.6,	-2996, 	2303.9, 7.0,	6,	"Government",	1,	0,		0 },
 	[20]={ 	985, 	-3085.2, 	2314.7, 	7.0,  		-3085.5, 	2307.5, 	7.0,		0,	0,	267,	-3084.8,2314.6, 7.0,	6,	"Government",	1,	0,		0 },
	[21]={ 	986,	-2953.4, 	2255.8, 	6.7, 	 	-2953.4, 	2249.1, 	6.7,		0,	0,	90,	-2953.4,2256.3, 7.0, 	5,	"Government", 	1, 	0,		0 },
	[22]={ 	986,	-2944.7, 	2254.1, 	6.7, 	 	-2944.7, 	2246.7, 	6.7,		0,	0,	90,	-2944.7,2254.3, 7.0, 	5,	"Government", 	1, 	0,		0 },
	-- ObjectID	closeX 		closeY 		closeZ 		openX 		openY 		openZ 		rotX 	rotY 	rotZ 	colX 	colY 	colZ	colRad	Group		Scale	Interior	Dimension
	[23]={ 	986, 	-2995.7, 	2264.7, 	6.9, 		-2999.7, 	2264.7, 	6.9,		0,	0,	0,	-2992.7,2264.6, 7.0,	5,	"Government",	1,	0,		0 },
	[24]={ 	986, 	-2990.7, 	2348.7,  	7.6,  		-2996.2, 	2348.7,  	7.6, 		0, 	0, 	0,	-2989.7,2348.7,  7.6, 	5,	"Government", 	0.83,	0,		0 },
	[25]={ 	986, 	380.8, 		-68.6, 		1002.16,	380.8, 		-68.6, 		1007.5, 	0,	0,	90,	380.8, 	-69, 	1000.0,	1.5,	"Government", 	1, 	10,		10 },
}

-- Global data members
gates = { }
cols = 	{ }
openSpeed = 2000

-- Add all gates
function load_gates(name)
   	for k=1, #gate_data do
		-- Create objects
		local gat = createObject( gate_data[k][1], gate_data[k][2], gate_data[k][3], gate_data[k][4], gate_data[k][8], gate_data[k][9], gate_data[k][10] )
		local col = createColSphere( gate_data[k][11], gate_data[k][12], gate_data[k][13]+2, gate_data[k][14] )
		setObjectScale( gat, gate_data[k][16] )

		-- Assign arrays of object pointers
		gates[col] = gat
		cols[col] = k

		-- Set interior
		setElementInterior(gat, gate_data[k][17])
		setElementInterior(col, gate_data[k][17])

		-- Set dimension
		setElementDimension(gat, gate_data[k][18])
		setElementDimension(col, gate_data[k][18])

		-- Add event handlers
		addEventHandler("onColShapeHit", col, open_gate )
		addEventHandler("onColShapeLeave", col, close_gate )
	end
end
addEventHandler("onResourceStart", resourceRoot, load_gates)

-- Gates open
function open_gate(plr, matching_dimension)
	if not matching_dimension then return end
	local ID = cols[source]
	local px,py,pz = getElementPosition(plr)
    	if plr and isElement(plr) and getElementType(plr) == "player" and
    		( getElementData(plr, "Group") == gate_data[ID][15] or
    		getPlayerTeam(plr) == getTeamFromName(gate_data[ID][15]) or
    		getPlayerTeam(plr) == getTeamFromName("Staff")) and
    		pz + 5 > gate_data[ID][4] and pz - 5 < gate_data[ID][4] then
    		-- Open the gate
        	moveObject(gates[source], openSpeed, gate_data[ID][5], gate_data[ID][6], gate_data[ID][7] )
	end
end

-- Gates close
function close_gate(elem, matching_dimension)
	if not matching_dimension then return end
    	local ID = cols[source]
	local elem_count = #getElementsWithinColShape(source, "player")
	elem_count = elem_count + #getElementsWithinColShape(source, "vehicle")
    	if elem and isElement(elem) and elem_count == 0 then
        	moveObject(gates[source], openSpeed, gate_data[ID][2], gate_data[ID][3], gate_data[ID][4])
	end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
