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

-- Table to count spam by commands
spam 	= { }
limit 	= 15
range 	= 5000

-- Ignore any command issued after limit has passed within range
function check_for_spam(cmd)
	if not spam[source] then
		spam[source] = 1
	elseif spam[source] == limit then
		exports.GTWtopbar:dm("Do not spam commands!",source,255,0,0)
		cancelEvent()
	else
		spam[source] = spam[source] + 1
	end

	-- Uncomment to track commands issued by players
	--outputServerLog(getPlayerName(source).." issued the server command: '"..cmd.."'")
end
addEventHandler("onPlayerCommand", root, check_for_spam)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

-- Reset spam tracker table each [range] ms.
setTimer(function() spam = {} end, range, 0)
