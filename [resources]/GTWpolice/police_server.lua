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

police_data = {
	is_arrested 		= { },
	is_tazed 		= { },
	arrested_players 	= { },
}
tracker_timers 	= { }
max_jail_time	= 1800
min_jail_time 	= 30

--[[ Pay the cop for arrest ]]--
function pay_cop(cop, wl, viol_sec)
	local money = 30
	local payout = (money * wl) + (money * viol_sec/10)
	if payout < 300 then
		payout = 300
	elseif payout > 100000 then
		payout = 100000
	end
	if not cop or not wl or not viol_sec or not isElement(cop) or getElementType(cop) ~= "player" then return end
	givePlayerMoney(cop, payout)
	return payout or 0
end

--[[ Arrest or taze a player ]]--
function arrest_or_taze(attacker, attackerweapon)
	-- Get the team
	if not attacker or not isElement(attacker) or getElementType(attacker) ~= "player"
		or not getPlayerTeam(attacker) or not getPlayerTeam(source) then return end

	-- Get the wanted level as int
	local wl,viol = exports.GTWwanted:getWl(source)

	-- Arrest players
	if attackerweapon == 3 and wl > 0 and not getPedOccupiedVehicle(source) and
		isLawUnit(attacker) and getElementData(source, "Jailed") ~= "Yes" and
		not police_data.arrested_players[attacker] and not police_data.is_arrested[crim] then

		-- Setting the control data
		if isTimer(prisonerSyncTimers[source]) then
			killTimer(prisonerSyncTimers[source])
			setElementCollisionsEnabled(source, true)
		end
		prisonerSyncTimers[source] = setTimer(syncArrest, 500, 0, source, attacker)
		setElementCollisionsEnabled(source, false)
		exports.GTWtopbar:dm("You have been arrested by: "..getPlayerName(attacker).."!", source, 255, 0, 0)
		exports.GTWtopbar:dm("You have arrested: "..getPlayerName(source)..", take him to nearest police department", attacker, 0, 255, 0)

		-- Arrested players: indexed by cops, holding suspects
		police_data.arrested_players[attacker] = source
		police_data.is_arrested[source] = true
		setElementData(source, "arrested", true)
		police_data.is_tazed[source] = nil
		setElementFrozen(source, false)

		-- Arrest suspect
	set_control_states(source, false)

		-- Add jail markers
	for k=1, #cells do
			if not marker[k] then
				marker[k] = {}
			end
			if isElement(marker[k][source]) then
				destroyElement(marker[k][source])
			end

			-- Add delivery markers
			marker[k][source] = createMarker(cells[k][4], cells[k][5], cells[k][6]-1, "cylinder", 3.8, 0, 0, 255, 70, attacker)

			-- Set data for marker
			setElementInterior(marker[k][source], cells[k][2])
			setElementDimension(marker[k][source], cells[k][3])
				setElementData(marker[k][source], "cell", k)
				setElementData(marker[k][source], "release", cells[k][8])
			addEventHandler("onMarkerHit", marker[k][source], deliverSuspect)
	end
	for j=1, #blips do
			if not blipList[j] then
				blipList[j] = {}
			end
			if isElement(blipList[j][source]) then
				destroyElement(blipList[j][source])
			end
			blipList[j][source] = createBlip(blips[j][1], blips[j][2], blips[j][3], 30, 2, 0, 0, 0, 255, 5, 1500, attacker)
	end

	local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

	-- Weapons save
	for k,wep in ipairs(weapon) do
		weapon[k] = getPedWeapon(source, k)
		setPedWeaponSlot(source, getSlotFromWeapon(weapon[k]))
		ammo[k] = getPedTotalAmmo(source, k)
	end
	local ccx,ccy,ccz = getElementPosition(source)
	local rrx,rry,rrz = getElementRotation(source)
	spawnPlayer(source, ccx, ccy, ccz, rrz, getElementModel(source), getElementInterior(attacker), getElementDimension(attacker), getPlayerTeam(source))
	
	-- Weapons restore
	for k,wep in ipairs(weapon) do
	   	if weapon[k] and ammo[k] then
	   		giveWeapon(source, weapon[k], ammo[k], false)
	   	end
	end

	-- Taze suspect
	--local isJailed = exports.GTWjail:isJailed(source)
	elseif attackerweapon == 23 and wl > 0 and getPlayerWantedLevel(source) > 0 and
		not getPedOccupiedVehicle(source) and isLawUnit(attacker) then
		local sx,sy,sz = getElementPosition(source)
		local ax,ay,az = getElementPosition(attacker)
		local tDist = getDistanceBetweenPoints3D(sx,sy,sz, ax,ay,az)
		if tDist < 30 and not police_data.is_tazed[source] then
			exports.GTWtopbar:dm("You have been shot by a tazer, press the jump if you wanna try to escape", source, 255, 0, 0)
			exports.GTWtopbar:dm("Suspect has been tazed, get him before he escape!", attacker, 0, 255, 0)
			fadeCamera(source, false, 5, 255, 255, 255)
				police_data.is_tazed[source] = true
			toggleControl(source, "jump", false)
			setTimer(taze1, 1000, 1, source)
			setTimer(taze2, 10000, 1, source)
			setTimer(taze3, 10500, 1, source)
			setTimer(taze4, 18000, 1, source)
		end
	elseif police_data.arrested_players[attacker] then
		exports.GTWtopbar:dm("You already holding a suspect!", attacker, 255, 0, 0)
  	end
