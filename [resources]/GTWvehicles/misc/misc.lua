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

--[[ Drop players with a rope from helicopters ]]--
function drop_player(plr, command)
	-- Fastrope on helis
	if not getPedOccupiedVehicle(plr) then return end
	for k, pl in pairs(getVehicleOccupants(getPedOccupiedVehicle(plr))) do
		if pl and isElement(pl) then
			exports.fastrope:createFastRopeOnHeli(plr, getPedOccupiedVehicle(plr))
			exports.fastrope:addPlayerToFastRope(pl, 0)
		end
	end
end
addCommandHandler("drop", drop_player)

-- ********************************************************************

--[[ Gear box stuff, TODO: rewrite from scratch in different resource ]]--
--[[function showGearProfile(player,veh)
	if getPlayerTeam(player) and getPlayerTeam(player) == getTeamFromName("Unemployed") and math.random(1,20) == 10 then
		exports.GTWtopbar:dm("Gear box: profile is: "..getElementData(veh, "gearType")..
			", use /drive, /sport or /race to change", player, 255, 200, 0)
	end
end

-- Manage vehicle gear box and commands
function getRelMass(value, mass)
	if(mass/700) > 1 then
		return value/(mass/1000)
	else
		return value
	end
end
function gearBox(veh, player)
	if veh and isElement(veh) and isElement(player) and getVehicleType(veh) == "Automobile" then
		if getElementData(veh, "gearType") == "Drive" then
			local result = getVehicleHandling(veh)
	 		local maxVelocity = tonumber(result["maxVelocity"])
	 		local mass = tonumber(result["mass"])
	 		if mass > 7500 then
	 			mass =(mass/4)
	 		elseif mass > 4500 then
	 			mass =(mass/3)
	 		elseif mass > 3000 then
	 			mass =(mass/2)
	 		end

	 		local speedx, speedy, speedz = getElementVelocity(veh)
			local actualspeed =(speedx^2 + speedy^2 + speedz^2)^(0.5)
			local kmh = actualspeed * 180

			if kmh <= getRelMass(30, mass) then
				setVehicleHandling(veh, "maxVelocity", getRelMass(80, mass))
			elseif kmh >= getRelMass(30, mass) and kmh < getRelMass(70, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(110, mass))
			elseif kmh >= getRelMass(60, mass) and kmh < getRelMass(90, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(130, mass))
			elseif kmh >= getRelMass(90, mass) and kmh < getRelMass(120, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(140, mass))
			elseif kmh >= getRelMass(120, mass) and kmh < getRelMass(150, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(170, mass))
			elseif kmh >= getRelMass(150, mass) and kmh < getRelMass(180, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(210, mass))
			elseif kmh >= getRelMass(180, mass) and kmh < getRelMass(210, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(230, mass))
			elseif kmh >= getRelMass(210, mass) and kmh < getRelMass(240, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(260, mass))
			elseif kmh >= getRelMass(240, mass) and kmh < getRelMass(270, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(290, mass))
			elseif kmh >= getRelMass(270, mass) and kmh < getRelMass(300, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(320, mass))
			elseif kmh >= getRelMass(300, mass) and kmh < getRelMass(330, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(350, mass))
			elseif kmh >= getRelMass(330, mass) and kmh < getRelMass(360, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(380, mass))
			elseif kmh >= getRelMass(360, mass) and kmh < getRelMass(390, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(450, mass))
			end
		elseif getElementData(veh, "gearType") == "Race" then
			local result = getVehicleHandling(veh)
	 		local maxVelocity = tonumber(result["maxVelocity"])
	 		local mass = tonumber(result["mass"])
	 		if mass > 7500 then
	 			mass =(mass/4)
	 		elseif mass > 4500 then
	 			mass =(mass/3)
	 		elseif mass > 3000 then
	 			mass =(mass/2)
	 		end

	 		local speedx, speedy, speedz = getElementVelocity(veh)
			local actualspeed =(speedx^2 + speedy^2 + speedz^2)^(0.5)
			local kmh = actualspeed * 180

			if kmh <= getRelMass(30, mass) then
				setVehicleHandling(veh, "maxVelocity", 900)
			elseif kmh >= getRelMass(30, mass) and kmh < 70 and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", 750)
			elseif kmh >= getRelMass(60, mass) and kmh < 90 and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(240, mass))
			elseif kmh >= getRelMass(90, mass) and kmh < 120 and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(300, mass))
			elseif kmh >= getRelMass(120, mass) and kmh < 150 and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(660, mass))
			elseif kmh >= getRelMass(150, mass) and kmh < getRelMass(180, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(790, mass))
			elseif kmh >= getRelMass(180, mass) and kmh < getRelMass(210, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(720, mass))
			elseif kmh >= getRelMass(210, mass) and kmh < getRelMass(240, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(850, mass))
			elseif kmh >= getRelMass(240, mass) and kmh < getRelMass(270, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(880, mass))
			elseif kmh >= getRelMass(270, mass) and kmh < getRelMass(300, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(910, mass))
			elseif kmh >= getRelMass(300, mass) and kmh < getRelMass(330, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(1040, mass))
			elseif kmh >= getRelMass(330, mass) and kmh < getRelMass(360, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(1170, mass))
			elseif kmh >= getRelMass(360, mass) and kmh < getRelMass(390, mass) and kmh < currVehTopSpeed[veh] then
				setVehicleHandling(veh, "maxVelocity", getRelMass(1300, mass))
			end
		end
	else
		if isTimer(gearTimers[veh]) then
			killTimer(gearTimers[veh])
		end
	end
