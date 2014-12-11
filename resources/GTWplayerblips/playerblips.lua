--[[ 
********************************************************************************
	Project:		GTW RPG
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		(git)
	Status:			Stable release
********************************************************************************
]]--

players 		= {}
allBlips 		= {}
colorUpdater 	= {}
stealthTeams 	= {
	["Government"]=true,
	["Criminals"]=true
}

function onResourceStart(resource)
  	for id, plr in ipairs(getElementsByType("player")) do
		if players[plr] then
			--setElementParent(plr, getPlayerTeam(plr))
			--allBlips[plr] = createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3], 255, 999, 99999.0, getPlayerTeam(plr))
			allBlips[plr] = createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3], 255, 999, 99999.0, root)
		elseif getPlayerTeam(plr) then
			local r,g,b = getTeamColor(getPlayerTeam(plr))
			--setElementParent(plr, getPlayerTeam(plr))
			--allBlips[plr] = createBlipAttachedTo(plr, 0, 2, r, g, b, 255, 999, 99999.0, getPlayerTeam(plr))
			allBlips[plr] = createBlipAttachedTo(plr, 0, 2, r, g, b, 255, 999, 99999.0, root)
			players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
		end
		colorUpdater[plr] = setTimer(updateBlipColor,200,0,plr)
	end
end

function onPlayerSpawn(spawnpoint)
	if(players[source]) then
		--setElementParent(plr, getPlayerTeam(source))
		--allBlips[source] = createBlipAttachedTo(source, 0, 2, players[source][1], players[source][2], players[source][3], 255, 999, 99999.0, getPlayerTeam(source))
		allBlips[source] = createBlipAttachedTo(source, 0, 2, players[source][1], players[source][2], players[source][3], 255, 999, 99999.0, root)
	elseif getPlayerTeam(source) then
		local r,g,b = getTeamColor(getPlayerTeam(source))
		--setElementParent(plr, getPlayerTeam(source))
		--allBlips[source] = createBlipAttachedTo(source, 0, 2, r, g, b, 255, 999, 99999.0, getPlayerTeam(source))
		allBlips[source] = createBlipAttachedTo(source, 0, 2, r, g, b, 255, 999, 99999.0, root)
		players[source] = { tonumber(r), tonumber(g), tonumber(b) }
	end
	if not isTimer(colorUpdater[source]) then
		colorUpdater[source] = setTimer(updateBlipColor,200,0,source)
	end
	for id, plr2 in ipairs(getElementsByType("player")) do
		toggleVisibility(plr2)
	end
end

function onPlayerQuit()
	destroyBlipsAttachedTo(source)
	if isTimer(colorUpdater[source]) then
		killTimer(colorUpdater[source])
	end	
end

function onPlayerWasted(totalammo, killer, killerweapon)
	destroyBlipsAttachedTo(source)
end

function toggleVisibility(plr)
	if not getPlayerTeam(plr) then return end
	for id, plr2 in ipairs(getElementsByType("player")) do
		if getPlayerTeam(plr2) and plr ~= plr2 and getPlayerTeam(plr) ~= getPlayerTeam(plr2) and 
			stealthTeams[getTeamName(getPlayerTeam(plr2))] and
			stealthTeams[getTeamName(getPlayerTeam(plr))] then
			if allBlips[plr2] then setElementVisibleTo(allBlips[plr2], plr, false) end
		elseif getPlayerTeam(plr2) and plr ~= plr2 then
			if allBlips[plr2] then setElementVisibleTo(allBlips[plr2], plr, true) end
			if allBlips[plr] then setElementVisibleTo(allBlips[plr], plr2, true) end
		end
	end
end

function updateBlipColor(plr)
	if not getPlayerTeam(plr) then return end
	local r,g,b = getTeamColor(getPlayerTeam(plr))
	if players[plr] and ( r ~= players[plr][1] or g ~= players[plr][2] or b ~= players[plr][3] ) then
		destroyBlipsAttachedTo(plr)
		r,g,b = getTeamColor(getPlayerTeam(plr))
		players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
		setElementParent(plr, getPlayerTeam(plr))
		local alpha = 255
		if getElementData(plr,"anon") then alpha = 0 else alpha = 255 end
  		allBlips[plr] = createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3], alpha, 999, 99999.0, getPlayerTeam(plr))
  		for id, plr2 in ipairs(getElementsByType("player")) do
			toggleVisibility(plr2)
		end
	end
	if not hasPlayerBlip(plr) then
		r,g,b = getTeamColor(getPlayerTeam(plr))
		players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
		setElementParent(plr, getPlayerTeam(plr))
		local alpha = 255
		if getElementData(plr,"anon") then alpha = 0 else alpha = 255 end
  		allBlips[plr] = createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3], alpha, 999, 99999.0, getPlayerTeam(plr))
  		for id, plr2 in ipairs(getElementsByType("player")) do
			toggleVisibility(plr2)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)
addEventHandler("onPlayerSpawn", root, onPlayerSpawn)
addEventHandler("onPlayerQuit", root, onPlayerQuit)
addEventHandler("onPlayerWasted", root, onPlayerWasted)

function destroyBlipsAttachedTo(plr)
	local attached = getAttachedElements(plr)
	if(attached) then
		for k,element in ipairs(attached) do
			if element and getElementType(element) == "blip" then
				destroyElement(element)
			end
		end
	end
end

function hasPlayerBlip(plr)
	local attached = getAttachedElements(plr)
	if(attached) then
		for k,element in ipairs(attached) do
			if element and getElementType(element) == "blip" then
				return true
			end
		end
	end
	return false
end