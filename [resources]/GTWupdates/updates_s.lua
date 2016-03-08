--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Update list cache
txt_cache = ""

-- On receive updates
function result_send(text)
	-- Verify that the player is still online
	if not text then
		outputServerLog("ERROR: GTWupdates: unable to fetch update list")
		return
	end

	-- Format from wiki to MTA text field
	text = string.gsub(text, "'''", "")

	-- Check for real updates
	if txt_cache ~= text then
		-- Store to cache
		txt_cache = text

		-- Pass data back to client
		triggerClientEvent("GTWupdates.respond", root, text)
	end
end

-- Call a local php file (get.php) to fetch update list from remote servers
function onUpdateRequest( )
	callRemote("http://127.0.0.1/mta-mods/get.php", result_send)
end
addEvent("GTWupdates.request", true)
addEventHandler("GTWupdates.request", root, onUpdateRequest)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