end

function sport(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") ~= "Sport"  then
		setElementData(veh, "gearType", "Sport")
		exports.GTWtopbar:dm("Gear box: profile is: Sport, use /drive or /race to change", thePlayer, 255, 200, 0)
		setVehicleHandling(veh, "maxVelocity", nil, false)
    end
end
addCommandHandler("sport", sport)
function sport2(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") ~= "Sport" and(veh_police[getElementModel(veh)] or
    		veh_fireman[getElementModel(veh)] or veh_medic[getElementModel(veh)]) then
		setElementData(veh, "gearType", "Sport")
		setVehicleHandling(veh, "maxVelocity", nil, false)
    end
end
addCommandHandler("sport2", sport2)
function drive(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(thePlayer, "gearType") ~= "Drive" then
		setElementData(veh, "gearType", "Drive")
		exports.GTWtopbar:dm("Gear box: profile is: Drive, use /sport or /race to change", thePlayer, 255, 200, 0)
		setVehicleHandling(veh, "maxVelocity", nil, false)
		local result = getVehicleHandling(veh)
	 	currVehTopSpeed[veh] = tonumber(result["maxVelocity"])
    end
end
addCommandHandler("drive", drive)
function raceMode(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") ~= "Race" and not slow_vehicles[getElementModel(veh)] then
		setElementData(veh, "gearType", "Race")
		exports.GTWtopbar:dm("Gear box: profile is: Race, use /sport or /drive to change", thePlayer, 255, 200, 0)
		setVehicleHandling(veh, "maxVelocity", nil, false)
		local result = getVehicleHandling(veh)
	 	currVehTopSpeed[veh] = tonumber(result["maxVelocity"])
	elseif slow_vehicles[getElementModel(veh)] then
		exports.GTWtopbar:dm("This vehicle was not invented for racing!", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("race", raceMode)

function gearUp(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") == "Drive" then
    	sport(thePlayer, "sport")
    elseif isElement(veh) and getElementData(veh, "gearType") == "Sport" then
    	raceMode(thePlayer, "race")
    end
end
addCommandHandler("gearup", gearUp)
function gearDown(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") == "Race" then
    	sport(thePlayer, "sport")
    elseif isElement(veh) and getElementData(veh, "gearType") == "Sport" then
    	drive(thePlayer, "drive")
    end
end
addCommandHandler("geardown", gearDown)
function nextGear(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or not isElement(veh) or getVehicleType(veh) ~= "Automobile" then return end
    if isElement(veh) and getElementData(veh, "gearType") == "Drive" then
    	sport(thePlayer, "sport")
    elseif isElement(veh) and getElementData(veh, "gearType") == "Sport" then
    	raceMode(thePlayer, "race")
    elseif isElement(veh) and getElementData(veh, "gearType") == "Race" then
    	drive(thePlayer, "drive")
    end
end
addCommandHandler("nextgear", nextGear)]]--

function topSpeed(thePlayer, command)
	local veh = getPedOccupiedVehicle(thePlayer)
	if veh then
		outputChatBox("Current top speed: "..currVehTopSpeed[veh], thePlayer, 255, 200, 0)
	end
end
addCommandHandler("topspeed", topSpeed)

function setPlateText(thePlayer, cmd, ...)
	local arg = table.concat({...}, " ")
	if getPedOccupiedVehicle(thePlayer) then
		setVehiclePlateText(getPedOccupiedVehicle(thePlayer), arg)
	end
end
addCommandHandler("plate", setPlateText)
