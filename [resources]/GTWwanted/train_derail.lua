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
        {"train", -1943,169,27, 90},
        {"train", -1934,238,25, 90},
        {"train", -1920,276,20, 90},
        {"train", -1861,327,9, 90},
        {"train", -1801,367,2, 100},
        {"train", -1726,421,8, 110},
        {"train", -1663,467,19, 120},
        {"train", -1572,533,34, 130},
        {"train", -1380,672,36, 130},
        {"train", -1228,783,36, 130},
        {"train", -1109,869,36, 130},
        {"train", -1006,944,36, 130},
        {"train", -860,1050,36, 120},
        {"train", -712,1152,32, 110},
        {"train", -589,1190,28, 110},
        {"train", -463,1217,31, 110},
        {"train", -298,1256,30, 110},
        {"train", -205,1275,26, 100},
        {"train", -43,1292,19, 100},
        {"train", 90,1283,21, 100},
        {"train", 206,1242,24, 100},
        {"train", 302,1213,24, 90},
        {"train", 477,1219,16, 90},
        {"train", 625,1298,13, 80},
        {"train", 717,1375,13, 80},
        {"train", 741,1492,11, 80},
        {"train", 742,1714,7, 90},
        {"train", 741,1935,7, 90},
        {"train", 740,2054,10, 80},
        {"train", 738,2178,17, 70},
        {"train", 728,2295,20, 70},
        {"train", 731,2436,21, 70},
        {"train", 769,2543,22, 80},
        {"train", 834,2672,22, 80},
        {"train", 915,2749,21, 80},
        {"train", 1049,2738,16, 80},
        {"train", 1180,2643,13, 70},
        {"train", 1311,2632,12, 60},
        {"train", 1442,2632,12, 60},
        {"train", 1581,2632,12, 50},
        {"train", 1639,2636,12, 50},
        {"train", 1779,2676,12, 60},
        {"train", 1915,2694,12, 60},
        {"train", 2008,2694,12, 60},
        {"train", 2151,2693,12, 50},
        {"train", 2311,2690,12, 60},
        {"train", 2462,2685,12, 70},
        {"train", 2533,2610,12, 60},
        {"train", 2550,2467,12, 50},
        {"train", 2552,2424,11, 60},
        {"train", 2552,2323,5, 70},
        {"train", 2584,2230,2, 80},
        {"train", 2722,2123,0, 80},
        {"train", 2782,1999,5, 70},
        {"train", 2781,1886,9, 70},
        {"train", 2780,1755,12, 60},
        {"train", 2781,1652,12, 50},
        {"train", 2813,1603,12, 60},
        {"train", 2864,1438,12, 70},
        {"train", 2864,1284,12, 70},
        {"train", 2864,1232,12, 60},
        {"train", 2829,1134,12, 60},
        {"train", 2772,1045,12, 50},
        {"train", 2764,975,12, 60},
        {"train", 2764,888,12, 70},
        {"train", 2764,768,12, 80},
        {"train", 2765,610,11, 80},
        {"train", 2765,392,9, 80},
        {"train", 2765,306,9, 70},
        {"train", 2798,190,15, 70},
        {"train", 2821,101,26, 70},
        {"train", 2827,-94,35, 70},
        {"train", 2794,-192,29, 70},
        {"train", 2755,-262,21, 60},
        {"train", 2615,-295,15, 70},
        {"train", 2479,-277,19, 80},
        {"train", 2373,-279,22, 80},
        {"train", 2273,-336,39, 80},
        {"train", 2144,-357,57, 90},
        {"train", 2062,-370,65, 90},
        {"train", 1994,-473,72, 80},
        {"train", 2024,-563,73, 80},
        {"train", 2098,-629,64, 90},
        {"train", 2206,-712,45, 90},
        {"train", 2275,-813,33, 90},
        {"train", 2284,-929,28, 80},
        {"train", 2284,-1006,28, 70},
        {"train", 2284,-1075,28, 60},
        {"train", 2284,-1178,27, 50},
        {"train", 2284,-1305,25, 40},
        {"train", 2284,-1374,25, 40},
        {"train", 2277,-1466,24, 40},
        {"train", 2242,-1564,20, 50},
        {"train", 2212,-1641,17, 50},
        {"train", 2199,-1707,15, 50},
        {"train", 2198,-1848,15, 50},
        {"train", 2197,-1909,15, 40},
        {"train", 2173,-1947,15, 40},
        {"train", 2133,-1954,15, 50},
        {"train", 2031,-1954,15, 50},
        {"train", 1950,-1954,15, 50},
        {"train", 1895,-1954,15, 60},
        {"train", 1809,-1954,15, 70},
        {"train", 1674,-1954,15, 80},
        {"train", 1588,-1954,15, 90},
        {"train", 1507,-1954,15, 100},
        {"train", 1366,-1939,9, 110},
        {"train", 1221,-1808,-3, 110},
        {"train", 1124,-1696,-3, 110},
        {"train", 984,-1537,-1, 110},
        {"train", 927,-1476,-1, 100},
        {"train", 872,-1421,0, 90},
        {"train", 823,-1375,-1, 80},
        {"train", 763,-1321,0, 90},
        {"train", 694,-1265,2, 100},
        {"train", 612,-1204,5, 110},
        {"train", 524,-1148,10, 120},
        {"train", 437,-1103,14, 130},
        {"train", 335,-1062,19, 140},
        {"train", -9,-1018,22, 140},
        {"train", -149,-1027,12, 130},
        {"train", -286,-1133,29, 120},
        {"train", -396,-1249,43, 110},
        {"train", -502,-1236,43, 100},
        {"train", -566,-1186,43, 90},
        {"train", -665,-1124,50, 90},
        {"train", -772,-1154,64, 80},
        {"train", -818,-1231,73, 80},
        {"train", -829,-1290,80, 90},
        {"train", -865,-1448,97, 100},
        {"train", -961,-1498,89, 110},
        {"train", -1073,-1507,67, 120},
        {"train", -1166,-1518,44, 120},
        {"train", -1264,-1514,28, 120},
        {"train", -1396,-1510,24, 130},
        {"train", -1506,-1504,20, 140},
        {"train", -1649,-1477,15, 150},
        {"train", -1816,-1345,15, 150},
        {"train", -1898,-1225,15, 150},
        {"train", -1965,-1074,21, 150},
        {"train", -1979,-823,27, 150},
        {"train", -1979,-763,27, 140},
        {"train", -1979,-714,27, 130},
        {"train", -1980,-669,27, 120},
        {"train", -1980,-629,27, 110},
        {"train", -1981,-571,27, 100},
        {"train", -1979,-497,27, 90},
        {"train", -1970,-400,27, 80},
        {"train", -1964,-327,27, 70},
        {"train", -1949,-210,27, 60},
        {"train", -1945,-116,27, 60},
        {"train", -1945,-79,27, 60},
        {"train", -1945,-21,27, 60},
        {"train", -1945,27,27, 70},
        {"train", -1945,84,27, 80},

        -- Tram derail points
        {"tram", -2267,514,35, 40},
        {"tram", -2367,505,30, 30},
        {"tram", -2342,455,33, 40},
        {"tram", -2274,383,34, 50},
        {"tram", -2252,328,35, 50},
        {"tram", -2252,264,35, 70},
        {"tram", -2252,127,35, 70},
        {"tram", -2254,36,35, 70},
        {"tram", -2256,-13,35, 60},
        {"tram", -2256,-47,35, 50},
        {"tram", -2253,-65,35, 40},
        {"tram", -2214,-71,35, 50},
        {"tram", -2174,-69,35, 40},
        {"tram", -2167,-23,35, 50},
        {"tram", -2165,25,35, 40},
        {"tram", -2126,30,35, 50},
        {"tram", -2061,30,35, 50},
        {"tram", -2013,30,33, 40},
        {"tram", -2007,103,27, 60},
        {"tram", -2007,223,28, 70},
        {"tram", -2004,328,35, 70},
        {"tram", -2004,413,35, 60},
        {"tram", -2004,503,35, 50},
        {"tram", -2003,545,35, 40},
        {"tram", -1999,597,35, 30},
        {"tram", -1912,603,35, 40},
        {"tram", -1866,603,35, 50},
        {"tram", -1809,603,35, 40},
        {"tram", -1751,603,25, 40},
        {"tram", -1713,633,25, 40},
        {"tram", -1710,722,25, 40},
        {"tram", -1638,728,14, 40},
        {"tram", -1576,728,7, 30},
        {"tram", -1549,733,7, 30},
        {"tram", -1542,764,7, 40},
        {"tram", -1538,807,7, 40},
        {"tram", -1551,848,7, 30},
        {"tram", -1630,848,8, 30},
        {"tram", -1668,848,23, 30},
        {"tram", -1701,848,25, 40},
        {"tram", -1764,848,25, 40},
        {"tram", -1844,848,34, 30},
        {"tram", -1907,848,35, 40},
        {"tram", -1966,848,44, 30},
        {"tram", -2001,858,45, 40},
        {"tram", -2000,913,45, 40},
        {"tram", -1926,921,37, 50},
        {"tram", -1882,921,35, 40},
        {"tram", -1853,921,34, 30},
        {"tram", -1823,921,26, 40},
        {"tram", -1764,921,25, 50},
        {"tram", -1695,921,25, 40},
        {"tram", -1668,921,25, 30},
        {"tram", -1624,921,9, 40},
        {"tram", -1537,922,7, 40},
        {"tram", -1549,981,7, 50},
        {"tram", -1585,1081,7, 60},
        {"tram", -1585,1157,7, 70},
        {"tram", -1625,1237,7, 70},
        {"tram", -1705,1317,7, 80},
        {"tram", -1841,1375,7, 70},
        {"tram", -1912,1319,7, 70},
        {"tram", -1981,1307,7, 60},
        {"tram", -2039,1307,7, 50},
        {"tram", -2068,1277,9, 50},
        {"tram", -2146,1274,24, 60},
        {"tram", -2244,1272,40, 50},
        {"tram", -2273,1226,48, 50},
        {"tram", -2265,1119,73, 40},
        {"tram", -2265,1057,83, 50},
        {"tram", -2265,1015,84, 40},
        {"tram", -2265,977,70, 50},
        {"tram", -2265,920,66, 50},
        {"tram", -2265,866,66, 40},
        {"tram", -2265,824,52, 50},
        {"tram", -2265,742,49, 60},
        {"tram", -2265,683,49, 60},
        {"tram", -2265,642,49, 50},
}

