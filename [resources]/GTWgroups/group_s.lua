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

-- Global data storage
groups_table = {}
groups_data = {}
users = {}
gang_data = {}
char = "[^0-9a-zA-Z_]"
cache_data = {}

-- Logging and debug info
log = false
show_debug_info = false

-- Database connection setup, MySQL or fallback SQLite
local mysql_host    	= exports.GTWcore:getMySQLHost() or nil
local mysql_database 	= exports.GTWcore:getMySQLDatabase() or nil
local mysql_user    	= exports.GTWcore:getMySQLUser() or nil
local mysql_pass    	= exports.GTWcore:getMySQLPass() or nil
db = dbConnect("mysql", "dbname="..mysql_database..";host="..mysql_host, mysql_user, mysql_pass, "autoreconnect=1")
if not db then db = dbConnect("sqlite", "/groups.db") end

dbExec(db, "CREATE TABLE IF NOT EXISTS groupmember (account TEXT, groupName TEXT, rank TEXT, warningLvl TEXT, joined TEXT, lastTime TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS groups (name TEXT, leader TEXT, message TEXT, chatcolor TEXT, notecolor TEXT, date TEXT, turfcolor TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS groupRanks (groupName TEXT, name TEXT, permissions TEXT)")

permissions_table = {
	[1]="invite",
	[2]="promote",
	[3]="demote",
	[4]="kick",
	[5]="warn",
	[6]="delete",
	[7]="deposit",
	[8]="withdraw",
	[9]="editInfo",
	[10]="viewLog",
	[11]="viewBlacklist",
	[12]="addBlaclist",
	[13]="changeTurfColor",
	[14]="modifyAlliance",
	[15]="modifyRanks",
}

--Some misc functions
_outputDebugString = outputDebugString
function outputDebugString(string)
	if (show_debug_info) then _outputDebugString(string) end
end
function get_time()
    local time = getRealTime()
    local date = string.format("%04d-%02d-%02d", (time.year+1900), (time.month+1), time.monthday )
    local time = string.format("%02d:%02d", time.hour, time.minute )
    return date, time
end

--[[ Helper function for top bar messages ]]--
function output_topbar(message, player, r, g, b, bool)
	if (isElement(message) and getElementType(message) == "player") then
		exports.GTWtopbar:dm(player, message, r, g, b, bool)
	else
		exports.GTWtopbar:dm(message, player, r, g, b, bool)
	end
end

--[[ Helper function for group logs ]]--
function log_group(group, message)
	if (log) then
		outputServerLog("GROUP: "..group.." - "..message)
	end

	if (show_debug_info) then
		outputDebugString("GROUP: "..group.." - "..message)
	end
end

--[[ Helper function to obtain user account ]]--
function account(plr)
	if (plr and isElement(plr)) then
		return getAccountName(getPlayerAccount(plr))
	end
end

--[[ Load group ranks ]]--
function load_ranks(query)
	local the_table = dbPoll(query, -1)
	if (the_table) then
		for ind, data in pairs(the_table) do
			if (not cache_data[data.groupName]) then cache_data[data.groupName] = {} end
			if (not cache_data[data.groupName][data.name]) then cache_data[data.groupName][data.name] = {} end
			local JSONtable = fromJSON(data.permissions)
			for ind, value in pairs(JSONtable) do
				if (value and ind) then
					cache_data[data.groupName][data.name][ind] = true
				end
			end
		end
	end
end
dbQuery(load_ranks, db, "SELECT * FROM groupRanks")

--[[ Load all the group related data into tables ]]--
function load_group_data(query)
	local g_table = dbPoll(query, -1)
	if (not g_table) then return end
	for ind, data in ipairs(g_table) do
		groups_table[data.name] = {data.leader, data.message, data.chatcolor, data.notecolor, data.date, data.turfcolor}
	end
end
dbQuery(load_group_data, db, "SELECT * FROM groups")

