--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

spam = {}
function checkSpam(cmd)
	if not (spam[source]) then
		spam[source] = 1
	elseif (spam[source] == 10) then
		cancelEvent()
		exports.GTWtopbar:dm("Do not spam commands!",source,255,0,0)
	else
		spam[source] = spam[source] + 1
	end
	--outputServerLog(getPlayerName(source).." issued the server command: '"..cmd.."'")
end
addEventHandler("onPlayerCommand",root,checkSpam)
setTimer(function() spam = {} end, 5000, 0)