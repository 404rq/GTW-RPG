--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Sebbe (smart), Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Get the chat color of a group ]]--
function getGroupChatColor(group)
	if (not groups_table[group]) then return 255, 255, 255 end
	local color = fromJSON(groups_table[group][3])
	if (not color) then return 255, 255, 255 end
	return tonumber(color[1]), tonumber(color[2]), tonumber(color[3])
end

--[[ Get the turf color of a group ]]--
function getGroupTurfColor(group)
	if (not groups_table[group]) then return 255, 255, 255 end
	local color = fromJSON(groups_table[group][6])
	if (not color) then return 0, 0, 0 end
	return tonumber(color[1]), tonumber(color[2]), tonumber(color[3])
end

--[[ Change group color ]]--
function change_group_color(plr, cmd, re, gr, bl)
	local r, g, b = re or 255, gr or 255, bl or 255
	local group = getPlayerGroup(plr)
	if (not group) then return end
	if (not checkGroupAccess(plr, 13)) then return end
	if (not groups_table[group]) then return end
	local color = {r, g, b}
	dbExec(db, "UPDATE groups SET chatcolor=? WHERE name=?", toJSON(color), group)
	groups_table[group][3] = toJSON(color)
	exports.GTWtopbar:dm("Group colour changed to R: "..r.." G: "..g.." B: "..b, plr, r, g, b)
	log_group(group, getPlayerName(plr).." has set chat color to: "..r..", "..g..", "..b)
	exports.GTWgrouplogs:logSomething(group, getPlayerName(plr).." has set chat color to: "..r..", "..g..", "..b)
end
addCommandHandler("chatcolor", change_group_color)

--[[ Change turf color ]]--
function change_turf_color(plr, cmd, re, gr, bl)
	local r, g, b = re or 255, gr or 255, bl or 255
	local group = getPlayerGroup(plr)
	if (not group) then return end
	if (not checkGroupAccess(plr, 13)) then return end
	if (not groups_table[group]) then return end
	local color = {r, g, b}
	dbExec(db, "UPDATE groups SET turfcolor=? WHERE name=?", toJSON(color), group)
	groups_table[group][6] = toJSON(color)
	exports.GTWtopbar:dm("Turf colour changed to R: "..r.." G: "..g.." B: "..b, plr, r, g, b)
	log_group(group, getPlayerName(plr).." has set turf color to: "..r..", "..g..", "..b)
	exports.GTWgrouplogs:logSomething(group, getPlayerName(plr).." has set turf color to: "..r..", "..g..", "..b)
end
addCommandHandler("turfcolor", change_turf_color)
