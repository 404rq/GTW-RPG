--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

-- Time before a player capture the turf
function show_time_left( )
	if getElementData( localPlayer, "isInTurf" ) and not getElementData( localPlayer, "isInFriendlyTurf" ) then
		local timeMsg = getElementData( localPlayer, "captureTime" )
		local sx, sy = guiGetScreenSize( )
		if timeMsg and timeMsg ~= "none" then
			dxDrawText ( timeMsg, (sx/2)-250, sy-50, 0, 0, 
				tocolor( 200, 200, 200, 255 ), 0.8, "bankgothic" )
		end
	end
end
addEventHandler( "onClientRender", root, show_time_left )