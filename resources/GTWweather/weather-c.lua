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

function rainymood()
    setWeather (8)
end
addCommandHandler("rain", rainymood)

function foggymood()
   	setWeather (9)
end
addCommandHandler("foggy", foggymood)

function sunnymood()
   	setWeather (0)
end
addCommandHandler("sunny", sunnymood)