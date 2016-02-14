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

-- Add all the required stuff
function initialize_restaurants( )
	for k=1, #markers do
		-- Define some general properties
		local markSize = 2
		local lower = 0

		-- Increase marker size on drive thru's
		if markers[k][5] == 0 then
			markSize = 5
			lower = 2
		end
    		marker[k] = createMarker(markers[k][1], markers[k][2], markers[k][3]-lower, "cylinder", markSize, 255, 255, 255, 40)
    		addEventHandler("onMarkerHit", marker[k], open_menu)
    		addEventHandler("onMarkerLeave", marker[k], close_menu)
    		setElementDimension(marker[k], markers[k][4])
		setElementInterior(marker[k], markers[k][5])

		-- Store the type of restaurant
		setElementData(marker[k], "GTWfastfood.restaurantType", markers[k][6])
	end

	-- Setup invincible peds and force them to respawn each 8 hours
	respawn_all_peds()
	setTimer(respawn_all_peds, 60*60*8*1000, 0)
end
addEventHandler("onResourceStart", resourceRoot, initialize_restaurants)

-- Respawn ped if dead
function respawn_all_peds( )
	for k=1, #blips do
		-- Clean up old data
		if isElement(blip[k]) then destroyElement(blip[k]) end
		if isElement(ped[k]) then destroyElement(ped[k]) end

		-- Create blips
		blip[k] = createBlip(blips[k][1], blips[k][2], blips[k][3], blips[k][4], 1, 0, 0, 0, 255, 111, 180)
		ped[k] = createPed(peds[k][7], peds[k][1], peds[k][2], peds[k][3])
		setElementData(marker[k], "location", peds[k][8])

    		-- Create the ped
		setElementDimension(ped[k], peds[k][4])
		setElementInterior(ped[k], peds[k][5])
		setPedRotation(ped[k], peds[k][6])
		setElementData(ped[k], "robLoc", peds[k][8])

		-- Mark this ped as fastfood worker so that they can't be killed
		getElementData(ped[k], "GTWfastfood.isWorker", true)
    	end
end

-- Open the gui
function open_menu(plr, matching_dimension)
	if not matching_dimension then return end
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end

	-- Don't sell to ourselves by mistake if we're inside the food truck
	local veh = getPedOccupiedVehicle(plr)
	if veh and getElementData(veh, "GTWfastfood.isSelling") then
		return
	end

	-- Apply the handbrake if it's a drive thru shop
	if veh then
		setControlState(plr, "handbrake", true)
	end

	-- Get the restaurant location and display a welcome message if not being robbed
	local location = getElementData(source, "location")
	if location and not getElementData(plr, "rob") then
		exports.GTWtopbar:dm("Welcome to "..location.."!", plr, 0, 255, 0)
	end

	-- TODO: change GTWrob to use exported functions to determine if a store is robbed
	-- Open the GUI menu if we're not being robbed
	if not getElementData(plr, "rob")  then
		-- Is this restaurant owned by a player? then inform the customer
		if getElementData(source, "GTWfastfood.salesman") then
			setElementData(plr, "GTWfastfood.salesman",
				getElementData(source, "GTWfastfood.salesman"))
		end

		-- Open the shopping GUI
		triggerClientEvent(plr, "GTWfastfood.gui.show", root,
			plr, getElementData(source, "GTWfastfood.restaurantType"))
	elseif getElementData(plr, "rob") then
		-- Tell the robber he's an idiot for trying to buy food while robbing
		exports.GTWtopbar:dm("You can't shop while robbing the restaurant ye idiot!", plr, 255, 0, 0)
	end
end

--[[ Close the menu ]]--
function close_menu(plr, matching_dimension)
	if not matching_dimension then return end
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end

	if not getElementData(plr, "rob") then
		exports.GTWtopbar:dm("Thank you sir! welcome back next time you're hungry", plr, 255, 100, 0)
	end
	triggerClientEvent(plr, "GTWfastfood.gui.hide", root, plr)

	-- Clean up old salemen in food trucks
	setElementData(plr, "GTWfastfood.salesman", nil)

	-- Remove the handbrake if it's a drive thru shop
	local veh = getPedOccupiedVehicle(plr)
	if veh then
		setControlState(plr, "handbrake", false)
	end
end