end
addEventHandler("onPlayerDamage", root, arrest_or_taze)

--[[ Check if the death is counted as a kill arrest ]]--
function kill_arrest(ammo, attacker, weapon, bodypart)
	-- Release a suspect hold by a killed police officer
	if getPlayerTeam(source) and isLawUnit(source) and police_data.arrested_players[source] then
		releaseCrim(police_data.arrested_players[source], "releaseondeath")
		return
	end

	-- Kill arrest occurs if there is an attacker that killed the suspect and the suspect is violent
	local is_jailed = exports.GTWjail:isJailed(source)
	local wl,viol = exports.GTWwanted:getWl(source)
	if not is_jailed and attacker and isElement(attacker) and getElementType(attacker) == "player" and
		getPlayerTeam(attacker) and isLawUnit(attacker) and viol > 0 then
		setTimer(Jail, 18000, 1, source, attacker, true)
		setElementData(source, "isKillArrested", true)
		exports.GTWtopbar:dm( "You kill arrested "..getPlayerName(source), attacker, 255, 100, 0 )
		exports.GTWtopbar:dm( "You have been kill arrested by: "..getPlayerName(attacker), source, 255, 0, 0 )
		return
	end

	-- Suicide arrest, works if there's no attacker only, the nearest cop get's the payment if any
	local police = nearestCop(source)
	if police and isElement(police) and distanceToCop(source) < 180 and police ~= attacker and not is_jailed then
		setTimer(Jail, 18000, 1, source, police, true)
		setElementData(source, "isKillArrested", true)
		exports.GTWtopbar:dm(getPlayerName(source).." comitted suicide nearby", police, 255, 100, 0 )
		exports.GTWtopbar:dm("You have been arrested for suicide", source, 255, 0, 0 )
		return
	end
end
addEventHandler("onPlayerWasted", root, kill_arrest)

-- Taze the suspect(safe) 2014-03-04
function taze1(crim)
	if isElement(crim) and not getPedOccupiedVehicle(crim) and police_data.is_tazed[crim] then
		setElementFrozen(crim, true)
		setPedAnimation(crim, "ped", "ko_shot_front", 3000, false)
	end
end
function taze2(crim)
	if isElement(crim) and not getPedOccupiedVehicle(crim) and police_data.is_tazed[crim] then
		setPedAnimation(crim, "ped", "get_up_front", 500, false)
	end
	if isElement(crim) then
		fadeCamera(crim, true, 10, 255, 255, 255)
	end
end
function taze3(crim)
	if isElement(crim) and not getPedOccupiedVehicle(crim) and police_data.is_tazed[crim] then
		setPedAnimation(crim, "ped", "idle_tired", 2000, false)
	end
end
function taze4(crim)
	if isElement(crim) and police_data.is_tazed[crim] then
		police_data.is_tazed[crim] = nil
		toggleControl(crim, "jump", true)
		setElementFrozen(crim, false)
		setPedAnimation(crim, nil, nil)
	end
end

