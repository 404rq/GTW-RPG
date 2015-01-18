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

-- On receive updates
function result(str_result, plr)
	local text = str_result
	plr = getPlayerFromName(plr)
	
	-- Format from wiki to MTA text field
	text = string.gsub(text,"'''", "")
	
	-- Pass data back to client
	triggerClientEvent(plr, "GTWupdates.respond", plr, text)
end

-- Call remote server II to receive latest GTW updates
function onUpdateRequest( )	
	callRemote( "http://s2.albonius.com/mta-mods/get.php", result, getPlayerName(client))
end
addEvent("GTWupdates.request", true)
addEventHandler("GTWupdates.request", resourceRoot, onUpdateRequest)