--[[ Load group data by accounts ]]--
function load_client_group(query)
	local g_table = dbPoll(query, -1)
	if (not g_table) then return end
	for ind, data in ipairs(g_table) do
		if getAccount(data.account) then
			local player = getAccountPlayer(getAccount(data.account))
			users[data.groupName] = {}
			table.insert(users[data.groupName], data.account)
			if (player) then
				setElementData(player, "Group", data.groupName)
				gang_data[player] = data.groupName
			end
			groups_data[data.account] = {data.groupName, data.rank, data.warningLvl, data.joined, data.lastTime or 0}
		else
			-- Remove group if no members
			dbExec(db, "DELETE FROM groupRanks WHERE groupName=?", tostring(group))
			dbExec(db, "DELETE FROM groups WHERE name=?", tostring(group))
		end
	end
end
dbQuery(load_client_group, db, "SELECT * FROM groupmember")

--[[ Assign group to element data upon login ]]--
function groupMemberLogin()
	if (groups_data[account(source)]) then
		gang_data[source] = groups_data[account(source)][1]
		setElementData(source, "Group", groups_data[account(source)][1])
	end
end
addEventHandler("onPlayerLogin", root, groupMemberLogin)

--[[ Convert RGB to HEX ]]--
function getHexCode(r, g, b)
	if (r and g and b) then
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

--[[ Display a message to members of a certain group ]]--
function outputGroupMessage(message, group)
	for ind, data in pairs(groups_data) do
		if (data[1] == group) then
			local acc = getAccount(ind)
			if (getAccountPlayer(acc)) then
				local color = fromJSON(groups_table[group][3])
				local hex = getHexCode(color[1], color[2], color[3])
				exports.GTWtopbar:dm(hex.."("..group..") #EEEEEE"..message, getAccountPlayer(acc), 255, 255, 255, true)
			end
		end
	end
end