-- Sync
function syncArrest(crim, cop)
	if isElement(crim) and isElement(cop) then
		local sx,sy,sz = getElementPosition(crim)
		local rx,ry,rz = getElementRotation(crim)
		local ax,ay,az = getElementPosition(cop)
		setElementFrozen(crim, false)
		police_data.is_tazed[crim] = nil

		-- Calculate rotation
		if getElementInterior(cop) == getElementInterior(crim) then
			local X = math.abs(sx-ax)
			local Y = math.abs(sy-ay)
			local rot = math.deg(math.atan2(Y,X));
			if(sx >= ax) and(ay > sy) then	  -- north-east
				rot = 90 - rot
			elseif(sx <= ax) and(ay > sy) then  -- north-west
				rot = 270 + rot
			elseif(sx >= ax) and(ay <= sy) then -- south-east
				rot = 90 + rot
			elseif(sx < ax) and(ay <= sy) then  -- south-west
				rot = 270 - rot
			end
			setElementRotation(crim, rx,ry,rot)
		end

		-- Update crim location
		local cx,cy,cz = getElementPosition(cop)
		local rx,ry,rz = getElementRotation(cop)
		local crx,cry,crz = getElementPosition(crim)
		local syncDist = getDistanceBetweenPoints3D(cx,cy,cz, crx,cry,crz)
		if syncDist > 5 then
			local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
			local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

			-- Weapons save
			for k,wep in pairs(weapon) do
			   	weapon[k] = getPedWeapon(crim, k)
			   	setPedWeaponSlot(crim, getSlotFromWeapon(weapon[k]))
			   	ammo[k] = getPedTotalAmmo(crim, k)
			end
			spawnPlayer(crim, cx, cy, cz, rz, getElementModel(crim), getElementInterior(cop), getElementDimension(cop), getPlayerTeam(crim))
			-- Weapons restore
			for k,wep in ipairs(weapon) do
			   	if weapon[k] and ammo[k] then
			   		giveWeapon(crim, weapon[k], ammo[k], false)
			   	end
			end
		end

		-- Force suspect to run
		local tDist = getDistanceBetweenPoints3D(sx,sy,sz, ax,ay,az)
		if tDist < 1 and lastAnim[crim] ~= 1 then
			setPedAnimation(crim, nil, nil)
			lastAnim[crim] = 1
		elseif tDist >= 1 and tDist < 3 and lastAnim[crim] ~= 2 then
			setPedAnimation(crim, "ped", "walk_civi")
			lastAnim[crim] = 2
		elseif tDist >= 3 and tDist < 5 and lastAnim[crim] ~= 3 and getPlayerPing(crim) < 100 then
			setPedAnimation(crim, "ped", "run_civi")
			lastAnim[crim] = 3
		elseif tDist >= 5 and lastAnim[crim] ~= 4 and getPlayerPing(crim) < 200 then
			setPedAnimation(crim, "ped", "sprint_civi")
			lastAnim[crim] = 4
		elseif tDist >= 1 and getPlayerPing(crim) > 299 then
			setPedAnimation(crim, "ped", "walk_civi")
			lastAnim[crim] = 2
		end

		if not isLawUnit(cop) or isPedDead(cop) then
			if isElement(crim) then
				--detachElements(p)
				if isTimer(prisonerSyncTimers[crim]) then
					killTimer(prisonerSyncTimers[crim])
					setPedAnimation(crim, nil, nil)
					setElementCollisionsEnabled(crim, true)
					lastAnim[crim] = 0
				end
				showCursor(crim, false)

				police_data.arrested_players[cop] = nil
				police_data.is_arrested[crim] = nil
				setElementData(crim, "arrested", nil)
				exports.GTWtopbar:dm("You have been released!", crim, 0, 255, 0)
				exports.GTWtopbar:dm("You have released "..getPlayerName(crim), cop, 255, 0, 0)

				-- Reenable controlls
				set_control_states(crim, true)
			end

			-- Remove jail markers
			for k=1, #marker do
			  	if marker[k] and isElement(marker[k][crim]) then
					destroyElement(marker[k][crim])
				end
			end
			for j=1, #blips	do
				if blipList[j] and isElement(blipList[j][crim]) then
					destroyElement(blipList[j][crim])
				end
			end

			if isTimer(prisonerSyncTimers[crim]) then
				killTimer(prisonerSyncTimers[crim])
				setElementCollisionsEnabled(crim, true)
			end
		end

		-- Sync interior and dimension
		setElementInterior(crim, getElementInterior(cop))
		setElementDimension(crim, getElementDimension(cop))
	elseif crim and isElement(crim) then
		if isTimer(prisonerSyncTimers[crim]) then
			killTimer(prisonerSyncTimers[crim])
			setElementCollisionsEnabled(crim, true)
		end
	end
