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

--[[ Global data storage ]]--
group_invites	= {}
valid_ranks 	= {}
rank_perm		= {}
invited_p 		= {}
group_c			= {}

--[[ Settings ]]--
main_window_key = "F6"

--[[ Permissions table ]]--
permissions = {
	[1] = "Authorized to invite players",
	[2] = "Authorized to promote members",
	[3] = "Authorized to demote members",
	[4] = "Authorized to kick members",
	[5] = "Authorized to warn members",
	[6] = "Authorized to delete group",
	[7] = "Authorized to deposit money",
	[8] = "Authorized to withdraw money",
	[9] = "Authorized to edit group info",
	[10] = "Authorized to view group logs",
	[11] = "Authorized to view blacklist",
	[12] = "Authorized to blacklist members",
	[13] = "Authorized to change turf color",
	[14] = "Authorized to create/accept alliance",
	[15] = "Authorized to add/edit/remove ranks",
}

--[[ Inverse a logical expression ]]--
function inverse_logical_expression(var)
	return (not (not var))
end

--[[ Request and display the ranks ]]--
function viewSetRank()
	triggerServerEvent("GTWgroups.printTheRanks", root)
end
function printTheRanks(ranks)
	guiComboBoxClear(setRankCombo)
	guiSetVisible(setRankWindow, true)
	guiBringToFront(setRankWindow)

	for ind, data in pairs(ranks) do
		valid_ranks[ind] = true
		guiComboBoxAddItem(setRankCombo, tostring(ind))
	end

	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	local rank = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 3)
	local wl = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 5)
	guiSetText(accountSelectedRank, "Account: "..tostring(account).."\nRank: "..tostring(rank).."\nWL: "..tostring(wl))
	guiLabelSetColor(accountSelectedRank, 0, 255, 0)
end
addEvent("GTWgroups.printTheRanks", true)
addEventHandler("GTWgroups.printTheRanks", root, printTheRanks)

--[[ Load ranks ]]--
function clickOnRankCombo()
	local irrelevant = guiComboBoxGetSelected(setRankCombo)
	local name = guiComboBoxGetItemText(setRankCombo, irrelevant)
	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	if (valid_ranks[name] and name ~= "Select Rank") then
		guiSetText(setRankLabel1, "Set the rank of account: "..tostring(account).."\n to rank: "..name)
	end
end

--[[ Set player rank ]]--
function setRank()
	local irrelevant = guiComboBoxGetSelected(setRankCombo)
	local name = guiComboBoxGetItemText(setRankCombo, irrelevant)
	--if (not valid_ranks[name]) then return end
	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	if (not account) then return end
	triggerServerEvent("GTWgroups.setTheRank", root, name, account)
end

--[[ Kick player from group ]]--
function kickFromGroup()
	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	if (not account) then return end
	triggerServerEvent("GTWgroups.kickFromGroup", root, account)
end

--[[ Request and display ranks ]]--
function showRanks()
	triggerServerEvent("GTWgroups.showRanks", root)
end

--[[ Add custom rank ]]--
function addRank()
	local name = guiGetText(permAddEdit)
	if (name:len() >= 20 or name:len() < 1) then
		exports.GTWtopbar:dm("Invalid rank name", 255, 0, 0)
		return
	end
	triggerServerEvent("GTWgroups.addTheRank", root, name)
end

--[[ Attempt to delete custom rank ]]--
function deleteGroupRankAttempt()
	local irrelevant = guiComboBoxGetSelected(rankCombo)
	local name = guiComboBoxGetItemText(rankCombo, irrelevant)
	if (not rank_perm[name] and name ~= "Select Rank") then return end
	deleteGroupRank()
end

--[[ Delete custom rank ]]--
function deleteGroupRank()
	local irrelevant = guiComboBoxGetSelected(rankCombo)
	local name = guiComboBoxGetItemText(rankCombo, irrelevant)
	if (not rank_perm[name] and name ~= "Select Rank") then return end
	triggerServerEvent("GTWgroups.deleteRank", root, name)
end
addEvent("GTWgroups.deleteGroupRank", true)
addEventHandler("GTWgroups.deleteGroupRank", root, deleteGroupRank)

--[[ Edit custom rank ]]--
function editRank()
	local irrelevant = guiComboBoxGetSelected(rankCombo)
	local newPermissions = {}
	local name = guiComboBoxGetItemText(rankCombo, irrelevant)
	if (rank_perm[name] and check and type(check) == "table") then
		for ind, value in pairs(check) do
			table.insert(newPermissions, guiCheckBoxGetSelected(check[ind]))
		end
	end
	triggerServerEvent("GTWgroups.editRank", root, name, newPermissions, irrelevant)