function train_location(plr, cmd, speed)
	local x,y,z = getElementPosition(plr)
	if not speed then speed = 70 end
	outputChatBox("{\"train\", "..math.floor(x)..","..math.floor(y)..","..math.floor(z)..", "..speed.."},", plr)
end
addCommandHandler("tloc", train_location)

function train_secure(plr, cmd, state)
        local is_admin = exports.GTWstaff:isAdmin(plr)
        if not is_admin then return end
	local train = getPedOccupiedVehicle(plr)
        if not train or not isElement(train) or
                getElementType(train) ~= "vehicle" or
                getVehicleType(train) ~= "Train" then
                return
        end
        if state == "1" then state = true else state = false end
        setTrainDerailable(train, not state)
        -- Apply protection to all trains
	while getVehicleTowedByVehicle(train) do
                setTrainDerailable(train, not state)
		train = getVehicleTowedByVehicle(train)
	end
	outputChatBox("Train: is now protected from derailment: "..tostring(state), plr)
end
addCommandHandler("protecttrain", train_secure)

function check_derail()
	for i,plr in pairs(getElementsByType("player")) do
		local the_train = getPedOccupiedVehicle(plr)
		if the_train and getVehicleType(the_train) == "Train" and isTrainDerailable(the_train) then
			local px,py,pz = getElementPosition(getPedOccupiedVehicle(plr))
			local n_dist,n_speed,c_speed = 9999,0,0
			for j,dp in pairs(train_derail_points) do
				local t_type,dx,dy,dz,speed = unpack(dp)
				local dist = getDistanceBetweenPoints3D(px,py,pz, dx,dy,dz)
				local kmh = math.floor(math.abs(getTrainSpeed(getPedOccupiedVehicle(plr))*160))
				if dist < n_dist then
					n_dist = dist
					n_speed = speed
					c_speed = kmh
				end
				if dist < 30 and kmh > speed+10 then
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