end

-- Admin jail function
function admin_jail(admin, cmd, crim, time, ...)
	local is_staff = exports.GTWstaff:isStaff(admin)
	if not is_staff then
		outputChatBox("You are not allowed to use this command!", admin, 200, 0, 0)
	return
	end
	if not crim then
		outputChatBox("Jail command: /jail <nickname> <time in seconds (minimum 10)> <reason>", admin, 200, 0, 0)
		return
	end
	local suspect = getPlayerFromName(crim)
	if isElement(suspect) then
	   	local arg = {...}
	local reason = table.concat(arg, " ")
	   	if time and reason then
		exports.GTWwanted:setWl(suspect, tonumber(time)/60, 10, reason, false, false)
	   		exports.GTWjail:Jail(suspect, tonumber(time), "LSPD", reason, admin)
	   		exports.GTWtopbar:dm(crim.." was jailed successfully", admin, 0, 255, 0)
	   	else
	   		exports.GTWtopbar:dm("Warning: no time or reason was specified, the player was not jailed", admin, 255, 0, 0)
	   	end
	else
	   	exports.GTWtopbar:dm("Warning: no suspect found with that name ("..crim..")", admin, 255, 0, 0)
	end
end
addCommandHandler("jail", admin_jail)

-- Admin unjail function
function admin_jail_release(admin, cmd, crim)
	local is_staff = exports.GTWstaff:isStaff(admin)
	if not is_staff then
		outputChatBox("You are not allowed to use this command!", admin, 200, 0, 0)
		return
	end
	if not crim then
		outputChatBox("Unjail command: /unjail <nickname>", admin, 200, 0, 0)
		return
	end
	local suspect = getPlayerFromName(crim)
	if suspect and isElement(suspect) then
	   	exports.GTWjail:Unjail(suspect, "LSPD", "", admin)
	   	exports.GTWtopbar:dm(crim.." was released successfully", admin, 0, 255, 0)
	else
	   	exports.GTWtopbar:dm("Warning: no suspect found with that name ("..crim..")", admin, 255, 0, 0)
	end
end
addCommandHandler("unjail", admin_jail_release)

