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
				local sx,sy = getScreenFromWorldPosition(x2,y2,z2+0.3)
				local sx1,sy1 = getScreenFromWorldPosition(x2,y2,z2+0.45)
				if sx and sy and not getElementData(v, "anon") and getElementInterior(v) == getElementInterior(localPlayer) and
					getElementDimension(v) == getElementDimension(localPlayer) then
					--local nWidth = string.len(getPlayerName(v)) or 20
					--dxDrawRectangle( sx-((nWidth*14)/2),sy-7,(nWidth*14),30, tocolor(0,0,0,100))
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx,sy,sx,sy,
						tocolor(0,0,0,255), 0.4, "bankgothic", "center","top",false,false,false )
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx+2,sy+2,sx,sy,
						tocolor(r,g,b,255), 0.4, "bankgothic", "center","top",false,false,false )

					-- Staff tag
					local is_staff = exports.GTWstaff:isStaff(v)
					if is_staff then
						if sx1 and sy1 and sx1 and sy1 then
							dxDrawText("[404rq]", sx1,sy1,sx1,sy1,tocolor(0,0,0,255), 0.4, "bankgothic", "center","top",false,false,false)
							dxDrawText("[404rq]", sx1+2,sy1+2,sx1,sy1,tocolor(255,255,255,255), 0.4, "bankgothic", "center","top",false,false,false)
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, update_nametags)
