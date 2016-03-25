--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

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
		exports.GTWtopbar:dm(txt[getElementData(source, "GTWcore.language") or r_lang]["msg_no_spam"], source, 255,0,0)
		cancelEvent()
	else
		spam[source] = spam[source] + 1
	end

	-- Uncomment to track commands issued by players
	--outputServerLog(getPlayerName(source)..txt[r_lang]["log_cmd_issuer"]..cmd.."'")
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
