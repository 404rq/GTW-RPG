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

--[[ Global data and settings ]]--
colorUpdater 	= { }
playersTeam 	= { }
stealthTeams 	= {
	["Government"]=true,
	["Criminals"]=true,
	["Gangsters"]=true
}

--[[ Rules for who can view the blips ]]--
function validateVisiblity(plr, spectator)
	-- Player is either cop or criminal and may be hidden?
	if plr and spectator and getPlayerTeam(plr) and getPlayerTeam(spectator) and
		stealthTeams[getTeamName(getPlayerTeam(plr))] and stealthTeams[getTeamName(getPlayerTeam(spectator))] then
		-- Memembers of the team staff sees all blips
		--local c_acc = getPlayerAccount(spectator)
		if getPlayerTeam(spectator) == getTeamFromName("Staff") --[[or
			isObjectInACLGroup("user."..getAccountName(c_acc),
			aclGetGroup("Admin"))]] then return true end
		-- They are in different teams and should not see each others
		if getPlayerTeam(plr) ~= getPlayerTeam(spectator) then return false end
		-- They are in the same team and should see each others
		if getPlayerTeam(plr) == getPlayerTeam(spectator) then return true end
	elseif plr and spectator and getPlayerTeam(plr) and getPlayerTeam(spectator) then
		return true
	end
end

--[[ Refresh all blips on resource start ]]--
function refreshAllBlips(resource)
  	for x, plr in pairs(getElementsByType("player")) do
  		-- Remove current blips if any
  		cleanPlayerBlips(plr)

  		-- Get team color or black
		local r,g,b = 0,0,0
		if getPlayerTeam(plr) then
			r,g,b = getTeamColor(getPlayerTeam(plr))
			playersTeam[plr] = getTeamName(getPlayerTeam(plr))
		end

		-- Make the blip visible to a specific amount of players
		for y, spectator in pairs(getElementsByType("player")) do
			if validateVisiblity(plr, spectator) and not getElementData(plr,"anon") then
				createBlipAttachedTo(plr, 0, 2, r, g, b, 255, 99, 99999.0, spectator)
			elseif not getElementData(plr, "anon") then
				local alpha = 200
				local vdist = 180
				local plr_team = getPlayerTeam(plr) or ""
				if getElementData(plr, "Occupation") == "Prisoner" or
					(plr_team == getTeamFromName("Government") and
					getElementData(spectator, "Occupation") == "Prisoner") then 
					alpha = 50
					vdist = 60
				end
				createBlipAttachedTo(plr, 0, 1, 200, 200, 200, alpha, 99, vdist, spectator)
			end
		end
		colorUpdater[plr] = setTimer(updateBlipColor, 500, 0, plr)
	end
end

--[[ Update blip when a player spawn ]]--
function onPlayerSpawn(spawnpoint)
	refreshAllBlips()
end
function updatePlayerBlip(plr)
	-- Remove current blips if any
  	cleanPlayerBlips(plr)

  	-- Get team color or black
	local r,g,b = 0,0,0
	if getPlayerTeam(plr) then
		r,g,b = getTeamColor(getPlayerTeam(plr))
		playersTeam[plr] = getTeamName(getPlayerTeam(plr))
		setElementData(plr, "Occupation2", getElementData(plr, "Occupation"))
	end

	-- Make the blip visible to a specific amount of players
	for y, spectator in pairs(getElementsByType("player")) do
		if validateVisiblity(plr, spectator) and not getElementData(plr,"anon") then
			createBlipAttachedTo(plr, 0, 2, r, g, b, 255, 99, 99999.0, spectator)
		elseif not getElementData(plr,"anon") then
			local alpha = 200
			local vdist = 180
			local plr_team = getPlayerTeam(plr) or ""
			if getElementData(plr, "Occupation") == "Prisoner" or
				(plr_team == getTeamFromName("Government") and
				getElementData(spectator, "Occupation") == "Prisoner") then 
				alpha = 50 
				vdist = 60
			end
			createBlipAttachedTo(plr, 0, 1, 200, 200, 200, alpha, 99, vdist, spectator)
		end
	end
	if not isTimer(colorUpdater[plr]) then
		colorUpdater[plr] = setTimer(updateBlipColor,500,0,plr)
	end
end

-- Force blips update when "anon" command is used
addCommandHandler("anon", updatePlayerBlip)

--[[ Clean up when a player leaves ]]--
function onPlayerQuit()
	-- Remove current blips if any
  	cleanPlayerBlips(source)
  	playersTeam[source] = nil

  	-- Kill the update timer
	if isTimer(colorUpdater[source]) then
		killTimer(colorUpdater[source])
	end
end

--[[ Clean up when a player dies ]]--
function onPlayerWasted(totalammo, killer, killerweapon)
	-- Remove current blips if any
  	cleanPlayerBlips(source)
  	playersTeam[source] = nil
end

--[[ Check if team have changed and update blips ]]--
function updateBlipColor(plr)
	-- Check if team exist and has changed
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	if not getPlayerTeam(plr) then return end
	if playersTeam[plr] == getTeamName(getPlayerTeam(plr)) and
		getElementData(plr, "Occupation2") == getElementData(plr, "Occupation") then return end

	-- Remove current blips if any
  	playersTeam[plr] = nil

  	-- Remake blips
  	for x, plr2 in pairs(getElementsByType("player")) do
  		updatePlayerBlip(plr2)
  	end
end
addEventHandler("onResourceStart", resourceRoot, refreshAllBlips)
addEventHandler("onPlayerSpawn", root, onPlayerSpawn)
addEventHandler("onPlayerQuit", root, onPlayerQuit)
addEventHandler("onPlayerWasted", root, onPlayerWasted)

--[[ Clean up all blips attached to a player ]]--
function cleanPlayerBlips(plr)
	local attached = getAttachedElements(plr)
	if not attached then return end
	for k,element in pairs(attached) do
		if element and getElementType(element) == "blip" then
			destroyElement(element)
		end
	end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Check if a player has blips attached ]]--
function hasPlayerBlip(plr)
	local attached = getAttachedElements(plr)
	if not attached then return end
	for k,element in pairs(attached) do
		if element and getElementType(element) == "blip" then
			return true
		end
	end
	return false
end
