--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

-- On receive updates
function result(str_result, plr)
	local text = str_result
	plr = getPlayerFromName(plr)

	-- Verify that the player is still online
	if not plr then return end

	-- Format from wiki to MTA text field
	text = string.gsub(text,"'''", "")

	-- Pass data back to client
	triggerClientEvent(plr, "GTWupdates.respond", plr, text)
end

-- Call remote server II to receive latest GTW updates
function onUpdateRequest( )
	callRemote( "http://gs.gtw-games.org:81/updates/get.php", result, getPlayerName(client))
end
addEvent("GTWupdates.request", true)
addEventHandler("GTWupdates.request", resourceRoot, onUpdateRequest)
