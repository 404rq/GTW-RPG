--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Enable/disable 2D view
local view_2D = false
local dummy_object = nil
local zoom = 50

sx,sy = guiGetScreenSize()
--[[ Render 2D view if enabled ]]--
function update_2d_view()
	if not view_2D then return end
        local x,y,z = getElementPosition(localPlayer)
        local dx,dy,dz = getElementPosition(dummy_object)
	setCameraMatrix(x,y,z + zoom, dx,dy,dz)
end

--[[ Manage zoom ]]--
function manage_zoom(up_down)
        if up_down == 1 and zoom < 70 then zoom = zoom + up_down
        elseif zoom > 10 then zoom = zoom - up_down end
end
addEventHandler("onClientMouseWheel", root, manage_zoom)

--[[ Toggle 2D view ]]--
function toggle_2d(plr)
        view_2D = not view_2D
        if not view_2D then
                setCameraTarget(localPlayer)
                removeEventHandler("onClientPreRender", root, update_2d_view)
                detachElements(dummy_object)
                destroyElement(dummy_object)
        else
                addEventHandler("onClientPreRender", root, update_2d_view)
                dummy_object = createMarker(0,0,0, "cylinder", 0.1, 0,0,0, 0)
                attachElements(dummy_object, localPlayer, 0, 1, 0)
        end
end
addCommandHandler("2d", toggle_2d)
addCommandHandler("toggle2d", toggle_2d)