-- Protect the resource
addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Sell to the client and pay the restaurant owner ]]--
function buy_food(money, health)
	-- We do not sell to robbers
	if getElementData(client, "rob") then return end

	-- Find the salesman, used for Mr. Whoopee and hot dog vans
	local plr_salesman = getElementData(client, "GTWfastfood.salesman")

	-- Pay the restaurant owner if any
	if plr_salesman and plr_salesman ~= client then
		givePlayerMoney(plr_salesman, money*2)
		exports.GTWtopbar:dm("Fastfood: You sold food to: "..getPlayerName(client), plr_salesman, 0, 255, 0)
	end

	-- Pay for food and increase health
	if (getElementHealth(client) + health) < 100 then
		takePlayerMoney(client, money)
		setElementHealth(client, getElementHealth(client) + health)
	elseif getElementHealth(client) < 100 then
		takePlayerMoney(client, money)
		setElementHealth(client, 100)
	else
		exports.GTWtopbar:dm("You already ate enough fatty!", client, 255, 0, 0)
	end
end
addEvent("GTWfastfood.buy", true)
addEventHandler("GTWfastfood.buy", root, buy_food)

--[[ Stop selling from food truck, this function cleans up ]]--
function stop_selling_from_vans(veh)
	setElementData(veh, "GTWfastfood.isSelling", nil)
	local food_truck = getElementData(veh, "GTWfastfood.salesMarker")
	if food_truck and isElement(food_truck) then
		local t_validator = getElementData(food_truck, "GTWfastfood.validatorTimer")
		if isTimer(t_validator) then
			killTimer(t_validator)
		end
		setElementData(food_truck, "GTWfastfood.salesman", nil)
		removeEventHandler("onMarkerHit", food_truck, open_menu)
		removeEventHandler("onMarkerLeave", food_truck, close_menu)
		destroyElement(food_truck)
		setElementData(veh, "GTWfastfood.salesMarker", nil)
	end
	removeCommandHandler("engine", sell_from_vans)
end

--[[ This function validates if a food truck still exists and are allowed to sell ]]--
function validate_food_truck(veh, cx,cy,cz, marker)
	-- Make sure the vehicle is an existing vehicle
	if not marker then return end
	if not veh or not isElement(veh) or getElementType(veh) ~= "vehicle" then
		-- Destroy validator timer
		local t_validator = getElementData(marker, "GTWfastfood.validatorTimer")
		if isTimer(t_validator) then
			killTimer(t_validator)
		end

		-- Special case if the food van is destoryed or removed in any way
		setElementData(marker, "GTWfastfood.salesman", nil)
		removeEventHandler("onMarkerHit", marker, open_menu)
		removeEventHandler("onMarkerLeave", marker, close_menu)
		destroyElement(marker)
		return
	end

	-- Make sure the engine is turned of
	if getVehicleEngineState(veh) then
		stop_selling_from_vans(veh)
		return
	end

	-- Make sure it hasn't moved the last second
	local vx,vy,vz = getElementPosition(veh)
	if getDistanceBetweenPoints3D(vx,vy,vz, cx,cy,cz) > 1 then
		stop_selling_from_vans(veh)
		return
	end
end

--[[ Sell from Mr. Whoopee or Hotdog vans ]]--
function sell_from_vans(plr, cmd)
	local veh = getPedOccupiedVehicle(plr)
	if not veh or not fastfood_trucks[getElementModel(veh)] then return end
	if getVehicleEngineState(veh) then
		exports.GTWtopbar:dm("Turn off your engine before opening your restaurant! (/engine)", plr, 255, 0, 0)
		return
	end

	-- Check if this van is currently selling or not
	local is_selling = getElementData(veh, "GTWfastfood.isSelling")
	if not is_selling then
		local vx,vy,vz = getElementPosition(veh)
		local food_truck = createMarker(vx,vy,vz-2, "cylinder", 6, 255, 255, 255, 40)
		addEventHandler("onMarkerHit", food_truck, open_menu)
		addEventHandler("onMarkerLeave", food_truck, close_menu)
		setElementData(veh, "GTWfastfood.isSelling", true)
		setElementData(veh, "GTWfastfood.salesMarker", food_truck)
		setElementData(food_truck, "GTWfastfood.salesman", plr)

		-- Set the type of restaurant
		if getElementModel(veh) == 423 then
			setElementData(food_truck, "GTWfastfood.restaurantType", "icecream")
		elseif getElementModel(veh) == 588 then
			setElementData(food_truck, "GTWfastfood.restaurantType", "hotdogs")
		end
		addCommandHandler("engine", sell_from_vans)

		-- Start a validator
		local validator_timer = setTimer(validate_food_truck, 1000, 0, veh, vx,vy,vz, food_truck)

		-- Save the validator timer in the marker
		setElementData(food_truck, "GTWfastfood.validatorTimer", validator_timer)
	else
		-- We're selling so we should now stop selling
		stop_selling_from_vans(veh)
	end
end
addCommandHandler("sell", sell_from_vans)
