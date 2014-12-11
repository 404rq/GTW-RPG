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

-- Global members
--[[cooldownspeeding = {}
local cooldownaim
local cooldown

-- Weapon fire
function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	if hitElement ~= localPlayer and source == localPlayer then
    	-- Protect law and staff from getting wanted
    	local isCop = false
		if lawTeams[getTeamName(getPlayerTeam( localPlayer ))] then
			isCop = true
		end
	
		-- Get number of occupants
		occuCount = 0
		if isElement( hitElement ) and getElementModel( hitElement ) > 300 and getElementType( hitElement ) == "vehicle" and getVehicleOccupants( hitElement ) then
			for Index, Value in pairs( getVehicleOccupants( hitElement )) do
  				occuCount = occuCount + 1
			end
		end
	
		-- Get wanted for shooting at vehicles or other objects 10 seconds anti spam
    	if not isTimer(cooldown) and ( not isCop ) then 
    		if weapon ~= 42 and weapon ~= 43 and isElement( hitElement ) and getElementModel( hitElement ) > 300 and getElementModel( hitElement ) < 600 and occuCount > 0 then
        	 	triggerServerEvent("setClientWL", localPlayer, round(((occuCount*0.4)+0.3), 2), 4, "You committed the crime of vandalism (vehicle) ("..tostring(round(((occuCount*0.4)+0.3), 2)).." stars)" )
        	 	cooldown = setTimer(function() end, 2000, 1)
        	elseif weapon ~= 42 and weapon ~= 43 and isElement( hitElement ) and getElementModel( hitElement ) > 300 and getElementModel( hitElement ) < 600 then
        	 	triggerServerEvent("setClientWL", localPlayer, round(0.2, 2), 4, "You committed the crime of vandalism (vehicle) (0.2 stars)" )
        	 	cooldown = setTimer(function() end, 2000, 1)
        	elseif weapon ~= 41 and weapon ~= 42 and weapon ~= 43 and isElement( hitElement ) and (getElementType(hitElement) == "player" or getElementType(hitElement) == "ped") then
         		triggerServerEvent("setClientWL", localPlayer, round(0.35, 2), 4, "You committed the crime of violence (0.35 stars)", false )
         		cooldown = setTimer(function() end, 7000, 1)
        	elseif weapon ~= 41 and not ( weapon == 42 and isPedOnFire( hitElement )) and weapon ~= 43 and ( not isCop ) and getElementInterior( localPlayer ) > 0 then
        		local wwl = math.random(1,5)*0.1
         		triggerServerEvent("setClientWL", localPlayer, round(wwl, 2), 2, "You committed the crime of vandalism (government property) ("..tostring(wwl).." stars)", false )
         		cooldown = setTimer(function() end, 7000, 1)
        	elseif isCop and hitElement and isElement(hitElement) and getElementData( hitElement, "Wanted" ) == 0 then
        		triggerServerEvent("setClientWL", localPlayer, round(0.07, 2), 1, "You committed the crime of public violence (0.07 stars)", false )
         		cooldown = setTimer(function() end, 7000, 1)
        	end
    	end
    end
end
addEventHandler( "onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFireFunc )

-- Getting wanted for running over pedastrians
function pedDamageWl( attacker, weapon, bodypart, loss )
	if not isTimer(cooldown3) and attacker == localPlayer then
		triggerServerEvent("setClientWL", localPlayer, round(loss/100, 2), 1, "You committed the crime of violence ("..tostring(round(loss/100,2)).."stars)", false )
    	cooldown3 = setTimer(function() end, 1000, 1)
    end 
end
addEventHandler( "onClientPedDamage", getRootElement(), pedDamageWl )

-- Getting wanted fpr killing a ped
function onWasted(killer, weapon, bodypart)
	if killer == localPlayer and not lawTeams[getTeamName(getPlayerTeam(localPlayer))] then
    	triggerServerEvent("setClientWL", localPlayer, round(1.0, 2), 8, "You committed the crime of murder (1.0 stars)", false )
    elseif killer == localPlayer and lawTeams[getTeamName(getPlayerTeam(localPlayer))] then
    	triggerServerEvent("setClientWL", localPlayer, round(0.4, 2), 8, "You committed the crime of murder (0.4 stars)", false )
    end
end
addEventHandler("onClientPedWasted", getRootElement(), onWasted)

-- Player aims at another player or object
function targetingActivated( target )
	-- Protect law and staff from getting wanted
	local isCop = false
	if lawTeams[getTeamName(getPlayerTeam( localPlayer ))] then
		isCop = true
	end
	
	-- Speeding camera
	if isCop and getControlState("aim_weapon") and getPedWeapon( localPlayer ) == 43 and isElement( target ) then
		speedx, speedy, speedz = getElementVelocity( target )
		actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
		kmh = actualspeed * 180

		if kmh > 70 and not isTimer( cooldownspeeding[localPlayer] ) then
			triggerServerEvent("onSpeeding", localPlayer, target )
			cooldownspeeding[localPlayer] = setTimer( function() end, 10000, 1 )
		end
	end
	
	-- Get wanted for aiming at other players, vehicles or objects 
	-- (lowest represent 1% of a star and none of these won´t trigger 
	-- more than one time/10 seconds) not all objects trigger on this 
	-- either, mostly players or vehicles.
	if target and isElement(target) and getPedWeapon( localPlayer ) ~= 41 and getPedWeapon( localPlayer ) ~= 42 and 
		getPedWeapon( localPlayer ) ~= 43 and not isTimer( cooldownaim ) and getControlState("aim_weapon") and ( not isCop ) then 
        if ( getElementModel( target ) or 0 ) < 400 and (getElementData( target, "DM" ) or target) ~= localPlayer then
         	--outputChatBox ( "You committed the crime of threat 0.05 stars", 255, 255, 0 )
         	triggerServerEvent("setClientWL", localPlayer, round(0.05, 2), 8, "You committed the crime of threat (0.05 stars)", false )
         	cooldownaim = setTimer(function() end, 7000, 1)
        elseif getElementModel ( target ) > 399 and getElementModel ( target ) < 612 then
         	--outputChatBox ( "You committed the crime of threat (vehicle) 0.02 stars", 255, 255, 0 )
         	triggerServerEvent("setClientWL", localPlayer, round(0.02, 2), 4, "You committed the crime of threat (vehicle) (0.02 stars)", false )
         	cooldownaim = setTimer(function() end, 7000, 1)
        elseif getElementModel ( target ) > 611 then
         	--outputChatBox ( "You committed the crime of threat (object) 0.01 stars", 255, 255, 0 )
         	triggerServerEvent( "setClientWL", localPlayer, round(0.01, 2), 1, "You committed the crime of threat (object) (0.01 stars)", false )
         	cooldownaim = setTimer(function() end, 7000, 1)
        end
    end
end
addEventHandler( "onClientPlayerTarget", getRootElement(), targetingActivated )

-- Dangerous driving, calculate damage in collisions and 
-- make you wanted for collisions with a lot of force, 
-- note that this is depending on the speed limit of 70km/h 
-- server side and won't trigger for unimportant stuff.
-- the limit is pretty much when you drive threw SF in over 130 
-- jumping over the hills or crash anywhere with a speed higher than 70km/h
addEventHandler("onClientVehicleCollision", root,
    function(collider,force, bodyPart, x, y, z, nx, ny, nz)
        if ( source == getPedOccupiedVehicle(localPlayer) ) and ( not isTimer( cooldowncrash )) then
            -- Make the bad driver getting wanted
            local fDamageMultiplier = 1 -- getVehicleHandling(source).collisionDamageMultiplier
            local wl = tonumber( math.floor(( force * fDamageMultiplier)*100) / 60000 );
            local speedx, speedy, speedz = getElementVelocity( source )
			local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
			local kmh = actualspeed * 180
			local isViolent = 0
			if kmh > 70 then
				wl = wl*(kmh/70)*4
			end
			if kmh > 100 then
				wl = wl*(kmh/70)*3
			end
            if kmh > 40 and wl > 0.005 then
            	-- Justify wl
            	if wl > 3 then
            		wl = 3
            	end
            	if wl > 1 then
            		isViolent = 1
            	end
            	if lawTeams[getTeamName(getPlayerTeam( localPlayer ))] then
            		wl = (wl/4)
            	end
            
            	-- Checking the wl and only call if it's enough damage.
         		triggerServerEvent( "setClientWL", localPlayer, round((wl/5), 2), 
         			isViolent, "You committed the crime of dangerous driving ("..
            		tostring(round((wl/5), 2)).." stars)", true )
            	cooldowncrash = setTimer( function() end, 3000, 1)
            end
        end
    end
)

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
	-- Protect law and staff from getting wanted
	local hasWantedPlayersInside = false
	local occupants = getVehicleOccupants( source )
	local vx,vy,vz = getElementPosition( source )
	local px,py,pz = getElementPosition( localPlayer )
	local dist = getDistanceBetweenPoints3D( vx,vy,vz, px,py,pz )
	if occupants then
		for seat, occupant in pairs(occupants) do
       	 	if getElementType(occupant) == "player" then
            	if tonumber( getElementData( occupant, "Wanted" )) > 0 then
					hasWantedPlayersInside = true
				end
        	end
   	 	end
   	end
	if isElement(source) and isElement(attacker) and not isTimer(cooldownvehdamage) and 
		not getElementData( attacker, "admin" ) and not hasWantedPlayersInside and
		not lawTeams[getTeamName(getPlayerTeam( localPlayer ))] and attacker == localPlayer and 
		dist < 10 and getPedOccupiedVehicle(localPlayer) ~= source then
		local wl = (loss/50)
		if wl > 2 then
			wl = 2
		end
	    triggerServerEvent("setClientWL", localPlayer, round(wl, 2), math.floor(wl*2), "You committed the crime of vandalism (vehicle) ("..tostring(round(wl, 2)).." stars)", false )
	    cooldownvehdamage = setTimer( function() end, 3000, 1)
	end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)

-- Protect server staff from criminals
function clientPDamage(attacksser, weapon, bodypart, loss )
   	if getElementData( localPlayer, "admin" ) or
		getElementData( localPlayer, "arrested" ) or  	 	
	   	getElementData( localPlayer, "Jailed" ) == "Yes" then
	    cancelEvent()
	end
end
addEventHandler( "onClientPlayerDamage", getRootElement(), clientPDamage)

-- Disable stealt kills on staff
addEventHandler("onClientPlayerStealthKill",localPlayer,
function( targetPlayer )
    if getElementData(targetPlayer,"admin") or getElementType(targetPlayer) == "ped" then
        cancelEvent()
    end
end)

-- Round float values
function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end]]--
