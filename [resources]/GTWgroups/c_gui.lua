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

--[[ Initialize group system GUI elements ]]--
function makeGUI()
	window = guiCreateWindow(0, 0, 770, 550, "Grand Theft Walrus - groups", false)
	guiWindowSetSizable(window, false)
	guiSetAlpha(window, 1.00)
	guiSetVisible(window, false)

	mainPanel = guiCreateTabPanel(6, 23, 758, 520, false, window)
	exports.GTWgui:setDefaultFont(mainPanel, 10)

	minePanel = guiCreateTab("Information", mainPanel)

	myGroupLabel = guiCreateLabel(20, 10, 280, 20, "Current group: ", false, minePanel)
	exports.GTWgui:setDefaultFont(myGroupLabel, 10)
	myGroupRankLabel = guiCreateLabel(20, 30, 280, 20, "Group rank: ", false, minePanel)
	exports.GTWgui:setDefaultFont(myGroupRankLabel, 10)
	dateJoinedLabel = guiCreateLabel(20, 50, 280, 20, "Date joined: ", false, minePanel)
	exports.GTWgui:setDefaultFont(dateJoinedLabel, 10)
	mineListInvites = guiCreateGridList(10, 80, 730, 366, false, minePanel)
	guiGridListAddColumn(mineListInvites, "Group", 0.3)
	guiGridListAddColumn(mineListInvites, "Sent by", 0.3)
	guiGridListAddColumn(mineListInvites, "Time", 0.3)
	exports.GTWgui:setDefaultFont(mineListInvites, 10)
	reject_inviteButton = guiCreateButton(124, 450, 110, 36, "Reject Invite", false, minePanel)
	accept_inviteButton = guiCreateButton(10, 450, 110, 36, "Accept Invite", false, minePanel)
	createGroupButton = guiCreateButton(640, 10, 100, 30, "Create", false, minePanel)
	createGroupEdit = guiCreateEdit(486, 10, 150, 30, "", false, minePanel)
	leaveGroupButton = guiCreateButton(640, 44, 100, 30, "Leave", false, minePanel)
	groupListButton = guiCreateButton(238, 450, 110, 36, "Group List", false, minePanel)

	exports.GTWgui:setDefaultFont(reject_inviteButton, 10)
	exports.GTWgui:setDefaultFont(accept_inviteButton, 10)
	exports.GTWgui:setDefaultFont(createGroupButton, 10)
	exports.GTWgui:setDefaultFont(leaveGroupButton, 10)
	exports.GTWgui:setDefaultFont(groupListButton, 10)

	adminPanel = guiCreateTab("Management", mainPanel)

	adminMembsList = guiCreateGridList(10, 10, 730, 430, false, adminPanel)
	guiGridListAddColumn(adminMembsList, "Last Nick", 0.19)
	guiGridListAddColumn(adminMembsList, "Account", 0.19)
	guiGridListAddColumn(adminMembsList, "Rank", 0.19)
	guiGridListAddColumn(adminMembsList, "Last time online", 0.19)
	guiGridListAddColumn(adminMembsList, "Warning Level", 0.19)
	viewSetRankButton = guiCreateButton(11, 444, 104, 36, "Set Rank", false, adminPanel)
	logButton = guiCreateButton(115, 444, 104, 36, "View Log", false, adminPanel)
	viewAdminInviteButton = guiCreateButton(219, 444, 104, 36, "Invite Player(s)", false, adminPanel)
	blackListButton = guiCreateButton(333, 444, 104, 36, "Blacklist", false, adminPanel)
	manageRanksButton = guiCreateButton(437, 444, 104, 36, "Manage Ranks", false, adminPanel)
	viewWarnsButton = guiCreateButton(541, 444, 104, 36, "Warn Player", false, adminPanel)
	viewMessageButton = guiCreateButton(645, 444, 104, 36, "Set Message", false, adminPanel)
	--kickPlayerButton = guiCreateButton(216, 220, 92, 30, "Kick Player", false, adminPanel)

	exports.GTWgui:setDefaultFont(adminMembsList, 10)
	exports.GTWgui:setDefaultFont(viewSetRankButton, 10)
	exports.GTWgui:setDefaultFont(logButton, 10)
	exports.GTWgui:setDefaultFont(viewAdminInviteButton, 10)
	exports.GTWgui:setDefaultFont(blackListButton, 10)
	exports.GTWgui:setDefaultFont(manageRanksButton, 10)
	exports.GTWgui:setDefaultFont(viewWarnsButton, 10)
	exports.GTWgui:setDefaultFont(viewMessageButton, 10)

	messageWindow = guiCreateWindow(602, 341, 455, 350, "Group Message", false)
	guiWindowSetSizable(messageWindow, false)
	guiSetAlpha(messageWindow, 1.00)

	messageMemo = guiCreateMemo(9, 18, 436, 283, "", false, messageWindow)
	messageCloseButton = guiCreateButton(165, 311, 108, 29, "Close", false, messageWindow)
	messageSaveButton = guiCreateButton(10, 311, 108, 29, "Save", false, messageWindow)
	guiSetVisible(messageWindow, false)

	inviteWindow = guiCreateWindow(680, 277, 301, 414, "Invite Player", false)
	guiWindowSetSizable(inviteWindow, false)
	guiSetAlpha(inviteWindow, 1.00)
	inviteSearchEdit = guiCreateEdit(9, 25, 282, 33, "", false, inviteWindow)
	inviteList = guiCreateGridList(11, 62, 280, 302, false, inviteWindow)
	guiGridListAddColumn(inviteList, "Name", 0.5)
	inviteCloseButton = guiCreateButton(13, 372, 78, 32, "Close", false, inviteWindow)
	inviteButton = guiCreateButton(213, 372, 78, 30, "Invite", false, inviteWindow)
	guiSetVisible(inviteWindow, false)


	listWindow = guiCreateWindow(680, 289, 297, 373, "Group List", false)
	guiWindowSetSizable(listWindow, false)
	guiSetAlpha(listWindow, 1.00)
	listEdit = guiCreateEdit(9, 23, 278, 33, "", false, listWindow)
	groupListGrid = guiCreateGridList(9, 61, 278, 271, false, listWindow)
	guiGridListAddColumn(groupListGrid, "Group", 0.4)
	guiGridListAddColumn(groupListGrid, "Founder", 0.3)
	guiGridListAddColumn(groupListGrid, "Members", 0.2)
	closeGroupList = guiCreateButton(10, 335, 277, 28, "Close", false, listWindow)
	guiSetVisible(listWindow, false)

	warnWindow = guiCreateWindow(668, 296, 280, 167, "", false)
	guiWindowSetSizable(warnWindow, false)
	guiSetAlpha(warnWindow, 1.00)

	warningReasonEdit = guiCreateEdit(9, 26, 258, 38, "Reason", false, warnWindow)
	warningLevelEdit = guiCreateEdit(9, 74, 258, 38, "Warning Level", false, warnWindow)
	warningCloseButton = guiCreateButton(9, 130, 88, 27, "Close", false, warnWindow)
	warnButton = guiCreateButton(179, 132, 88, 25, "Warn", false, warnWindow)
	guiSetVisible(warnWindow, false)

	permWindow = guiCreateWindow(679, 289, 275, 446, "Rank Management", false)
	guiWindowSetSizable(permWindow, false)
	guiSetAlpha(permWindow, 1.00)

	rankCombo = guiCreateComboBox(9, 23, 238, 150, "Select Rank", false, permWindow)
	--permEdit = guiCreateEdit(9, 23, 254, 36, "", false, permWindow)
	permEditButton = guiCreateButton(9, 403, 72, 33, "Edit", false, permWindow)
	permDeleteButton = guiCreateButton(99, 403, 72, 33, "Delete", false, permWindow)
	permCloseButton = guiCreateButton(185, 403, 72, 33, "Close", false, permWindow)
	rankScrollPanel = guiCreateScrollPane(9, 51, 250, 307, false, permWindow)
	permAddEdit = guiCreateEdit(12, 364, 159, 21, "", false, permWindow)
	addRankButton = guiCreateButton(185, 362, 72, 23, "Add Rank", false, permWindow)
	guiSetVisible(permWindow, false)

	--[[GUIEditor.window[1] = guiCreateWindow(652, 300, 296, 301, "Set Rank", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	guiSetAlpha(GUIEditor.window[1], 1.00)
	GUIEditor.combobox[1] = guiCreateComboBox(20, 94, 250, 161, "", false, GUIEditor.window[1])
	GUIEditor.label[1] = guiCreateLabel(-17, 46, 290, 80, "Set the rank of account: .. to : ..", false, GUIEditor.combobox[1])
	guiSetFont(GUIEditor.label[1], "clear-normal")
	guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
	GUIEditor.button[1] = guiCreateButton(10, 259, 73, 32, "Cancel", false, GUIEditor.window[1])
	GUIEditor.button[2] = guiCreateButton(209, 259, 73, 32, "Set Rank", false, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(0, 21, 296, 55, "Account Selected:\nCurrent Rank:\nWL:", false, GUIEditor.window[1])
	guiSetFont(GUIEditor.label[2], "clear-normal")
	guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)--]]


	setRankWindow = guiCreateWindow(652, 300, 291, 265, "Set Rank", false)
	guiWindowSetSizable(setRankWindow, false)
	guiSetAlpha(setRankWindow, 1.00)
	setRankCombo = guiCreateComboBox(20, 94, 250, 161, "Select Rank", false, setRankWindow)
	setRankLabel1 = guiCreateLabel(-16, 46, 290, 80, "Set the rank of account: to : ", false, setRankCombo)
	guiLabelSetColor(setRankLabel1, 0, 255, 0)
	guiSetFont(setRankLabel1, "clear-normal")
	guiLabelSetHorizontalAlign(setRankLabel1, "center", false)
	setRankClose = guiCreateButton(20, 223, 73, 32, "Cancel", false, setRankWindow)
	setRankButton = guiCreateButton(197, 223, 73, 32, "Set Rank", false, setRankWindow)
	accountSelectedRank = guiCreateLabel(0, 21, 296, 55, "Account Selected:\nCurrent Rank:\nWL:", false, setRankWindow)
	guiSetFont(accountSelectedRank, "clear-normal")
	guiLabelSetColor(accountSelectedRank, 0, 255, 0)
	guiLabelSetHorizontalAlign(accountSelectedRank, "center", false)
	guiSetVisible(setRankWindow, false)

	addEventHandler("onClientGUIClick", addRankButton, addRank, false)
	addEventHandler("onClientGUIClick", setRankButton, setRank, false)
	addEventHandler("onClientGUIClick", viewSetRankButton, viewSetRank, false)
	addEventHandler("onClientGUIClick", setRankCombo, clickOnRankCombo, false)
	addEventHandler("onClientGUIClick", permEditButton, editRank, false)
	addEventHandler("onClientGUIClick", closeGroupList, function() guiSetVisible(listWindow, false) end, false)
	addEventHandler("onClientGUIClick", permCloseButton, function() guiSetVisible(permWindow, false) end, false)
	addEventHandler("onClientGUIClick", setRankClose, function() guiSetVisible(setRankWindow, false) end, false)
	addEventHandler("onClientGUIClick", groupListButton, show_group_list, false)
	addEventHandler("onClientGUIClick", warnButton, warnAccount, false)
	addEventHandler("onClientGUIClick", manageRanksButton, showRanks, false)
	addEventHandler("onClientGUIClick", viewWarnsButton, showWarn, false)
	addEventHandler("onClientGUIClick", rankCombo, selectRank, false)
	addEventHandler("onClientGUIClick", viewMessageButton, function() guiSetVisible(messageWindow, true) guiBringToFront(messageWindow) end, false)
	addEventHandler("onClientGUIClick", messageCloseButton, function() guiSetVisible(messageWindow, false) end, false)
	addEventHandler("onClientGUIClick", warningCloseButton, function() guiSetVisible(warnWindow, false) end, false)
	addEventHandler("onClientGUIClick", messageSaveButton, saveMessage, false)
	addEventHandler("onClientGUIClick", logButton, function() triggerServerEvent("GTWgroups.showLog", root) end, false)
	addEventHandler("onClientGUIClick", viewAdminInviteButton, function() guiSetVisible(inviteWindow, true) guiBringToFront(inviteWindow) openInviteSearch() end, false)
	addEventHandler("onClientGUIClick", inviteCloseButton, function() guiSetVisible(inviteWindow, false) end, false)
	addEventHandler("onClientGUIClick", leaveGroupButton, confirmDelete, false)
	addEventHandler("onClientGUIClick", permDeleteButton, deleteGroupRankAttempt, false)

	addEventHandler("onClientGUIClick", inviteButton, invite_player, false)
	addEventHandler("onClientGUIChanged", inviteSearchEdit, search_invite, false)
	addEventHandler("onClientGUIChanged", listEdit, search_group_list, false)
	addEventHandler("onClientGUIClick", reject_inviteButton, reject_invite, false)
	addEventHandler("onClientGUIClick", accept_inviteButton, accept_invite, false)
	addEventHandler("onClientGUIClick", createGroupButton, make_group, false)
	addEventHandler("onClientGUIClick", createGroupEdit, function() if (guiGetText(source) == "Group Name") then guiSetText(source, "") end end, false)
	addEventHandler("onClientGUIClick", warningReasonEdit, function() if (guiGetText(source) == "Reason") then guiSetText(source, "") end end, false)
	addEventHandler("onClientGUIClick", warningLevelEdit, function() if (guiGetText(source) == "Warning Level") then guiSetText(source, "") end end, false)
	addEventHandler("onClientGUIClick", inviteSearchEdit, function() if (guiGetText(source) == "Search..") then guiSetText(source, "") end end, false)

	centerAllWindows(resourceRoot)
end
addEventHandler("onClientResourceStart", resourceRoot, makeGUI)

--[[ Center all windows within the resource ]]--
function centerAllWindows(res)
	for ind, element in ipairs(getElementsByType("gui-window", res)) do
		centerWindow(element)
	end
end

--[[ Center window element ]]--
function centerWindow(window)
    local sx, sy = guiGetScreenSize()
    local width, heigh = guiGetSize(window, false)
    local x, y = (sx-width) / 2, (sy-heigh) / 2
    guiSetPosition(window, x, y, false)
end
