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

-- Armor pickups
crimWantedCooldown	= { }
emlightCounter		= { }
armor_pickups = {
	[1]={ 1565.52734375, -1635.310546875, 13.550964355469 },
	[2]={ 3183.548828125, -1984.7590332031, 11.262499809265 },
	[3]={ 194.3837890625, 1920.892578125, 17.640625 },
	[4]={ -1616.7138671875, 677.953125, 7.1875 },
	[5]={ 2295.9873046875, 2456.498046875, 10.8203125 },
	[6]={ -222.185546875, 988.0732421875, 19.630926132202 },
	[7]={ -1389.2841796875, 2628.666015625, 55.984375 },
	[8]={ -2241.72265625, 2318.0166015625, 4.984375 },
	[9]={ -2977.486328125, 2243.716796875, 7.2578125 },
}

for ww=1, #armor_pickups do
	local aPickup = createPickup(armor_pickups[ww][1], armor_pickups[ww][2], armor_pickups[ww][3], 1, 100, 30000, 50)
	addEventHandler("onPickupHit", aPickup, function(plr)
		if not isLawUnit(plr) and not isTimer(crimWantedCooldown[plr]) then
		   	-- Set the wanted level
    			exports.GTWwanted:setWl(plr, 0.2, 15, "You comitted the crime of burglary of armor in government building!")
   				crimWantedCooldown[plr] = setTimer(function() end, 60000, 1)
   		end
	end)
end

-- Emergency lights
function toggleEmergencyLights(plr)
	if not isTimer(emlightCounter[plr]) then
		emlightCounter[plr] = setTimer(function() end, 1000, 1)
		return
	end
    	local theVehicle = getPedOccupiedVehicle(plr)
    	if(theVehicle and isElement(theVehicle) and getPedOccupiedVehicleSeat(plr) == 0) then
    		if not isTimer(light1[theVehicle]) and not isTimer(light2[theVehicle]) and
			lawTeams[getTeamName(getPlayerTeam(plr))] then
        		setVehicleOverrideLights(theVehicle, 2)
        		light1[theVehicle] = setTimer(setLight, 100, 1, theVehicle)
		elseif lawTeams[getTeamName(getPlayerTeam(plr))] then
			if isTimer(light1[theVehicle]) then
				killTimer(light1[theVehicle])
			end
			if isTimer(light2[theVehicle]) then
				killTimer(light2[theVehicle])
			end
			setVehicleOverrideLights(theVehicle, 0)
			setVehicleHeadLightColor(theVehicle, 255, 255, 255)
			setVehicleLightState(theVehicle, 0, 0)
			setVehicleLightState(theVehicle, 1, 0)
			setVehicleLightState(theVehicle, 2, 0)
			setVehicleLightState(theVehicle, 3, 0)
		end
    	end
end
addCommandHandler("emlight", toggleEmergencyLights)

function setLight(theVehicle)
	if isElement(theVehicle) then
    	light2[theVehicle] = setTimer(setLight2, 200, 1, theVehicle)
		if (policeVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 255, 0, 0)
   		elseif (fireVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 255, 255, 0)
   		elseif (medicVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 255, 255, 255)
		else
			setVehicleHeadLightColor(theVehicle, 0, 0, 255)
   		end
		setVehicleLightState(theVehicle, 0, 1)
		setVehicleLightState(theVehicle, 1, 0)
		setVehicleLightState(theVehicle, 2, 0)
		setVehicleLightState(theVehicle, 3, 1)
	else
		killTimer(light1[theVehicle])
	end
end
function setLight2(theVehicle)
	if isElement(theVehicle) then
    	setVehicleHeadLightColor(theVehicle, 255, 255, 255)
		light1[theVehicle] = setTimer(setLight, 200, 1, theVehicle)
		if (policeVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 0, 0, 255)
   		elseif (fireVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 0, 255, 0)
   		elseif (medicVehicles[getElementModel(theVehicle)]) then
   			setVehicleHeadLightColor(theVehicle, 255, 0, 0)
		else
			setVehicleHeadLightColor(theVehicle, 255, 0, 0)
   		end
		setVehicleLightState(theVehicle, 0, 0)
		setVehicleLightState(theVehicle, 1, 1)
		setVehicleLightState(theVehicle, 2, 1)
		setVehicleLightState(theVehicle, 3, 0)
	else
		killTimer(light2[theVehicle])
	end
end

-- Show distance to suspect
function syncTracker( cop )
	if not cop or not isElement(cop) then return end
	local dist = distanceToCrim( cop )
	if dist < 3100 and dist > 90 then
		setElementData( cop, "distToCrim", tostring(math.floor(dist)).."m, "..directionToCrim(cop))
	elseif dist >= 3100 then
		setElementData( cop, "distToCrim", "?" )
	elseif dist <= 90 then
		setElementData( cop, "distToCrim", "very close" )
	end
end
addEventHandler("onPlayerLogin", root,
function()
    tracker_timers[source] = setTimer( syncTracker, 1000, 0, source )
    -- Bind the key to emergency lights
    bindKey(source, "H", "down", "emlight")
    bindKey(source, "H", "up", "emlight")
end)
for k,v in pairs(getElementsByType("player")) do
	tracker_timers[v] = setTimer( syncTracker, 1000, 0, v )
end
