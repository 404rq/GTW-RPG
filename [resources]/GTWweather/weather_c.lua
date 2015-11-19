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

-- Set rain
function set_rainy()
	setWeather(8)
end
addCommandHandler("rainy", set_rainy)
addCommandHandler("rain", set_rainy)

-- Set foggy
function set_foggy()
   	setWeather(9)
end
addCommandHandler("foggy", set_foggy)
addCommandHandler("fog", set_foggy)

-- Set sunny
function set_sunny()
	setWeather(0)
end
addCommandHandler("sunny", set_sunny)
addCommandHandler("sun", set_sunny)
