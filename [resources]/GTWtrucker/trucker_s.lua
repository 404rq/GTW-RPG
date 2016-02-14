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

--[[ Calculate the ID for next DeliveryPoint and inform the passengers ]]--
function create_new_delivery_point(plr, ID, load_time)
	-- There must be a route at this point
	if not plr or not getElementData(plr, "GTWtrucker.currentRoute") then return end

	-- Get the coordinates of the next stop from our table
	local x,y,z = truck_routes[getElementData(plr, "GTWtrucker.currentRoute")][ID][1],
		truck_routes[getElementData(plr, "GTWtrucker.currentRoute")][ID][2],
		truck_routes[getElementData(plr, "GTWtrucker.currentRoute")][ID][3]

	local msg_end_text = "to pickup your cargo"
	if ID > 1 then msg_end_text = "to finish your delivery" end

	-- Alright, we got some passengers, let's tell them where we're going
	exports.GTWtopbar:dm("Trucker: drive to: "..getZoneName(x,y,z)..
		" in "..getZoneName(x,y,z, true).." "..msg_end_text, plr, 255,100,0)

	-- Tell the client to make a marker and a blip for the truckdriver
	triggerClientEvent(plr, "GTWtrucker.createDeliveryPoint", plr, x,y,z)

	-- Save the stop ID
	setElementData(plr, "GTWtrucker.currentStop", ID)
end

--[[ Drivers get's a route asigned while passengers has to pay when entering the truck ]]--
function on_truck_enter(plr, seat, jacked)
	-- Make sure the vehicle is a truck
        if not truck_vehicles[getElementModel(source)] then return end
	if getElementType(plr) ~= "player" then return end

	-- Whoever entered the truck is a truckdriver
	if getPlayerTeam(plr) and getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Trucker" and
		seat == 0 and truck_vehicles[getElementModel(source )] and
		not getElementData(plr, "GTWtrucker.currentRoute") then

		-- Let him choose a route to drive
		triggerClientEvent(plr, "GTWtrucker.selectRoute", plr)
	end
end
addEventHandler("onVehicleEnter", root, on_truck_enter)

--[[ A new route has been selected, load it's data ]]--
function start_new_route(route)
    	setElementData(client, "GTWtrucker.currentRoute", route)
	if not getElementData(client, "GTWtrucker.currentStop") then
		create_new_delivery_point(client, 1)
	else
		create_new_delivery_point(client, getElementData(client, "GTWtrucker.currentStop"))
	end
end
addEvent("GTWtrucker.selectRouteReceive", true)
addEventHandler("GTWtrucker.selectRouteReceive", root, start_new_route)

--[[ Calculate the next stop ]]--
function calculate_next_stop(tr_payment, load_time)
	-- Make sure the player is driving a truck
	if not isPedInVehicle(client) then return end
	if not truck_vehicles[getElementModel(getPedOccupiedVehicle(client))] then return end

	-- Calculate the payment minus charges for damage
	local fine = math.floor(tr_payment -
		(tr_payment*(1-(getElementHealth(getPedOccupiedVehicle(client))/1000))))

	-- Increase stats by 1
	local playeraccount = getPlayerAccount( client )
	local delivery_points = (getAccountData( playeraccount, "GTWdata_stats_delivery_points" ) or 0) + 1
	setAccountData( playeraccount, "GTWdata_stats_delivery_points", delivery_points )

	-- Pay the driver
	givePlayerMoney(client, fine + math.floor(delivery_points/4))
	exports.GTWtopbar:dm("Trucker: Delivery finished, you earned: $"..tostring(fine + math.floor(delivery_points/4)),
		client, 0, 255, 0)

	-- Notify about the payment reduce if the truck is damaged
	if math.floor(tr_payment - fine) > 1 then
		takePlayerMoney(client, math.floor(tr_payment - fine))
		exports.GTWtopbar:dm("Removed $"..tostring(math.floor(tr_payment - fine)).." due to damage on your truck!",
			client, 255, 0, 0)
	end

	-- Get the next destination on the list
	if #truck_routes[getElementData(client, "GTWtrucker.currentRoute")] ==
	 	tonumber(getElementData(client, "GTWtrucker.currentStop")) then
		-- Mission are finished, let's select a new Mission
		setElementData(client, "GTWtrucker.currentStop", 1)
	else
		setElementData(client, "GTWtrucker.currentStop", tonumber(
			getElementData(client, "GTWtrucker.currentStop" ))+1)
	end

	-- Force the client to create markers and blips for the next stop
	setTimer(create_new_delivery_point, load_time, 1, client, tonumber(getElementData(client, "GTWtrucker.currentStop")))
end
addEvent("GTWtrucker.payTrucker", true)
addEventHandler("GTWtrucker.payTrucker", resourceRoot, calculate_next_stop)

--[[ A little hack for developers to manually change the route ID ]]--
function set_manual_stop(plr, cmd, ID)
	local is_staff = exports.GTWstaff:isStaff(plr)
	if not is_staff then return end
	setElementData(plr, "GTWtrucker.currentStop", tonumber(ID) or 1)
	create_new_delivery_point(plr, tonumber(ID) or 1)
end
addCommandHandler("setDeliveryPoint", set_manual_stop)

--[[ A little hack for developers to manually change the route ID ]]--
function choose_route(plr, cmd, ID)
	-- Make sure it's a trucker inside a truck requesting this
	if getPlayerTeam(plr) and getPedOccupiedVehicle(plr) and
		getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Trucker" and
		seat == 0 and truck_vehicles[getElementModel(getPedOccupiedVehicle(plr))] then

		-- Force selection of new route
		triggerClientEvent(plr, "GTWtrucker.selectRoute", plr)
	end
end
addCommandHandler("route", choose_route)
addCommandHandler("routes", choose_route)
addCommandHandler("routelist", choose_route)
addCommandHandler("routeslist", choose_route)

--[[ Display a delayed message securely ]]--
function delayed_message(text, plr, r,g,b, color_coded)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	if not getPlayerTeam(plr) or getPlayerTeam(plr) ~= getTeamFromName("Civilians") or
		getElementData(plr, "Occupation") ~= "Trucker" then return end
	if not getPedOccupiedVehicle(plr) or not truck_vehicles[getElementModel(getPedOccupiedVehicle(plr))] then return end
	exports.GTWtopbar:dm(text, plr, r,g,b, color_coded)
end
