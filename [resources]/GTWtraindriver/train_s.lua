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

-- Globally accessible tables
local train_payment_timers 	= { }
local td_payment = 50

--[[ Find and return the ID of nearest station ]]--
function find_nearest_station(plr, route)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return 1 end
	local x,y,z = getElementPosition(plr)
	local ID,total_dist = 1,9999
	for k=1, #train_routes[route] do
		local dist = getDistanceBetweenPoints3D(train_routes[route][k][1],train_routes[route][k][2],train_routes[route][k][3], x,y,z)
		if dist < total_dist then
			total_dist = dist
			ID = k
		end
	end
	return ID
end

--[[ Calculate the ID for next trainstation and inform the passengers ]]--
function create_new_train_station(plr, ID)
	-- There must be a route at this point
	if not plr or not getElementData(plr, "GTWtraindriver.currentRoute") then return end

	-- Did we reach the end of the line yet? if so then restart the same route
	if #train_routes[getElementData(plr, "GTWtraindriver.currentRoute")] < ID then
		ID = 1;
		setElementData(plr, "GTWtraindriver.currentstation", 1)
	end

	-- Get the coordinates of the next station from our table
	local x,y,z = train_routes[getElementData(plr, "GTWtraindriver.currentRoute")][ID][1],
		train_routes[getElementData(plr, "GTWtraindriver.currentRoute")][ID][2],
		train_routes[getElementData(plr, "GTWtraindriver.currentRoute")][ID][3]

	-- Tell the client to make a marker and a blip for the traindriver
	triggerClientEvent(plr, "GTWtraindriver.createtrainstation", plr, x,y,z)

	-- Get the train object and check for passengers in it
	local veh = getPedOccupiedVehicle(plr)
	if not veh then return end
	local passengers = getVehicleOccupants(veh)
	if not passengers then return end

	-- Alright, we got some passengers, let's tell them where we're going
	for k,pa in pairs(passengers) do
		setTimer(delayed_message, 10000, 1, "Next station: "..getZoneName(x,y,z)..
			" in "..getZoneName(x,y,z, true), pa, 55,200, 0)
	end

	-- Save the station ID
	setElementData(plr, "GTWtraindriver.currentstation", ID)
end

