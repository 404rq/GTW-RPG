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

-- Globally accessible tables
local bus_payment_timers 	= { }

function find_nearest_stop(plr, route)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return 1 end
	local x,y,z = getElementPosition(plr)
	local ID,total_dist = 1,9999
	for k=1, #bus_routes[route] do
		local dist = getDistanceBetweenPoints3D(bus_routes[route][k][1],bus_routes[route][k][2],bus_routes[route][k][3], x,y,z)
		if dist < total_dist then
			total_dist = dist
			ID = k
		end
	end
	return ID
end

--[[ Calculate the ID for next busstop and inform the passengers ]]--
function create_new_bus_stop(plr, ID)
	-- There must be a route at this point
	if not plr or not getElementData(plr, "GTWbusdriver.currentRoute") then return end

	-- Did we reach the end of the line yet? if so then restart the same route
	if #bus_routes[getElementData(plr, "GTWbusdriver.currentRoute")] < ID then
		ID = 1;
		setElementData(plr, "GTWbusdriver.currentStop", 1)
	end

	-- Get the coordinates of the next stop from our table
	local x,y,z = bus_routes[getElementData(plr, "GTWbusdriver.currentRoute")][ID][1],
		bus_routes[getElementData(plr, "GTWbusdriver.currentRoute")][ID][2],
		bus_routes[getElementData(plr, "GTWbusdriver.currentRoute")][ID][3]

	-- Tell the client to make a marker and a blip for the busdriver
	triggerClientEvent(plr, "GTWbusdriver.createBusStop", plr, x,y,z)

	-- Get the bus object and check for passengers in it
	local veh = getPedOccupiedVehicle(plr)
	if not veh then return end
	local passengers = getVehicleOccupants(veh)
	if not passengers then return end

	-- Alright, we got some passengers, let's tell them where we're going
	for k,pa in pairs(passengers) do
		setTimer(delayed_message, 5000, 1, "Next stop: "..getZoneName(x,y,z)..
			" in "..getZoneName(x,y,z, true), pa, 55,200, 0)
	end

	-- Save the stop ID
	setElementData(plr, "GTWbusdriver.currentStop", ID)
end