-- Jail a criminal
function Jail(crim, cop, pay_the_cop)
	-- Make sure there is a criminal to jail
	if not isElement(crim) or not getPlayerTeam(crim) then return end
	local is_jailed = exports.GTWjail:isJailed(crim)

	-- Make sure the player has wanted level and is not already in jail
	if is_jailed or getPlayerWantedLevel(crim) == 0 then return end

	-- Get current wanted level and violent time
	local wl,viol_sec = exports.GTWwanted:getWl(crim)

	-- 10 seconds/star min 60 seconds max 20 minutes
	local jailTime = math.floor(wl*60)
	if jailTime < min_jail_time then
		jailTime = min_jail_time
	elseif jailTime > max_jail_time then
		jailTime = max_jail_time
	end

	fadeCamera(crim, false, 1, 0, 0, 0)
	setElementFrozen(crim, true)
	setTimer(fadeCamera, 1100, 1, crim, true, 4, 0, 0, 0)
	setTimer(setElementFrozen, 4000, 1, crim, false)

	-- Justify
	if not cells[cellID] then
		cellID = math.random(#cells)
	end

	-- Get the cell
	local c_name,ji,jd,jx,jy,jz,rot,rp = unpack(cells[cellID])

	-- Re enable controlls
	if isTimer(prisonerSyncTimers[crim]) then
		killTimer(prisonerSyncTimers[crim])
		setPedAnimation(crim, nil, nil)
		setElementCollisionsEnabled(crim, true)
		lastAnim[crim] = 0
	end

	setElementCollisionsEnabled(crim, true)

	-- Remove jail markers
	for k=1, #marker do
		   	if marker[k] then
			  	if isElement(marker[k][crim]) then
					destroyElement(marker[k][crim])
				end
		end
	end
	for j=1, #blips	do
		if blipList[j] then
			if isElement(blipList[j][crim]) then
					destroyElement(blipList[j][crim])
				end
		end
	end

	-- Enable controls in jail
	set_control_states(crim, true)

	-- Take some of the money as a bribe
	takePlayerMoney(crim, math.floor(wl*10))

	-- Increase stats by 1 for cop
	if cop and isElement(cop) and getElementType(cop) == "player" then
		local playeraccount = getPlayerAccount(cop)
		local arrests = getAccountData(playeraccount, "GTWdata_stats_police_arrests") or 0
		setAccountData(playeraccount, "GTWdata_stats_police_arrests", arrests + 1)
	end

	-- Increase criminals times in jail stat for crim
	local playeraccount2 = getPlayerAccount(crim)
	local timesInJail = getAccountData(playeraccount2, "GTWdata_stats_times_in_jail") or 0
	setAccountData(playeraccount2, "GTWdata_stats_times_in_jail", timesInJail + 1)

	-- Jail player
	local money = 200
	local pd = getZoneName(jx, jy, jz)
	local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
	local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

	-- Weapons save
	for k,wep in ipairs(weapon) do
	   	weapon[k] = getPedWeapon(crim, k)
	   	setPedWeaponSlot(crim, getSlotFromWeapon(weapon[k]))
	   	ammo[k] = getPedTotalAmmo(crim, k)
	end

	-- Move player to jail
	exports.GTWjail:Jail(crim, math.floor(jailTime), c_name)

	-- Move to criminals team
	local r,g,b = getTeamColor(getTeamFromName("Criminals"))
	setElementData(crim, "Occupation", "Criminal")
	setPlayerNametagColor(crim, r,g,b)

	-- Fix for the weapons bug 2014-01-22
	-- Weapons restore
	for k,wep in ipairs(weapon) do
	   	if weapon[k] and ammo[k] then
	   		giveWeapon(crim, weapon[k], ammo[k], false)
	   	end
	end

	if getElementHealth(crim) > 40 then
		setElementHealth(crim, 40)
	end
	police_data.is_arrested[crim] = nil
	if cop and isElement(cop) and crim ~= cop then
		local money = 0
		if pay_the_cop then money = pay_cop(cop, wl, viol_sec) end
		exports.GTWtopbar:dm("You got "..tostring(math.floor(money)).."$ for jailing: " .. getPlayerNametagText(crim), cop, 0, 255, 0)
		exports.GTWtopbar:dm("You have been jailed by the cop: " .. getPlayerNametagText(cop)..
			",(Location: "..pd..")", crim, 255, 255, 0)
		police_data.arrested_players[cop] = nil
	end
end

function set_control_states(crim, n_state)
	toggleControl(crim, "jump", n_state)
	toggleControl(crim, "sprint", n_state)
	toggleControl(crim, "crouch", n_state)
	toggleControl(crim, "fire", n_state)
	toggleControl(crim, "aim_weapon", n_state)
	toggleControl(crim, "enter_exit", n_state)
	toggleControl(crim, "enter_passenger", n_state)
	toggleControl(crim, "forwards", n_state)
	toggleControl(crim, "walk", n_state)
	toggleControl(crim, "backwards", n_state)
	toggleControl(crim, "left", n_state)
	toggleControl(crim, "right", n_state)
	toggleControl(crim, "vehicle_fire", n_state)
end

-- Get wanted for stealing or hijacking police vehicles
function enterLawVehicle(plr, seat, jacked)
	local maxSeats = getVehicleMaxPassengers(source)
	if maxSeats then
		maxSeats = maxSeats+1
		local comp = 0
		for s,occupant in pairs(getVehicleOccupants(source)) do
			if isElement(occupant) and getElementType(occupant) == "player" then
				comp = comp + 1
			end
		end
		local free = (maxSeats - comp)
		if police_data.is_arrested[plr] and seat == 0 then
				exports.GTWtopbar:dm("You are arrested and can't drive!", plr, 255, 0, 0)
				cancelEvent()
		elseif police_data.arrested_players[plr] then
			if free >= 1 then
				local p = police_data.arrested_players[plr]
				if isElement(p) then
					if isTimer(prisonerSyncTimers[p]) then
						killTimer(prisonerSyncTimers[p])
						setPedAnimation(p, false)
						setElementCollisionsEnabled(p, true)
						lastAnim[p] = 0
					end
					if maxSeats == 2 then
						warpPedIntoVehicle(p, source, 1)
					elseif maxSeats > 1 and maxSeats < 5 then
						warpPedIntoVehicle(p, source, 2 or 3)
					else
						warpPedIntoVehicle(p, source, 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11)
					end
				end
			else
				exports.GTWtopbar:dm("This vehicle doesn't have enough free seats!", plr, 255, 0, 0)
				cancelEvent()
			end
		end
		if ((source and(policeVehicles[getElementModel(source)] or
			fireVehicles[getElementModel(source)] or medicVehicles[getElementModel(source)]))
			and getPlayerTeam(plr) and not isLawUnit(plr)
			and seat and seat == 0) then
		end
	end
end
addEventHandler("onVehicleEnter", root, enterLawVehicle)

-- Get wanted for stealing or hijacking police vehicles
function startEnterVehicle(plr, seat, jacked)
	local maxSeats = getVehicleMaxPassengers(source)
	if maxSeats then
		maxSeats = maxSeats+1
		local comp = 0
		for s,occupant in pairs(getVehicleOccupants(source)) do
			if isElement(occupant) and getElementType(occupant) == "player" then
				comp = comp + 1
			end
		end
		local free = (maxSeats - comp)
		if police_data.is_arrested[plr] and(seat == 0) then
			exports.GTWtopbar:dm("You are arrested and can't drive!", plr, 255, 0, 0)
			cancelEvent()
		elseif police_data.arrested_players[plr] then
			if free >= 1 then
				local p = police_data.arrested_players[plr]
				if isElement(p) then
					--detachElements(p)
					if isTimer(prisonerSyncTimers[p]) then
						killTimer(prisonerSyncTimers[p])
						setPedAnimation(p, false)
						setElementCollisionsEnabled(p, true)
						lastAnim[p] = 0
					end
					if maxSeats == 2 then
						warpPedIntoVehicle(p, source, 1)
					elseif maxSeats > 1 and maxSeats < 5 then
						warpPedIntoVehicle(p, source, 2 or 3)
					else
						warpPedIntoVehicle(p, source, 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11)
					end
				end
			else
				exports.GTWtopbar:dm("This vehicle doesn't have enough free seats!", plr, 255, 0, 0)
				cancelEvent()
			end
		end
	end
end
addEventHandler("onVehicleStartEnter", root, startEnterVehicle)

function arrestOnExitDelay(source, cop, seat, jacked)
	if source and isElement(source) and police_data.arrested_players[cop] and getPlayerTeam(cop) then
   		local prisoner = police_data.arrested_players[cop]
   		if prisoner and isElement(prisoner) and getElementType(prisoner) == "player" then
   			removePedFromVehicle(prisoner)
   			local x,y,z = getElementPosition(source)
   			local cx,cy,cz = getElementPosition(cop)
   			local rx,ry,rz = getElementRotation(prisoner)
   			local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
			local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

			-- Weapons save
			for k,wep in ipairs(weapon) do
		   		weapon[k] = getPedWeapon(prisoner, k)
		   		setPedWeaponSlot(prisoner, getSlotFromWeapon(weapon[k]))
		   		ammo[k] = getPedTotalAmmo(prisoner, k)
			end
   			spawnPlayer(prisoner, cx, cy, cz, rz, getElementModel(prisoner), 0, 0, getPlayerTeam(prisoner))
   			-- Weapons restore
			for k,wep in ipairs(weapon) do
		   		if weapon[k] and ammo[k] then
		   			giveWeapon(prisoner, weapon[k], ammo[k], false)
		   		end
			end
   			--attachElements(prisoner, cop, -0.5, 0 )
   			if isTimer(prisonerSyncTimers[prisoner]) then
				killTimer(prisonerSyncTimers[prisoner])
			end
			prisonerSyncTimers[prisoner] = setTimer(syncArrest, 500, 0, prisoner, cop)
			setElementCollisionsEnabled(prisoner, false)
   		end
   		local speedx, speedy, speedz = getElementVelocity(source)
		local actualspeed =(speedx^2 + speedy^2 + speedz^2)^(0.5)
		local kmh = actualspeed * 180
	end
end

-- Reattach suspect after cop exit
function arrestOnExit(cop, seat, jacked)
	setTimer(arrestOnExitDelay, 1000, 1, source, cop, seat, jacked)
end
addEventHandler("onVehicleExit", root, arrestOnExit)

-- Move to the criminal team
function releaseCrim(cop, cmd)
	local crim = police_data.arrested_players[cop]
	if crim and isElement(crim) and getPlayerTeam(crim) then
		--detachElements(p)
		if isTimer(prisonerSyncTimers[crim]) then
			killTimer(prisonerSyncTimers[crim])
			setPedAnimation(crim, nil, nil)
			setElementCollisionsEnabled(crim, true)
			lastAnim[crim] = 0
		end
		showCursor(crim, false)

		police_data.arrested_players[cop] = nil
		police_data.is_arrested[crim] = nil
		setElementData(crim, "arrested", nil)
		exports.GTWtopbar:dm("You have been released!", crim, 0, 255, 0)
		if cmd == "release" then
			exports.GTWtopbar:dm("You have released "..getPlayerName(crim), cop, 255, 0, 0)
		else
			setTimer(function()
				exports.GTWtopbar:dm(getPlayerName(crim).." was released due to your death", cop, 255, 0, 0)
			end, 3500, 1)
		end

		-- Reenable controlls
		set_control_states(crim, true)
	end

	-- Remove jail markers
	for k=1, #marker do
		if marker[k] and isElement(marker[k][crim]) and isElement(crim) then
			destroyElement(marker[k][crim])
		end
	end
	for j=1, #blips	do
		if blipList[j] and isElement(blipList[j][crim]) and isElement(crim) then
			destroyElement(blipList[j][crim])
		end
	end
end
addCommandHandler("release", releaseCrim)

function deliverSuspect(theCop, matchdimension)
	local crim = police_data.arrested_players[theCop]
	if isElement(crim) and isElement(theCop) and matchdimension then
		Jail(crim, theCop, true)
		police_data.arrested_players[theCop] = nil
	end
end

function quitPlayer(quitType)
	local acc = getPlayerAccount(source)
	local is_jailed = exports.GTWjail:isJailed(source)
	if (distanceToCop(source) < 180 and getPlayerWantedLevel(source) > 0 and
		getPlayerTeam(source)) and not is_jailed then
		setAccountData(acc, "GTWdata.police.jailTimeOffline", true)
		-- Find and pay nearest police
		local police = nearestCop(source)
		local wl,viol_sec = exports.GTWwanted:getWl(source)

		-- Remove jail markers
	   	for k=1, #marker do
		   	if marker[k] and isElement(marker[k][source]) then
				destroyElement(marker[k][source])
		   	end
		end
		for j=1, #blips	do
			if blipList[j] and isElement(blipList[j][source]) then
				destroyElement(blipList[j][source])
			end
		end

		-- Take some of the money as a bribe
		local money = 0
		if police and isElement(police) then
			money = pay_cop(police, wl, viol_sec)
		end
		exports.GTWtopbar:dm("You got "..tostring(math.floor(money)).."$ for jailing an evader", police, 0, 255, 0)
	elseif is_jailed and getPlayerWantedLevel(source) > 0 then
		-- Player should be rejailed after logging in again but noone will get paid
		setAccountData(acc, "GTWdata.police.jailTimeOffline", true)
	else
		-- Player should not be arrested after relogin
		setAccountData(acc, "GTWdata.police.jailTimeOffline", nil)
	end

	-- Clean up old unused data
	setAccountData(acc, "acorp.police.isArrested", nil)
	for w,cop in ipairs(getElementsByType("player")) do
		if getPlayerTeam(cop) and isLawUnit(cop) then
			if police_data.arrested_players[cop] == source then
				police_data.arrested_players[cop] = nil
			end
		end
	end
	if isTimer(tracker_timers[source]) then
		killTimer(tracker_timers[source])
	end
end
addEventHandler("onPlayerQuit", root, quitPlayer)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
		getThisResource(), "author")..", v-"..getResourceInfo(
		getThisResource(), "version")..", is represented", plr)
end)

--[[ Validate if a player is a law unit or not ]]--
function isLawUnit(plr)
	-- Check some stuff
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return false end
	if not getPlayerTeam(plr) then return false end

	-- Verify if law unit
	if lawTeams[getTeamName(getPlayerTeam(plr))] then
		return true
	else
		return false
	end
end
