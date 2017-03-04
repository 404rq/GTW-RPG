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

local enable_flying_cars = nil
function toggle_flying_cars()
	local is_admin = exports.GTWstaff:isAdmin(localPlayer)
	if is_admin then
	    	if not enable_flying_cars then
	            	enable_flying_cars = true
	            	setWorldSpecialPropertyEnabled("aircars", true)
			exports.GTWtopbar:dm("Flying cars: enabled", 0, 200, 0)
	        else
	            	enable_flying_cars = false
	            	setWorldSpecialPropertyEnabled("aircars", false)
			exports.GTWtopbar:dm("Flying cars: disabled", 0, 200, 0)
	        end
	else
	        exports.GTWtopbar:dm("Only admins can do that!", 200, 0, 0)
	end
end
addCommandHandler("carsfly", toggle_flying_cars)
