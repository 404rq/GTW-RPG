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

-- Render the new nametag
local x,y = guiGetScreenSize()
function update_nametags()
	for k,v in pairs(getElementsByType("player")) do
		if localPlayer ~= v and getPlayerTeam(v) then
			local r,g,b = getTeamColor(getPlayerTeam(v))
			local x1,y1,z1 = getElementPosition(localPlayer)
			local x2,y2,z2 = getElementPosition(v)
			local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
			if visibleto < 8 and getElementData(localPlayer, "isLoggedIn") then
				local sx,sy = getScreenFromWorldPosition(x2,y2,z2+0.25)
				local sx1,sy1 = getScreenFromWorldPosition(x2,y2,z2+0.35)
				if sx and sy and not getElementData(v, "anon") and getElementInterior(v) == getElementInterior(localPlayer) and
					getElementDimension(v) == getElementDimension(localPlayer) then
					--local nWidth = string.len(getPlayerName(v)) or 20
					--dxDrawRectangle( sx-((nWidth*14)/2),sy-7,(nWidth*14),30, tocolor(0,0,0,100))
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx,sy,sx,sy,
						tocolor(0,0,0,135), 0.4, "bankgothic", "center","top",false,false,false )
					dxDrawText( string.gsub( getPlayerName(v), "#%x%x%x%x%x%x", "" ).."", sx+2,sy+2,sx,sy,
						tocolor(r,g,b,80), 0.4, "bankgothic", "center","top",false,false,false )

					-- Staff tag
					local is_staff = exports.GTWstaff:isStaff(v)
					if is_staff then
						if sx1 and sy1 and sx1 and sy1 then
							dxDrawText("[STAFF]", sx1,sy1,sx1,sy1,tocolor(0,0,0,135), 0.4, "bankgothic", "center","top",false,false,false)
							dxDrawText("[STAFF]", sx1+2,sy1+2,sx1,sy1,tocolor(255,255,255,80), 0.4, "bankgothic", "center","top",false,false,false)
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, update_nametags)
