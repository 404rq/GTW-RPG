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

-- Local index over places where trains can derail
local train_derail_points = {
	-- Train derail points
    {"train",-186, -1941, 15, 70},
    {"train",-200, -1736, 15, 70},
    {"train",-212, -1648, 17, 70},
    {"train",-274, -1487, 22, 70},
    {"train",-287, -1384, 24, 70},
    {"train",-286, -1150, 26, 70},
    {"train",-241, -1578, 19, 100},
    {"train",-039, -573, 72, 110},
    {"train",-071, -371, 65, 110},
    {"train",-367, -285, 23, 110},
    {"train",-748, -276, 19, 80},
    {"train",-766, 290, 9, 130},
    {"train",-766, 1029, 12, 120},
    {"train",-788, 1635, 12, 70},
    {"train",-782, 1950, 6, 50},
    {"train",-550, 2469, 12, 50},
    {"train",-162, 2692, 12, 50},
    {"train",-631, 2636, 12, 50},
    {"train",-064, 2728, 16, 110},
    {"train",-35, 2235, 19, 90},
    {"train",-39, 2118, 14, 90},
    {"train",-11, 1365, 13, 80},
    {"train",-12, 1206, 20, 130},
    {"train",-685, 1166, 30, 130},
    {"train",-1916, 282, 19, 120},
    {"train",-1945, -10, 27, 50},
    {"train",-1949, 31, 27, 50},
    {"train",-814, -1216, 71, 130},
    {"train",-694, -1121, 55, 100},
    {"train",-486, -1246, 43, 80},
    {"train",-368, -1234, 42, 90},
    {"train",-244, -1077, 20, 100},
    {"train",-344, -1930, 5, 130},
    {"train",-957, -1954, 15, 70},
    -- SF Tram tracks
    {"tram",-2003, 542, 35, 50},
    {"tram",-2000, 597, 35, 40},
    {"tram",-1926, 603, 35, 60},
    {"tram",-1737, 605, 25, 60},
    {"tram",-1711, 719, 25, 40},
    {"tram",-1552, 730, 7, 60},
    {"tram",-1537, 837, 7, 70},
    {"tram",-1627, 848, 8, 90},
    {"tram",-1672, 848, 24, 70},
    {"tram",-1804, 848, 25, 80},
    {"tram",-1846, 848, 34, 80},
    {"tram",-1909, 848, 35, 80},
    {"tram",-1995, 850, 45, 50},
    {"tram",-1999, 915, 45, 50},
    {"tram",-1917, 921, 36, 100},
    {"tram",-1854, 921, 35, 60},
    {"tram",-1818, 921, 25, 70},
    {"tram",-1666, 921, 24, 60},
    {"tram",-1624, 921, 9, 70},
    {"tram",-1536, 922, 7, 40},
    {"tram",-1578, 1017, 7, 70},
    {"tram",-1589, 1181, 7, 80},
	{"tram",-1782, 1376, 7, 70},
    {"tram",-1782, 1376, 7, 70},
    {"tram",-1852, 1370, 7, 70},
    {"tram",-1919, 1315, 7, 60},
    {"tram",-2037, 1308, 7, 40},
    {"tram",-2068, 1277, 9, 70},
    {"tram",-2248, 1271, 41, 80},
    {"tram",-2265, 1168, 56, 60},
    {"tram",-2265, 1109, 78, 50},
    {"tram",-2265, 1003, 81, 60},
    {"tram",-2265, 965, 67, 60},
    {"tram",-2265, 860, 66, 60},
    {"tram",-2265, 824, 52, 50},
    {"tram",-2265, 642, 49, 60},
    {"tram",-2265, 583, 36, 70},
    {"tram",-2266, 516, 35, 40},
    {"tram",-2366, 506, 30, 30},
    {"tram",-2275, 385, 34, 80},
    {"tram",-2254, 52, 35, 70},
    {"tram",-2255, -62, 35, 50},
    {"tram",-2172, -68, 35, 40},
    {"tram",-2165, 24, 35, 40},
    {"tram",-2012, 30, 33, 30},
}

function train_location(plr, cmd, speed)
	local x,y,z = getElementPosition(plr)
	if not speed then speed = 70 end
	outputChatBox("    {\"train\","..math.floor(x)..", "..math.floor(y)..", "..math.floor(z)..", "..speed.."},", plr)
end
addCommandHandler("tloc", train_location)

function check_derail()
	for i,plr in pairs(getElementsByType("player")) do
		local the_train = getPedOccupiedVehicle(plr)
		if the_train and getVehicleType(the_train) == "Train" then
			local px,py,pz = getElementPosition(getPedOccupiedVehicle(plr))
			local n_dist,n_speed,c_speed = 9999,0,0
			local train_type = "train"
			if getElementModel(the_train) == 449 then train_type = "tram" end
			for j,dp in pairs(train_derail_points) do
				local t_type,dx,dy,dz,speed = unpack(dp)
				local dist = getDistanceBetweenPoints3D(px,py,pz, dx,dy,dz)
				local kmh = math.floor(math.abs(getTrainSpeed(getPedOccupiedVehicle(plr))*160))
				if dist < n_dist and train_type == t_type then
					n_dist = dist
					n_speed = speed
					c_speed = kmh
				end
				if dist < 30 and kmh > speed then
					setTrainDerailed(the_train, true)
					setWl(plr, 5, 0, "You committed the crime of dangerous driving (derailed train)")
				end
			end
			setElementData(plr, "GTWwanted.maxTrainSpeed", n_speed)
			setElementData(plr, "GTWwanted.currentTrainSpeed", c_speed)
		end
	end
end
setTimer(check_derail, 1000, 0)
