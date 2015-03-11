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

jail_data = {
	is_jailed 		= { },
	last_location	= { },
	release_timers	= { },
	info_timers 	= { },
}

--[[ Public list of release points indexed by code ]]--
release_locations = {
	["LSPD"]={ "Los Santos police department", 1540, -1654, 14, 270 },
	["SFPD"]={ "San Fierro police department", 1540, -1654, 14, 270 },
	["LVPD"]={ "Las Venturas police department", 1540, -1654, 14, 270 },
	["EQPD"]={ "El Quebrados police department", 1540, -1654, 14, 270 },
	["FCPD"]={ "Fort Carson police department", 1540, -1654, 14, 270 },
	["APPD"]={ "Angel Pine police department", 1540, -1654, 14, 270 },
}

--[[ Sends a player to jail ]]--
function Jail(crim, time, police_dept, reason, admin)
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return end
	if not police_dept then outputServerLog("GTW-RPG: (Wanted) Please specify a police department") end
	if jail_data.is_jailed[crim] then
		exports.GTWtopbar:dm(getPlayerName(crim).." is already in jail!", crim, 255, 150, 0)
		return
	end
	
	-- Save last location (string with the name of the police station) 
	jail_data.last_location[crim] = police_dept
	
	-- Allow count down timer
	time = tonumber(time)
	setElementData(crim, "jailTime", (time*1000)+getTickCount())
	setElementData(crim, "jailTime2", getTickCount())	
	
	-- Sets a value indication that the player is jailed
	jail_data.is_jailed[crim] = true
	setElementData(crim, "Jailed", "Yes")
	setElementData(crim, "arrested", nil)
	exports.GTWwanted:setWl(crim, time*0.02, 0, "", false)
	set_control_states(crim, false)
	
	-- Reset a value used to block hospitals from respawn kill arrested players
	setElementData(crim, "isKillArrested", nil)
	
	-- Get and save weapons temporary
	local weapons = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	for k,wep in pairs(weapons) do
	   	weapons[k] = getPedWeapon(crim, k)
	   	setPedWeaponSlot(crim, getSlotFromWeapon(weapons[k]))
	   	ammo[k] = getPedTotalAmmo(crim, k)
	end
	
	-- Move to jail
	local rand_x = math.random(1,10)
	local rand_y = math.random(1,10)
	local own_skin = exports.GTWclothes:getBoughtSkin(crim) or getElementModel(crim) or 0
	setTimer(spawnPlayer, 1100, 1, crim, -2965+((-5)+rand_x), 2305+((-5)+rand_y), 8, 180, own_skin, 0, 0, getTeamFromName("Criminals"))
	fadeCamera(crim, false)
	setTimer(fadeCamera, 1500, 1, crim, true)
	
	-- Restore weapons
	if weapons then
		for k,wep in ipairs(weapons) do
		   	if weapons[k] and ammo[k] then
		   		if ammo[k] > 5000 then ammo[k] = 5000 end
		   		setTimer(giveWeapon, 1500, 1, crim, weapons[k], ammo[k], false)
		   	end
		end
	end
	
	-- Set team and occupation
	setPlayerNametagColor(crim, 170, 0, 0)
	
	-- Set occupation to prisoner after 30 seconds, you can't escape until this time has passed
	setTimer(setElementData, 30000, 1, crim, "Occupation", "Prisoner")
	
	-- Assign release timer
	jail_data.release_timers[crim] = setTimer(Unjail, time*1000, 1, crim, police_dept)
	jail_data.info_timers[crim] = setTimer(sync_time_display, 1000, math.floor(time), crim)
	
	-- Dispaly why the jail was issued if admin jailed
	if reason and admin then
		outputChatBox("You have been jailed for: "..tostring(time).." seconds, by: "..getPlayerName(admin)..", reason: "..reason, crim, 200, 0, 0)
		outputServerLog("ADMIN: "..getPlayerName(crim).." was jailed by: "..getPlayerName(admin).." for: "..tostring(time).." seconds, reason: "..reason)
	else
		outputChatBox("You have been jailed for: "..tostring(time).." seconds", crim, 200, 0, 0)
	end
end

--[[ Occurs on failed jail escape attempts ]]--
function resume_jail(totalAmmo, killer, killerWeapon, bodypart, stealth)
	if jail_data.is_jailed[source] then
		-- Get and save weapons temporary
		local weapons = { 0,0,0,0,0,0,0,0,0,0,0,0 }
		local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }
		for k,wep in pairs(weapons) do
		   	weapons[k] = getPedWeapon(source, k)
		   	setPedWeaponSlot(source, getSlotFromWeapon(weapons[k]))
		   	ammo[k] = getPedTotalAmmo(source, k)
		end
	
		local rand_x = math.random(1,10)
		local rand_y = math.random(1,10)
		fadeCamera(source, false, 2, 135, 135, 135)
		setTimer(spawnPlayer, 2100, 1, source, -2965+((-5)+rand_x), 2305+((-5)+rand_y), 8, 180, getElementModel(source), 0, 0, getTeamFromName("Criminals"))
		setTimer(set_control_states, 3000, 1, source, false)
		setTimer(fadeCamera, 2500, 1, source, true, 3)
		
		-- Restore weapons
		if weapons then
			for k,wep in ipairs(weapons) do
			   	if weapons[k] and ammo[k] then
			   		if ammo[k] > 5000 then ammo[k] = 5000 end
			   		setTimer(giveWeapon, 3000, 1, source, weapons[k], ammo[k], false)
			   	end
			end
		end
	end
