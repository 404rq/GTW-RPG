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

-- Player aims at another player or objcet
cooldown = nil
info_cooldown = nil
function targetingActivated ( target )
	-- Check so the team is criminals, that the criminal
	-- is aiming and that the location is interior
	local theTeam = getPlayerTeam ( localPlayer )
	if not isTimer(cooldown) and not isTimer(info_cooldown) and getControlState("aim_weapon") and
		getElementInterior( localPlayer ) > 0 and isElement( target ) and
		( getPlayerTeam( localPlayer ) == getTeamFromName( "Criminals" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Civilians" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Gangsters" ) or
		getPlayerTeam( localPlayer ) == getTeamFromName( "Unemployed" )) then
		-- Cooldown during robbery 5 minutes between each rob
        triggerServerEvent( "onRob", localPlayer, target )
        cooldown = setTimer(function() end, 300000, 1 )
        info_cooldown = setTimer(function() end, 30000, 1 )
    elseif not isTimer(info_cooldown) and getControlState("aim_weapon") and
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
	if getElementInterior(localPlayer) > 0 then
		cancelEvent() -- Cancel any damage done to shop peds
	end
end
addEventHandler("onClientPedDamage", root, cancelPedDamage)

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
