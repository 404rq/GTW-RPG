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

--[[ Turn vehicle headlights on or off ]]--
function toggle_lights(plr, key, state)
        -- Make sure only the driver can control the lights
        if getPedOccupiedVehicleSeat(plr) > 0 then return end
        local veh = getPedOccupiedVehicle(plr)

        -- Make sure the player is inside a vehicle
    	if not veh or not isElement(veh) or getElementType(veh) ~= "vehicle" then return end

        -- Turn lights on (force)
        if getVehicleOverrideLights(veh) ~= 2 then
                -- Apply to eventual attached trailers as well
                while veh do
                        setVehicleOverrideLights(veh, 2)
                        veh = getVehicleTowedByVehicle(veh)
                end
        -- Turn lights off (force)
        else
                -- Apply to eventual attached trailers as well
                while veh do
                        setVehicleOverrideLights(veh, 1)
                        veh = getVehicleTowedByVehicle(veh)
                end
        end
end

--[[ Start or stop the engine of any vehicle ]]--
function toggle_engine(plr, command)
        -- Make sure only the driver can use this
	if getPedOccupiedVehicleSeat(plr) > 0 then return end
    	local veh = getPedOccupiedVehicle(plr)

        -- Make sure the player is inside a vehicle
    	if not veh or not isElement(veh) or getElementType(veh) ~= "vehicle" then return end

        -- Stop the engine
	if getVehicleEngineState(veh) then
                -- Train engine cannot be turned off, train can only be stopped
		if getVehicleType(veh) == "Train" then
                        setTrainSpeed(veh, 0)
                        toggleControl(plr, "accelerate", false)
                        toggleControl(plr, "brake_reverse", false)
		else
        	        setVehicleOverrideLights(veh, 1)
			setControlState(plr, "handbrake", true)
		end
                setVehicleEngineState(veh, false)
                exports.GTWtopbar:dm("Engine: Turned off successfully", plr, 255, 100, 0)
        -- Start the engine if there's enough fuel
	elseif tonumber(getElementData(veh, "vehicleFuel")) > 0 then
	    	if getVehicleType(veh) ~= "Train" then
	        	setControlState(plr, "handbrake", false)
        	    	setVehicleOverrideLights(veh, 0)
                else
                        toggleControl(plr, "accelerate", true)
                        toggleControl(plr, "brake_reverse", true)
	        end
                setVehicleEngineState(veh, true)
                exports.GTWtopbar:dm("Engine: Turned on successfully", plr, 255, 100, 0)
	end
end
addCommandHandler("engine", toggle_engine)
addCommandHandler("engineon", toggle_engine)
addCommandHandler("engineoff", toggle_engine)

--[[ Toggle the lock of any vehicle ]]--
function toggle_lock(plr, command)
        -- Get vehicle from currently spawned
	local veh = vehicles[plr]

        -- If no vehicle is spawned get from whichever vehicle you're in
	if not isElement(vehicles[plr]) or getPedOccupiedVehicle(plr) then
		veh = getPedOccupiedVehicle(plr)
	end

        -- Check if the vehicle exist and that the player is the owner of it
        if not isElement(veh) or not getElementData(veh, "owner") then
                exports.GTWtopbar:dm("You don't have the keys to this vehicle!", plr, 255, 0, 0)
                return
        end

        -- Check distance to the vehicle
	local px,py,pz = getElementPosition(plr)
	local vx,vy,vz = getElementPosition(veh)
	local dist = getDistanceBetweenPoints3D(px,py,pz, vx,vy,vz)
	if dist > 90 then
                exports.GTWtopbar:dm("You are too far away from your vehicle to use it's keys", plr, 255, 0, 0)
                return
        end

        -- Unlock vehicle and it's trailers
        if isVehicleLocked(veh) then
                setVehicleLocked(veh, false)
                while veh do
                        if getElementModel(veh) == 537 or getElementModel(veh) == 538 then
                                setVehicleLocked(veh, false)
                        end
                        veh = getVehicleTowedByVehicle(veh)
                end
		exports.GTWtopbar:dm("Your vehicle has been unlocked", plr, 255, 100, 0)
        -- Lock vehicle and it's trailers
	else
                setVehicleLocked(veh, true)
                while veh do
                        if getElementModel(veh) == 537 or getElementModel(veh) == 538 then
                                setVehicleLocked(veh, true)
                        end
                        veh = getVehicleTowedByVehicle(veh)
                end
                exports.GTWtopbar:dm("Your vehicle has been locked", plr, 255, 100, 0)
        end
