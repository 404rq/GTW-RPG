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

function hpm(message, thePlayer, red, green, blue, colorCoded)
	if colorCoded == nil then
		colorCoded = false
	end		
	if isElement(thePlayer) then
		triggerClientEvent(thePlayer, "GTWhelp.onTextAdd", root, message, red, green, blue, colorCoded)
	end
end