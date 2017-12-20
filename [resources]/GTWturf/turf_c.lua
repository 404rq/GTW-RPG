--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Time before a player capture the turf
function show_time_left( )
	if getElementData( localPlayer, "isInTurf" ) and not getElementData( localPlayer, "isInFriendlyTurf" ) and not isPlayerMapVisible( ) then
		local timeMsg = getElementData( localPlayer, "captureTime" )
		local sx, sy = guiGetScreenSize( )
		if timeMsg and timeMsg ~= "none" then
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
addEventHandler( "onClientRender", root, show_time_left )
