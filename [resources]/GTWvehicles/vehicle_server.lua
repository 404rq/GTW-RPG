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
function spawn_vehicle(vehID, rot, price, extra, spawnx, spawny, spawnz)
    if isElement(client) and vehID and rot and price then
    	local money = getPlayerMoney(client)
	    if money >= price and getPlayerWantedLevel(client) == 0 and
	    	getElementInterior(client) == 0 then
	   	 	if isElement(vehicles[client]) then
	   	 		triggerEvent("GTWdata_onDestroyVehilce", client, client)
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
				--[[if vehID == 592 or vehID == 577 or vehID == 553 then
					local playeraccount = getPlayerAccount(client)
					local pilot_progress = tonumber(getAccountData(playeraccount, "GTWdata_stats_pilot_progress")) or 0
					if pilot_progress < 40 then
						exports.GTWtopbar:dm("Your pilot license doesn't allow large aircraft yet! (Must be above 40)", client, 255, 0, 0)
						return
					end
				end]]--
		    	local x,y,z = getElementPosition(client)
		    	if spawnx and spawny and spawnz then
		    		x,y,z = spawnx,spawny,spawnz
		    	end
			   	vehicles[client] = createVehicle(vehID, x, y, z+1.5, 0, 0, rot)
			   	setVehicleHandling(vehicles[client], "headLight ", "big")
			   	setVehicleHandling(vehicles[client], "tailLight", "big")

			   	-- Semi truck trailers
			   	if vehID == 403 or vehID == 514 or vehID == 515 then
			   		if vehID == 403 then
			   			vehID = 435
                                        elseif vehID == 514 then
			   			vehID = 584
			   		else
			   			local r_n = math.random(1,9)
			   			if r_n < 5 then
			   				vehID = 435
			   			else
			   				vehID = 584
			   			end
			   		end
			   		trailers[client] = createVehicle(vehID, x, y, z, 0, 0, rot)
                                        triggerClientEvent(root, "GTWvehicles.onStreamOut", root, trailers[client])
                                        --attachTrailerToVehicle(vehicles[client], trailers[client])
                                        setElementData(vehicles[client], "GTWvehicles.isTrailerTowingVehile", true)
                                        setElementData(vehicles[client], "GTWvehicles.attachedTrailer", trailers[client])
                                        setElementData(trailers[client], "GTWvehicles.isTrailer", true)
                                        setElementData(trailers[client], "GTWvehicles.towingVehicle", vehicles[client])
			   		attachElements(trailers[client], vehicles[client], 0, -8)
                                        setElementSyncer(trailers[client], client)
			   		setTimer(detachElements, 50, 1, trailers[client])
			   		setTimer(attachTrailerToVehicle, 200, 1, vehicles[client], trailers[client])
			   	end

			   	-- Train cars
			   	if vehID == 537 or vehID == 538 or vehID == 449 then
			   		setTrainDirection(vehicles[client], true)
			   		if vehID == 537 then
			   			vehID = 569
			   		end
			   		if vehID == 538 then
			   			vehID = 570
			   		end
			   		local carriage = nil
					local carriage2 = vehicles[client]
					local playeraccount = getPlayerAccount(client)
					--[[local train_stops = tonumber(getAccountData(playeraccount, "GTWdata_stats_train_stops")) or 0
					local tram_stops = tonumber(getAccountData(playeraccount, "GTWdata_stats_tram_stops")) or 0]]--
					local numberOfCarriages = tonumber(extra) or 2
					-- Create cars
					local engines = 1
					if numberOfCarriages > 4 and (getElementModel(vehicles[client]) == 538 or getElementModel(vehicles[client]) == 537) then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)
                                                triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						numberOfCarriages = numberOfCarriages - 1
						engines = engines + 1
					end
					-- Extra freight engines
					if numberOfCarriages > 6 and getElementModel(vehicles[client]) == 537 then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)
                                                triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						numberOfCarriages = numberOfCarriages - 1
						engines = engines + 1
					end
                                        local r_n = 0
					for c=1, numberOfCarriages do
                                                if getElementModel(vehicles[client]) == 537 then
                                                        r_n = math.random(1,9)
			   			        if r_n < 4 then
			   				        vehID = 590
                                                        end
			   			end
						carriage = createVehicle(vehID, x, y, z, 0, 0, rot)
                                        	triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
					end
					-- Adds an extra freight locomotive at the end
					if numberOfCarriages > 4 and (getElementModel(vehicles[client]) == 538 or getElementModel(vehicles[client]) == 537) then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)
                                                triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						engines = engines + 1
					end
					setElementData(client,"numberOfCars",numberOfCarriages)
					setTimer(display_message, 350, 1, "Train set up: "..engines.." engines and: "..numberOfCarriages.." cars", client, 0, 255, 0)
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

function removeTimer(thePlayer, seat, jacked)
	if isTimer(gearTimers[source]) then
		killTimer(gearTimers[source])
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeTimer)

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
