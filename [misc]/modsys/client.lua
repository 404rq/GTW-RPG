local downloadDirectory = "/mta-mods"
-- This is the file path to the location of the mods -- Don't include the IP and start it with a /"
-- Example: downloadDirectory = "/vehiclemods" | Now the mods will download from [[ip]]/vehiclemods

function alertMessage(message, r, g, b)
	exports.GTWtopbar:dm(message, r, g, b) -- you can change this to an export or whatever..
end

local data = getElementData(localPlayer, "PlayerIpAddress")

httpModDirectory = "http://104.238.188.170"..downloadDirectory

local sx, sy = guiGetScreenSize()
local button = { }
local window = guiCreateWindow((sx / 2 - 560 / 2),(sy / 2 - 369 / 2), 560, 369, "RageQuit 404 # mod library", false)
guiWindowSetSizable(window, false)
guiSetVisible(window, false)
local mods = guiCreateGridList(9, 22, 541, 292, false, window)
guiGridListSetSortingEnabled(mods, false)
guiGridListAddColumn(mods, "Name", 0.4)
guiGridListAddColumn(mods, "Type", 0.2)
guiGridListAddColumn(mods, "Enabled", 0.15)
guiGridListAddColumn(mods, "Downloaded", 0.15)
button['setstat'] = guiCreateButton(12, 324, 127, 35, "Enable Mod", false, window)
button['dl'] = guiCreateButton(149, 324, 127, 35, "Download Mod", false, window)
button['del'] = guiCreateButton(286, 324, 127, 35, "Delete Mod", false, window)
button['exit'] = guiCreateButton(423, 324, 127, 35, "Exit", false, window)
guiSetEnabled(button['setstat'], false)
guiSetEnabled(button['dl'], false)
guiSetEnabled(button['del'], false)

local enabledMods = { }
local downloadingFiles = { }

function openGUI()
	local x = not guiGetVisible(window)
	guiSetVisible(window, x)
	showCursor(x)
	refreshModList()
end
addCommandHandler("mods", openGUI)
addCommandHandler("vehmods", openGUI)
addCommandHandler("gunmods", openGUI)
addCommandHandler("skinmods", openGUI)
addCommandHandler("wepmods", openGUI)
addCommandHandler("weaponmods", openGUI)

addEventHandler("onClientGUIClick", root, function()
	if(source == button['exit']) then
		executeCommandHandler('vehmods')
	elseif(source == button['dl']) then
		local row, col = guiGridListGetSelectedItem(mods)
		if(row ~= -1 and col ~= 0) then
			local name = guiGridListGetItemText(mods, row, 1)
			if(not downloadingFiles[name] and not modExists(name)) then
				downloadMod(name)
				alertMessage("Downloading the "..name.." mod!", 0, 255, 0)
				guiSetEnabled(source, false)
				downloadingFiles[name] = true
			else
				alertMessage("You already have this mod.. It may still be downloading.", 255, 0, 0)
				guiSetEnabled(button['dl'], false)
				if(modExists(name)) then
					guiSetEnabled(button['setstat'], false)
					guiSetEnabled(button['del'], false)
					guiSetText(button['setstat'], "Enable Mod")
				end
			end
		end
	elseif(source == button['del']) then
		local r, c = guiGridListGetSelectedItem(mods)
		local t, t2 = guiGridListGetItemText(mods, r, 1), guiGridListGetItemText(mods, r, 2)
		if(t2 == "No") then
			alertMessage("Deleting the "..t.." mod.", 255, 0, 0)
			guiSetEnabled(source, false)
			guiSetEnabled(button['setstat'], false)
			guiSetEnabled(button['dl'], true)
			guiGridListSetItemText(mods, r, 3, "No", false, false)
			for i=1,3 do guiGridListSetItemColor(mods, r, i, 255, 0, 0) end
			deleteMod(t)
		else
			alertMessage("Please disable the mod before deleting it.", 255, 0, 0)
		end
	elseif(source == mods) then
		local row, col = guiGridListGetSelectedItem(source)
		if(row ~= -1 and col ~= 0) then
			local t = guiGridListGetItemText(mods, row, 1)
			guiSetText(button['setstat'], "Enable Mod")
			if(modExists(t)) then
				guiSetEnabled(button['setstat'], true)
				guiSetEnabled(button['dl'], false)
				guiSetEnabled(button['del'], true)
			else
				guiSetEnabled(button['setstat'], false)
				guiSetEnabled(button['dl'], true)
				guiSetEnabled(button['del'], false)
			end
			if(enabledMods[t]) then
				guiSetText(button['setstat'], "Disable Mod")
				guiGridListSetItemText(mods, row, 2, "Yes", false, false)
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 0, 255, 0) end
			else
				guiGridListSetItemText(mods, row, 2, "No", false, false)
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 255, 0, 0) end
			end
		else
			guiSetEnabled(button['setstat'], false)
			guiSetEnabled(button['dl'], false)
			guiSetEnabled(button['del'], false)
		end

		if(downloadingFiles[t]) then
			guiSetEnabled(button['dl'], false)
		end
	elseif(source == button['setstat']) then
		if(not isPedInVehicle(localPlayer)) then
			local row, col = guiGridListGetSelectedItem(mods)
			if(row ~= -1 and col ~= 0) then
				local t = guiGridListGetItemText(mods, row, 1)
				if(enabledMods[t]) then
					setModEnabled(t, false)
				else
					setModEnabled(t, true)
				end
			end
		else
			alertMessage("Please get out of your vehicle to use this function.", 255, 0, 0)
		end
	end