end

--[[ Save changes to database ]]--
function doneWithRanks(ranksTable, selected)
	guiComboBoxClear(rankCombo)
	local id = {}
	for ind, data in pairs(ranksTable) do
		rank_perm[ind] = data
		id[ind] = guiComboBoxAddItem(rankCombo, tostring(ind))
	end
	guiSetVisible(permWindow, true)
	guiBringToFront(permWindow, true)

	if (selected) then
		local newRank = id[selected]
		guiComboBoxSetSelected(rankCombo, newRank)
		deleteCheckBoxes(rankScrollPanel)
		check = createCheckBoxes(rankScrollPanel)
	end
end
addEvent("GTWgroups.doneWithRanks", true)
addEventHandler("GTWgroups.doneWithRanks", root, doneWithRanks)

--[[ Select rank ]]--
function selectRank()
	deleteCheckBoxes(rankScrollPanel)
	check = createCheckBoxes(rankScrollPanel)
	local irrelevant = guiComboBoxGetSelected(rankCombo)
	local name = guiComboBoxGetItemText(rankCombo, irrelevant)
	if (rank_perm[name] and name ~= "Select Rank") then
		for ind, v in pairs(rank_perm[name]) do
			if (v and isElement(check[ind])) then
				guiCheckBoxSetSelected(check[ind], true)
			end
		end
	end
end

--[[ List ranks in permission box ]]--
function createCheckBoxes(scrollPane)
	local stuffCount = 1
	local checkboxes = {}
	for k, v in ipairs(permissions) do
		table.insert(checkboxes, guiCreateCheckBox(0, stuffCount*19, 287, 17, v, false, false, scrollPane))
		stuffCount = stuffCount + 1
	end
	return checkboxes
end

--[[ Clean up permission window ]]--
function deleteCheckBoxes(scrollPane)
	for k, v in ipairs(getElementsByType("gui-checkbox", resourceRoot)) do
		if (getElementParent(v) == scrollPane) then
			destroyElement(v)
		end
	end
end

--[[ Display warning ]]--
function showWarn()
	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	if (not account or account == "") then return end
	guiSetVisible(warnWindow, true)
	guiSetText(warnWindow, "Warn "..account)
	guiBringToFront(warnWindow)
end

--[[ Warn player ]]--
function warnAccount()
	local lvl = guiGetText(warningLevelEdit)
	local reason = guiGetText(warningReasonEdit)
	local account = guiGridListGetItemText(adminMembsList, guiGridListGetSelectedItem(adminMembsList), 2)
	if (not account or account == "") then return end
	if (not tonumber(lvl)) then
		exports.GTWtopbar:dm("Invalid warning level entered", 255, 0, 0)
		return
	end
	triggerServerEvent("GTWgroups.warnAccount", root, account, lvl, reason)
end

--[[ Request leave group ]]--
function confirmDelete()
	triggerServerEvent("GTWgroups.leaveGroup", root)
end
addEvent("GTWgroups.confirmDelete", true)
addEventHandler("GTWgroups.confirmDelete", root, confirmDelete)

--[[ Close main window and hide cursor ]]--
function closeWindow()
	guiSetVisible(window, false)
	showCursor(false)
end

--[[ Toggle main window ]]--
function openWindowAndSend()
	if (guiGetVisible(window)) then
		guiSetVisible(window, false)
		showCursor(false)
		guiSetInputEnabled( false )
	else
		showCursor(true)
		guiSetVisible(window, true)
		guiSetInputEnabled( true )
		triggerServerEvent("GTWgroups.viewWindow", root)
	end
end
addCommandHandler("group", openWindowAndSend)
bindKey(main_window_key, "down", openWindowAndSend)

--[[ Request and display group list ]]--
function show_group_list()
	guiSetVisible(listWindow, true)
	guiBringToFront(listWindow)
	triggerServerEvent("GTWgroups.addGroupListServer", root)
end
function add_group_list(group, count)
	gTable = group
	guiGridListClear(groupListGrid)
	for ind, data in pairs(group) do
		local row = guiGridListAddRow(groupListGrid)
		guiGridListSetItemText(groupListGrid, row, 1, tostring(ind), false, false)
		guiGridListSetItemText(groupListGrid, row, 2, tostring(data[1]), false, false)
		guiGridListSetItemText(groupListGrid, row, 3, tostring(count[ind]), false, false)
		group_c[ind] = count[ind]
	end
