--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

local current_zone,new_zone = 0,1
function onWeatherReturn( weather, zoone )
	setWeather(weather)
	current_zone = zoone
end
addEvent("GTWweather.onWeatherReturn", true)
addEventHandler("GTWweather.onWeatherReturn", localPlayer, onWeatherReturn)

function askForWeather()
	local x,y,z = getElementPosition(localPlayer)
	x,y,z = math.floor((x+3)/1000),math.floor((y+3)/1000),math.floor((z+3)/1000)
	local z_counter = 1
	for i=1, 6 do
		for j=1, 6 do
			if x == i and y == j then new_zone = z_counter break end
			z_counter = z_counter + 1
		end
	end
	if new_zone ~= current_zone then
		triggerServerEvent("GTWweather.onAskForWeather", resourceRoot, current_weather)
	end
end

-- Initialize and update each
askForWeather()
setTimer(askForWeather, 1000, 0)