--[[ Attempt to make a group ]]--
function attempt_make_group(name)
	if (isGuestAccount(getPlayerAccount(client))) then return end
	local name = string.gsub(name, char, "")
	if (groups_table[name]) then
		exports.GTWtopbar:dm("There is already a group with this name", client, 255, 0, 0)
		return
	end
	if (#name > 20) then
		exports.GTWtopbar:dm("Max group name is 20 characters", client, 255, 0, 0)
		return
	end
	if (#name < 3) then
		exports.GTWtopbar:dm("Group name length must be longer than 2 characters", client, 255, 0, 0)
		return
	end

	if (not getPlayerGroup(client) or getPlayerGroup(client) == "None" or getPlayerGroup(client) == "nil") then
		local date, time = get_time()
		local date = date.." - "..time
		make_group(name, client, date)
		set_player_group(client, name, date, "Founder")
		exports.GTWtopbar:dm("You have made a group called '"..name.."'", client, 0, 255, 0)
	end
end
addEvent("GTWgroups.attemptMakeGroup", true)
addEventHandler("GTWgroups.attemptMakeGroup", root, attempt_make_group)

--[[ Add a player to group ]]--
function set_player_group(player, group, date, rank)
	if (not users[group]) then
		users[group] = {}
	end
	local date, time = get_time()
	local date = date.." - "..time
	local color = {math.random(255), math.random(255), math.random(255)}
	gang_data[player] = gang
	groups_data[account(player)] = {group, rank, 0, date, 0}
	table.insert(users[group], account(player))
	dbExec(db, "INSERT INTO groupmember VALUES (?, ?, ?, ?, ?, ?)", tostring(account(player)), tostring(group), tostring(rank), "0", date, "0")
	viewWindow(player)
	outputDebugString(getPlayerName(player).." joined group: "..group.." as: "..rank.." at: "..date)
	setElementData(player, "Group", group)
end

--[[ Creates a new group ]]--
function make_group(name, creator, date)
	if (not users[name]) then
		users[name] = {}
	end
	local permissions = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
	local color = {math.random(255), math.random(255), math.random(255)}
	addRank(name, "Founder", toJSON(permissions))
	groups_table[name] = {account(creator), "", toJSON(color), toJSON(color), date, toJSON(color)}
	gang_data[creator] = name
	table.insert(users[name], account(creator))
	dbQuery(load_ranks, db, "SELECT * FROM groupRanks")
	dbExec(db, "INSERT INTO groups VALUES (?, ?, ?, ?, ?, ?, ?)", name, account(creator), "", toJSON(color), toJSON(color), date, toJSON(color))
	outputDebugString(getPlayerName(creator).." created group: "..name.." at: "..date)
end

--[[ Lave the group and remove if empty ]]--
function leave_group(player)
	if (not player) then player = client end
	local group = getPlayerGroup(player)
	if (not group) then return end
	if (getPlayerGroupRank(player) == "Founder") then
		outputGroupMessage(getPlayerName(player).." has decided to delete the group", group)
		for ind, data in pairs(groups_data) do
			if (data[1] == group) then
				if (getAccountPlayer(getAccount(ind))) then
					setElementData(getAccountPlayer(getAccount(ind)), "Group", nil)
				end
				dbExec(db, "DELETE FROM groupmember WHERE account=?", tostring(ind))
				groups_data[ind] = nil
			end
		end
		dbExec(db, "DELETE FROM groupRanks WHERE groupName=?", tostring(group))
		dbExec(db, "DELETE FROM groups WHERE name=?", tostring(group))
		groups_table[group] = nil
		cache_data[group] = nil
	end
	dbExec(db, "DELETE FROM groupmember WHERE account=?", tostring(account(player)))
	groups_data[account(player)] = nil
	viewWindow(player)
	gang_data[player] = nil
end
addEvent("GTWgroups.leaveGroup", true)
addEventHandler("GTWgroups.leaveGroup", root, leave_group)

--[[ Get warning details and send to client ]]--
function print_managment(player)
	if (player) then player = client end
	local group = getPlayerGroup(client)
	for ind, data in pairs(groups_data) do
		if (data[1] == group) then
			local rank, warning, joined, lastTime = groups_data[ind][2], groups_data[ind][3],groups_data[ind][4], groups_data[ind][5]
			triggerClientEvent(client, "GTWgroups.addToList", client, tostring(ind), rank, warning, joined, lastTime, exports.GTWgrouplogs:getLastNick(ind), getAccountPlayer(getAccount(ind)))
		end
	end
end
addEvent("GTWgroups.print", true)
addEventHandler("GTWgroups.print", root, print_managment)

--[[ Invide a player to a group ]]--
function make_invite(player)
	if (getPlayerGroup(player)) then return end
	if (not getPlayerGroup(client)) then return end
	if (not checkGroupAccess(client, 1)) then return end
	local group = getPlayerGroup(client)
	exports.GTWtopbar:dm(getPlayerName(client).." has sent and invite for you to join "..group, player, 0, 255, 0)
	exports.GTWtopbar:dm("Sent an invite to "..getPlayerName(player).." to join "..group, client, 0, 255, 0)
	triggerClientEvent(player, "GTWgroups.addInviteToList", player, group, getPlayerName(client), time)
end
addEvent("GTWgroups.makeInvite", true)
addEventHandler("GTWgroups.makeInvite", root, make_invite)

--[[ On client accept invite ]]--
function accept_invite(group)
	if (not groups_table[group]) then
		exports.GTWtopbar:dm(tostring(group).." does no longer exist", client, 255, 0, 0)
		return
	end
	set_player_group(client, group, _, "Trial")
	outputGroupMessage(getPlayerName(client).." has joined the group", group)
end
addEvent("GTWgroups.acceptInvite", true)
addEventHandler("GTWgroups.acceptInvite", root, accept_invite)

--[[ List all groups and send to client GUI ]]--
function get_list_of_groups()
	local count = {}
	for ind, data in pairs(groups_table) do
		for ind2, data2 in pairs(groups_data) do
			if (data2[1] == ind) then
				if (not count[ind]) then count[ind] = 0 end
				count[ind] = count[ind] + 1
			end
		end
		if count[ind] == 0 then
			-- Cleanup old groups without members
			dbExec(db, "DELETE FROM groups WHERE name=?", tostring(ind))
			dbExec(db, "DELETE FROM groupRanks WHERE groupName=?", tostring(ind))
		end
	end
	triggerClientEvent(client, "GTWgroups.addGroupList", client, groups_table, count)
end
addEvent("GTWgroups.addGroupListServer", true)
addEventHandler("GTWgroups.addGroupListServer", root, get_list_of_groups)

--[[ Issue a warning to account ]]--
function warn_account(account, lvl, reason)
	local online = getAccountPlayer(getAccount(account))
	local group = getPlayerGroup(client)
	if (not checkGroupAccess(client, 5)) then return end
	if (not groups_data[account] or not groups_data[account][3]) then return end
	local mine = getPermissionCount(group, getPlayerGroupRank(client))
	local his = getPermissionCount(group, groups_data[account][2])
	if (getAccountName(getPlayerAccount(client)) == account and mine <= 14) then return end
	if (tonumber(mine) <= tonumber(his) and getAccountName(getPlayerAccount(client)) ~= account) then
		exports.GTWtopbar:dm("You cannot warn this account because it has more permissions attributes than yours", client, 255, 0, 0)
		return
	end

	if (tonumber(groups_data[account][3] + lvl) < 1) then
		add = 0
	elseif (tonumber(groups_data[account][3] + lvl) >= 100) then
		if (not checkGroupAccess(client, 4)) then return end
		if (account == getAccountName(getPlayerAccount(client))) then exports.GTWtopbar:dm("You can not kick yourself", client, 255, 0, 0) return end
		kickAccount(account)
		outputGroupMessage("Account: "..account.." has been kicked by "..getPlayerName(client).." ("..reason..")", group)
		log_group(group, "Account: "..account.." has been kicked by "..getPlayerName(client).." ("..reason..")", group)
		exports.GTWgrouplogs:logSomething(group, "Account: "..account.." has been kicked by "..getPlayerName(client).." ("..reason..")", group)
		return
	else
		add = groups_data[account][3] + lvl
	end

	if (online) then
		outputGroupMessage(getPlayerName(online).." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")", group)
		log_group(group, getPlayerName(online).." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")")
		exports.GTWgrouplogs:logSomething(group, getPlayerName(online).." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")")
	else
		exports.GTWgrouplogs:logSomething(group, "Account: "..account.." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")")
		log_group(group, "Account: "..account.." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")")
		outputGroupMessage("Account: "..account.." has been warned by "..getPlayerName(client).." ("..lvl.." ("..reason..") Total: "..add..")", group)
	end

	groups_data[account][3] = add
	dbExec(db, "UPDATE groupmember SET warningLvl=? WHERE account=?", tostring(add), tostring(account))
	viewWindow(client)
end
addEvent("GTWgroups.warnAccount", true)
addEventHandler("GTWgroups.warnAccount", root, warn_account)

--[[ Display group logs ]]--
function showLog()
	local group = getPlayerGroup(client)
	if (not group) then return end
	if (not checkGroupAccess(client, 10)) then return end
	exports.GTWgrouplogs:viewLog(client, group)
end
addEvent("GTWgroups.showLog", true)
addEventHandler("GTWgroups.showLog", root, showLog)

--[[ Get ranks and send to client ]]--
function show_ranks()
	if (not checkGroupAccess(client, 15)) then return end
	local group = getPlayerGroup(client)
	triggerClientEvent(client, "GTWgroups.doneWithRanks", client, cache_data[group] or {})
end
addEvent("GTWgroups.showRanks", true)
addEventHandler("GTWgroups.showRanks", root, show_ranks)

--[[ Add a new custom rank ]]--
function add_rank(name, selected)
	if (not checkGroupAccess(client, 15)) then return end
	local group = getElementData(client, "Group")
	if (not group) then return end
	local permissions = {false, false, false, false, false, false, false, false, false, false, false, false, false, false}
	addRank(group, name, toJSON(permissions))
	exports.GTWtopbar:dm("Added the rank "..name.." successfully", client, 0, 255, 0)
	triggerClientEvent(client, "GTWgroups.doneWithRanks", client, cache_data[group] or {}, name)
end
addEvent("GTWgroups.addTheRank", true)
addEventHandler("GTWgroups.addTheRank", root, add_rank)

--[[ Edit custom rank ]]--
function edit_rank(name, newPerm)
	if (not checkGroupAccess(client, 15)) then return end
	local group = getPlayerGroup(client)
	if (isRank(group, name)) then
		removeRank(group, name)
	else
		return
	end
	addRank(group, name, toJSON(newPerm))
	exports.GTWtopbar:dm("Edited permissions for rank '"..name.."'", client, 0, 255, 0)
	log_group(group, getPlayerName(client).." edited permissions for rank '"..name.."'")
	exports.GTWgrouplogs:logSomething(group, getPlayerName(client).." edited permission for rank'"..name.."'")
end
addEvent("GTWgroups.editRank", true)
addEventHandler("GTWgroups.editRank", root, edit_rank)

--[[ Delete custom rank ]]--
function delete_rank(rank)
	if (not checkGroupAccess(client, 15)) then return end
	local group = getPlayerGroup(client)
	if (getGroupRankCount(group) == 1) then
		exports.GTWtopbar:dm("Cannot delete the only rank you have", client, 255, 0, 0)
		return
	end
	if (isRank(group, rank)) then
		removeRank(group, rank)
	else
		return
	end
	outputGroupMessage(getPlayerName(client).." deleted the rank: "..rank)
	log_group(group, getPlayerName(client).." deleted the rank: "..rank)
	exports.GTWgrouplogs:logSomething(group, getPlayerName(client).." deleted the rank: "..rank)
	triggerClientEvent(client, "GTWgroups.doneWithRanks", client, cache_data[group] or {})
end
addEvent("GTWgroups.deleteRank", true)
addEventHandler("GTWgroups.deleteRank", root, delete_rank)

--[[ Get player ranks and display to client in GUI ]]--
function list_player_ranks()
	if (checkGroupAccess(client, 4) or checkGroupAccess(client, 5)) then
		local group = getPlayerGroup(client)
		triggerClientEvent(client, "GTWgroups.printTheRanks", client, cache_data[group] or {})
	end
end
addEvent("GTWgroups.printTheRanks", true)
addEventHandler("GTWgroups.printTheRanks", root, list_player_ranks)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Aet a rank for an account ]]--
function set_account_rank(rank, account)
	if (not account or not getAccount(account)) then
		exports.GTWtopbar:dm("No account was selected from the list", client, 255, 0, 0)
		return
	end
	--if (getAccountName(getPlayerAccount(client)) == account) then return end
	local group = getPlayerGroup(client)
	local mine = getPermissionCount(group, getPlayerGroupRank(client))
	local his = getPermissionCount(group, rank)
	if (not cache_data[group] or cache_data[group] and not cache_data[group][rank]) then
		exports.GTWtopbar:dm("This rank ("..tostring(rank)..") was not found in your group", client, 255, 0, 0)
		return
	end
	local online = getAccountPlayer(getAccount(account))
	if (not checkGroupAccess(client, 15)) then return end
	if (tonumber(his) > tonumber(mine)) then
		exports.GTWtopbar:dm("You cannot set the rank of this account because it has more permissions attributes than yours", client, 255, 0, 0)
		return
	end
	if (getAccountGroupRank(account) == "Founder") then
		exports.GTWtopbar:dm("You cannot change the rank of your groups founder", client, 255, 0, 0)
		return
	end
	if (not groups_data[account]) then return end
	if (groups_data[account][1] ~= group) then return end
	if (groups_data[account][2] == rank) then
		exports.GTWtopbar:dm("This account already has the rank "..rank, client, 255, 0, 0)
		return
	end
	if (online) then
		outputGroupMessage(getPlayerName(client).." has set "..getPlayerName(online).."'s rank to: "..rank, group)
		log_group(group, getPlayerName(client).." has set "..getPlayerName(online).."'s rank to: "..rank)
		exports.GTWgrouplogs:logSomething(group, getPlayerName(client).." has set "..getPlayerName(online).."'s rank to: "..rank)
	else
		log_group(group, getPlayerName(client).." has set account: "..account.."'s rank to: "..rank)
		outputGroupMessage(getPlayerName(client).." has set account: "..account.."'s rank to: "..rank, group)
		exports.GTWgrouplogs:logSomething(group, getPlayerName(client).." has set account: "..account.."'s rank to: "..rank)
	end
	dbExec(db, "UPDATE groupmember SET rank=? WHERE account=?", tostring(rank), tostring(account))
	exports.GTWtopbar:dm("You have set the rank of account "..account.." to "..rank, client, 0, 255, 0)
	groups_data[account][2] = rank
end
addEvent("GTWgroups.setTheRank", true)
addEventHandler("GTWgroups.setTheRank", root, set_account_rank)

--[[ Sync element data across group ]]--
function set_group_element_data()
	for ind, plr in pairs(getElementsByType("player")) do
		if (not groups_data[account(plr)]) then
			setElementData(plr, "Group", false)
		end
	end
end
setTimer(set_group_element_data, 2500, 0)
