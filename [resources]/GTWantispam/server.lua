--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.gtw-games.org/bug-reports/
	Suggestions:		http://forum.gtw-games.org/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

spam = {}
function checkSpam(cmd)
	if not (spam[source]) then
		spam[source] = 1
	elseif (spam[source] == 20) then
		cancelEvent()
		exports.GTWtopbar:dm("Do not spam commands!",source,255,0,0)
	else
		spam[source] = spam[source] + 1
	end
	--outputServerLog(getPlayerName(source).." issued the server command: '"..cmd.."'")
end
addEventHandler("onPlayerCommand",root,checkSpam)
setTimer(function() spam = {} end, 5000, 0)