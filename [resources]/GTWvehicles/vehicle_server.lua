--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.gtw-games.org/bug-reports/
	Suggestions:		http://forum.gtw-games.org/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

--[[ List of vehicles not allowed to use the Race gear ]]--
slow_vehicles = {
	[531] = true,
	[532] = true,
}

--[[ Bind the L key to toggle vehicle lights ]]--
function resource_load()
    local players = getElementsByType("player")
    for k,v in pairs(players) do
        bindKey(v, "l", "down", toggle_lights, "Lights on/off")
    end
end
addEventHandler("onResourceStart", resourceRoot, resource_load)
function apply_key_binds()
    bindKey(source, "l", "down", toggle_lights, "Lights on/off")
end
addEventHandler("onPlayerJoin", root, apply_key_binds)

--[[ Helper function for vehicle rental charges ]]--
function pay_vehicle_rent(plr, amount)
	paymentsCounter[plr] = (paymentsCounter[plr] or 0) + amount
end

--[[ Client want to spawn a vehicle ]]--
function spawn_vehicle(vehID, rot, price, spawnx, spawny, spawnz)
    if isElement(client) and vehID and rot and price then
    	local money = getPlayerMoney(client)
	    if money >= price and getPlayerWantedLevel(client) == 0 and 
	    	getElementInterior(client) == 0 then
	   	 	if isElement(vehicles[client]) then
	   	 		triggerEvent("acorp_onDestroyVehilce", client, client)
				if vehicles[client] and getVehicleTowedByVehicle(vehicles[client]) then
		   	 		destroyElement(getVehicleTowedByVehicle(vehicles[client]))
		   	 	end
		   	 	if isElement(trailers[client]) then
   	 				destroyElement(trailers[client])
   	 			end
   	 			if isElement(peds[client]) then
		   	 		destroyElement(peds[client])
		   	 	end
				-- Destroys the old vehicle
				destroyElement(vehicles[client])
				
				-- Pay for previous vehicle
				if isTimer(paymentsHolder[client]) then
					killTimer(paymentsHolder[client])
				end
				takePlayerMoney(client, paymentsCounter[client] or 0)
				exports.GTWtopbar:dm("Rental cost was: "..tostring(paymentsCounter[client] or 0).."$", client, 0, 255, 0)
			end
			if vehID then
				if vehID == 592 or vehID == 577 or vehID == 553 then
					local playeraccount = getPlayerAccount(client)
					local pilot_progress = tonumber(getAccountData(playeraccount, "acorp_stats_pilot_progress")) or 0
					if pilot_progress < 40 then
						exports.GTWtopbar:dm("Your pilot license doesn't allow large aircraft yet!(Must be above 40)", client, 255, 0, 0)
						return
					end
				end				
		    	local x,y,z = getElementPosition(client)
		    	if spawnx and spawny and spawnz then
		    		x,y,z = spawnx,spawny,spawnz
		    	end
			   	vehicles[client] = createVehicle(vehID, x, y, z+1.5, 0, 0, rot) 
			   	setVehicleFuelTankExplodable(vehicles[client], true)
			   	setVehicleHandling(vehicles[client], "headLight ", "big")
			   	setVehicleHandling(vehicles[client], "tailLight", "big")
			   	
			   	-- Semi truck trailers
			   	--[[if vehID == 403 or vehID == 514 or vehID == 515 then
			   		if vehID == 403 then
			   			vehID = 435
			   		else
			   			local r_n = math.random(1,9)
			   			if r_n < 5 then
			   				vehID = 435
			   			else
			   				vehID = 584
			   			end
			   		end
			   		trailers[client] = createVehicle(vehID, x, y, z, 0, 0, rot)
			   		attachElements(trailers[client], vehicles[client], 0, -8)
			   		setTimer(detachElements, 50, 1, trailers[client])
			   		setTimer(attachTrailerToVehicle, 1000, 1, vehicles[client], trailers[client])
			   	end]]--
			   	
			   	-- Train carriages
			   	if vehID == 537 or vehID == 538 or vehID == 449 then
			   		setTrainDirection(vehicles[client],true)
			   		if vehID == 537 then
			   			local r_n = math.random(1,9)
			   			if r_n < 5 then
			   				vehID = 569
			   			else
			   				vehID = 590
			   			end
			   		end
			   		if vehID == 538 then
			   			vehID = 570
			   		end
			   		local carriage = nil
					local carriage2 = vehicles[client]
					local playeraccount = getPlayerAccount(client)
					local train_stops = tonumber(getAccountData(playeraccount, "acorp_stats_train_stops")) or 0
					local tram_stops = tonumber(getAccountData(playeraccount, "acorp_stats_tram_stops")) or 0
					local numberOfCarriages = 2
					-- Train carriages
					if train_stops > 700 then
						numberOfCarriages = math.random(7,8)
					elseif train_stops > 500 then
						numberOfCarriages = math.random(6,7)
					elseif train_stops > 300 then
						numberOfCarriages = math.random(5,6)
					elseif train_stops > 160 then
						numberOfCarriages = math.random(4,5)
					elseif train_stops > 80 then
						numberOfCarriages = math.random(3,4)
					elseif train_stops > 20 then
						numberOfCarriages = math.random(2,3)
					end
					-- Tram cars
					if vehID == 449 and tram_stops > 500 then
						numberOfCarriages = math.random(2,4)
					elseif vehID == 449 and tram_stops > 150 then
						numberOfCarriages = math.random(1,3)
					elseif vehID == 449 then
						numberOfCarriages = 1
					end
					-- Create cars
					local engines = 1
					if numberOfCarriages > 4 and (getElementModel(vehicles[client]) == 538 or getElementModel(vehicles[client]) == 537) then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)					
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						numberOfCarriages = numberOfCarriages - 1
						engines = engines + 1
					end
					-- Extra freight engines
					if numberOfCarriages > 6 and getElementModel(vehicles[client]) == 537 then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)					
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						numberOfCarriages = numberOfCarriages - 1
						engines = engines + 1
					end
					for c=1, numberOfCarriages do
						carriage = createVehicle(vehID, x, y, z, 0, 0, rot)					
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
					end
					-- Adds an extra freight locomotive at the end
					if numberOfCarriages > 4 and (getElementModel(vehicles[client]) == 538 or getElementModel(vehicles[client]) == 537) then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)					
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						engines = engines + 1
					end
					setElementData(client,"numberOfCars",numberOfCarriages)
					setTimer(topBar, 350, 1, "Train set up: "..engines.." engines and: "..numberOfCarriages.." cars", client, 0, 255, 0)
			   	end
			    setElementData(vehicles[client], "vehicleFuel", math.random(90,100))
			    setElementData(vehicles[client], "owner", getAccountName(getPlayerAccount(client)))
			    setElementData(client, "currVeh", getElementModel(vehicles[client]))			
			    warpPedIntoVehicle(client, vehicles[client])
				-- Start the rental price counter
				paymentsCounter[client] = price
			    paymentsHolder[client] = setTimer(pay_vehicle_rent, 60000, 0, client, price)
			    exports.GTWtopbar:dm("You will pay: "..price.."$/minute to use this vehicle", client, 255, 200, 0)
			end
		elseif getElementInterior(client) > 0 then
			exports.GTWtopbar:dm("Vehicles can not be used inside!", client, 255, 0, 0)
		elseif money < price then
			exports.GTWtopbar:dm("You don't have enought money to use this vehicle!", client, 255, 0, 0)
		end
	    triggerClientEvent(client, "GTWvehicles.closeWindow", root)
	end
