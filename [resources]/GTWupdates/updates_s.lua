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

-- Update list cache
local txt_cache = ""

-- On receive updates
function result(str_result, plr)
	local text = str_result
	plr = getPlayerFromName(plr)

	-- Verify that the player is still online
	if not plr then return end

	-- Format from wiki to MTA text field
	text = string.gsub(text, "'''", "")

	-- Check for real updates
	if txt_cache ~= text then
		-- Pass data back to client
		triggerClientEvent(plr, "GTWupdates.respond", plr, text)

		-- Store to cache
		txt_cache = text
	end
end

-- Call remote server II to receive latest GTW updates
function onUpdateRequest( )
	callRemote( "http://404rq.com/update-list/get.php", result, getPlayerName(client))
end
addEvent("GTWupdates.request", true)
addEventHandler("GTWupdates.request", resourceRoot, onUpdateRequest)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
