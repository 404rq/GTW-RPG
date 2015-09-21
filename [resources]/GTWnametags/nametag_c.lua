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

-- Render the new nametag
local x,y = guiGetScreenSize()
function update_nametags()
	for k,v in pairs(getElementsByType("player")) do
		if v ~= localPlayer and getPlayerTeam(v) then
			local r,g,b = getTeamColor(getPlayerTeam(v))
			local x1,y1,z1 = getElementPosition(localPlayer)
			local x2,y2,z2 = getElementPosition(v)
			local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
			if visibleto < 10 and getElementData(localPlayer, "isLoggedIn") then
				local sx,sy = getScreenFromWorldPosition(x2,y2,z2+0.4)
				if sx and sy and not getElementData(v, "anon") and getElementInterior(v) == getElementInterior(localPlayer) and
					getElementDimension(v) == getElementDimension(localPlayer) then
					local nWidth = string.len(getPlayerName(v)) or 20
					--dxDrawRectangle( sx-((nWidth*14)/2),sy-7,(nWidth*14),30, tocolor(0,0,0,100))
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx,sy,sx,sy,
						tocolor(0,0,0,200), 0.6, "bankgothic", "center","top",false,false,false )
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx+2,sy+2,sx,sy,
						tocolor(r,g,b,255), 0.6, "bankgothic", "center","top",false,false,false )
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, update_nametags)
