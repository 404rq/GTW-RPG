--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

players 		= {}
allBlips 		= {}
colorUpdater 	= {}
function onResourceStart(resource)
  	for id, plr in ipairs(getElementsByType("player")) do
		if players[plr] then
			setElementParent(plr, getPlayerTeam(plr))
			allBlips[plr] = createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3], 255, 999, 99999.0, getPlayerTeam(plr))
		elseif getPlayerTeam(plr) then
			local r,g,b = getTeamColor(getPlayerTeam(plr))
			setElementParent(plr, getPlayerTeam(plr))
			allBlips[plr] = createBlipAttachedTo(plr, 0, 2, r, g, b, 255, 999, 99999.0, getPlayerTeam(plr))
			players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
		end
		colorUpdater[plr] = setTimer(updateBlipColor,200,0,plr)
	end
end

function onPlayerSpawn(spawnpoint)
	if(players[source]) then
		--setElementParent(plr, getPlayerTeam(source))
		allBlips[source] = createBlipAttachedTo(source, 0, 2, players[source][1], players[source][2], players[source][3], 255, 999, 99999.0, getPlayerTeam(source))
	elseif getPlayerTeam(source) then
		local r,g,b = getTeamColor(getPlayerTeam(source))
		--setElementParent(plr, getPlayerTeam(source))
		allBlips[source] = createBlipAttachedTo(source, 0, 2, r, g, b, 255, 999, 99999.0, getPlayerTeam(source))
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
	if getPlayerTeam(plr) == getTeamFromName("Staff") then
		for id, plr2 in ipairs(getElementsByType("player")) do
			setElementVisibleTo(allBlips[plr2], plr, true)
		end
	else
		for id, plr2 in ipairs(getElementsByType("player")) do
			if getPlayerTeam(plr) ~= getPlayerTeam(plr2) then
				if allBlips[plr2] then setElementVisibleTo(allBlips[plr2], plr, false) end
			end
		end
	end
end

function updateBlipColor(plr)
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