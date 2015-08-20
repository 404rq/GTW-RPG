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

--[[ Adds a custom rank ]]--
function addRank(group, rank, permissionTable)
	if (not cache_data[group]) then cache_data[group] = {} end
	--cache_data[group][rank] = {fromJSON(permissionTable)}
	dbExec(db, "INSERT INTO groupRanks VALUES (?, ?, ?)", tostring(group), tostring(rank), permissionTable)
	dbQuery(load_ranks, db, "SELECT * FROM groupRanks")
end

--[[ Removes a custom rank ]]--
function removeRank(group, rank)
	if (not cache_data[group]) then return true end
	if (cache_data[group][rank]) then
		cache_data[group][rank] = nil
		dbExec(db, "DELETE FROM groupRanks WHERE name=? AND groupName=?", tostring(rank), tostring(group))
		dbQuery(load_ranks, db, "SELECT * FROM groupRanks")
		return true
	end
end

--[[ Check if a rank exist ]]--
function isRank(group, rank)
	if (not cache_data[group]) then return false end
	return cache_data[group][rank]
end

--[[ List all the group memebers ]]--
function getGroupMembers(group)
	local temp = {}
	for ind, data in pairs(users) do
		if (ind == group) then
			table.insert(temp, data[1])
		end
	end
	return temp
end

--[[ Get the group of which the player are a member of ]]--
function getPlayerGroup(player)
	if (not groups_data[account(player)]) then return false end
	return groups_data[account(player)][1]
end

--[[ Get the rank a player has in his current group ]]--
function getPlayerGroupRank(player)
	if (not groups_data[account(player)]) then return false end
	return groups_data[account(player)][2]
end
function getAccountGroupRank(acc)
	if (not groups_data[acc]) then return false end
	return groups_data[acc][2]
end

--[[ Get warning level for a specific player ]]--
function getPlayerWarningLevel(player)
	if (not groups_data[account(player)]) then return false end
	return groups_data[account(player)][3]
end

--[[ Get the date and time a player joined a group ]]--
function getPlayerJoinDate(player)
	if (not groups_data[account(player)]) then return false end
	return groups_data[account(player)][4]
end

--[[ Check if a player has access to a certain action within his group ]]--
function checkGroupAccess(player, actionID)
	local rank = getPlayerGroupRank(player)
	local group = getPlayerGroup(player)
	if (not cache_data[group]) then return false end
	if (cache_data[group] and cache_data[group][rank]) then
		if (tostring(actionID)) then
			for ind, data in pairs(permissions_table) do
				if (data == actionID) then
					actionID = ind
					break
				end
			end
		end
		local actionID = tonumber(actionID)
		if (cache_data[group][rank][actionID]) then
			return true
		end
	end
end

--[[ Count permissions for a certain group ]]--
function getPermissionCount(group, rank)
	if (not cache_data[group]) then return false end
	local count = 0
	if (cache_data[group] and cache_data[group][rank]) then
		for ind, data in pairs(cache_data[group][rank]) do
			count = count + 1
		end
	end
	return count
end

--[[ Count ranks within a group ]]--
function getGroupRankCount(group)
	if (not cache_data[group]) then return end
	local count = 0
	for ind, v in pairs(cache_data[group]) do
		count = count + 1
	end
	return tonumber(count) or 1
end

--[[ Send information to client window ]]--
function viewWindow(player)
	if (player) then client = player end
	local group = getPlayerGroup(client)
	local rank = getPlayerGroupRank(client)
	local dateJoined = getPlayerJoinDate(client)
	local permRank = false
	local msg = ""
	if (group and group ~= "none" and groups_table[group] and groups_table[group][2]) then
		msg = groups_table[group][2]
	end
	if (group and rank and cache_data[group] and cache_data[group][rank]) then
		permRank = cache_data[group][rank]
	end
	triggerClientEvent(client, "GTWgroups.done", client, group, rank, dateJoined, msg, permRank)
end
addEvent("GTWgroups.viewWindow", true)
addEventHandler("GTWgroups.viewWindow", root, viewWindow)

--[[ Kick from group by account ]]--
function kickAccount(account)
	if getAccountGroupRank(account) ~= "Founder" then
		dbExec(db, "DELETE FROM groupmember WHERE account=?", tostring(account))
		groups_data[account] = nil

		local plr = getAccountPlayer(getAccount(account))
		if (plr) then
			gang_data[plr] = nil
			viewWindow(plr)
		end
	end
end

--[[ Update group information ]]--
function updateMessage(message)
	local group = getPlayerGroup(client)
	if (not groups_table[group]) then exports.GTWtopbar:dm "1" return end
	if (not checkGroupAccess(client, 9)) then exports.GTWtopbar:dm "2" return end
	groups_table[group][2] = message
	viewWindow(client)
	dbExec(db, "UPDATE groups SET message=? WHERE name=?", tostring(message), tostring(group))
	outputGroupMessage(getPlayerName(client).." has updated the group info", group)
end
addEvent("GTWgroups.updateMessage", true)
addEventHandler("GTWgroups.updateMessage", root, updateMessage)
