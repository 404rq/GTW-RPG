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