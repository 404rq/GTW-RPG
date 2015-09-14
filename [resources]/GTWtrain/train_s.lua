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

--[[ Verify that a new train is allowed to spawn at given location ]]--
function spawn_allowed(sx,sy,sz)
	local c_dist = 9999
	for k,v in pairs(getElementsByType("vehicle", resourceRoot)) do
		if v and isElement(v) and getVehicleType(v) == "Train" then
			local tx,ty,tz = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(sx,sy,sz, tx,ty,tz)
			if c_dist > dist then
				c_dist = dist
			end
		end
	end

	-- Compare results
	if c_dist > Settings.max_distance_to_spawn then
		return true
	else
		return false
	end
end

--[[ Return the distance to nearest point from given coordinates ]]--
function get_next_node(ix,iy,iz)
	local c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = 9999,0,0,0,0,0,0,0
	for k,v in pairs(coords) do
		local s_type, t_dir, t_type, tx,ty,tz, t_speed = unpack(v)
		local dist = getDistanceBetweenPoints3D(ix,iy,iz, tx,ty,tz)
		if c_dist > dist then
			c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = dist, s_type, t_dir, t_type, tx,ty,tz, t_speed
		end
	end

	-- Return distance to nearest point and its data
	return c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed
end

--[[ Return the distance to nearest station from given coordinates ]]--
function nearest_station(ix,iy,iz)
	if not ix or not iy or not iz then ix,iy,iz = 0,0,0 end
	local c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = 9999,0,0,0,0,0,0,0
	for k,v in pairs(coords) do
		local s_type, t_dir, t_type, tx,ty,tz, t_speed = unpack(v)
		local dist = getDistanceBetweenPoints3D(ix,iy,iz, tx,ty,tz)
		if c_dist > dist and s_type > 0 then
			c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = dist, s_type, t_dir, t_type, tx,ty,tz, t_speed
		end
	end

	-- Return distance to nearest point and its data
	return c_dist
end

function print_nearest_station(plr, cmd)
	local px,py,pz = getElementPosition(plr)
	local dist = nearest_station(px,py,pz)
	outputChatBox("Nearest train station: "..dist.." at: "..getZoneName(px,py,pz), plr, 255, 100, 0)
end
addCommandHandler("station", print_nearest_station)

--[[ Return the coordinates of a proper spawn point based on given cordinates ]]--
function get_spawn_point(ix,iy,iz)
	local c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = 9999,0,0,0,0,0,0,0
	for k,v in pairs(coords) do
		-- Get the data for given point
		local s_type, t_dir, t_type, tx,ty,tz, t_speed = unpack(v)

		-- Calculate distance between the point and the input
		local dist = getDistanceBetweenPoints3D(ix,iy,iz, tx,ty,tz)

		-- Check if there's any player even closer to the spawn
		for l,plr in pairs(getElementsByType("player")) do
			local px,py,pz = getElementPosition(plr)
			local plr_dist = getDistanceBetweenPoints3D(tx,ty,tz, px,py,pz)
			if dist > plr_dist then
				-- There are players to close to the spawn, reject later
				dist = plr_dist
			end
		end

		-- Update if the spawnpoint is more than 100m away from any player
		if c_dist > dist and dist > Settings.min_track_distance and dist < Settings.max_track_distance then
			c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed = dist, s_type, t_dir, t_type, tx,ty,tz, t_speed
		end
	end

	-- Return distance to nearest point and its data
	return c_dist, station_type, train_dir, train_type, rx,ry,rz, r_speed
end

--[[ Convert a direction ID into a bolean representing the direction ]]--
function convert_direction(ID)
	if not ID then return false end
	if ID == 0 then return false end
	if ID == 1 then return true end
	if ID == 2 then
		local tmp = math.random(1,11)
		if tmp < 6 then return false
		else return true end
	end
end

--[[ Toggle if the train is at station or not ]]--
function station_status(train, status)
	if not train or not isElement(train) then return end
	Trains.is_running[train] = status

	-- Set a value indication that the station should be ignored
	if status then
		Trains.is_leaving[train] = true

		-- Call again to allow normal driving after 10 seconds
		setTimer(station_status, 30000, 1, train, false)
	end
