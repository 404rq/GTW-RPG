--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

-- Local index over places where trains can derail
local train_derail_points = {
	-- Train derail points
    {2186, -1941, 15, 70},
    {2200, -1736, 15, 70},
    {2212, -1648, 17, 70},
    {2274, -1487, 22, 70},
    {2287, -1384, 24, 70},
    {2286, -1150, 26, 70},
    {2241, -1578, 19, 100},
    {2039, -573, 72, 110},
    {2071, -371, 65, 110},
    {2367, -285, 23, 110},
    {2748, -276, 19, 80},
    {2766, 290, 9, 130},
    {2766, 1029, 12, 120},
    {2788, 1635, 12, 70},
    {2782, 1950, 6, 50},
    {2550, 2469, 12, 50},
    {2162, 2692, 12, 50},
    {1631, 2636, 12, 50},
    {1064, 2728, 16, 110},
    {735, 2235, 19, 90},
    {739, 2118, 14, 90},
    {711, 1365, 13, 80},
    {412, 1206, 20, 130},
    {-685, 1166, 30, 130},
    {-1916, 282, 19, 120},
    {-1945, -10, 27, 50},
    {-1949, 31, 27, 50},
    {-814, -1216, 71, 130},
    {-694, -1121, 55, 100},
    {-486, -1246, 43, 80},
    {-368, -1234, 42, 90},
    {-244, -1077, 20, 100},
    {1344, -1930, 5, 130},
    {1957, -1954, 15, 70},
    -- SF Tram tracks
    {-2003, 542, 35, 50},
    {-2000, 597, 35, 40},
    {-1926, 603, 35, 60},
    {-1737, 605, 25, 60},
    {-1711, 719, 25, 40},
    {-1552, 730, 7, 60},
    {-1537, 837, 7, 70},
    {-1627, 848, 8, 90},
    {-1672, 848, 24, 70},
    {-1804, 848, 25, 80},
    {-1846, 848, 34, 80},
    {-1909, 848, 35, 80},
    {-1995, 850, 45, 50},
    {-1999, 915, 45, 50},
    {-1917, 921, 36, 100},
    {-1854, 921, 35, 60},
    {-1818, 921, 25, 70},
    {-1666, 921, 24, 60},
    {-1624, 921, 9, 70},
    {-1536, 922, 7, 40},
    {-1578, 1017, 7, 70},
    {-1589, 1181, 7, 80},
	{-1782, 1376, 7, 70},  
    {-1782, 1376, 7, 70},
    {-1852, 1370, 7, 70},
    {-1919, 1315, 7, 60},
    {-2037, 1308, 7, 40},
    {-2068, 1277, 9, 70},
    {-2248, 1271, 41, 80},
    {-2265, 1168, 56, 60},
    {-2265, 1109, 78, 50},
    {-2265, 1003, 81, 60},
    {-2265, 965, 67, 60},
    {-2265, 860, 66, 60},
    {-2265, 824, 52, 50},
    {-2265, 642, 49, 60},
    {-2265, 583, 36, 70},
    {-2266, 516, 35, 40},
    {-2366, 506, 30, 30},
    {-2275, 385, 34, 80},
    {-2254, 52, 35, 70},
    {-2255, -62, 35, 50},
    {-2172, -68, 35, 40},
    {-2165, 24, 35, 40},
    {-2012, 30, 33, 30},
}

function train_location(plr, cmd, speed)
	local x,y,z = getElementPosition(plr)
	if not speed then speed = 70 end
	outputChatBox("    {"..math.floor(x)..", "..math.floor(y)..", "..math.floor(z)..", "..speed.."},", plr)
end
addCommandHandler("tloc", train_location)

function check_derail()
	for i,plr in pairs(getElementsByType("player")) do
		if getPedOccupiedVehicle(plr) and getVehicleType(getPedOccupiedVehicle(plr)) == "Train" then
			local px,py,pz = getElementPosition(getPedOccupiedVehicle(plr))
			local n_dist,n_speed,c_speed = 9999,0,0
			for j,dp in pairs(train_derail_points) do
				local dx,dy,dz,speed = unpack(dp)
				local dist = getDistanceBetweenPoints3D(px,py,pz, dx,dy,dz)
				local speedx,speedy,speedz = getElementVelocity(plr)
				local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
				local kmh = (actualspeed * 180)-5
				if dist < n_dist then 
					n_dist = dist 
					n_speed = speed
					c_speed = kmh					
				end
				if dist < 30 and kmh > speed then
					setTrainDerailed(getPedOccupiedVehicle(plr), true)
					setWl(plr, 5, 0, "You committed the crime of dangerous driving (derailed train)")
				end		
			end
			setElementData(plr, "GTWwanted.maxTrainSpeed", n_speed)
			setElementData(plr, "GTWwanted.currentTrainSpeed", c_speed)
		end
	end
end
setTimer(check_derail, 1000, 0)