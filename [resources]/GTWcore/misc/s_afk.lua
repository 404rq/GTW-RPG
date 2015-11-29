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

-- List of AFK players
is_afk = { }

--[[ Toggle afk mode ]]--
function go_afk(plr)
	if not is_afk[plr] and getPlayerWantedLevel(plr) == 0 then
		local old_dim = getElementDimension(plr)
		setElementDimension(plr, math.random(1000,2000))
		setElementFrozen(plr, true)
		is_afk[plr] = old_dim
		exports.GTWtopbar:dm(getPlayerName(plr).." is now AFK", root, 255, 100, 0)
		bindKey(plr, "W", "down", "afk")
		setPlayerName(plr, getPlayerName(plr).."_AFK")
		outputChatBox("The _AFK tag has been added to your name, remember to remove it.", plr, 200, 200, 200)
		outputServerLog(getPlayerName(plr).." is now AFK")
	elseif is_afk[plr] then
		setElementDimension(plr, is_afk[plr])
		setElementFrozen(plr, false)
		is_afk[plr] = nil
		exports.GTWtopbar:dm(getPlayerName(plr).." is now back in game", root, 255, 100, 0)
		unbindKey(plr, "W", "down", "afk")
		setPlayerName(plr, string.gsub(getPlayerName(plr), "_AFK", ""))
		outputServerLog(getPlayerName(plr).." is now back in game")
	elseif getPlayerWantedLevel(plr) > 0 then
		exports.GTWtopbar:dm("AFK: You can not go AFK while being wanted!", plr, 255, 0, 0)
	end
end
addCommandHandler("afk", go_afk)