end

--[[ Find the target speed and sync it ]]--
function sync_train_speed(train)
	if not train or not isElement(train) then return end
	if not Trains.is_running[train] then
		-- Train is at the station and must stay there
		setTrainSpeed(train, 0)
		return
	end

	-- Check if there are players nearby
	local x,y,z = getElementPosition(train)
	local plr_dist = 9999
	for k,v in pairs(getElementsByType("player")) do
		local px,py,pz = getElementPosition(v)
		local plr_dist2 = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
		if plr_dist > plr_dist2 then
			plr_dist = plr_dist2
		end
	end

	-- Destroy the train if the nearest player is more than 300m away
	if plr_dist > 300 then
		destroy_train(train)
		return
	end

	-- Get the target speed
	local dist, s_type, dir, t_type, tx,ty,tz, speed = get_next_node(x,y,z)
	local cx,cy,cz = getElementPosition(train)
	local center_dist = nearest_station(cx,cy,cz)
	local curr_speed = getTrainSpeed(train)*160

	-- If next point is a station and we're not leaving it then force the train to stop
	if center_dist < 20 and not Trains.is_leaving[train] then
		speed = 3
	elseif center_dist < 40 and not Trains.is_leaving[train] then
		speed = 10
	elseif center_dist < 80 and not Trains.is_leaving[train] then
		speed = 20
	elseif Trains.is_leaving[train] then
		speed = 40
	end

	-- Check if we are leaving a station
	local diff = math.abs(speed - curr_speed)
	if Settings.debug_level > 1 then
		outputServerLog("INFO: station: "..math.floor(center_dist).." | dst: "..
			math.floor(dist).." | diff: "..math.floor(diff).." | t-sp: "..
			speed.." | c-sp: "..math.floor(curr_speed))
	end

	-- Sync the speed
	if diff > Settings.slow_speed and speed > curr_speed and curr_speed >= 0 and (center_dist > 10 or Trains.is_leaving[train]) then
		set_speed_policy(train, 1)
	elseif diff > Settings.slow_speed and speed < curr_speed and curr_speed > Settings.slow_speed and center_dist > 10 then
		set_speed_policy(train, 2)
	else
		-- The target speed has been reached successfully
		set_speed_policy(train, 0)

		-- Now, let's check if we're at a station or end of the tracks, if so then we override
		if not Trains.is_leaving[train] and center_dist < 8 and s_type == 1 then
			station_status(train, false)
			setTrainSpeed(train, 0)
			if Settings.debug_level > 0 then
				outputServerLog("Stopped at station")
			end

			-- Make the train continue it's ride after given time
			setTimer(station_status, Settings.station_stop_time_ms, 1, train, true)
		end

		-- Is this really the end of the track? Well then we stop until cleanup
		if not Trains.is_leaving[train] and dist < 20 and s_type == 2 then
			station_status(train, false)
			setTrainSpeed(train, 0)
			if Settings.debug_level > 0 then
				outputServerLog("Stopped at end")
			end
		end
	end

	-- Always override if departure
	if Trains.is_leaving[train] and s_type == 1 then
		set_speed_policy(train, 1)
	end
end