end
addEvent("GTWvehicles.spawnvehicle", true)
addEventHandler("GTWvehicles.spawnvehicle", resourceRoot, spawn_vehicle)

--[[ Set the color of the new vehicle ]]--
function set_vehicle_color(m_type)
    if isElement(vehicles[client]) then	
		local p_text, free_fuel, r1,g1,b1, r2,g2,b2 = unpack(properties[m_type])   
	    if p_text ~= "" then
	    	setVehiclePlateText(vehicles[client], p_text)
	    end
	    if free_fuel then
	    	setElementData(vehicles[client], "vehicleOccupation", true) -- Free fuel
	    end
	    if r1 and g1 and b1 and r2 and g2 and b2 and r1 > -1 then
	    	setVehicleColor(vehicles[client], r1,g1,b1, r2,g2,b2)
	    end
	end
end
addEvent("GTWvehicles.colorvehicle", true)
addEventHandler("GTWvehicles.colorvehicle", root, set_vehicle_color)

--[[ Cleanup and destroy vehicle ]]--
function destroy_vehicle(plr, force_delete)
	if not force_delete then force_delete = false end
	if vehicles[plr] and isElement(vehicles[plr]) and (not getVehicleOccupant(vehicles[plr]) or force_delete) then
		if getVehicleTowedByVehicle(vehicles[plr]) then
   	 		destroyElement(getVehicleTowedByVehicle(vehicles[plr]))
   	 	end
   	 	if isElement(trailers[plr]) then
   	 		destroyElement(trailers[plr])
   	 	end
   	 	triggerEvent("GTWvehicles.onDestroyVehilce", plr, plr)
		
		destroyElement(vehicles[plr])
		setElementData(plr, "currVeh", 0)
		if isTimer(paymentsHolder[plr]) then
			killTimer(paymentsHolder[plr])
		end
		takePlayerMoney(plr, paymentsCounter[plr] or 0)
		exports.GTWtopbar:dm("Rental cost was: "..tostring(paymentsCounter[plr] or 0).."$", plr, 0, 255, 0)
	elseif getPedOccupiedVehicle(plr) then
		exports.GTWtopbar:dm("Exit your vehicle before removing it!", plr, 255, 0, 0)
	else
		exports.GTWtopbar:dm("You don't have a vehicle to destroy!", plr, 255, 0, 0)
	end