end)

function modExists(name)
	if(name and moddinglist[name] and not downloadingFiles[name]) then
		local dff = moddinglist[name][1]
		local txd = moddinglist[name][2]
		if(fileExists("mods/"..dff)) then
			if(moddinglist[name][4] and fileExists("mods/"..txd)) then
				return true
			elseif(not moddinglist[name][4]) then
				return true
			end
		else
			if(fileExists('mods/'..txd)) then
				fileDelete('mods/'..txd)
			end
		end
	end
	return false
end

function downloadMod(name)
	if(name and moddinglist[name]) then
		local dff = moddinglist[name][1]
		local txd = moddinglist[name][2]
		if(fileExists("mods/"..dff)) then
			fileDelete("mods/"..dff)
		end if(fileExists("mods/"..txd)) then
			fileDelete("mods/"..txd)
		end

		downloadingFiles[name] = true
		local f = fetchRemote(httpModDirectory.."/"..dff, function(data, err, name, dff, txd )
			if(err == 0) then

				local f = fileCreate("mods/"..dff)
				fileWrite(f, data)
				fileClose(f)

				if(moddinglist[name][4]) then
					fetchRemote(httpModDirectory.."/"..txd, function(data, err, name, name2)
						if(err == 0) then
							local f = fileCreate("mods/"..name)
							fileWrite(f , data)
							fileClose(f)

							alertMessage(name2.." mod has been downloaded. You can now activate it.", 0, 255, 0)
							downloadingFiles[name2] = false
							for i=0,guiGridListGetRowCount(mods) do
								local t = guiGridListGetItemText(mods, i, 1)
								if(t == name2) then
									guiGridListSetItemText(mods, i, 3, "Yes", false, false)
									local row, col = guiGridListGetSelectedItem(mods)
									if(row == i) then
										guiSetText(button['setstat'], "Enable Mod")
										guiSetEnabled(button['setstat'], true)
										guiSetEnabled(button['dl'], false)
										guiSetEnabled(button['del'], true)
									end
									break
								end
							end
						else
							alertMessage("Error "..err.." for resource "..getResourceName(getThisResource())..". Please report it at forum.404rq.com", 255, 0, 0)
							deleteMod(name)
							downloadingFiles[name] = false
						end
					end, "", false, txd, name)
				else
					alertMessage(name.." mod has been downloaded. You can now activate it.", 0, 255, 0)
					downloadingFiles[name] = false
					for i=0,guiGridListGetRowCount(mods) do
						local t = guiGridListGetItemText(mods, i, 1)
						if(t == name) then
							guiGridListSetItemText(mods, i, 3, "Yes", false, false)
							local row, col = guiGridListGetSelectedItem(mods)
							if(row == i) then
								guiSetText(button['setstat'], "Enable Mod")
								guiSetEnabled(button['setstat'], true)
								guiSetEnabled(button['dl'], false)
								guiSetEnabled(button['del'], true)
							end
							break
						end
					end
				end
			else
				alertMessage("Error "..err.." for resource "..getResourceName(getThisResource())..". Please report it at forum.404rq.com.", 255, 0, 0)
				deleteMod(name)
				downloadingFiles[name] = false
			end
		end, "", false, name, dff, txd)
	end
end

function deleteMod(name)
	local m1_dl = false
	local m2_dl = false
	if(name and moddinglist[name] and modExists(name)) then
		local txd, dff = moddinglist[name][2], moddinglist[name][1]
		if(fileExists("mods/"..txd)) then
			if(not fileDelete("mods/"..txd)) then
				return alertMessage("Failed to delete the "..name.." mod. Please reconnect.", 255, 0, 0)
			end
			m1_dl = true
		end if(fileExists("mods/"..dff)) then
			fileDelete("mods/"..dff)
			m2_dl = true
		end
	end
	return m2_dl and m1_dl
