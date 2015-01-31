--[[ 
********************************************************************************
Project owner:	GTWGames												
Project name:	GTW-RPG	
Developers: 	GTWCode
	
Source code:	https://github.com/GTWCode/GTW-RPG/
Suggestions:	http://forum.albonius.com/mta-servers-development/
Bugtracker: 	http://forum.albonius.com/bug-reports/
	
Version:		Open source
License:		GPL v.3 or later
Status: 		Stable release
********************************************************************************
]]--

-- 36 areas 1000x1000 metres starting from Bayside 
-- marina to the east then 1 step south and continues.
area_data = {
	[1]={{5,6,7,8,9},{17,18,19},{17,18,19},{17,18,19},{10,11,12},{10,11,12}},
	[2]={{5,6,7,8,9},{17,18,19},{17,18,19},{17,18,19},{10,11,12},{10,11,12}},
	[3]={{5,6,7,8,9},{5,6,7,8,9},{17,18,19},{17,18,19},{10,11,12},{10,11,12}},
	[4]={{5,6,7,8,9},{5,6,7,8,9},{13,14,15,16},{13,14,15,16},{13,14,15,16},{13,14,15,16}},
	[5]={{5,6,7,8,9},{13,14,15,16},{13,14,15,16},{0,1,2,3,4},{0,1,2,3,4},{0,1,2,3,4}},
	[6]={{13,14,15,16},{13,14,15,16},{13,14,15,16},{13,14,15,16},{0,1,2,3,4},{0,1,2,3,4}},
}

-- Return weather in my zoone
function getWeatherInMyZone()
	local x,y,z = getElementPosition(client)
	x,y,z = math.floor((x+3)/1000),math.floor((y+3)/1000),math.floor((z+3)/1000)
	local counter = 1
	for i=1, 6 do
		for j=1, 6 do
			if x == i and y == j then break end
			counter = counter + 1
		end
	end
	triggerClientEvent(client, "GTWweather.onWeatherReturn", client, (current_weather[counter] or 0), counter)
end
addEvent("GTWweather.onAskForWeather", true)
addEventHandler("GTWweather.onAskForWeather", resourceRoot, getWeatherInMyZone)

-- Keep track of the local weather
current_weather = { }
function chWeather( )
	for i=1, 6 do
		for k,v in pairs(area_data[i]) do
			local new_weather = v[math.random(#v)]
			table.insert(current_weather, new_weather)
		end
	end
end

-- Initialize and update each hour
chWeather()
setTimer(chWeather,3600*1000,0)