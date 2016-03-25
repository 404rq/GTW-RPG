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

--[[ Show how much minerals an ironminer has ]]--
function show_minerals_info( )
	if getElementData( localPlayer, "Occupation" ) == "Iron miner" then
		local mineral_string = "Minerals: Pt: "..(getElementData(localPlayer, "GTWironminer.platinum") or 0)..
    		" | Au: "..(getElementData(localPlayer, "GTWironminer.gold") or 0)..
    		" | Ag: "..(getElementData(localPlayer, "GTWironminer.silver") or 0)..
    		" | Fe: "..(getElementData(localPlayer, "GTWironminer.iron") or 0)..
    		" | Cu: "..(getElementData(localPlayer, "GTWironminer.cupper") or 0)..
    		" | $"..math.floor(getElementData(localPlayer, "GTWironminer.profit") or 0)
		local sx, sy = guiGetScreenSize( )
		dxDrawText(mineral_string, (sx/2)-278, sy-28, 0, 0,
			tocolor(0, 0, 0, 255 ), 0.7, "bankgothic" )
		dxDrawText(mineral_string, (sx/2)-280, sy-30, 0, 0,
			tocolor(200, 200, 200, 255 ), 0.7, "bankgothic" )
	end
end
addEventHandler("onClientRender", root, show_minerals_info)

--[[ Update a value determining if a player is on the ground ]]--
local is_on_ground,old_check = false,true
function is_player_on_the_ground( )
	local px, py, pz = getElementPosition(localPlayer)
	--outputConsole(getGroundPosition(px, py, pz + 10).." "..pz.." "..(getGroundPosition(px, py, pz + 10) + 2))
	if getGroundPosition(px, py, pz + 10) < pz and (getGroundPosition(px, py, pz + 10) + 2) > pz then
		is_on_ground = true
	else
		is_on_ground = false
	end

	if is_on_ground ~= old_check then
		setElementData(localPlayer, "isOnGround", is_on_ground)
		old_check = is_on_ground
	end
end

--[[ Start checking if a player is on the ground ]]--
is_player_on_the_ground()
setTimer(is_player_on_the_ground, 3000, 0)
