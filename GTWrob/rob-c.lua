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

-- Player aims at another player or objcet
cooldown = {}
function targetingActivated ( target )
	-- Check so the team is criminals, that the criminal 
	-- is aiming and that the location is interior
	local theTeam = getPlayerTeam ( localPlayer )
	if not isTimer( cooldown[localPlayer] ) and getControlState("aim_weapon") and 
		getElementInterior( localPlayer ) > 0 and isElement( target ) and 
		( getPlayerTeam( localPlayer ) == getTeamFromName( "Criminals" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Civilians" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Gangsters" ) or 
		getPlayerTeam( localPlayer ) == getTeamFromName( "Unemployed" )) then 
		-- Cooldown during robbery 20 minutes between each rob
        triggerServerEvent( "onRob", localPlayer, target ) 
        cooldown[localPlayer] = setTimer(function() end, 300000, 1 )
    elseif getControlState("aim_weapon") and 
		getElementInterior( localPlayer ) > 0 and isElement( target ) and 
		( getPlayerTeam( localPlayer ) == getTeamFromName( "Criminals" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Civilians" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Gangsters" ) or 
		getPlayerTeam( localPlayer ) == getTeamFromName( "Unemployed" )) then 
    	exports.GTWtopbar:dm( "There are to many cops around! Get the hell out of here.", 255, 0, 0 ) 
    end
end
addEventHandler ( "onClientPlayerTarget", root, targetingActivated )

function cancelPedDamage(attacker)
	cancelEvent() -- cancel any damage done to peds
end
addEventHandler("onClientPedDamage", resourceRoot, cancelPedDamage)

local color,direction = 0,true
function showTimeLeft( )
	if getElementData( localPlayer, "rob" ) then
		local endTime = tonumber( getElementData( localPlayer, "robTime" ))
		local currentTime = tonumber( getElementData( localPlayer, "robTime2" ))
		local sx, sy = guiGetScreenSize( )
		if endTime and currentTime and math.floor((endTime-currentTime)/1000) > 0 then
			dxDrawText ( "Robbery in progress, time left: "..tostring(math.floor((endTime-currentTime)/1000)), ((sx/2)-200), sy-50, 0, 0, 
				tocolor( color, color, color, 255 ), 0.7, "bankgothic" )
			if color == 255 then
				direction = false
			elseif color == 0 then
				direction = true
			end
			if direction then
				color = color + 1
			else
				color = color - 1
			end
		end
	end
end
addEventHandler( "onClientRender", root, showTimeLeft )