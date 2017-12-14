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
		local dist_to_cop = exports.GTWpolice:distanceToCop(client)
		if money >= price and getPlayerWantedLevel(client) == 0 or dist_to_cop > 180 and
		getElementInterior(client) == 0 then
			if isElement(vehicles[client]) then
				destroy_vehicle(client, true)
			end
			if vehID then
				if vehID == 592 or vehID == 577 or vehID == 553 then
					local playeraccount = getPlayerAccount(client)
					local pilot_progress = tonumber(exports.GTWcore:get_account_data(playeraccount, "GTWdata.stats.pilot_progress")) or 0
					if pilot_progress < 40 then
						exports.GTWtopbar:dm("Your pilot license doesn't allow large aircraft yet! (Must be above 40)", client, 255, 0, 0)
						return
					end
				end
				local x,y,z = getElementPosition(client)
				if spawnx and spawny and spawnz then
					x,y,z = spawnx,spawny,spawnz
				end
				vehicles[client] = createVehicle(vehID, x, y, z+1.5, 0, 0, rot)
				setElementHealth(vehicles[client], (getElementHealth(vehicles[client])))
				setVehicleHandling(vehicles[client], "headLight ", "big")
				setVehicleHandling(vehicles[client], "tailLight", "big")

				-- Reduce rental vehicle top speed
				local bicycle_list = {[509]=true,[481]=true,[510]=true,[462]=true}
				local bike_list = {[581]=true,[509]=true,[481]=true,[462]=true,[521]=true,[463]=true,[510]=true,[522]=true,[461]=true,[448]=true,[468]=true,[586]=true}
				if getVehicleType(vehicles[client]) == "Automobile" or bike_list[vehID] then
					local result = getVehicleHandling(vehicles[client])
					local realism_index = 1.5
					setVehicleHandling(vehicles[client], "engineAcceleration", tonumber(result["engineAcceleration"])/realism_index, false)
					setVehicleHandling(vehicles[client], "engineInertia", tonumber(result["engineInertia"])*realism_index, false)
					setVehicleHandling(vehicles[client], "brakeDeceleration", tonumber(result["brakeDeceleration"])/realism_index, false)
					setVehicleHandling(vehicles[client], "brakeBias", tonumber(result["brakeBias"])/realism_index, false)
					setVehicleHandling(vehicles[client], "percentSubmerged", tonumber(result["percentSubmerged"])*realism_index, false)

					--Reduce max speed on bicycles and faggio
					if bicycle_list[vehID] then
						setVehicleHandling(vehicles[client], "maxVelocity", 40, false)
					end
					currVehTopSpeed[vehicles[client]] = tonumber(result["maxVelocity"])
				end

				-- Semi truck trailers
				if vehID == 403 or vehID == 514 or vehID == 515 then
					if extra ~= "" then
						if extra == "Fuel" then vehID = 584 end
						if extra == "Box container" then vehID = 435 end
						if extra == "Open container" then vehID = 450 end
						if extra == "Dual trailers" then vehID = 591 end
						trailers[client] = { }
						trailers[client][1] = createVehicle(vehID, x, y, z, 0, 0, rot)
						setElementHealth(trailers[client][1], (getElementHealth(trailers[client][1])))
						--triggerClientEvent(root, "GTWvehicles.onStreamOut", root, trailers[client])
						--attachTrailerToVehicle(vehicles[client], trailers[client])
						setElementData(vehicles[client], "GTWvehicles.isTrailerTowingVehile", true)
						setElementData(vehicles[client], "GTWvehicles.attachedTrailer", trailers[client][1])
						setElementData(trailers[client][1], "GTWvehicles.isTrailer", true)
						setElementData(trailers[client][1], "GTWvehicles.towingVehicle", vehicles[client])
						attachElements(trailers[client][1], vehicles[client], 0, -10)
						setElementSyncer(trailers[client][1], client)
						setTimer(detachElements, 50, 1, trailers[client][1])
						setTimer(attachTrailerToVehicle, 100, 1, vehicles[client], trailers[client][1])
						triggerClientEvent(root, "GTWvehicles.onStreamOut", root, vehicles[client])
						triggerClientEvent(root, "GTWvehicles.onStreamOut", root, trailers[client][1])

						-- Dual trailers if supported
						if vehID == 591 then
							local second_trailer = createVehicle(435, x, y, z, 0, 0, rot)
							local second_tower = createVehicle(515, x, y, z, 0, 0, rot)
							setElementHealth(second_trailer, (getElementHealth(second_trailer)))
							setElementHealth(second_tower, (getElementHealth(second_tower)))
							attachElements(second_tower, trailers[client][1], 0, 0, 0.5)
							setElementCollisionsEnabled(second_tower, false)
							setElementAlpha(second_tower, 0)

							attachElements(second_trailer, second_tower, 0, -10)
							setElementSyncer(second_trailer, client)
							setTimer(detachElements, 50, 1, second_trailer)
							setTimer(attachTrailerToVehicle, 100, 1, second_tower, second_trailer)
							setTimer(attachTrailerToVehicle, 1000, 1, second_tower, second_trailer)

							-- Save element pointers for deletion
							setElementData(vehicles[client], "GTWvehicles.second_tower", second_tower)
							setElementData(trailers[client][1], "GTWvehicles.second_trailer", second_trailer)
							triggerClientEvent(root, "GTWvehicles.onStreamOut", root, second_trailer)
						end

						-- Trailer sync function
						trailerSyncTimers[client] = setTimer(function(client)
							-- Sync first truck trailer if there is any
							if vehicles and vehicles[client] and isElement(vehicles[client]) and isElement(getElementData(vehicles[client], "GTWvehicles.attachedTrailer")) then
								local tx,ty,tz = getElementPosition(getElementData(vehicles[client], "GTWvehicles.attachedTrailer"))
								local trx,try,trz = getElementRotation(getElementData(vehicles[client], "GTWvehicles.attachedTrailer"))
								setElementData(getElementData(vehicles[client], "GTWvehicles.attachedTrailer"), "GTWvehicles.trailer.location",
								toJSON({tx,ty,tz, trx,try,trz}))
							elseif isTimer(trailerSyncTimers[client]) then
								killTimer(trailerSyncTimers[client])
							end
							-- Sync first truck trailer if there is any
							if trailers and trailers[client] and trailers[client][1] and isElement(trailers[client][1]) and isElement(getElementData(trailers[client][1],
							"GTWvehicles.second_trailer")) then
								local tx,ty,tz = getElementPosition(getElementData(trailers[client][1], "GTWvehicles.second_trailer"))
								local trx,try,trz = getElementRotation(getElementData(trailers[client][1], "GTWvehicles.second_trailer"))
								setElementData(getElementData(trailers[client][1], "GTWvehicles.second_trailer"), "GTWvehicles.trailer.location",
								toJSON({tx,ty,tz, trx,try,trz}))
							end
						end, 250, 0, client)
					end
				end

				-- Train cars
				if vehID == 537 or vehID == 538 or vehID == 449 then
					trailers[client] = { }
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
					--[[local train_stops = tonumber(exports.GTWcore:get_account_data(playeraccount, "GTWdata.stats.train_stops")) or 0
					local tram_stops = tonumber(exports.GTWcore:get_account_data(playeraccount, "GTWdata.stats.tram_stops")) or 0]]--
					local numberOfCarriages = tonumber(extra) or 2
					-- Extra freight engines
					local engines = 1
					if numberOfCarriages > 3 and (getElementModel(vehicles[client]) == 538 or getElementModel(vehicles[client]) == 537) then
						carriage = createVehicle(getElementModel(vehicles[client]), x, y, z, 0, 0, rot)
						setElementHealth(carriage, (getElementHealth(carriage)))
						triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						carriage2 = carriage
						numberOfCarriages = numberOfCarriages - 1
						engines = engines + 1
						table.insert(trailers[client], carriage)
						setTimer(setTrainDirection, 1000, 1, carriage, not getTrainDirection(vehicles[client]))
					end
					-- Add train carriages
					for c=1, numberOfCarriages do
						carriage = createVehicle(vehID, x, y, z, 0, 0, rot)
						setElementHealth ( carriage, ( getElementHealth(carriage) ) * 4 )
						if vehID == 569 then
							local container_array = {3566, 3568, 3569}
							local container = createObject(container_array[math.random(#container_array)], x,y,z, 0,0,0, true)
							setObjectScale(container, 0.8)
							attachElements(container, carriage, 0,0,0.8, 0,0,0)
							setElementData(carriage, "GTWvehicles.container", container)
						end
						triggerClientEvent(root, "GTWvehicles.onStreamOut", root, carriage)
						attachTrailerToVehicle(carriage2, carriage)
						table.insert(trailers[client], carriage)
						carriage2 = carriage
					end
					if numberOfCarriages < 1 then numberOfCarriages = 1 end
					setElementData(client, "GTWvehicles.numberOfCars", numberOfCarriages)
					setTimer(display_message, 350, 1, "Train set up: "..engines.." engines and: "..numberOfCarriages.." cars", client, 0, 255, 0)
				end
				--setElementData(vehicles[client], "vehicleFuel", math.random(90,100))
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
			if trailers[client] then
				for k,v in pairs(trailers[client]) do
					if isElement(v) then
						setVehicleColor(v, r1,g1,b1, r2,g2,b2)
					end
				end
			end
		end
	end
end
addEvent("GTWvehicles.colorvehicle", true)
addEventHandler("GTWvehicles.colorvehicle", root, set_vehicle_color)

--[[ Cleanup and destroy vehicle ]]--
function destroy_vehicle(plr, force_delete)
	if not force_delete then force_delete = false end
	if vehicles[plr] and isElement(vehicles[plr]) and (not getVehicleOccupant(vehicles[plr]) or force_delete) then
		-- Clean up second trailers for semi trucks
		if trailers[plr] and isElement(trailers[plr][1]) and getElementData(trailers[plr][1], "GTWvehicles.second_trailer") then
			destroyElement(getElementData(trailers[plr][1], "GTWvehicles.second_trailer"))
		end
		if getElementData(vehicles[plr], "GTWvehicles.second_tower") then
			destroyElement(getElementData(vehicles[plr], "GTWvehicles.second_tower"))
		end
		if getPedOccupiedVehicle(plr) and force_delete ~= true then
			return exports.GTWtopbar:dm("Exit your vehicle before removing it!", plr, 255, 0, 0)
		end
		if trailers[plr] and #trailers[plr] > 0 then
			for k,v in ipairs(trailers[plr]) do
				if isElement(v) then
					detachTrailerFromVehicle(v)
					if getElementData(v, "GTWvehicles.container") then
						destroyElement(getElementData(v, "GTWvehicles.container"))
					end
					destroyElement(v)
				end
			end
		end
		if isElement(vehicles[plr]) then
			for k,v in ipairs(getAttachedElements(vehicles[plr])) do
				destroyElement(v)
			end
			destroyElement(vehicles[plr])
		end
		triggerEvent("GTWvehicles.onDestroyVehilce", plr, plr)

		setElementData(plr, "currVeh", 0)
		if isTimer(paymentsHolder[plr]) then
			killTimer(paymentsHolder[plr])
		end
		takePlayerMoney(plr, paymentsCounter[plr] or 0)
		exports.GTWtopbar:dm("Rental cost was: "..tostring(paymentsCounter[plr] or 0).."$", plr, 0, 255, 0)
	else
		exports.GTWtopbar:dm("You don't have a vehicle to destroy!", plr, 255, 0, 0)
	end
end
function player_quit() destroy_vehicle(source, true) end
function player_logout(playeraccount, _) destroy_vehicle(source, true) end
addCommandHandler("djv", destroy_vehicle)
addCommandHandler("rrv", destroy_vehicle)
addEventHandler("onPlayerQuit", root, player_quit)
addEventHandler("onPlayerLogout", root, player_logout)

function removeTimer(thePlayer, seat, jacked)
	if isTimer(gearTimers[source]) then
		killTimer(gearTimers[source])
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeTimer)

-- Remove/respawn broken vehicles and clean up
function cleanUp()
	if isElement(source) and not getElementData(source, "owner") then
		setTimer(destroy_vehicle, 330000, 1, source)
	elseif isElement(source) and getElementData(source, "owner") then
		setTimer(respawn_vehicle, 330000, 1, source)
	end
end
addEventHandler("onVehicleExplode", getRootElement(), cleanUp)
function respawn_vehicle(veh)
	if isElement(veh) then
		respawnVehicle(veh)
	end
end

--[[ Detach trailer from your trailer towing vehicle ]]--
function disconnect_trailer(plr)
	local tower = getPedOccupiedVehicle(plr)
	if not tower or not isElement(tower) or getElementType(tower) ~=
	"vehicle" then
		exports.GTWtopbar:dm("You're not in a vehicle!", plr, 255, 0, 0)
		return
	end

	-- Detach carriages
	local sx,sy,sz = getElementVelocity(tower)
	local actualspeed = (sx^2 + sy^2 + sz^2)^(0.5)
	local kmh = actualspeed*180
	if kmh < 5 then
		if detachTrailerFromVehicle(tower) then
			exports.GTWtopbar:dm("Trailer was detached successfully!", plr, 0,255,0)
		end
	else
		exports.GTWtopbar:dm("You're moving too fast to detach your trailer", plr, 255, 0, 0)
	end
end
addCommandHandler("detachtrailer", disconnect_trailer)

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
