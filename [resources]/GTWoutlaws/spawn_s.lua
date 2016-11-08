--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- List of bot spawn data
local bot_spawners = {
	-- x,y,z, weapon, spawn_radius, time_to_deletion (seconds), mode, skins, max_bots_in_area
	{-1302, 2513, 88, {24,25,26,27,30,31}, 70, 300, {"guarding"}, {32,33,34,73,77}, 12, {"Civilians", 200,200,0}},
	{99, 1921, 19, {31}, 10, 300, {"guarding"}, {287}, 5, {"Government", 110,110,110}},
	{273, 1808, 18, {31}, 10, 300, {"guarding"}, {287}, 3, {"Government", 110,110,110}},
	{122, 1820, 18, {31}, 10, 300, {"guarding"}, {287}, 3, {"Government", 110,110,110}},
	{355, 1892, 18, {31}, 10, 300, {"guarding"}, {287}, 4, {"Government", 110,110,110}},
	{279, 2062, 18, {31}, 10, 300, {"guarding"}, {287}, 4, {"Government", 110,110,110}},
	{-3003, 2361, 8, {31}, 2, 600, {"guarding"}, {288}, 2, {"Government", 110,110,110}},
	{-3110, 2313, 8, {31}, 2, 600, {"guarding"}, {288}, 2, {"Government", 110,110,110}},
	{-3099, 2251, 8, {31}, 0, 600, {"guarding"}, {288}, 1, {"Government", 110,110,110}},
	{-2938, 2119, 8, {31}, 2, 600, {"guarding"}, {288}, 2, {"Government", 110,110,110}},
	{-2979, 2393, 4, {31}, 2, 600, {"guarding"}, {288}, 2, {"Government", 110,110,110}},
	{-79, -1551, 3, {1,4,5,22,41}, 5, 1800, {"waiting", "guarding"}, {108,109,110}, 8, {"Civilians", 200,0,0}},
	{2215, -1261, 24, {1,4,5,22,41}, 2, 1800, {"waiting", "guarding"}, {102,103,104}, 3, {"Civilians", 200,0,0}},
	{2121, -1261, 24, {1,4,5,22,41}, 2, 1800, {"waiting", "guarding"}, {102,103,104}, 3, {"Civilians", 200,0,0}},
	{2491, -1668, 14, {1,4,5,22,41}, 30, 1800, {"waiting", "guarding"}, {105,106,107}, 10, {"Civilians", 200,0,0}}, 
}
local bots_count = { }

-- Safely destroy element
function safe_destroy(elem)
	if not elem or not isElement(elem) then return end
	if bots_count[getElementData(elem, "GTWoutlaws.vBot")] then 
		bots_count[getElementData(elem, "GTWoutlaws.vBot")] = 
		bots_count[getElementData(elem, "GTWoutlaws.vBot")] - 1
	end
	if isElement(getElementData(elem, "GTWoutlaws.vBot.blip")) then
		destroyElement(getElementData(elem, "GTWoutlaws.vBot.blip"))
	end
	if isPedDead(elem) then return end
	destroyElement(elem)
end

-- Reward law units
function reward_law_unit(totalAmmo, killer, killerWeapon, bodypart, stealth)
	if isElement(getElementData(source, "GTWoutlaws.vBot.blip")) then
		destroyElement(getElementData(source, "GTWoutlaws.vBot.blip"))
	end
	if bots_count[getElementData(source, "GTWoutlaws.vBot")] then 
		bots_count[getElementData(source, "GTWoutlaws.vBot")] = 
		bots_count[getElementData(source, "GTWoutlaws.vBot")] - 1
	end
	if not killer or getElementType(killer) ~= "player" or not getPlayerTeam(killer) or getPlayerTeam(killer) ~= getTeamFromName("Government") then return end
	
	-- Get bot team
	local is_bot = exports.slothbot:isPedBot(source)
	if not is_bot then return end
	local b_team = exports.slothbot:getBotTeam(source)
	if not getElementData(source, "GTWoutlaws.vBot") or b_team == "Government" then return end
	
	-- Add the kill to stats
	local playeraccount = getPlayerAccount(killer)
	local arrests = getAccountData(playeraccount, "GTWdata_stats_police_arrests") or 0
	setAccountData(playeraccount, "GTWdata_stats_police_arrests", arrests + 1)
	
	-- Generate a reward
	local reward = math.random(100, 700)
	
	-- Pay the cop for the kill
	if getPlayerTeam(killer) and getElementData(source, "GTWoutlaws.botTeam") and 
		getElementData(source, "GTWoutlaws.botTeam") ~= getTeamName(getPlayerTeam(killer)) then
		-- Message and reward to the law unit
		exports.GTWtopbar:dm("You kill arrested an outlaw and got rewarded $"..reward, killer, 255, 100, 0 )
		givePlayerMoney(killer, reward)
	else
		-- Warn about killing your own team
		exports.GTWtopbar:dm("Stopp killing your own team! you lost $"..reward.." for hospital treatment", killer, 255, 0, 0 )
		takePlayerMoney(killer, reward)
	end
end
addEventHandler("onPedWasted", root, reward_law_unit)

-- Function to spawn bots when a player comes nearby
setTimer(function() 
	for i,plr in pairs(getElementsByType("player")) do
		local px,py,pz = getElementPosition(plr)
		for j,bot in pairs(bot_spawners) do
			local dist = getDistanceBetweenPoints3D(px,py,pz, bot[1],bot[2],bot[3])
			if dist > 5 and dist < 180 and (bots_count[j] or 0) < bot[9] then
				local new_bot = exports.slothbot:spawnBot(bot[1]+math.random(-(bot[5]/2),(bot[5]/2)),
					bot[2]+math.random(-(bot[5]/2),(bot[5]/2)),bot[3], 0, bot[8][math.random(#bot[8])], 
					0, 0, getTeamFromName(bot[10][1]), bot[4][math.random(#bot[4])], bot[7][math.random(#bot[7])], plr)
				if not bots_count[j] then bots_count[j] = 0 end
				if bots_count[j] < 0 then bots_count[j] = 0 end
				bots_count[j] = bots_count[j] + 1
				setElementData(new_bot, "GTWoutlaws.vBot", j)
				setElementData(new_bot, "GTWoutlaws.botTeam", bot[10][1])
				local bot_blip = createBlipAttachedTo(new_bot, 0, 1, bot[10][2],bot[10][3],bot[10][4], 255, 99, 180)
				setElementData(new_bot, "GTWoutlaws.vBot.blip", bot_blip)
				setTimer(safe_destroy, bot[6]*1000, 1, new_bot)
			end
		end
	end
end, 4*1000, 0)