--[[ Create a random train and attach cariages ]]--
function create_train(plr, cmd, args)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local x,y,z = getElementPosition(plr)
	local dist, s_type, dir, t_type, tx,ty,tz, speed = get_spawn_point(x,y,z)

	-- Validate spawn point
	if not spawn_allowed(x,y,z) or (tx == 0 and ty == 0 and tz == 0) then
		if Settings.debug_level > 0 then
			outputServerLog("Not allowed to create a train at: {"..x..", "..y..", "..z.."}")
		end
		return
	end

	-- Create the engine
	local engine_ID = 537
	if math.random(1,11) > 6 then
		engine_ID = 538
	end

	-- Spawn a tram
	if t_type == 1 then
		engine_ID = 449
	end

	local new_train = createVehicle(engine_ID, tx,ty,tz, 0,0,0, "")
	setElementSyncer(new_train, plr)

	-- Show debug info
	if Settings.debug_level > 0 then
		outputServerLog("New train created at: {"..tx..", "..ty..", "..tz.."}")
	end

	-- Create a hidden engineer
	local ped = createPed(172, 0, 0, 0)
	warpPedIntoVehicle(ped, new_train)
	Trains.engineer[new_train] = ped

	-- Set speed and direction
	local direction = convert_direction(dir)
	if args then
		if args == "0" then direction = false end
		if args == "1" then direction = true end
	end
	setTrainDirection(new_train, direction)

	if direction then
		setTrainSpeed(new_train, math.abs(30/160))	-- Clockwise
	else
		setTrainSpeed(new_train, -math.abs(30/160))	-- Counter clockwise
	end
	Trains.is_running[new_train] = true
	Trains.is_leaving[new_train] = false

	-- Add a new entry in the data table
	Trains.cars[new_train] = { }

	-- Add an extra engine if freight train
	local max_cars = 7
	local start_at = 1
	local t_length = math.random(2, max_cars)
	local front_car = new_train
	if t_length > 0 then
		local tmp_ID = 537
		if engine_ID == 538 then tmp_ID = 538 end

		-- Calculate position relative to the engine
		local rx,ry,rz = getElementRotation(front_car)
		tx = 20 * math.sin(rz)
		ty = 20 * math.cos(rz)

		-- Create a second engine
		local engine2 = createVehicle(tmp_ID, tx,ty,tz, 0,0,0, "")

		-- Attach car to the train
		attachTrailerToVehicle(front_car, engine2)
		--setTrainDirection(engine2, not direction)

		-- Add car to collection
		Trains.cars[new_train][start_at] = engine2

		-- Update front_car (the car in front of the next one)
		front_car = engine2
		start_at = 2
	end

	-- Generate some random cars
	if engine_ID == 449 then
		t_length = math.random(1, 2)
	end
	for index=start_at, t_length do
		-- Generate a train type
		local car_ID = 569
		if engine_ID == 537 and math.random(1,11) > 8 then
			car_ID = 590
		elseif engine_ID == 538 then
			car_ID = 570
		elseif engine_ID == 449 then
			car_ID = 449
		end

		-- Calculate position relative to front car
		local rx,ry,rz = getElementRotation(front_car)
		tx = 20 * math.sin(rz)
		ty = 20 * math.cos(rz)

		-- Create a random car
		local car = createVehicle(car_ID, tx,ty,tz, 0,0,0, "")

		-- Attach car to the train
		attachTrailerToVehicle(front_car, car)

		-- Add car to collection
		Trains.cars[new_train][index] = car

		-- Update front_car (the car in front of the next one)
		front_car = car
	end

	-- Activate speed syncer
	Trains.sync_timer[new_train] = setTimer(sync_train_speed, Settings.update_sync_time, 0, new_train)

	-- Adds a client event handler that destroys the train when it streams out.
	triggerClientEvent(plr, "GTWtrain.onStreamOut", plr, new_train)

	-- Use the horn
	use_horn(new_train)
end
addCommandHandler("maketrain", create_train)

--[[ Helper function to execute train horn ]]--
function use_horn(t_engine)
	exports.GTWtrainhorn:triggerTrainHorn(t_engine)
end

--[[ Gather points indicating where the tracks are (Development only) ]]--
function write_location(plr, cmd)
	local train = getPedOccupiedVehicle(plr)
	if not train or getElementType(train) ~= "vehicle" then return end
	local x,y,z = getElementPosition(train)
	outputConsole("    {0,2,0,70,"..x..","..y..","..z.."},", plr)
end
addCommandHandler("tl", write_location)

