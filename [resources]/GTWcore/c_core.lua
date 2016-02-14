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

-- Trigger the peak on join
triggerServerEvent("GTWcore.onPeakTrigger", root)

--[[ Display current version at screen bottom ]]--
local sx, sy = guiGetScreenSize( )
function show_version_info( )
	dxDrawText(getElementData(root, "gtw-version"), sx-409, sy-13, 0, 0,
		tocolor(40, 40, 40, 255), 1, "clear" )
	dxDrawText(getElementData(root, "gtw-version"), sx-410, sy-14, 0, 0,
		tocolor(180, 180, 180, 220), 1, "clear" )

	-- Local time
	local hours, minutes = getTime()
	if hours < 10 then hours = "0"..hours end
	if minutes < 10 then minutes = "0"..minutes end
	dxDrawText("Game time: "..hours..":"..minutes, 7, sy-33, 0, 0,
		tocolor(0, 0, 0, 255), 0.6, "bankgothic" )
	dxDrawText("Game time: "..hours..":"..minutes, 6, sy-34, 0, 0,
		tocolor(140, 140, 140, 255), 0.6, "bankgothic" )

	-- Display current team and occupation to 2015-07-20
	if not getPlayerTeam(localPlayer) or not getElementData(localPlayer, "Occupation") then return end
	dxDrawText(getTeamName(getPlayerTeam(localPlayer))..": "..getElementData(localPlayer, "Occupation"), 7, sy-19, 0, 0,
		tocolor(0, 0, 0, 255), 0.6, "bankgothic" )
	dxDrawText(getTeamName(getPlayerTeam(localPlayer))..": "..getElementData(localPlayer, "Occupation"), 6, sy-20, 0, 0,
		tocolor(getTeamColor(getPlayerTeam(localPlayer))), 0.6, "bankgothic" )
end
addEventHandler("onClientRender", root, show_version_info)
