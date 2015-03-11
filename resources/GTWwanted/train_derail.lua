--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

-- Local index over places where trains can derail
local train_derail_points = {
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
}

function train_location(plr, cmd, speed)
	local x,y,z = getElementPosition(plr)
	if not speed then speed = 70 end
	outputChatBox("    {"..math.floor(x)..", "..math.floor(y)..", "..math.floor(z)..", "..speed.."},", plr)
end
addCommandHandler("tloc", train_location)