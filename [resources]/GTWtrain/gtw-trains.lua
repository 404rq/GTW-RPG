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

--[[ Resource settings, all settings goes here ]]--
Settings = {
	min_distance_to_spawn 	= 500,
	update_sync_time		= 1000,
	interval				= 1,
	slow_speed				= 3,
	station_stop_time_ms	= 5000,
}

--[[ All train data are stored in this table ]]--
Trains = {
	cars 			= {{ }},	-- Array of carriages attached to the train
	is_running		= { },		-- Boolean indicating if train is moving or not
	target_speed	= { },		-- The speed the train is trying to reach
	engineer		= { },
	sync_timer		= { },
	is_leaving		= { },
}

--[[
	Spawn points along the tracks
	stoptype[0=drive, 1=station, 2=hold]
	direction[0=counterclockwise, 1=clockwise, 2=both]
	type[0=train, 1=tram]
	maxSpeed(kmh), x, y, z
]]--
coords = {
 	{0,2,0,10,-1529.2353515625,563.9736328125,35.844818115234},
    {0,2,0,20,-1482.001953125,598.31640625,35.875617980957},
    {1,2,0,1,-1349.1943359375,694.8310546875,35.875617980957},
    {0,2,0,70,-1264.9013671875,756.06640625,35.875617980957},
    {0,2,0,50,-1147.2587890625,841.49609375,35.875617980957},
    {2,2,0,0,-1069.51171875,897.970703125,35.875617980957},
}

--[[ Verify that a new train is allowed to spawn at given location ]]--
function isSpawnAllowed(sx,sy,sz)
	local c_dist = 9999
	for k,v in pairs(getElementsByType("Vehicle")) do
		if getVehicleType(v) == "Train" then
			local tx,ty,tz = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(sx,sy,sz, tx,ty,tz)
			if c_dist > dist then
				c_dist = dist
			end
		end
	end

	-- Compare results
	if c_dist > Settings.min_distance_to_spawn then return true
	else return false end
end

--[[ Return the distance to nearest point from given coordinates ]]--
function nearestPoint(sx,sy,sz)
	local c_dist,rs_type,r_dir,rt_type,r_speed,rx,ry,rz = 9999,0,0,0,0,0,0,0
	for k,v in pairs(coords) do
		local s_type,dir,t_type,speed,tx,ty,tz = unpack(v)
		local dist = getDistanceBetweenPoints3D(sx,sy,sz, tx,ty,tz)
		if c_dist > dist then
			c_dist,r_dir,rs_type,rt_type,r_speed,rx,ry,rz = dist,dir,s_type,t_type,speed,tx,ty,tz
		end
	end

	-- Return distance to nearest point and its data
	return c_dist,r_dir,s_type,rt_type,r_speed,rx,ry,rz
end

--[[ Convert a direction ID into a bolean representing the direction ]]--
function convertIDToDirection(ID)
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
function setStationStatus(train, status)
	if not train or not isElement(train) then return end
	Trains.is_running[train] = status

	-- Set a value indication that the station should be ignored
	if status then
		Trains.is_leaving[train] = true
	end
end