--[[ Attach a car to a train that currently is in the right position ]]--
function connect_carriages(plr)
	local train = getPedOccupiedVehicle(plr)
	if not train or not isElement(train) or getElementType(train) ~=
		"vehicle" or getVehicleType(train) ~= "Train" then
		exports.GTWtopbar:dm("You're not in a train!", plr, 255, 0, 0)
		return
	end

	-- Attach carriages
	local px,py,pz = getElementPosition(train)
	for k,v in pairs(getElementsByType("vehicle")) do
		if getVehicleType(v) == "Train" then
			local cx,cy,cz = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(px,py,pz, cx,cy,cz)
			if dist < 25 and dist > 15 and math.abs(getTrainSpeed(train)) < 0.01 then
				setTrainDirection(v, getTrainDirection(train))
				attachTrailerToVehicle(train, v)
				exports.GTWtopbar:dm("Train was attached successfully!", plr, 0, 255, 0)
				break
			elseif math.abs(getTrainSpeed(train)) >= 0.01 then
				exports.GTWtopbar:dm("Turn your engine off before attaching or dettaching cars to your train!", plr, 255, 0, 0)
			else
				exports.GTWtopbar:dm("There is no car close enough to attach! ("..dist..")", plr, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("attachtrain", connect_carriages)

--[[ Detach last car attached to a train ]]--
function disconnect_carriages(plr)
	local train = getPedOccupiedVehicle(plr)
	if not train or not isElement(train) or getElementType(train) ~=
		"vehicle" or getVehicleType(train) ~= "Train" then
		exports.GTWtopbar:dm("You're not in a train!", plr, 255, 0, 0)
		return
	end

	-- Detach carriages
	if math.abs(getTrainSpeed(train)) < 0.01 then
		detachTrailerFromVehicle(train)
		exports.GTWtopbar:dm("Train was detached successfully!", plr, 0, 255, 0)
	else
		exports.GTWtopbar:dm("Turn your engine off before attaching or dettaching cars to your train!", plr, 255, 0, 0)
	end
end
addCommandHandler("detachtrain", disconnect_carriages)

--[[ Destroy the train ]]--
function destroy_train(d_train)
	-- Kill the sync timer
	if isTimer(Trains.sync_timer[d_train]) then
		killTimer(Trains.sync_timer[d_train])
		Trains.sync_timer[d_train] = nil
	end

	-- Destroy the engineer
	if isElement(Trains.engineer[d_train]) then
		destroyElement(Trains.engineer[d_train])
		Trains.engineer[d_train] = nil
	end

	-- Clean properties from memory
	Trains.is_running[d_train] = nil
	Trains.is_leaving[d_train] = nil

	-- Destroy attached cars
	for k,v in ipairs(Trains.cars[d_train]) do
		if not isElement(v) then break end
		destroyElement(v)
		Trains.cars[d_train][k] = nil
	end
	Trains.cars[d_train] = nil

	-- Write to debug logs
	if Settings.debug_level > 0 then
		local tx,ty,tz = getElementPosition(d_train)
		outputServerLog("Destroyed train at: {"..tx..", "..ty..", "..tz.."}")
	end

	-- Destroy the engine
	destroyElement(d_train)
end
addEvent("GTWtrain.destroy", true)
addEventHandler("GTWtrain.destroy", root, destroy_train)

--[[ Control the engine clientside for better syncing
	State: 0 - neutral, 1 - forward, 2 - backward ]]--
function set_speed_policy(t_engine, state)
	if not t_engine or not isElement(t_engine) or getElementType(t_engine) ~= "vehicle" then return end
	local engineer = getVehicleOccupant(t_engine, 0)
	if not engineer or not isElement(engineer) or getElementType(engineer) ~= "ped" then return end

	-- Inverse if negative speed
	if getTrainSpeed(t_engine) < 0 and state == 1 then
		state = 2
	elseif getTrainSpeed(t_engine) < 0 and state == 2 then
		state = 1
	end

	triggerClientEvent(root, "GTWtrain.setControlState", resourceRoot, engineer, state)
end

--[[ Round float numbers ]]--
function math.round(number, decimals, method)
    	local decimals = decimals or 0
    	local factor = 10 ^ decimals
    	if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    	else return tonumber(("%."..decimals.."f"):format(number)) end
end

--[[ Execute a timer each 30 second to see if it's possible to create a new train ]]--
setTimer(function()
	local plr = getRandomPlayer( )
	create_train(plr)
end, 60*1000, 0)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
