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
triggerServerEvent("onPeakTrigger", root)

--[[ Quick cheat hack ]]--
blip = { }
function markPlayer(cmd, plr)
	local target = getPlayerFromName(plr)
	if not isElement(target) then return end
	blip[plr] = createBlipAttachedTo( target, 23, 2, 0, 0, 0, 255, 0, 99999, localPlayer)
end
addCommandHandler("mark", markPlayer)
function markPlayer(cmd, plr)
	if isElement(blip[plr]) then
		destroyElement(blip[plr])
	end
end
addCommandHandler("unmark", markPlayer)
function onQuitGame( reason )
    local name = getPlayerName(source)
    if isElement(blip[name]) then
		destroyElement(blip[name])
	end
end
addEventHandler( "onClientPlayerQuit", root, onQuitGame )

-- Set version and name information
local sx, sy = guiGetScreenSize( )
--local lbl_info = guiCreateLabel(sx-400, sy-16, 300, 16, getElementData(root, "gtw-version"), false)
function show_version_info( )
	dxDrawText(getElementData(root, "gtw-version"), sx-409, sy-13, 0, 0,
		tocolor( 40, 40, 40, 255 ), 1, "clear" )
	dxDrawText(getElementData(root, "gtw-version"), sx-410, sy-14, 0, 0,
		tocolor( 180, 180, 180, 220 ), 1, "clear" )

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
