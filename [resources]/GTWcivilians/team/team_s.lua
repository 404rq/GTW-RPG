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

--[[ Display who just logged in ]]--
function notice_login()
    	for k,v in pairs(getElementsByType("player")) do
		exports.GTWtopbar:dm(getPlayerName(source).." has logged in", v, 255, 150, 0)
	    	playSoundFrontEnd(v, 11)
    	end
end
addEventHandler("onPlayerLogin", root, notice_login)

--[[ Display who just joined the game in ]]--
function notice_join()
    	for k,v in pairs(getElementsByType("player")) do
		exports.GTWtopbar:dm(getPlayerName(source).." has joined the game", v, 255, 150, 0)
    		playSoundFrontEnd(source, 11)
	end
end
addEventHandler("onPlayerJoin", root, notice_join)

--[[ Staff teleportation functionality ]]--
function set_player_pos(source, commandName, posX, posY, posZ, interior, dimension)
	local accName = getAccountName(getPlayerAccount(source))
	if isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Supporter")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) then

		-- Default data
		if not posX then posX = 0 end
		if not posY then posY = 0 end
		if not posZ then posZ = 50 end
		if not interior then interior = 0 end
		if not dimension then dimension = 0 end
		local rx,ry,rz = getElementRotation(source)

		local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
		local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

		-- Weapons save
		for k,wep in ipairs(weapon) do
		   	weapon[k] = getPedWeapon(source, k)
		   	setPedWeaponSlot(source, getSlotFromWeapon(weapon[k]))
		   	ammo[k] = getPedTotalAmmo(source, k)
		end
		
		-- Teleport player or the vehicle the player is driving
		if not getPedOccupiedVehicle(source) then
			spawnPlayer(source, posX, posY, posZ, rz, getElementModel(source), interior, dimension, getPlayerTeam(source))
		else
			setElementPosition(getPedOccupiedVehicle(source), posX,posY,posZ)
			takeAllWeapons(source)
		end
		
		-- Weapons restore
		for k,wep in ipairs(weapon) do
		   	if weapon[k] and ammo[k] then
		   		giveWeapon(source, weapon[k], ammo[k], false)
		   	end
		end
	end
end
addCommandHandler("setpos", set_player_pos)

--[[ Move to the criminal team ]]--
function go_criminal(source, command)
	if client then
		source = client
	end
	local team = getTeamFromName("Criminals")
	if not getPedOccupiedVehicle(source) then
		setPlayerTeam(source, team)
		setElementData(source, "Occupation", "Criminal", true)
		local r,g,b = getTeamColor(getTeamFromName("Criminals"))
		setPlayerNametagColor(source, r, g, b)

		-- Return your bought skin or CJ skin(0) if none, replace with 0
		local skinID = exports.GTWclothes:getBoughtSkin(source) or 0
		setElementModel(source, skinID)
		setElementData(source, "admin", false)
		exports.GTWtopbar:dm("You are now a criminal!", source, 0, 255, 0)
	elseif getPedOccupiedVehicle(source) then
		exports.GTWtopbar:dm("Exit your vehicle before using this command!", source, 255, 0, 0)
	end
end
addCommandHandler("criminal", go_criminal)
addEvent("acorp_gocrim", true)
addEventHandler("acorp_gocrim", root, go_criminal)

--[[ End current job (go to unemployed team) ]]--
function end_work(source, command)
	local team = getTeamFromName("Unemployed")
	setPlayerTeam(source, team)
	setElementData(source, "Occupation", "", true)
	local r,g,b = getTeamColor(team)
	setPlayerNametagColor(source, r, g, b)

	-- Make sure that staff get's vulnerable as well
	-- !This value is no longer used (2016-03)
	setElementData(source, "admin", false)

	-- Return your bought skin or CJ skin(0) if none, replace with 0
	local skinID = exports.GTWclothes:getBoughtSkin(source) or 0
	exports.GTWtopbar:dm("End work: successfully!", source, 255, 200, 0)
	setElementModel(source, skinID)
end
addCommandHandler("endwork", end_work)

--[[ End work (called via GUI) ]]--
function endWorkButton()
	local team = getTeamFromName("Unemployed")
	setPlayerTeam(client, team)
	setElementData(client, "Occupation", "", true)
	local r,g,b = getTeamColor(team)
	setPlayerNametagColor(client, r, g, b)

	-- Make sure that staff get's vulnerable as well
	-- !This value is no longer used (2016-03)
	setElementData(client, "admin", false)

	-- Return your bought skin or CJ skin(0) if none, replace with 0
	local skinID = exports.GTWclothes:getBoughtSkin(client) or 0
	exports.GTWtopbar:dm("End work: successfully!", client, 255, 200, 0)
	setElementModel(client, skinID)
end
addEvent("acorp_onEndWork", true)
addEventHandler("acorp_onEndWork", root, endWorkButton)

--[[ Commit suicide ]]--
function commit_suicide(source, command)
	if not isTimer(cooldown) then
		local is_jailed = exports.GTWjail:isJailed(source)
		local is_arrested = exports.GTWpolice:isArrested(source)
		if not is_jailed and not is_arrested and
			exports.GTWpolice:distanceToCop(source) > 400 then
			local pay = math.random(100, 200)
			if getPlayerMoney(source) > pay then
				setTimer(do_kill, 1000, 1, source)
				setElementFrozen(source, true)
				takePlayerMoney(source,pay)
				exports.GTWtopbar:dm("You have committed suicide, it will cost "..
					tostring(pay).."$ + Hospital fines", source, 255, 200, 0)
			else
				exports.GTWtopbar:dm("You can't afford suicide(price: "..tostring(pay).."$)", source, 255, 0, 0)
			end
		elseif exports.GTWpolice:distanceToCop(source) <= 400 then
			exports.GTWtopbar:dm("Suicide was interrupted, a cop is nearby!", source, 255, 0, 0)
		else
			exports.GTWtopbar:dm("You can not use this command in jail or when arrested!", source, 255, 0, 0)
		end
		cooldown = setTimer(function() end, 60000, 1)
	end
end
addCommandHandler("kill", commit_suicide)
addCommandHandler("stuck", commit_suicide)

--[[ Helper function for the suicide ]]
function do_kill(thePlayer)
	if isElement(thePlayer) then
		setElementHealth(thePlayer, 0)
		setElementFrozen(thePlayer, false)
	end
end

--[[ Cleanup data when leaving ]]--
function exit_cleanup(quitType)
	-- Remove attached blips
	--[[local attachedElements = getAttachedElements(source)
	if(attachedElements) then
		for ElementKey, ElementValue in pairs(attachedElements) do
			if isElement(ElementValue) and getElementType(ElementValue) == "blip" and getBlipIcon(ElementValue) == 0 then
			   	destroyElement(ElementValue)
			end
		end
	end]]--
end
addEventHandler("onPlayerQuit", root, exit_cleanup)