end

function setModEnabled(t, state, msg)
	if(t and moddinglist[t]) then
		row = 0
		if(msg == nil) then msg = true end
		for i=0,guiGridListGetRowCount(mods) do
			if(guiGridListGetItemText(mods, i, 1) == t) then
				row = i
				break
			end
		end
		local dff, txd, id = unpack(moddinglist[t])
		if(modExists(t)) then
			if(state == false and enabledMods[t]) then
				engineRestoreModel(id)
				enabledMods[t] = false
				guiSetText(button['setstat'], "Enable Mod")
				guiGridListSetItemText(mods, row, 2, "No", false, false)
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 255, 0, 0) end
				if(msg) then alertMessage(t.." Mod Disabled!", 0, 255, 0) end
			else
				if(moddinglist[t][4]) then
					local txd1 = engineLoadTXD("mods/"..txd)
					if(not txd1) then
						alertMessage("Failed to load the mod. Try re-downloading it.", 255, 0, 0)
						--return false
					end
					if(not engineImportTXD(txd1, id)) then
						alertMessage("Failed to enable the mod. Try re-downloading it.", 255, 0, 0)
						--return false
					end
				end
				local dff = engineLoadDFF("mods/"..dff, id)
				if(not dff) then
					alertMessage("Failed loading the mod model. Try re-downloading it.", 255, 0, 0)
					--return false
				end
				if(not engineReplaceModel(dff , id)) then
					alertMessage("Failed to replace the mod model. Try re-downloading it", 255, 0, 0)
					--return false
				end
				enabledMods[t] = true
				if(msg) then alertMessage(t.." mod enabled!", 0, 255, 0) end
				guiSetText(button['setstat'], "Disable Mod")
				guiGridListSetItemText(mods, row, 2, "Yes", false, false)
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 0, 255, 0) end
				--return true
			end
		end

		if(enabledMods[t]) then
			guiSetText(button['setstat'], "Disable Mod")
			guiGridListSetItemText(mods, row, 2, "Yes", false, false)
			for i=1,3 do guiGridListSetItemColor(mods, row, i, 0, 255, 0) end
		else
			guiGridListSetItemText(mods, row, 2, "No", false, false)
			for i=1,3 do guiGridListSetItemColor(mods, row, i, 255, 0, 0) end
		end
		return true
	end
	return false
end

function refreshModList()
	guiGridListClear(mods)
	table.sort(moddinglist)
	for i, v in pairs(moddinglist) do
		local row = guiGridListAddRow(mods)
		if v[5] == true then
			guiGridListSetItemText(mods, row, 1, tostring(i), true, false)
		else
			local exists = "No"
			if(modExists(i)) then
				exists = "Yes"
			end
			local enabled = "No"
			if(enabledMods[i]) then
				enabled = "Yes"
			end
			guiGridListSetItemText(mods, row, 1, tostring(i), false, false)
			guiGridListSetItemText(mods, row, 2, tostring(v[6]), false, false)
			guiGridListSetItemText(mods, row, 3, tostring(enabled), false, false)
			guiGridListSetItemText(mods, row, 4, tostring(exists), false, false)
			guiGridListSetItemData(mods, row, 1, { v[1], v[6], v[2], v[3] })
			if(enabled == "No") then
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 255, 0, 0) end
			else
				for i=1,3 do guiGridListSetItemColor(mods, row, i, 0, 255, 0) end
			end
		end
	end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	local file = xmlCreateFile('@save.xml', 'data')
	for i, v in pairs(moddinglist) do
		local child = xmlCreateChild(file, 'mod')
		xmlNodeSetAttribute(child, 'name', i)
		xmlNodeSetAttribute(child, 'enabled', tostring(isset(enabledMods[i])))
	end
	xmlSaveFile(file)
	xmlUnloadFile(file)
end)

function toboolean(input)
	local input = string.lower(tostring(input))
	if(input == 'true') then
		return true
	elseif(input == 'false') then
		return false
	else return nil end
end

function isset(value)
	if(value) then
		return true
	end
	return false
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	setTimer(function()
		refreshModList()
		local file = xmlLoadFile('@save.xml', 'data')
		if file then
			for i, v in ipairs(xmlNodeGetChildren(file)) do
				local name = tostring(xmlNodeGetAttribute(v, 'name'))
				local enabled = toboolean(xmlNodeGetAttribute(v, 'enabled'))
				if(moddinglist[name] and tostring(enabled):lower() ~= "false") then
					setModEnabled(name, true, false)
				end
			end
		end
	end, 5000, 1)
end)
