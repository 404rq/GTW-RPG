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

-- Temporary storage of weapons
timers			= { }
awaiting_spawn		= { }
weapon_list 		= {{ }}
ammo_list 		= {{ }}

-- List of available hospitals
hs_table = {  -- x	y	z			rot	view x			view y			view z
	[1]={ 1177,	-1320,	14.137756347656, 	270, 	1200.6923828125, 	-1324.9873046875, 	20.398437	},
	[2]={ -2666, 	630,	13.567041397095, 	180, 	-2664.4501953125, 	611.0771484375, 	20.454549789429 },
	[3]={ 1607,	1818, 	10.8203125, 		0, 	1607.3310546875, 	1839.7470703125, 	16.8203125 	},
	[4]={ 2040, 	-1420, 	16.9921875, 		90, 	2031.8486328125, 	-1419.5927734375, 	22.9921875 	},
	[5]={ -2200, 	-2308, 	30.625, 		-45, 	-2193.5888671875, 	-2301.6630859375, 	36.625 		},
	[6]={ 208, 	-65.3, 	1.4357746839523, 	180, 	208.310546875, 		-75.525390625, 		7.4357746839523 },
	[7]={ 1245.8, 	336.9, 	19.40625, 		-20, 	1250.3759765625, 	346.681640625, 		25.40625 	},
	[8]={ -317.4, 	1056.4, 19.59375, 		0,	-316.8125, 		1066.306640625, 	25.59375 	},
	[9]={ -1514.8, 	2527.9, 55.6875, 		1.790, 	-1514.283203125, 	2536.412109375, 	61.6875 	},
}

-- Cost of the healthcare
hs_charge 			= 500
hs_respawn_time 		= 10	-- Check GTWjail respawn times if you decide to change this value!
hs_spawn_protection_time 	= 20

--[[ Load all the hospitals from the table ]]--
function load_hospitals()
	for i=1, #hs_table do
		createBlip(hs_table[i][1], hs_table[i][2], hs_table[i][3], 22, 1, 0, 0, 0, 255, 2, 180)
		local h_marker = createMarker(hs_table[i][1], hs_table[i][2], hs_table[i][3]-1, "cylinder", 2, 0, 200, 0, 30)
		addEventHandler("onMarkerHit", h_marker, hs_start_heal)
		addEventHandler("onMarkerLeave", h_marker, hs_stop_heal)
	end
end
addEventHandler("onResourceStart", resourceRoot, load_hospitals)

