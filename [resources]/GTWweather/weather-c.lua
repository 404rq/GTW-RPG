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

function set_rainy() 
	setWeather (8) 
end 
addCommandHandler("rainy", set_rainy) 
addCommandHandler("rain", set_rainy)

function set_foggy() 
   	setWeather (9) 
end
addCommandHandler("foggy", set_foggy)
addCommandHandler("fog", set_foggy)

function set_sunny() 
	setWeather (0) 
end 
addCommandHandler("sunny", set_sunny) 
addCommandHandler("sun", set_sunny)