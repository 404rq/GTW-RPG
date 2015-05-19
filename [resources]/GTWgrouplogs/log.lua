local sx, sy = guiGetScreenSize()

function makeLogGUI()	
	log = guiCreateWindow((sx / 2) - (694 / 2), (sy / 2) - (526 / 2), 694, 526, "Log", false)
	guiWindowSetSizable(log , false)
	guiSetAlpha(log , 1.00)
	guiSetVisible(log, false)

	nameEdit = guiCreateEdit(9, 22, 152, 30, "", false, log)
	searchEdit = guiCreateEdit(11, 483, 152, 30, "Search..", false, log)
	logGrid = guiCreateGridList(9, 61, 670, 408, false, log)
	guiGridListAddColumn(logGrid, "Message", 1.5)
	guiGridListSetSortingEnabled(logGrid, false)
	logCloseButton = guiCreateButton(591, 483, 88, 33, "Close", false, log)
	
	addEventHandler("onClientGUIClick", logCloseButton, function() guiSetVisible(log, false) showCursor(false) end, false)
	addEventHandler("onClientGUIClick", searchEdit, function() if (guiGetText(source) == "Search..") then guiSetText(source, "") end end, false)
	addEventHandler("onClientGUIChanged", searchEdit, searchLogs, false)
end
addEventHandler("onClientResourceStart", resourceRoot, makeLogGUI)


function invertTable(t)
	local newT = {}
	for k, v in ipairs(t) do
		newT[k] = t[(#t + 1) - (k)] 
	end
	return newT
end

function openLog(account, logTable, logType, group)
	guiSetText(nameEdit, account..".log")
	guiSetEnabled(nameEdit, false)
	guiBringToFront(log)
	guiSetVisible(log, true)
	guiGridListClear(logGrid)
	
	if (not logTable or logTable and #logTable < 1) then
		local row = guiGridListAddRow(logGrid)
		guiGridListSetItemText(logGrid, row, 1, "No logs found on this group", false, false)
		--guiGridListSetItemColor(logGrid, row, 1, 0, 255, 255)
		guiGridListSetItemColor(logGrid, row, 1, 250, 0, 0)
		return
	end
	
	logTable = invertTable(logTable)
	
	for ind, data in ipairs(logTable) do
		local row = guiGridListAddRow(logGrid)
		guiGridListSetItemText(logGrid, row, 1, tostring(data.msg), false, false)
		--guiGridListSetItemColor(logGrid, row, 1, 0, 255, 255)
		guiGridListSetItemColor(logGrid, row, 1, 0, 250, 0)
	end
	
	
	logAcc = account
	logCache = logTable
	lType = logType
end
addEvent("GTWlogs.openLog", true)
addEventHandler("GTWlogs.openLog", root, openLog)

function searchLogs()
	if (not logCache) then return end
	local text = guiGetText(source)
	guiGridListClear(logGrid)
	
	if (not text or text == "" and logCache) then
		for ind, data in pairs(logCache) do
			local row = guiGridListAddRow(logGrid)
			guiGridListSetItemText(logGrid, row, 1, tostring(data.msg), false, false)
			guiGridListSetItemColor(logGrid, row, 1, 0, 255, 255)
		end
		return
	end
	
	if (not logCache or #logCache < 0) then
		exports.CRmisc:outputTopBar("Could not find any logs", 255, 0, 0, "default-bold", false, 0.1)
		return
	end
	
	for ind, data in pairs(logCache) do
		if (string.find(data.msg:lower(), text:lower(), 1, true)) then
			local row = guiGridListAddRow(logGrid)
			guiGridListSetItemText(logGrid, row, 1, tostring(data.msg), false, false)
			guiGridListSetItemColor(logGrid, row, 1, 0, 255, 255)
		end
	end
end