--[[ Return the nearest hospital depending on a players location ]]--
function get_nearest_hospital(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local n_loc,min = nil,9999
	for k,v in ipairs(hs_table) do
		-- Get the distance for each point
		local px,py,pz=getElementPosition(plr)
		
		-- Use cached coordinates if player is inside interior
		if getElementDimension(plr) ~= 0 or getElementInterior(plr) ~= 0 then
			if getElementData(plr, "interiors.px") then px = getElementData(plr, "interiors.px") end
			if getElementData(plr, "interiors.py") then py = getElementData(plr, "interiors.py") end
			if getElementData(plr, "interiors.pz") then pz = getElementData(plr, "interiors.pz") end
		end
		
		-- Meassure distance to nearest hospital
		local dist = getDistanceBetweenPoints2D(px,py,v[1],v[2])

		-- Update coordinates if distance is smaller
		if dist < min then
			n_loc = v
			min = dist
		end

		-- 2015-03-01 Dead in interior? respawn at LS hospital
		if getElementInterior(plr) > 0 then break end
	end

	-- Check if jailed or not and return either hospital or jail
	local isJailed = exports.GTWjail:isJailed(thePlayer)
	if not isJailed then
		return n_loc[1]+math.random(-1,1),n_loc[2]+math.random(-1,1),n_loc[3],n_loc[4],n_loc[5],n_loc[6],n_loc[7]
	else
		return -2965+math.random(-5,5),2305+math.random(-5,5),9,270
	end
end

--[[ Toggle controls for a player ]]--
function toggle_controls(plr, n_state)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	toggleControl(plr, "jump", n_state)
	toggleControl(plr, "sprint", n_state)
    	toggleControl(plr, "crouch", n_state)
    	toggleControl(plr, "fire", n_state)
    	toggleControl(plr, "aim_weapon", n_state)
    	toggleControl(plr, "enter_exit", n_state)
    	toggleControl(plr, "enter_passenger", n_state)
    	toggleControl(plr, "forwards", n_state)
	toggleControl(plr, "walk", n_state)
 	toggleControl(plr, "backwards", n_state)
  	toggleControl(plr, "left", n_state)
  	toggleControl(plr, "right", n_state)
  	toggleControl(plr, "vehicle_fire", n_state)
end

--[[ Respawn after death "onPlayerSpawn" ]]--
function player_Spawn(x,y,z, r, team_name, skin_id, int,dim)
	-- Check if a player is picked up by an ambulance
	if not awaiting_spawn[source] then return end

	-- Restore weapons
	if weapon_list[source] and ammo_list[source] then
		for k,wep in ipairs(weapon_list[source]) do
			if weapon_list[source][k] and ammo_list[source][k] then
				-- Return ammo to the player
				giveWeapon(source, weapon_list[source][k], ammo_list[source][k], false)

				-- Clean up used space
				weapon_list[source][k] = nil
				ammo_list[source][k] = nil
			end
		end
	end

	-- Check if jailed
	local isJailed = exports.GTWjail:isJailed(source)
	if isJailed then return end

	-- Set camera view target
	local x,y,z, r, vx,vy,vz = get_nearest_hospital(source)
	setCameraMatrix(source, vx,vy,vz, x,y,z, 0,75)

	-- Fade in the camera and set it's target
	fadeCamera(source, true, 6,255,255,255)

	-- Make sure the player is not frozen
	setElementFrozen(source, false)
	toggle_controls(source, false)
	setTimer(finish_spawn, 8000, 1, source)

	-- Set health to 30
	setElementHealth(source, 30)

	-- Reset ambulance data
	awaiting_spawn[source] = nil

	-- Infom the player about his respawn
	exports.GTWtopbar:dm("Hospital: You have been healed at "..getZoneName(x,y,z)..", for a cost of $"..hs_charge, source, 255, 100, 0)
end
addEventHandler("onPlayerSpawn", root, player_Spawn)

--[[ Helper function for spawn triggers and style ]]--
function finish_spawn(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	setCameraTarget(plr, plr)

	-- Enable controls
	toggle_controls(plr, true)

	-- Play a spawn sound
	playSoundFrontEnd(plr, 11)

	-- Enable spawn protection
	triggerClientEvent(plr, "GTWhospital.setSpawnProtection", plr, hs_spawn_protection_time)
end

--[[ On player wasted, fade out and send to hospital ]]--
function on_death(ammo, attacker, weapon, bodypart)
	-- Save all weapons currently hold by a player
	weapon_list[source] 	= { 0,0,0,0,0,0,0,0,0,0,0,0 }
	ammo_list[source] 	= { 0,0,0,0,0,0,0,0,0,0,0,0 }

	-- Check all weapon slots and save their ammo
	for k,v in ipairs(weapon_list[source]) do
		weapon_list[source][k] = getPedWeapon(source, k)
		setPedWeaponSlot(source, k)
		ammo_list[source][k] = getPedTotalAmmo(source, k)
	end

	-- Check if jailed or not
	local isJailed = exports.GTWjail:isJailed(source)
	if isJailed then return end

	-- Make sure warp to hospital is possible
	if getPedOccupiedVehicle(source) then removePedFromVehicle(source) end

	-- Take some of the money
	takePlayerMoney(source, hs_charge)
	fadeCamera(source, false, 8, 0, 0, 0)

	-- Respawn player after "hs_respawn_time" seconds
	setTimer(plr_respawn, hs_respawn_time*1000, 1, source)

	-- Add to respawn
	awaiting_spawn[source] = true

	-- Notify player about his death
	exports.GTWtopbar:dm("Hospital: You are dead! an ambulance will pick you up soon", source, 255, 100, 0)
end
addEventHandler("onPlayerWasted", root, on_death)

--[[ Helper function to spawn player ]]--
function plr_respawn(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local x,y,z, r, vx,vy,vz = get_nearest_hospital(plr)
	spawnPlayer(plr, x,y,z+1, r, getElementModel(plr), 0,0, getPlayerTeam(plr))
end

--[[ Dump weapons into users database on quit ]]--
function dump_weapons()
	-- Get player account
    local acc = getPlayerAccount(source)

    -- Reset ambulance data
	awaiting_spawn[source] = nil

    -- Check if there is any weapons in memory
    if not weapon_list[source] then return end

    -- Save the weapons and ammo stored in memory
    for k,w in ipairs(weapon_list[source]) do
	    if weapon_list[source][k] and ammo_list[source][k] then
	   		setAccountData(acc, "acorp.weapon."..tostring(k), weapon_list[source][k])
	   		setAccountData(acc, "acorp.ammo."..tostring(k), ammo_list[source][k])
	   	end
	end
end
addEventHandler("onPlayerQuit", root, dump_weapons)

--[[ Heal player once in a health marker ]]--
function hospital_heal(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local health = getElementHealth(plr)
	local charge = math.floor(hs_charge/10)
    	if health < 90 and getPlayerMoney(plr) >= charge then
    		setElementHealth(plr, health+10)
    		takePlayerMoney(plr, charge)
    	elseif getPlayerMoney(plr) >= charge then
    		setElementHealth(plr, 100)
    		takePlayerMoney(plr, charge)
    		exports.GTWtopbar:dm("Hospital: Go away, you're fine!", plr, 255, 100, 0)
    		if isTimer(timers[plr]) then
			killTimer(timers[plr])
		end
    	elseif getPlayerMoney(plr) < charge then
    		exports.GTWtopbar:dm("Hospital: You can't afford the healthcare!", plr, 255, 0, 0)
    	end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Start an healing timer, increasing the health of a player ]]--
function hs_start_heal(hitElement, matchingDimension)
	if isTimer(timers[hitElement]) then killTimer(timers[hitElement]) end
	if getElementHealth(hitElement) < 90 then
		exports.GTWtopbar:dm("Stay in the marker to get healed!", hitElement, 255, 100, 0)
    		timers[hitElement] = setTimer(hospital_heal, 1400, 0, hitElement)
    	end
end

--[[ Stop and kill the heal timers ]]--
function hs_stop_heal(plr, matchingDimension)
	if isTimer(timers[plr]) then killTimer(timers[plr]) end
end