end
addCommandHandler("lock", toggle_lock)
addCommandHandler("unlock", toggle_lock)

--[[ On vehicle enter, automatically start the engine and lights ]]--
function start_vehicle(plr, seat, jacked)
	if isElement(plr) and getElementData(source, "owner") then
		if getPedOccupiedVehicleSeat(plr) == 0 then
	    	setVehicleEngineState(source, true)
	    	if trailers[plr] and isElement(trailers[plr]) and getElementType(trailers[plr]) == "Vehicle" then
	    		setVehicleEngineState(trailers[plr], true)
	    	end
			setVehicleOverrideLights(source, 2)
			gearTimers[source] = setTimer(gearBox, 100, 0, source, plr)
			if not getElementData(source, "gearType") then
				setElementData(source, "gearType", "Sport")
			end
			if getVehicleType(source) == "Automobile" then
				setVehicleHandling(source, "maxVelocity", nil, false)
				local result = getVehicleHandling(source)
				currVehTopSpeed[source] = tonumber(result["maxVelocity"])
				setTimer(showGearProfile, 95, 1, plr, source)
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, start_vehicle)

--[[ Unlock your own car on enter ]]--
function validate_lock(plr, seat, jacked)
        -- Skip check if the vehicle has no owner
	if not getElementData(source, "owner") then return end

        -- Notify if the vehicle is locked
	if (not getPlayerAccount(plr) or getAccountName(getPlayerAccount(plr)) ~=
		getElementData(source, "owner")) and isVehicleLocked(source) then
                -- Tell the person trying to enter
		exports.GTWtopbar:dm("This vehicle is locked and you don't have it's keys", plr, 255,0,0)

                -- Check if the vehicle has a driver and notify that driver
                local driver = getVehicleOccupant(source, 0)
                if driver then
                        exports.GTWtopbar:dm(getPlayerName(plr)..
                                " tries to enter your vehicle but it's locked", plr, 255,0,0)
                end

                -- Cancel the event and break
		cancelEvent()
		return
	end
end
addEventHandler("onVehicleStartEnter", root, validate_lock)

--[[ Apply speedlimit to vehicle ]]--
function limit_the_speed(plr, command, amount)
	local veh = getPedOccupiedVehicle(plr)
	local amount = tonumber(amount) or -1
        if not veh or not isElement(veh) then return end
    	if amount == -1 then
		setVehicleHandling(veh, "maxVelocity", nil, false)
		if currVehTopSpeed[veh] then
			exports.GTWtopbar:dm("Vehicle top speed is now: "..tostring(currVehTopSpeed[veh]).."km/h", plr, 255, 100, 0)
		else
			exports.GTWtopbar:dm("Vehicle top speed has been resetted", plr, 255, 100, 0)
		end
	else
		if currVehTopSpeed[veh] and currVehTopSpeed[veh] < amount then amount = currVehTopSpeed[veh] end
		setVehicleHandling(veh, "maxVelocity", amount, false)
		exports.GTWtopbar:dm("Vehicle top speed is now: "..tostring(amount).."km/h", plr, 255, 100, 0)
        end
end
addCommandHandler("limitspeed", limit_the_speed)
addCommandHandler("speedlimit", limit_the_speed)

--[[ Helper function for the display_message ]]--
function display_message(message, plr, r, g, b)
	if isElement(plr) then
		exports.GTWtopbar:dm(message, plr, r, g, b)
	end
end

--[[ Resource validator ]]--
addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