--[[ Find the target speed and sync it ]]--
function syncSpeed(train)
	if not train or not isElement(train) then return end
	if not Trains.is_running[train] then
		-- Train is at the station and must stay there
		setTrainSpeed(train, 0)
		return
	end

	-- Get the target speed
	local x,y,z = getElementPosition(train)
	local dist,dir,s_type,t_type,speed,tx,ty,tz = nearestPoint(x,y,z)

	-- Check if we are leaving a station
	if Trains.is_leaving[train] and math.abs(getTrainSpeed(train)*160) > Settings.slow_speed then
		Trains.is_leaving[train] = false 	-- We're at next point
	end
	if Trains.is_leaving[train] and math.abs(getTrainSpeed(train)*160) < Settings.slow_speed then
		speed = Settings.slow_speed	-- Choose a more proper start speed
	end
	local diff = math.abs(speed-(getTrainSpeed(train)*160))
	outputConsole("Dist: "..dist..", diff: "..diff..", tspeed: "..speed)

	-- Sync the speed
	if diff > Settings.interval and speed > (getTrainSpeed(train)*160) then
		setTrainSpeed(train, getTrainSpeed(train)+(Settings.interval/160))
	elseif diff > Settings.interval and speed < (getTrainSpeed(train)*160) then
		setTrainSpeed(train, getTrainSpeed(train)-(Settings.interval/160))
	else
		-- The target speed has been reached successfully
		setTrainSpeed(train, speed/160)

		-- Now, let's check if we're at a station or end of the tracks
		if not Trains.is_leaving[train] and dist < 20 and s_type == 1 then
			setStationStatus(train, false)
			setTrainSpeed(train, 0)
			outputConsole("Stopped at station")

			-- Make the train continue it's ride after given time
			setTimer(setStationStatus, Settings.station_stop_time_ms, 1, train, true)
		end

		-- Is this really the end of the track? Well then we stop until cleanup
		if not Trains.is_leaving[train] and dist < 20 and s_type == 2 then
			setStationStatus(train, false)
			setTrainSpeed(train, 0)
			outputConsole("Stopped at end")
		end
	end
end

--[[ Create a random train and attach cariages ]]--
function createTrain(plr, cmd)
	local x,y,z = getElementPosition(plr)
	local dist,dir,s_type,t_type,speed,tx,ty,tz = nearestPoint(x,y,z)
	local new_train = createVehicle(538, tx,ty,tz, 0,0,0, "")

	-- Add a new entry in the data table
	Trains.cars[new_train] = { }

	-- Create a hidden engineer
	local ped = createPed(0, 0, 0, 0)
	setElementAlpha(ped, 0)
	warpPedIntoVehicle(ped, new_train)
	Trains.engineer[new_train] = ped

	-- Set speed and direction
	local direction = convertIDToDirection(dir)
	setTrainDirection(new_train, direction)
	setTrainSpeed(new_train, speed/160)
	Trains.is_running[new_train] = true
	Trains.is_leaving[new_train] = false

	-- Activate speed syncer
	Trains.sync_timer[new_train] = setTimer(syncSpeed, Settings.update_sync_time, 0, new_train)
end
addCommandHandler("maketrain", createTrain)

-- Gather points indicating where the tracks are (Development only)
function printTrainPoint(plr, cmd)
	local train = getPedOccupiedVehicle(plr)
	if not train or getElementType(train) ~= "vehicle" then return end
	local x,y,z = getElementPosition(train)
	outputConsole("    {0,2,0,70,"..x..","..y..","..z.."},", plr)
end
addCommandHandler("tl", printTrainPoint)

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
			if dist < 25 and dist > 15 and not getVehicleEngineState(train) then
				setTrainDirection(v, getTrainDirection(train))
				attachTrailerToVehicle(train, v)
				exports.GTWtopbar:dm("Train was attached successfully!", plr, 0, 255, 0)
				break
			elseif getVehicleEngineState(train) then
				exports.GTWtopbar:dm("Turn your engine off before attaching or dettaching cars to your train!", plr, 255, 0, 0)
			else
				exports.GTWtopbar:dm("There is no car close enough to attach! ("..dist..")", plr, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("attachtrain", connect_carriages)
function disconnect_carriages(plr)
	local train = getPedOccupiedVehicle(plr)
	if not train or not isElement(train) or getElementType(train) ~=
		"vehicle" or getVehicleType(train) ~= "Train" then
		exports.GTWtopbar:dm("You're not in a train!", plr, 255, 0, 0)
		return
	end

	-- Detach carriages
	if not getVehicleEngineState(train) then
		detachTrailerFromVehicle(train)
		exports.GTWtopbar:dm("Train was detached successfully!", plr, 0, 255, 0)
	else
		exports.GTWtopbar:dm("Turn your engine off before attaching or dettaching cars to your train!", plr, 255, 0, 0)
	end
end
addCommandHandler("deattachtrain", disconnect_carriages)
createVehicle(570, 1785.5224609375, -1953.814453125, 15.099542617798)
createVehicle(570, 1826.1123046875, -1953.8583984375, 15.099542617798)
