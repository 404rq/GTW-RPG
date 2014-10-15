--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

-- Global data and pointers
toggler				= { }
dtype				= { }
syncTimer 			= { }
currHeadLightColor 	= {{ }}

-- Toggling lights
function toggleLights( veh )
	if isElement( veh ) then
		setVehicleOverrideLights( veh, 2 ) 
		if toggler[veh] == 1 then
			setVehicleLightState( veh, 0, 1 )
			setVehicleLightState( veh, 1, 1 )
			setVehicleLightState( veh, 2, 1 )
			setVehicleLightState( veh, 3, 1 )
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				setVehicleLightState( veh2, 0, 1 )
				setVehicleLightState( veh2, 1, 1 )
				setVehicleLightState( veh2, 2, 1 )
				setVehicleLightState( veh2, 3, 1 )
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
					setVehicleLightState( veh2, 0, 0 )
					setVehicleLightState( veh2, 1, 1 )
					setVehicleLightState( veh2, 2, 1 )
					setVehicleLightState( veh2, 3, 0 )
				end
			elseif dtype[veh] == "lright" then
				setVehicleLightState( veh, 0, 1 )
				setVehicleLightState( veh, 1, 0 )
				setVehicleLightState( veh, 2, 0 )
				setVehicleLightState( veh, 3, 1 )
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					setVehicleLightState( veh2, 0, 1 )
					setVehicleLightState( veh2, 1, 0 )
					setVehicleLightState( veh2, 2, 0 )
					setVehicleLightState( veh2, 3, 1 )
				end
			elseif dtype[veh] == "warn" then
				setVehicleLightState( veh, 0, 0 )
				setVehicleLightState( veh, 1, 0 )
				setVehicleLightState( veh, 2, 0 )
				setVehicleLightState( veh, 3, 0 )
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					setVehicleLightState( veh2, 0, 0 )
					setVehicleLightState( veh2, 1, 0 )
					setVehicleLightState( veh2, 2, 0 )
					setVehicleLightState( veh2, 3, 0 )
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
				setVehicleLightState( veh2, 0, 1 )
				setVehicleLightState( veh2, 1, 1 )
				setVehicleLightState( veh2, 2, 1 )
				setVehicleLightState( veh2, 3, 1 )
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
				currHeadLightColor[player] = nil
			end
			setVehicleLightState( veh, 0, 0 )
			setVehicleLightState( veh, 1, 0 )
			setVehicleLightState( veh, 2, 0 )
			setVehicleLightState( veh, 3, 0 )
			setVehicleOverrideLights( veh, 2 ) 
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				setVehicleLightState( veh2, 0, 0 )
				setVehicleLightState( veh2, 1, 0 )
				setVehicleLightState( veh2, 2, 0 )
				setVehicleLightState( veh2, 3, 0 )
				setVehicleOverrideLights( veh2, 2 )
			end
		end
	end
end
addCommandHandler( "lleft", lightHandler )
addCommandHandler( "lright", lightHandler )
addCommandHandler( "warn", lightHandler )