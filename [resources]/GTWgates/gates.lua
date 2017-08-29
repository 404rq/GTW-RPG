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

-- *****************************************************************************
-- BELOW TABLE ARE MADE FOR SERVERS OWNED BY GRAND THEFT WALRUS, USE IT ONLY AS
-- AN EXAMPLE OF THE LAYOUT TO UNDERSTAND HOW THIS SYSTEM WORKS
-- *****************************************************************************
gate_data = {
	-- ObjectID	closeX 		closeY 		closeZ 		openX 		openY 		openZ 		rotX 	rotY 	rotZ 	colRad	Group		Scale	Int	Dim
	{ 986, 		1588.6, 	-1638.4,	13.4, 		1578.6, 	-1638.4, 	13.4,		0, 	0, 	0,  	5,	"Government", 	1,	0,	0 },
	{ 10671,  	-1631, 		688.4, 		8.587, 		-1631, 		688.4, 		20.187, 	0, 	0, 	90, 	10,	"Government", 	2,	0,	0 },
	{ 11327,  	2334.6, 	2443.7, 	7.70, 		2334.6, 	2443.7, 	15.70, 		0, 	0, 	-30, 	10,	"Government", 	1.3,	0,	0 },
	{ 2957,  	2294, 		2498.8, 	5.1, 		2294, 		2498.8, 	14.3, 		0, 	0, 	90,	10,	"Government", 	1.8,	0,	0 },
	{ 980, 		3159, 		-1962.8, 	12.5,  		3159, 		-1947.8, 	12.5, 		0, 	0, 	90,	10,	"SAPD", 	1,	0,	0 },
	{ 986, 		-1571.8, 	662.1, 		7.4,  		-1571.8, 	654.6, 		7.4, 		0, 	0, 	90,	10,	"Government", 	1,	0,	0 },
	{ 985, 		-1641.4, 	689, 		7.4,  		-1641.4, 	689, 		7.4, 		0, 	0, 	90,	10,	"Government", 	1,	0,	0 },
	{ 986, 		-1641.4, 	681, 		7.4,  		-1641.4, 	673.1, 		7.4, 		0, 	0, 	90,	10,	"Government", 	1,	0,	0 },
	{ 985, 		-2990.75, 	2358.6, 	7.6,  		-2984.2, 	2358.6, 	7.6, 		0, 	0, 	0,	5,	"Government", 	0.83,	0,	0 },
	{ 985, 		2237.5, 	2453.3, 	8.55,  		2237.5, 	2461.1, 	8.55, 		0, 	0, 	90,	15,	"Government", 	1,	0,	0 },
	{ 986, 		1543.55, 	-1627.1, 	13.6,  		1543.55, 	-1634.7, 	13.6, 		0, 	0,	90,	15,	"Government", 	0.93,	0,	0 },
	{ 985, 		-2228.5, 	2373.3, 	4.1,  		-2234.8, 	2379.6, 	4.1, 		0, 	0, 	135,	15,	"Government", 	1,	0,	0 },
	{ 985, 		284.7, 		1818.0, 	17.0,  		284.7, 		1811.6, 	17.0, 		0, 	0, 	270,	20,	"ArmedForces", 	1,	0,	0 },
	{ 986, 		284.7, 		1826.0, 	17.0,  		284.7, 		1831.2, 	17.0, 		0, 	0, 	270,	20,	"ArmedForces", 	1,	0,	0 },
	{ 985, 		131, 		1941.8, 	17.8,  		123, 		1941.8, 	17.8, 		0, 	0, 	180,	20,	"ArmedForces", 	1,	0,	0 },
	{ 986, 		139, 		1941.8, 	17.8,  		147, 		1941.8, 	17.8, 		0, 	0, 	180,	20,	"ArmedForces", 	1,	0,	0 },
	{ 986, 		-2995.7, 	2252.7, 	6.9, 		-2999.7, 	2252.7, 	6.9,		0,	0,	0,	5,	"Government",	1,	0,	0 },
	{ 986, 		-2954.8, 	2136.5, 	7.0,  		-2949.0, 	2138, 		7.0,		0,	0,	190,	6,	"Government",	1,	0,	0 },
	{ 986, 		-2996.1, 	2305.1, 	7.9,  		-2995.86, 	2306.6, 	7.9,		0,	0,	268.6,	6,	"Government",	1,	0,	0 },
 	{ 985, 		-3085.2, 	2314.7, 	7.0,  		-3085.5, 	2307.5, 	7.0,		0,	0,	267,	6,	"Government",	1,	0,	0 },
	{ 986,		-2953.4, 	2255.8, 	6.7, 	 	-2953.4, 	2249.1, 	6.7,		0,	0,	90,	5,	"Government", 	1, 	0,	0 },
	{ 986,		-2944.7, 	2254.1, 	6.7, 	 	-2944.7, 	2246.7, 	6.7,		0,	0,	90,	5,	"Government", 	1, 	0,	0 },
	{ 986, 		-2995.7, 	2264.7, 	6.9, 		-2999.7, 	2264.7, 	6.9,		0,	0,	0,	5,	"Government",	1,	0,	0 },
	{ 986, 		-2990.7, 	2348.7,  	7.6,  		-2996.2, 	2348.7,  	7.6, 		0, 	0, 	0,	5,	"Government", 	0.83,	0,	0 },
	{ 986, 		380.8, 		-68.6, 		1002.16,	380.8, 		-68.6, 		1007.5, 	0,	0,	90,	1.5,	"Government", 	1, 	10,	10 },
	{ 986, 		617.4, 		-1509.2, 	14.35,		617.4, 		-1501, 		14.35,	 	0,	0,	270,	8,	"Government", 	1, 	0,	0 },
}

-- Global data members
gates = { }
cols = 	{ }
openSpeed = 3000

-- Add all gates
function load_gates(name)
   	for k,v in pairs(gate_data) do
		-- Create objects
		local gat = createObject(v[1], v[2], v[3], v[4], v[8], v[9], v[10])
		local col = createColSphere(v[2], v[3], v[4]+2, v[11])
		setObjectScale(gat, v[13])

		-- Assign arrays of object pointers
		gates[col] = gat
		cols[col] = k

		-- Set interior
		setElementInterior(gat, v[14])
		setElementInterior(col, v[14])

		-- Set dimension
		setElementDimension(gat, v[15])
		setElementDimension(col, v[15])

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
    		( getElementData(plr, "Group") == gate_data[ID][12] or
    		getPlayerTeam(plr) == getTeamFromName(gate_data[ID][12]) or
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
