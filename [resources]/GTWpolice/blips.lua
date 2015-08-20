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

blips_table = {
	{1551,-1676,16}, 	-- LSPD
    {-1606,715,8}, 		-- SFPD
    {2340,2457,14},		-- LVPD
    {-214,979,19},		-- FCPD
    {-1392,2635,55},	-- EQPD
    {-2241,2293,5},		-- BMPD
}

-- Create blips to show nearest police department always
for k,v in pairs(blips_table) do
	--local blip = exports.customblips:createCustomBlip(v[1], v[2], 16, 16, "police_blip.png", 200)
	--exports.customblips:setCustomBlipRadarScale(blip, 1.6)
	createBlip(v[1],v[2],v[3], 30, 2, 0,0,0,255, 5, 400)
end

-- Function to print code to generate blips
function get_coordinates(cmd)
	local x,y,z = getElementPosition(localPlayer)
	outputChatBox("    {"..math.floor(x)..","..math.floor(y)..","..math.floor(z).."},")
end
addCommandHandler("mpdblip", get_coordinates)
