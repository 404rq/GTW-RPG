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

-- Global data and pointers
toggler				= { }
dtype				= { }
syncTimer 			= { }
currHeadLightColor 	= {{ }}

-- Bind keys
function bindTurnIndicators()
	bindKey(source, ",", "down", "lleft")
	bindKey(source, ".", "down", "lright")
	bindKey(source, "-", "down", "warn")
end
addEventHandler("onPlayerJoin", root, bindTurnIndicators)

-- Bind on resource start
for k,v in pairs(getElementsByType("players")) do
	bindKey(v, ",", "down", "lleft")
	bindKey(v, ".", "down", "lright")
	bindKey(v, "-", "down", "warn")
	outputServerLog("player: "..getPlayerName(v))
end

-- Toggling lights
function toggleLights( veh )
	if veh and isElement( veh ) and getElementType(veh) == "vehicle" then
		setVehicleOverrideLights( veh, 2 )
		if toggler[veh] == 1 then
			setVehicleLightState( veh, 0, 1 )
			setVehicleLightState( veh, 1, 1 )
			setVehicleLightState( veh, 2, 1 )
			setVehicleLightState( veh, 3, 1 )
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				if veh2 then
					setVehicleLightState( veh2, 0, 1 )
					setVehicleLightState( veh2, 1, 1 )
					setVehicleLightState( veh2, 2, 1 )
					setVehicleLightState( veh2, 3, 1 )
				end
			end
			toggler[veh] = 0
		else
			if dtype[veh] == "lleft" then
				setVehicleLightState( veh, 0, 0 )
				setVehicleLightState( veh, 1, 1 )
				setVehicleLightState( veh, 2, 1 )
				setVehicleLightState( veh, 3, 0 )
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					if veh2 then
						setVehicleLightState( veh2, 0, 0 )
						setVehicleLightState( veh2, 1, 1 )
						setVehicleLightState( veh2, 2, 1 )
						setVehicleLightState( veh2, 3, 0 )
					end
				end
			elseif dtype[veh] == "lright" then
				setVehicleLightState( veh, 0, 1 )
				setVehicleLightState( veh, 1, 0 )
				setVehicleLightState( veh, 2, 0 )
				setVehicleLightState( veh, 3, 1 )
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					if veh2 then
						setVehicleLightState( veh2, 0, 1 )
						setVehicleLightState( veh2, 1, 0 )
						setVehicleLightState( veh2, 2, 0 )
						setVehicleLightState( veh2, 3, 1 )
					end
				end
			elseif dtype[veh] == "warn" then
				setVehicleLightState( veh, 0, 0 )
				setVehicleLightState( veh, 1, 0 )
				setVehicleLightState( veh, 2, 0 )
				setVehicleLightState( veh, 3, 0 )
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					if veh2 then
						setVehicleLightState( veh2, 0, 0 )
						setVehicleLightState( veh2, 1, 0 )
						setVehicleLightState( veh2, 2, 0 )
						setVehicleLightState( veh2, 3, 0 )
					end
				end
			end
			toggler[veh] = 1
		end
	end
end

-- Left
function lightHandler( player, cmd )
	if player and isElement( player ) and getPedOccupiedVehicle( player ) then
		local veh = getPedOccupiedVehicle( player )
		if ( not isTimer( syncTimer[veh] ) or cmd ~= dtype[veh] ) and getVehicleOccupants(veh)[0] == player then
			-- Save the current head light color
			setVehicleLightState( veh, 0, 1 )
			setVehicleLightState( veh, 1, 1 )
			setVehicleLightState( veh, 2, 1 )
			setVehicleLightState( veh, 3, 1 )
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				if veh2 then
					setVehicleLightState( veh2, 0, 1 )
					setVehicleLightState( veh2, 1, 1 )
					setVehicleLightState( veh2, 2, 1 )
					setVehicleLightState( veh2, 3, 1 )
				end
			end

			if not currHeadLightColor[veh] then
				currHeadLightColor[veh] = { }
				currHeadLightColor[veh][1],currHeadLightColor[veh][2],currHeadLightColor[veh][3] = getVehicleHeadLightColor( veh )
			end

			-- Set the new headlight color to yellow
			setVehicleHeadLightColor( veh, 255, 200, 0 )

			-- Start the syn timer
			if isTimer( syncTimer[veh] ) then
				killTimer( syncTimer[veh] )
			end
			syncTimer[veh] = setTimer( toggleLights, 380, 0, veh )
			toggler[veh] = 1
			dtype[veh] = cmd
			toggleLights( veh )
		else
			if isTimer( syncTimer[veh] ) then
				killTimer( syncTimer[veh] )
				setVehicleHeadLightColor( veh, currHeadLightColor[veh][1],currHeadLightColor[veh][2],currHeadLightColor[veh][3] )
				currHeadLightColor[veh][1] = nil
				currHeadLightColor[veh][2] = nil
				currHeadLightColor[veh][3] = nil
				currHeadLightColor[veh] = nil
			end
			startLights(veh)
		end
	end
end
addCommandHandler( "lleft", lightHandler )
addCommandHandler( "lright", lightHandler )
addCommandHandler( "warn", lightHandler )

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Turn on all lights ]]--
function startLights(veh)
	if not veh or not isElement(veh) then return end
	setVehicleLightState( veh, 0, 0 )
	setVehicleLightState( veh, 1, 0 )
	setVehicleLightState( veh, 2, 0 )
	setVehicleLightState( veh, 3, 0 )
	setVehicleOverrideLights( veh, 2 )
	if getVehicleTowedByVehicle( veh ) then
		local veh2 = getVehicleTowedByVehicle( veh )
		if veh2 then
			setVehicleLightState( veh2, 0, 0 )
			setVehicleLightState( veh2, 1, 0 )
			setVehicleLightState( veh2, 2, 0 )
			setVehicleLightState( veh2, 3, 0 )
			setVehicleOverrideLights( veh2, 2 )
		end
	end
end
