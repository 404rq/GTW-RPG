--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Global variables
cooldown 		= nil
fire_cooldown 		= nil
damage_cooldown		= nil
target_cooldown		= nil
speeding_cooldown 	= nil

--[[ Check if a player is on the law side ]]--
function is_law_unit(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local law_teams = {
		["Government"]=true,
		["Staff"]=true,
	}
	if getPlayerTeam(plr) and law_teams[getTeamName(getPlayerTeam( plr ))] then
		return true
	else
		return false
	end
end

--[[ Set and pass wanted level to the server ]]--
function setWl(level, violent_time, reason, require_nearby_cop, reduce_health)
	triggerServerEvent("GTWwanted.serverSetWl", localPlayer, level, violent_time, reason, require_nearby_cop, reduce_health)
end

--[[ Return wanted level and remaining violent time ]]--
function getWl(plr)
	if not plr then plr = localPlayer end
	local wl = getElementData(plr, "Wanted")
	local viol = getElementData(plr, "violent_seconds")
	return (wl or 0), (viol or 0)
end

--[[ Crimes related to crashing and damaging vehicles ]]--
function crime_vehicle_collision(collider, force, bodyPart, x, y, z, nx, ny, nz)
	if (cooldown or 0) > getTickCount()-3000 then return end
	local wl = force * getVehicleHandling(source).collisionDamageMultiplier * 0.0001
	local bike_list = {[581]=true,[509]=true,[481]=true,[462]=true,[521]=true,[463]=true,[510]=true,[522]=true,[461]=true,[448]=true,[468]=true,[586]=true}
	if source and isElement(source) and bike_list[getElementModel(source)] then force = force/20 wl = wl*20 end

	-- Kill the ped if the force is too big
	if collider and isElement(collider) and getElementType(collider) == "ped" and collider ~= localPlayer and force/getVehicleHandling(source).collisionDamageMultiplier > 20 then
		if not isPedDead(collider) then triggerServerEvent("GTWwanted.serverKillPed", localPlayer, collider, localPlayer, bodyPart) end
		--setWl(0.5, 60, "You comitted the crime of murder", false, false)
	elseif collider and isElement(collider) and getElementType(collider) == "player" and collider ~= localPlayer and force/getVehicleHandling(source).collisionDamageMultiplier > 40 then
		if not isPedDead(collider) then triggerServerEvent("GTWwanted.serverKillPed", localPlayer, collider, localPlayer, bodyPart) end
		--setWl(1, 120, "You comitted the crime of murder", false, false)
	end

	local viol = 0
	if wl > 0.1 then viol = 30 end
	if wl < 0.05 then return end
	if source ~= getPedOccupiedVehicle(localPlayer) then return end
	if viol == 0 then
		setWl(wl, viol, "You comitted the crime of bad driving", true, true)
	else
		setWl(wl, viol, "You comitted the crime of bad driving", false, true)
	end
	cooldown = getTickCount()
end
addEventHandler("onClientVehicleCollision", root, crime_vehicle_collision)

function crime_fire_weapon(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if isTimer(fire_cooldown) then return end
	if hitElement == localPlayer or source ~= localPlayer then return end
	if is_law_unit(localPlayer) and hitElement and isElement(hitElement) and ((
		getElementType(hitElement) == "player" and getWl(hitElement) > 0) or (
		getElementType(hitElement) == "vehicle" and getVehicleOccupant(hitElement)
		and getWl(getVehicleOccupant(hitElement)) > 0)) then return end

	-- Get number of occupants
	occuCount = 0
	if hitElement and isElement(hitElement) and getElementType(hitElement) == "vehicle" and getVehicleOccupants(hitElement) then
		for k,v in pairs(getVehicleOccupants(hitElement)) do
  			occuCount = occuCount + 1
		end
	end

	-- Get wanted for shooting at vehicles or other objects
    	if weapon ~= 42 and weapon ~= 43 and isElement(hitElement) and getElementType(hitElement) == "vehicle" and occuCount > 0 then
       		setWl(0.3+occuCount, 30+(20*occuCount), "You comitted the crime of vandalism and threat (vehicle with passengers)")
       		fire_cooldown = setTimer(function() end, 7000, 1)
    	elseif weapon ~= 42 and weapon ~= 43 and isElement(hitElement) and getElementType(hitElement) == "vehicle" then
     		setWl(0.3, 5, "You comitted the crime of vandalism (vehicle)")
     		fire_cooldown = setTimer(function() end, 7000, 1)
    	elseif weapon ~= 41 and weapon ~= 42 and weapon ~= 43 and isElement(hitElement) and (getElementType(hitElement) == "player" or
		getElementType(hitElement) == "ped") then
		if getElementData(hitElement, "GTWoutlaws.vBot") then return end
    		setWl(0.5, 10, "You comitted the crime of violence and threat")
    		fire_cooldown = setTimer(function() end, 7000, 1)
    	elseif weapon ~= 41 and not (weapon == 42 and isPedOnFire(hitElement)) and weapon ~= 43 and getElementInterior(localPlayer) > 0 then
    		setWl(0.2, 5, "You comitted the crime of vandalism and threat")
    		fire_cooldown = setTimer(function() end, 7000, 1)
    	end
end
addEventHandler("onClientPlayerWeaponFire", root, crime_fire_weapon)

-- Getting wanted for running over pedastrians
function crime_damage_peds(attacker, weapon, bodypart, loss)
	if getElementData(source, "GTWoutlaws.vBot") then return end
	if isTimer(damage_cooldown) or attacker ~= localPlayer or is_law_unit(attacker) then return end
	setWl(loss/100, 5, "You comitted the crime of violence and threat")
    	damage_cooldown = setTimer(function() end, 1000, 1)
end
addEventHandler("onClientPedDamage", root, crime_damage_peds)

function crime_target_weapon(target)
	if isTimer(target_cooldown) then return end
	if target and getElementData(target, "GTWoutlaws.vBot") then return end
	if not target or target == localPlayer or source ~= localPlayer then return end
	if target and isElement(target) and ((
		getElementType(target) == "player" and getWl(target) > 0) or (
		getElementType(target) == "vehicle" and getVehicleOccupant(target)
		and getWl(getVehicleOccupant(target)) > 0)) then return end

	-- Speeding camera allow law units to catch speeders
	if is_law_unit(localPlayer) and getControlState("aim_weapon") and
		getPedWeapon(localPlayer) == 43 and isElement(target) then
		local speedx, speedy, speedz = getElementVelocity(target)
		local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
		local kmh = actualspeed * 180
		if kmh > 70 and not isTimer(speeding_cooldown) then
			triggerServerEvent("GTWwanted.onSpeeding", localPlayer, target)
			speeding_cooldown = setTimer(function() end, 10000, 1)
		end
	end

	-- Break here if law unit to prevent getting wanted for aiming
	if is_law_unit(localPlayer) then return end

	-- Get wanted for aiming at other players, vehicles or objects
	if getPedWeapon(localPlayer) ~= 41 and getPedWeapon(localPlayer) ~= 42 and getPedWeapon(localPlayer) ~= 43 and
		not isTimer(target_cooldown) and getControlState("aim_weapon") then
        if getElementType(target) == "player" or getElementType(target) == "ped" then
         	setWl(0.08, 4, "You comitted the crime of threat")
         	target_cooldown = setTimer(function() end, 5000, 1)
        elseif getElementType(target) == "vehicle" then
         	setWl(0.04, 2, "You comitted the crime of threat (vehicle)")
         	target_cooldown = setTimer(function() end, 5000, 1)
        elseif isElement(target) then
         	setWl(0.02, 0, "You comitted the crime of threat (object)")
         	target_cooldown = setTimer(function() end, 5000, 1)
        end
    end
end
addEventHandler("onClientPlayerTarget", root, crime_target_weapon)

function show_max_train_speed()
	if not getPedOccupiedVehicle(localPlayer) then return end
	if getVehicleType(getPedOccupiedVehicle(localPlayer)) ~= "Train" then return end
	local max_speed = getElementData(localPlayer, "GTWwanted.maxTrainSpeed") or 0
	local kmh = getElementData(localPlayer, "GTWwanted.currentTrainSpeed") or 0
	local sx,sy = guiGetScreenSize( )
	local r,g,b = 170,170,170
	if (kmh+30) > max_speed then r,g,b = 255,200,0 end
	if (kmh+20) > max_speed then r,g,b = 255,100,0 end
	if (kmh+10) > max_speed then r,g,b = 255,0,0 end
	if kmh > max_speed then r,g,b = 200,0,0 end
	if kmh > max_speed+5 then r,g,b = 150,0,0 end
	if kmh < 0 then kmh = 0 end
	dxDrawText ( "Train: Speed limit: "..math.floor(kmh).."/"..max_speed, sx-408, sy-33, 0, 0,
		tocolor( 0, 0, 0, 255 ), 0.7, "bankgothic" )
	dxDrawText ( "Train: Speed limit: "..math.floor(kmh).."/"..max_speed, sx-410, sy-35, 0, 0,
		tocolor( r, g, b, 255 ), 0.7, "bankgothic" )
end
addEventHandler("onClientRender", root, show_max_train_speed)

function crime_damage_vehicle(attacker, weapon, loss, x, y, z, tyre)
	-- Verify that the attacker is a player element
	if not attacker or not isElement(attacker) or getElementType(attacker) ~= "player" then return end

	-- Verify that the attacker is the local player
	if attacker ~= localPlayer then return end

	-- Verify cooldown timer
	if isTimer(damage_cooldown) then return end

	-- Break here if law unit to prevent getting wanted for aiming
	if is_law_unit(localPlayer) then return end

	-- Apply wanted level
	setWl(0.08, 3, "You comitted the crime of vandalism (vehicle)")
    	damage_cooldown = setTimer(function() end, 1000, 1)
end
addEventHandler("onClientVehicleDamage", root, crime_damage_vehicle)