end
function onPlayerQuit() destroy_vehicle(source, true) end
function onPlayerLogout(playeraccount, _) destroy_vehicle(source, true) end
addCommandHandler("djv", destroy_vehicle)
addCommandHandler("rrv", destroy_vehicle)
addEventHandler("onPlayerQuit", root, onPlayerQuit)
addEventHandler("onPlayerLogout", root, onPlayerLogout)

--[[ Gear box stuff, TODO: rewrite from scratch in different resource ]]--
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
addCommandHandler("nextgear", nextGear)

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

function removeTimer(thePlayer, seat, jacked)
	if isTimer(gearTimers[source]) then
		killTimer(gearTimers[source])
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeTimer)

-- Drop players with a rope from helicopters
function dropPlayer(plr, command)
	-- Fastrope on helis
	if getPedOccupiedVehicle(plr) then
		for k, pl in pairs(getVehicleOccupants(getPedOccupiedVehicle(plr))) do
			if pl and isElement(pl) then
				exports.fastrope:createFastRopeOnHeli(plr, getPedOccupiedVehicle(plr))
				exports.fastrope:addPlayerToFastRope(pl, 0)
			end
		end
	end
end
addCommandHandler("drop", dropPlayer)

-- Turn a train around
function turnTrain(player, command)
	local train_engine = getPedOccupiedVehicle(player)
	if train_engine and getElementType(train_engine) == "vehicle" and 
		getVehicleType(train_engine) == "Train" and not getVehicleEngineState(train_engine) then
		setTrainDirection(train_engine, not getTrainDirection(train_engine))
	end
end
addCommandHandler("turntrain", turnTrain)

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

-- Remove/respawn broken vehicles and clean up
function cleanUp()
	if isElement(source) and not getElementData(source, "owner") then
    	setTimer(cleanUpEnd, 330000, 1, source)
    elseif isElement(source) and getElementData(source, "owner") then
    	setTimer(respawnCar, 330000, 1, source)
    end
end
addEventHandler("onVehicleExplode", getRootElement(), cleanUp)
function respawnCar(veh)
	if isElement(veh) then
		respawnVehicle(veh)
	end
end
function cleanUpEnd(source)
	if isElement(source) then
		destroyElement(source)
	end
	if isElement(trailers[source]) then
   	 	destroyElement(trailers[source])
   	end
   	if isElement(peds[source]) then
		destroyElement(peds[source])
	end
end

-- Recursively destroys entire trains consisting of attached carriages or traielrs
function destroyVehicleTrain(veh)
	if veh and isElement(veh) and getVehicleTowedByVehicle(veh) then
		destroyVehicleTrain(getVehicleTowedByVehicle(veh))
		if veh and getVehicleTowedByVehicle(veh) and isElement(getVehicleTowedByVehicle(veh)) then
			destroyElement(getVehicleTowedByVehicle(veh))
		end
	end
end
addEventHandler("onElementDestroy", getRootElement(), function()
  	if getElementType(source) == "vehicle" then
    	destroyVehicleTrain(source)
  	end
end)

function showGearProfile(player,veh)
	if getPlayerTeam(player) and getPlayerTeam(player) == getTeamFromName("Unemployed") and math.random(1,20) == 10 then
		exports.GTWtopbar:dm("Gear box: profile is: "..getElementData(veh, "gearType")..
			", use /drive, /sport or /race to change", player, 255, 200, 0)
	end
end