--[[ Drivers get's a route asigned while passengers has to pay when entering the bus ]]--
function on_bus_enter(plr, seat, jacked)
	-- Make sure the vehicle is a bus
        if not bus_vehicles[getElementModel(source)] then return end
	if getElementType(plr) ~= "player" then return end

	-- Start the payment timer for passengers entering the bus
	if seat > 0 then
		driver = getVehicleOccupant(source, 0)
		if driver and getElementType(driver) == "player" and getPlayerTeam(driver) and
			getPlayerTeam(driver) == getTeamFromName( "Civilians" ) and
			getElementData(driver, "Occupation") == "Bus Driver" then

			-- Initial payment
			pay_for_the_ride(driver, plr)

			-- Kill the timer if it exist and make a new one
			if isTimer( bus_payment_timers[plr] ) then
				killTimer( bus_payment_timers[plr] )
			end
	            	bus_payment_timers[plr] = setTimer(pay_for_the_ride, 30000, 0, driver, plr)
	        end
        end

	-- Whoever entered the bus is a busdriver
	if getPlayerTeam(plr) and getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Bus Driver" and
		seat == 0 and bus_vehicles[getElementModel(source )] then

		-- Let him choose a route to drive
		triggerClientEvent(plr, "GTWbusdriver.selectRoute", plr)
	end
end
addEventHandler("onVehicleEnter", root, on_bus_enter)

--[[ A little hack for developers to manually change the route ID ]]--
function choose_route(plr, cmd)
	if not getPedOccupiedVehicle(plr) or not bus_vehicles[
		getElementModel(getPedOccupiedVehicle(plr))] then return end
	if getElementType(plr) ~= "player" then return end
	
	-- Make sure it's a traindriver inside a train requesting this
	if getPlayerTeam(plr) and getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Bus Driver" and 
		getPedOccupiedVehicleSeat(plr) == 0 then

		-- Force selection of new route
		triggerClientEvent(plr, "GTWbusdriver.selectRoute", plr)
	end
end
addCommandHandler("route", choose_route)
addCommandHandler("routes", choose_route)
addCommandHandler("routelist", choose_route)
addCommandHandler("routeslist", choose_route)

--[[ A new route has been selected, load it's data ]]--
function start_new_route(route)
    	setElementData(client, "GTWbusdriver.currentRoute", route)
	if not getElementData(client, "GTWbusdriver.currentStop") then
		local first_stop = find_nearest_stop(client, route)
		create_new_bus_stop(client, first_stop)
	else
		create_new_bus_stop(client, getElementData(client, "GTWbusdriver.currentStop"))
	end
	exports.GTWtopbar:dm("Drive your bus to the first stop to start your route", client, 0, 255, 0)
end
addEvent("GTWbusdriver.selectRouteReceive", true)
addEventHandler("GTWbusdriver.selectRouteReceive", root, start_new_route)

--[[ Handles payments in busses ]]--
function pay_for_the_ride(driver, passenger, first)
	-- Make sure that both the driver and passenger are players
	if not driver or not isElement(driver) or getElementType(driver) ~= "player" then return end
	if not passenger or not isElement(passenger) or getElementType(passenger) ~= "player" then return end

	-- Make sure the passenger is still inside the bus
	local veh = getPedOccupiedVehicle(driver)
	if getVehicleOccupant(veh, 0) == driver and getElementData(driver, "Occupation") == "Bus Driver" then
		-- First payment are more expensive
		if first then
			takePlayerMoney( passenger, 25 )
			givePlayerMoney( driver, 25 )
		else
			takePlayerMoney( passenger, 5 )
			givePlayerMoney( driver, 5 )
		end
	else
		-- Throw the passenger out if he can't pay for the ride any more
		removePedFromVehicle ( passenger )
		if isElement(bus_payment_timers[passenger]) then
			killTimer(bus_payment_timers[passenger])
		end
		exports.GTWtopbar:dm( "You can't afford this bus ride anymore!", passenger, 255, 0, 0 )
	end
end

--[[ Stop the payment timer when a passenger exit the bus ]]--
function vehicle_exit(plr, seat, jacked)
    	if isTimer(bus_payment_timers[plr]) then
		killTimer(bus_payment_timers[plr])
	end
end
addEventHandler("onVehicleExit", root, vehicle_exit)

--[[ Calculate the next stop ]]--
function calculate_next_stop(bd_payment)
	-- Make sure the player is driving a bus
	if not isPedInVehicle(client) then return end
	if not bus_vehicles[getElementModel(getPedOccupiedVehicle(client))] then return end

	-- Calculate the payment minus charges for damage
	local fine = math.floor(bd_payment -
		(bd_payment*(1-(getElementHealth(getPedOccupiedVehicle(client))/1000))))

	-- Increase stats by 1
	local playeraccount = getPlayerAccount( client )
	local bus_stops = (getAccountData( playeraccount, "GTWdata_stats_bus_stops" ) or 0) + 1
	setAccountData( playeraccount, "GTWdata_stats_bus_stops", bus_stops )

	-- Pay the driver
	givePlayerMoney(client, fine + math.floor(bus_stops/4))

	-- Open the door so that passengers can enter
	toggle_bus_door(client)
	setTimer(toggle_bus_door, 5000, 1, client)

	-- Notify about the payment reduce if the bus is damaged
	if math.floor(bd_payment - fine) > 1 then
		takePlayerMoney(client, math.floor(bd_payment - fine))
		exports.GTWtopbar:dm("Removed $"..tostring(math.floor(bd_payment - fine)).." due to damage on your bus!",
			client, 255, 0, 0)
	end

	-- Get the next stop on the list
	if #bus_routes[getElementData(client, "GTWbusdriver.currentRoute")] ==
	 	tonumber(getElementData(client, "GTWbusdriver.currentStop")) then
		setElementData( client, "GTWbusdriver.currentStop", 1)
	else
		setElementData(client, "GTWbusdriver.currentStop", tonumber(
			getElementData(client, "GTWbusdriver.currentStop" ))+1)
	end

	-- Force the client to create markers and blips for the next stop
	create_new_bus_stop(client, tonumber(getElementData(client, "GTWbusdriver.currentStop")))
end
addEvent("GTWbusdriver.payBusDriver", true)
addEventHandler("GTWbusdriver.payBusDriver", resourceRoot, calculate_next_stop)

--[[ Open/Close the passenger door on the bus ]]--
function toggle_bus_door(plr)
	if not isPedInVehicle(plr) then return end
	if isPedInVehicle(plr) and getVehicleOccupant(getPedOccupiedVehicle(plr)) ~= plr then return end
	if not bus_vehicles[getElementModel(getPedOccupiedVehicle(plr))] then return end
	if getVehicleDoorOpenRatio(getPedOccupiedVehicle(plr), 3) > 0 then
		setVehicleDoorOpenRatio(getPedOccupiedVehicle(plr), 3, 0, 300 )
	else
		setVehicleDoorOpenRatio(getPedOccupiedVehicle(plr), 3, 1, 300 )
	end
end
addCommandHandler("busdoor", toggle_bus_door)

--[[ A little hack for developers to manually change the route ID ]]--
function set_manual_stop(plr, cmd, ID)
	local is_staff = exports.GTWstaff:isStaff(plr)
	if not is_staff then return end
	setElementData(plr, "GTWbusdriver.currentStop", tonumber(ID) or 1)
	create_new_bus_stop(plr, tonumber(ID) or 1)
end
addCommandHandler("setbusstop", set_manual_stop)

--[[ Display a delayed message securely ]]--
function delayed_message(text, plr, r,g,b, color_coded)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	if not getPlayerTeam(plr) or getPlayerTeam(plr) ~= getTeamFromName("Civilians") or
		getElementData(plr, "Occupation") ~= "Bus Driver" then return end
	if not getPedOccupiedVehicle(plr) or not bus_vehicles[getElementModel(getPedOccupiedVehicle(plr))] then return end
	exports.GTWtopbar:dm(text, plr, r,g,b, color_coded)
end
