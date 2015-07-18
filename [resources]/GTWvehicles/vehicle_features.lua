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

--[[ Turn vehicle headlights on or off ]]--
function toggle_lights(plr, key, state)
    if(getPedOccupiedVehicleSeat(plr) == 0) then
        local veh = getPedOccupiedVehicle(plr)
        if (getVehicleOverrideLights(veh) ~= 2) then
            setVehicleOverrideLights(veh, 2)
            for i=1, 20 do
            	if getVehicleTowedByVehicle(veh) then
					local veh2 = getVehicleTowedByVehicle(veh)
					setVehicleOverrideLights(veh2, 2)
					veh = veh2
				end
			end
        else
            setVehicleOverrideLights(veh, 1)
            for i=1, 20 do
            	if getVehicleTowedByVehicle(veh) then
					local veh2 = getVehicleTowedByVehicle(veh)
					setVehicleOverrideLights(veh2, 1)
					veh = veh2
				end
			end
        end
    end
end

--[[ Start or stop the engine of any vehicle ]]--
function toggle_engine(plr, command)
	if getPedOccupiedVehicleSeat(plr) == 0 then
    	local veh = getPedOccupiedVehicle(plr)
    	if veh and ((getElementData(veh,"owner") and 
    		getElementData(veh,"owner") == getAccountName(getPlayerAccount(plr))) or 
    		getElementData(veh, "hijack") or getElementData(veh, "npc")) then
	    	if getVehicleEngineState(veh) then
		        setVehicleEngineState(veh, false)
		        setVehicleOverrideLights(veh, 1)
		        if getVehicleType(veh) == "Train" then
		        	local sx, sy, sz = getElementVelocity(veh)
					local actualspeed =(sx^2 + sy^2 + sz^2)^(0.5) 
					local kmh = actualspeed * 180
		        	if kmh < 5 then
		        		setElementFrozen(veh, true)
		        		setTrainSpeed(veh, 0)
		        		for i=1, 20 do
            				if getVehicleTowedByVehicle(veh) then
								local veh2 = getVehicleTowedByVehicle(veh)
								setVehicleOverrideLights(veh2, 1)
								setVehicleEngineState(veh2, false)
								setElementFrozen(veh2, true)
		        				setTrainSpeed(veh2, 0)
								veh = getVehicleTowedByVehicle(veh)
							end
						end
		        	else
		        		exports.GTWtopbar:dm("Slow down before turning off the engine!", plr, 255, 0, 0) 
		        	end
		        else
		        	setControlState(plr, "handbrake", true)
		        end
		    elseif tonumber(getElementData(veh, "vehicleFuel")) > 0 then
		    	setVehicleEngineState(veh, true)
		    	setVehicleOverrideLights(veh, 0)
		    	if getVehicleType(veh) == "Train" then
		        	setElementFrozen(veh, false)
		        	for i=1, 20 do
            			if getVehicleTowedByVehicle(veh) then
							local veh2 = getVehicleTowedByVehicle(veh)
							setVehicleOverrideLights(veh2, 0)
							setVehicleEngineState(veh2, true)
							setElementFrozen(veh2, false)
							veh = getVehicleTowedByVehicle(veh)
						end
					end
		        else
		        	setControlState(plr, "handbrake", false)
		        end
		    end
		else
			exports.GTWtopbar:dm("You don't have the keys to this vehicle!", plr, 255, 0, 0) 
		end
    end
end
addCommandHandler("engine", toggle_engine)
addCommandHandler("engineon", toggle_engine)
addCommandHandler("engineoff", toggle_engine)

--[[ Toggle the lock of any vehicle ]]--
function toggle_lock(plr, command)
	local veh = vehicles[plr]
	if not isElement(vehicles[plr]) or getPedOccupiedVehicle(plr) then
		veh = getPedOccupiedVehicle(plr)
	end
    if isElement(veh) and getElementData(veh, "owner") then 
		local px,py,pz = getElementPosition(plr)
		local vx,vy,vz = getElementPosition(veh)	
		local dist = getDistanceBetweenPoints3D(px,py,pz, vx,vy,vz)	
		if dist < 90 then		
        	if isVehicleLocked(veh) then 
	            setVehicleLocked(veh, false)
	            for i=1, 20 do
            		if getVehicleTowedByVehicle(veh) then
						local veh2 = getVehicleTowedByVehicle(veh)
						if getElementModel(veh2) == 537 or getElementModel(veh2) == 538 then
							setVehicleLocked(veh2, false)
						end
						veh = getVehicleTowedByVehicle(veh)
					end
				end
				exports.GTWtopbar:dm("Your vehicle has been unlocked", plr, 255, 100, 0)            
	        else                  
	            setVehicleLocked(veh, true) 
	            for i=1, 20 do
            		if getVehicleTowedByVehicle(veh) then
						local veh2 = getVehicleTowedByVehicle(veh)
						if getElementModel(veh2) == 537 or getElementModel(veh2) == 538 then
							setVehicleLocked(veh2, true)
						end
						veh = getVehicleTowedByVehicle(veh)
					end
				end
				exports.GTWtopbar:dm("Your vehicle was locked sucsessfully", plr, 255, 100, 0)              
	        end
	    else
	    	exports.GTWtopbar:dm("You are too far away from your vehicle to use it's keys", plr, 255, 0, 0) 
	    end
	else
		exports.GTWtopbar:dm("You don't have the keys to this vehicle!", plr, 255, 0, 0) 
    end
end
addCommandHandler("lock", toggle_lock)
addCommandHandler("unlock", toggle_lock)

--[[ On vehicle enter, automatically start the engine and lights ]]--
function startVehicle(plr, seat, jacked)
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
addEventHandler("onVehicleEnter", root, startVehicle)

--[[ Unlock your own car on enter ]]--
function unlock_my_own_vehicle(plr, seat, jacked)
	if not getElementData(source, "owner") then return end
	if (not getPlayerAccount(plr) or getAccountName(getPlayerAccount(plr)) ~= 
		getElementData(source, "owner")) and isVehicleLocked(source) then
		exports.GTWtopbar:dm("This vehicle is locked and you don't have it's keys", plr, 255, 0, 0)
		cancelEvent()
		return
	end
	
	-- Unlock and notice if owner
	if isVehicleLocked(source) then
		setVehicleLocked(source, false) 
		exports.GTWtopbar:dm("Your vehicle has been unlocked", plr, 255, 100, 0) 
	end
end
addEventHandler("onVehicleStartEnter", root, unlock_my_own_vehicle)

--[[ Apply speedlimit to vehicle ]]--
function limit_the_speed(plr, command, amount)
	local veh = getPedOccupiedVehicle(plr)
	local amount = tonumber(amount) or -1
    if veh and isElement(veh) then
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
end
addCommandHandler("limitspeed", limit_the_speed)
addCommandHandler("speedlimit", limit_the_speed)

--[[ Helper function for the topbar ]]--
function topBar(message, plr, r, g, b)
	if isElement(plr) then
		exports.GTWtopbar:dm(message, plr, r, g, b)
	end
end