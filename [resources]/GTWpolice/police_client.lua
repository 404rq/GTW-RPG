--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

function forceEnter( )
    setControlState ( localPlayer, "enter_passenger", true )
    -- setTimer( setControlState, 500, 1, localPlayer, "enter_passenger", false )
end
addEvent( "onForceEnter", true )
addEventHandler( "onForceEnter", getRootElement(), forceEnter )

--[[ Show how much time left in jail ]]--
function showTimeLeft( )
	if getElementData( localPlayer, "Jailed" ) == "Yes" then
		local endTime = tonumber( getElementData( localPlayer, "jailTime" ))
		local currentTime = tonumber( getElementData( localPlayer, "jailTime2" ))
		local sx, sy = guiGetScreenSize( )
		dxDrawText ( "Remaining time in jail: "..tostring(math.floor((endTime-currentTime)/1000)).." seconds", (sx/2)-248, sy-48, 0, 0, 
			tocolor( 0, 0, 0, 255 ), 0.7, "bankgothic" )
		dxDrawText ( "Remaining time in jail: "..tostring(math.floor((endTime-currentTime)/1000)).." seconds", (sx/2)-250, sy-50, 0, 0, 
			tocolor( 255, 100, 0, 255 ), 0.7, "bankgothic" )
	end
	if getElementData( localPlayer, "distToCrim" ) and getElementData( localPlayer, "distToCrim" ) ~= "?" and getPlayerTeam(localPlayer) and
		lawTeams[getTeamName(getPlayerTeam(localPlayer))] and not getElementData(localPlayer, "admin") and 
		getPlayerTeam(localPlayer) ~= getTeamFromName("Emergency service") then
		local dist = getElementData( localPlayer, "distToCrim" );
		local sx, sy = guiGetScreenSize( )
		dxDrawText ( "Possible suspect: "..dist, sx-548, sy-38, 0, 0, 
			tocolor( 0, 0, 0, 255 ), 0.7, "bankgothic" )
		dxDrawText ( "Possible suspect: "..dist, sx-550, sy-40, 0, 0, 
			tocolor( 255, 100, 0, 255 ), 0.7, "bankgothic" )
	end
end
addEventHandler ( "onClientRender", root, showTimeLeft )

--[[ Protect staff and arrested players from taking damage ]]-- 
function damage_protection(attacker, weapon, bodypart, loss)
	-- Staff protection
	if source == localPlayer and getPlayerTeam(source) and getPlayerTeam(source) == getTeamFromName("Staff") then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", root, damage_protection )