--[[ Drivers get's a route asigned while passengers has to pay when entering the train ]]--
function on_train_enter(plr, seat, jacked)
	-- Make sure the vehicle is a train
        if not train_vehicles[getElementModel(source)] then return end
	if getElementType(plr) ~= "player" then return end

	-- Start the payment timer for passengers entering the train
	if seat > 0 then
		driver = getVehicleOccupant(source, 0)
		if driver and getElementType(driver) == "player" and getPlayerTeam(driver) and
			getPlayerTeam(driver) == getTeamFromName( "Civilians" ) and
			getElementData(driver, "Occupation") == "Train Driver" then

			-- Initial payment
			pay_for_the_ride(driver, plr)

			-- Kill the timer if it exist and make a new one
			if isTimer( train_payment_timers[plr] ) then
				killTimer( train_payment_timers[plr] )
			end
	            	train_payment_timers[plr] = setTimer(pay_for_the_ride, 30000, 0, driver, plr)
	        end
        end

	-- Whoever entered the train is a traindriver
	if getPlayerTeam(plr) and getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Train Driver" and
		seat == 0 and train_vehicles[getElementModel(source )] then

		-- Let him choose a route to drive
		triggerClientEvent(plr, "GTWtraindriver.selectRoute", plr)
	end
end
addEventHandler("onVehicleEnter", root, on_train_enter)

--[[ A little hack for developers to manually change the route ID ]]--
function choose_route(plr, cmd)
	if not getPedOccupiedVehicle(plr) or not train_vehicles[
		getElementModel(getPedOccupiedVehicle(plr))] then return end
	if getElementType(plr) ~= "player" then return end

	-- Make sure it's a traindriver inside a train requesting this
	if getPlayerTeam(plr) and getPlayerTeam(plr) == getTeamFromName("Civilians") and
		getElementData(plr, "Occupation") == "Train Driver" and
		getPedOccupiedVehicleSeat(plr) == 0 then

		-- Force selection of new route
		triggerClientEvent(plr, "GTWtraindriver.selectRoute", plr)
	end
end
addCommandHandler("route", choose_route)
addCommandHandler("routes", choose_route)
addCommandHandler("routelist", choose_route)
addCommandHandler("routeslist", choose_route)

--[[ A new route has been selected, load it's data ]]--
function start_new_route(route)
    	setElementData(client, "GTWtraindriver.currentRoute", route)
	if not getElementData(client, "GTWtraindriver.currentstation") then
		local first_station = find_nearest_station(client, route)
		create_new_train_station(client, first_station)
	else
		create_new_train_station(client, getElementData(client, "GTWtraindriver.currentstation"))
	end
	exports.GTWtopbar:dm("Drive your train to the first station to start your route", client, 0, 255, 0)
end
addEvent("GTWtraindriver.selectRouteReceive", true)
addEventHandler("GTWtraindriver.selectRouteReceive", root, start_new_route)

--[[ Handles payments in trains ]]--
function pay_for_the_ride(driver, passenger, first)
	-- Make sure that both the driver and passenger are players
	if not driver or not isElement(driver) or getElementType(driver) ~= "player" then return end
	if not passenger or not isElement(passenger) or getElementType(passenger) ~= "player" then return end

	-- Make sure the passenger is still inside the train
	local veh = getPedOccupiedVehicle(driver)
	if getVehicleOccupant(veh, 0) == driver and getElementData(driver, "Occupation") == "Train Driver" then
		-- First payment are more expensive
		if first then
			takePlayerMoney(passenger, 10)
			givePlayerMoney(driver, 10)
		else
			takePlayerMoney(passenger, 5)
			givePlayerMoney(driver, 5)
		end
	else
		-- Throw the passenger out if he can't pay for the ride any more
		removePedFromVehicle ( passenger )
		if isElement(train_payment_timers[passenger]) then
			killTimer(train_payment_timers[passenger])
		end
		exports.GTWtopbar:dm( "You can't afford this train ride anymore!", passenger, 255, 0, 0 )
	end
end

--[[ station the payment timer when a passenger exit the train ]]--
function vehicle_exit(plr, seat, jacked)
    	if isTimer(train_payment_timers[plr]) then
		killTimer(train_payment_timers[plr])
	end
end
addEventHandler("onVehicleExit", root, vehicle_exit)

--[[ Calculate the next station ]]--
function calculate_next_station(td_payment)
	-- Make sure the player is driving a train
	if not isPedInVehicle(client) then return end
	if not train_vehicles[getElementModel(getPedOccupiedVehicle(client))] then return end

	-- Calculate the payment minus charges for damage
	local fine = math.floor(td_payment -
		(td_payment*(1-(getElementHealth(getPedOccupiedVehicle(client))/1000))))

	-- Increase stats by 1
	local playeraccount = getPlayerAccount(client)
	local train_stations = (exports.GTWcore:get_account_data(playeraccount, "GTWdata.stats.train_stations") or 0) + 1
	exports.GTWcore:set_account_data(playeraccount, "GTWdata.stats.train_stations", train_stations)

	-- Pay the driver
	givePlayerMoney(client, (fine + math.floor(train_stations/2)) * (1 + math.floor(getElementData(client, "GTWvehicles.numberOfCars")/10 or 1)))

	-- Notify about the payment reduce if the train is damaged
	if math.floor(td_payment - fine) > 1 then
		takePlayerMoney(client, math.floor(td_payment - fine))
		exports.GTWtopbar:dm("Removed $"..tostring(math.floor(td_payment - fine)).." due to damage on your train!",
			client, 255, 0, 0)
	end

	-- Get the next station on the list
	if #train_routes[getElementData(client, "GTWtraindriver.currentRoute")] ==
	 	tonumber(getElementData(client, "GTWtraindriver.currentstation")) then
		setElementData( client, "GTWtraindriver.currentstation", 1)
	else
		setElementData(client, "GTWtraindriver.currentstation", tonumber(
			getElementData(client, "GTWtraindriver.currentstation" ))+1)
	end

	-- Force the client to create markers and blips for the next station
	create_new_train_station(client, tonumber(getElementData(client, "GTWtraindriver.currentstation")))
end
addEvent("GTWtraindriver.paytrainDriver", true)
addEventHandler("GTWtraindriver.paytrainDriver", resourceRoot, calculate_next_station)

--[[ A little hack for developers to manually change the route ID ]]--
function set_manual_station(plr, cmd, ID)
	local is_staff = exports.GTWstaff:isStaff(plr)
	if not is_staff then return end
	setElementData(plr, "GTWtraindriver.currentstation", tonumber(ID) or 1)
	create_new_train_station(plr, tonumber(ID) or 1)
end
addCommandHandler("settrainstation", set_manual_station)

--[[ Display a delayed message securely ]]--
function delayed_message(text, plr, r,g,b, color_coded)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	if not getPlayerTeam(plr) or getPlayerTeam(plr) ~= getTeamFromName("Civilians") or
		getElementData(plr, "Occupation") ~= "Train Driver" then return end
	if not getPedOccupiedVehicle(plr) or not train_vehicles[getElementModel(getPedOccupiedVehicle(plr))] then return end
	exports.GTWtopbar:dm(text, plr, r,g,b, color_coded)
end