end
addEventHandler("onPlayerWasted", root, resume_jail)

--[[ Release from jail (if not escaped )]]--
function Unjail(crim, police_dept, reason, admin)
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return end
	if not police_dept then outputServerLog("GTW-RPG: (Wanted) Please specify a police department") end
	if not jail_data.is_jailed[crim] then
		exports.GTWtopbar:dm(getPlayerName(crim).." is already in free!", crim, 255, 150, 0)
		return
	end
	
	-- Get release point and it's coordinates
	local name,x,y,z,rot = release_locations[police_dept][1],
		release_locations[police_dept][2],release_locations[police_dept][3],
		release_locations[police_dept][4],release_locations[police_dept][5]
		
	-- Inform the suspect
	exports.GTWtopbar:dm("You have been released from jail! Location: "..name, crim, 0, 255, 0)
	set_control_states(crim, true)
	
	-- Clear memory, the player is free
	jail_data.is_jailed[crim] = nil
	jail_data.last_location[crim] = nil
	if isTimer(jail_data.release_timers[crim]) then
		killTimer(jail_data.release_timers[crim])
	end
	jail_data.release_timers[crim] = nil
	if isTimer(jail_data.info_timers[crim]) then
		killTimer(jail_data.info_timers[crim])
	end
	jail_data.info_timers[crim] = nil
	setElementData(crim, "Jailed", nil)
	setElementData(crim, "arrested", nil)
	exports.GTWwanted:setWl(crim, 0, 0)
	
	-- Dispaly why the unjail was issued if admin jailed
	if admin then
		outputChatBox("You have been released by: "..getPlayerName(admin), crim, 200, 0, 0)
		outputServerLog("ADMIN: "..getPlayerName(crim).." was released by: "..getPlayerName(admin))
	end
	
	-- Get and save weapons temporary
	local weapons = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	for k,wep in pairs(weapons) do
	   	weapons[k] = getPedWeapon(crim, k)
	   	setPedWeaponSlot(crim, getSlotFromWeapon(weapons[k]))
	   	ammo[k] = getPedTotalAmmo(crim, k)
	end
	
	-- Release and spawn
	local rand_x = math.random(1,5)
	local rand_y = math.random(1,5)
	local own_skin = exports.GTWclothes:getBoughtSkin(crim) or getElementModel(crim) or 0
	setTimer(spawnPlayer, 1100, 1, crim, x+((-2)+rand_x), y+((-2)+rand_y), z, rot, own_skin, 0, 0, getTeamFromName("Criminal"))
	fadeCamera(crim, false)
	setTimer(fadeCamera, 1500, 1, crim, true)
	
	-- Restore weapons
	if weapons then
		for k,wep in ipairs(weapons) do
		   	if weapons[k] and ammo[k] then
		   		if ammo[k] > 5000 then ammo[k] = 5000 end
		   		setTimer(giveWeapon, 1500, 1, crim, weapons[k], ammo[k], false)
		   	end
		end
	end
	
	-- Set team and occupation
	setPlayerNametagColor(crim, 170, 0, 0)
	setElementData(crim, "Occupation", "Criminal")
end

-- Check escape
function check_escape()
	for k,v in pairs(getElementsByType("player")) do
		if getElementData(v, "Occupation") == "Prisoner" then
			local x,y,z = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(-3000, 2305, 8, x,y,z)
			if dist > 350 and getElementInterior(v) == 0 and getElementDimension(v) == 0 then
				jail_escape(v)
			end
		end
	end
end

-- Escape
function jail_escape(crim)
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return end
	
	-- Clear memory, the player is free
	if isTimer(jail_data.release_timers[crim]) then
		killTimer(jail_data.release_timers[crim])
	end
	jail_data.is_jailed[crim] = nil
	jail_data.last_location[crim] = nil
	jail_data.release_timers[crim] = nil
	if isTimer(jail_data.info_timers[crim]) then
		killTimer(jail_data.info_timers[crim])
	end
	jail_data.info_timers[crim] = nil
	setElementData(crim, "Jailed", nil)
	setElementData(crim, "arrested", nil)
	set_control_states(crim, true)
	setElementData(crim, "Occupation", "Criminal")
	
	-- Notify cops
	for k,v in pairs(getElementsByType("player")) do
		if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName("Government") then
			outputChatBox(getPlayerName(crim).." has escaped from jail! Kill him", v, 255, 100, 0)
			exports.GTWtopbar:dm(getPlayerName(crim).." has escaped from jail! Kill him", v, 255, 100, 0)
		end
	end
	
	-- Set the wanted level
	exports.GTWwanted:setWl(crim, 10, 300, "You committed the crime of jailbreak")
end

-- Show the time left when jailed
function sync_time_display(crim)
	if isElement(crim) then
		-- Count down
		local time = getTickCount()
		setElementData(crim, "jailTime2", time)
	end
end

function isJailed(crim)
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return false end
	if jail_data.is_jailed[crim] then return true 
	else return false end	
end

function set_control_states(crim, n_state)
	toggleControl(crim, "fire", n_state)
	toggleControl(crim, "aim_weapon", n_state)
	toggleControl(crim, "enter_exit", n_state)
	toggleControl(crim, "next_weapon", n_state)
	toggleControl(crim, "previous_weapon", n_state)
end

-- Check if anyone escaped on regular intervalls
setTimer(check_escape, 10000, 0)