end
addEvent("GTWgroups.addGroupList", true)
addEventHandler("GTWgroups.addGroupList", root, add_group_list)

--[[ Search in group list ]]--
function search_group_list()
	guiGridListClear(groupListGrid)
	local text = guiGetText(source)
	if (not text or text == "") then
		triggerServerEvent("GTWgroups.addGroupListServer", root)
		return
	end
	for ind, data in pairs(gTable) do
		if (string.find(ind:lower(), text:lower(), 1, true)) then
			local row = guiGridListAddRow(groupListGrid)
			guiGridListSetItemText(groupListGrid, row, 1, tostring(ind), false, false)
			guiGridListSetItemText(groupListGrid, row, 2, tostring(data[1]), false, false)
			guiGridListSetItemText(groupListGrid, row, 3, tostring(c[ind]), false, false)
		end
	end
end

--[[ Toggle window, update information to display ]]--
function viewWindow(group, rank, datejoined, msg, perms)
	if (not group) then
		guiSetText(myGroupLabel, "My Group: N/A")
		guiSetText(myGroupRankLabel, "Group Rank: N/A")
		guiSetText(dateJoinedLabel, "Date Joined: N/A")
		guiSetEnabled(createGroupEdit, true)
		guiSetEnabled(createGroupButton, true)
		guiSetEnabled(adminPanel, false)
		guiSetEnabled(leaveGroupButton, false)
		guiSetEnabled(reject_inviteButton, true)
		guiSetEnabled(accept_inviteButton, true)
	else
		guiSetEnabled(leaveGroupButton, true)
		guiSetEnabled(createGroupEdit, false)
		guiSetEnabled(createGroupButton, false)
		guiSetEnabled(adminPanel, true)
		guiSetEnabled(reject_inviteButton, false)
		guiSetEnabled(accept_inviteButton, false)
		guiSetText(createGroupEdit, tostring(group))
		guiSetText(dateJoinedLabel, "Date Joined: "..tostring(datejoined))
		guiSetText(myGroupLabel, "My Group: "..tostring(group))
		guiSetText(myGroupRankLabel, "Group Rank: "..tostring(rank))
		printManagment()
		guiGridListClear(adminMembsList)
	end

	if (perms and type(perms) == "table") then
			local manageRanks = false
			if (perms[2] or perms[3]) then
				manageRanks = true
			end

			if (perms[4] or perms[5]) then
				warn = true
			end
			guiSetEnabled(viewSetRankButton, manageRanks)
			guiSetEnabled(logButton, inverse_logical_expression(perms[10]))
			guiSetEnabled(viewAdminInviteButton, inverse_logical_expression(perms[1]))
			guiSetEnabled(blackListButton, inverse_logical_expression(perms[12]))
			guiSetEnabled(viewWarnsButton, warn)
			guiSetEnabled(viewMessageButton, inverse_logical_expression(perms[9]))
	end
	guiSetText(messageMemo, tostring(msg))
end
addEvent("GTWgroups.done", true)
addEventHandler("GTWgroups.done", root, viewWindow)
function printManagment()
	triggerServerEvent("GTWgroups.print", root)
end

--[[ List group memebers ]]--
function addToList(account, rank, warning, joined, lastTime, lastNick, online)
	local row = guiGridListAddRow(adminMembsList)
	guiGridListSetItemText(adminMembsList, row, 1, tostring(lastNick), false, false)
	guiGridListSetItemText(adminMembsList, row, 2, tostring(account), false, false)
	guiGridListSetItemText(adminMembsList, row, 3, tostring(rank), false, false)
	guiGridListSetItemText(adminMembsList, row, 4, tostring(lastTime), false, false)
	guiGridListSetItemText(adminMembsList, row, 5, tostring(warning), false, false)

	if (online) then
		guiGridListSetItemColor(adminMembsList, row, 1, 0, 255, 0)
		guiGridListSetItemColor(adminMembsList, row, 2, 0, 255, 0)
		guiGridListSetItemColor(adminMembsList, row, 3, 0, 255, 0)
		guiGridListSetItemColor(adminMembsList, row, 4, 0, 255, 0)
		guiGridListSetItemColor(adminMembsList, row, 5, 0, 255, 0)
	else
		guiGridListSetItemColor(adminMembsList, row, 1, 255, 0, 0)
		guiGridListSetItemColor(adminMembsList, row, 2, 255, 0, 0)
		guiGridListSetItemColor(adminMembsList, row, 3, 255, 0, 0)
		guiGridListSetItemColor(adminMembsList, row, 4, 255, 0, 0)
		guiGridListSetItemColor(adminMembsList, row, 5, 255, 0, 0)
	end
end
addEvent("GTWgroups.addToList", true)
addEventHandler("GTWgroups.addToList", root, addToList)

--[[ Request save of group information ]]--
function saveMessage()
	local message = guiGetText(messageMemo)
	triggerServerEvent("GTWgroups.updateMessage", root, message)
end

--[[ Request make group ]]--
function make_group()
	if (not guiGetEnabled(createGroupEdit)) then
		exports.GTWtopbar:dm("You must leave your current group first", 255, 0, 0, "default-bold", true, 0.15)
		return
	end

	local name = guiGetText(createGroupEdit)
	local name = string.gsub(name, " ", "_")
	if (name and name ~= "" and name:len() > 2) then
		triggerServerEvent("GTWgroups.attemptMakeGroup", root, name)
	end
end

--[[ Open invite window ]]--
function openInviteSearch()
	guiGridListClear(inviteList)
	for ind, plr in pairs(getElementsByType("player")) do
		if (not getElementData(plr, "Group")) then
			local name = getPlayerName(plr)
			local row = guiGridListAddRow(inviteList)
			local r, g, b = getPlayerNametagColor(plr)
			guiGridListSetItemText(inviteList, row, 1, tostring(name), false, false)
			guiGridListSetItemColor(inviteList, row, 1, r or 255, g or 255, b or 255)
		end
	end
end

--[[ Filter available players to invite ]]--
function search_invite()
	local text = guiGetText(source)
	guiGridListClear(inviteList)
	if (not text or text == "") then
		openInviteSearch()
		return
	end
	for _, plr in pairs(getElementsByType("player")) do
		local name = getPlayerName(plr)
		local foundString = string.find(name:lower(), text:lower(), 1, true)
		if (foundString and not getElementData(plr, "Group")) then
			local row = guiGridListAddRow(inviteList)
			local r, g, b = getPlayerNametagColor(plr)
			guiGridListSetItemText(inviteList, row, 1, tostring(name), false, false)
			guiGridListSetItemColor(inviteList, row, 1, r or 255, g or 255, b or 255)
		end
	end
end

--[[ Send invite to player ]]--
function invite_player()
	local name = guiGridListGetItemText(inviteList, guiGridListGetSelectedItem(inviteList), 1)
	if (not name or not getPlayerFromName(name)) then return end
	local selected = getPlayerFromName(name)
	for ind, data in pairs(invited_p) do
		if (data == selected) then
			exports.GTWtopbar:dm("You can not invite this player again", 255, 0, 0)
			return
		end
	end
	table.insert(invited_p, selected)
	triggerServerEvent("GTWgroups.makeInvite", root, selected)
end

--[[ Display invite in player invite list ]]--
function add_to_invites_list(group, sender, time)
	for ind, data in pairs(group_invites) do
		if (data == group) then
			return
		end
	end
	table.insert(group_invites, group)
	local row = guiGridListAddRow(mineListInvites)
	guiGridListSetItemText(mineListInvites, row, 1, tostring(group), false, false)
	guiGridListSetItemText(mineListInvites, row, 2, tostring(sender), false, false)
	guiGridListSetItemText(mineListInvites, row, 3, tostring(time), false, false)
end
addEvent("GTWgroups.addInviteToList", true)
addEventHandler("GTWgroups.addInviteToList", root, add_to_invites_list)

--[[ Reject invite ]]--
function reject_invite()
	local group = guiGridListGetItemText(mineListInvites, guiGridListGetSelectedItem(mineListInvites), 1)
	if (not group) then return end
	guiGridListRemoveRow(mineListInvites, guiGridListGetSelectedItem(mineListInvites))
end

--[[ Accept invite ]]--
function accept_invite()
	local group = guiGridListGetItemText(mineListInvites, guiGridListGetSelectedItem(mineListInvites), 1)
	if (not group) then return end
	guiGridListRemoveRow(mineListInvites, guiGridListGetSelectedItem(mineListInvites))
	triggerServerEvent("GTWgroups.acceptInvite", root, group)
end
