--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

local sWidth, sHeight = guiGetScreenSize()
function initialize_skin_shop()
	window = exports.GTWgui:createWindow(sWidth-340, (sHeight-500)/2, 340, 500, "GTW skin shop", false)
	skin_list_gui = guiCreateGridList(10, 25, 320, 425, false, window)
	col_name = guiGridListAddColumn(skin_list_gui, "Title", 0.45)
	col_id = guiGridListAddColumn(skin_list_gui, "ID", 0.2)
	btn_buy = guiCreateButton(10, 456, 158, 40, "Buy skin ($50)", false, window)
	btn_close = guiCreateButton(172, 456, 158, 40, "Close", false, window)
	guiSetVisible(window, false)
	
	-- Apply GTW GUI styles
	exports.GTWgui:setDefaultFont(skin_list_gui, 10)
	exports.GTWgui:setDefaultFont(btn_buy, 10)
	exports.GTWgui:setDefaultFont(btn_close, 10)
	
	-- Events for the buttons
	addEventHandler("onClientGUIClick", btn_close, function( ) 
		guiSetVisible(window, false) 
		showCursor(false) 
		setPlayerHudComponentVisible("all", true) 
		setElementModel(localPlayer, model) 
		setElementFrozen(localPlayer, false) 
	end, false)
	addEventHandler("onClientGUIClick", btn_buy, buy_the_skin, false)
	addEventHandler("onClientGUIClick", skin_list_gui, preview_skin, false)
end
addEventHandler("onClientResourceStart", resourceRoot, initialize_skin_shop)

function show_skin(skinsTable)
	if getPlayerMoney() < 20 then exports.GTWtopbar:dm("You can not afford to buy this skin", 255, 0, 0) return end
	if getPlayerTeam(localPlayer) ~= getTeamFromName("Unemployed") and 
		getPlayerTeam(localPlayer) ~= getTeamFromName("Criminals") and
		getPlayerTeam(localPlayer) ~= getTeamFromName("Gangsters") then
	 	exports.GTWtopbar:dm("End your work before changing your skin, click F5 or use /endwork", 255, 0, 0) return end
	if getElementData(localPlayer, "rob") then exports.GTWtopbar:dm("You cannot shop while robbing you idiot!", 255, 0, 0) return end
	guiGridListClear(skin_list_gui)
	setElementFrozen(localPlayer, true)
	for category, skins in pairs(skinsTable) do
		local row = guiGridListAddRow(skin_list_gui)
		guiGridListSetItemText(skin_list_gui, row, 1, category, true, false)
		for id, name in pairs(skins) do
			local row = guiGridListAddRow(skin_list_gui)
			guiGridListSetItemText(skin_list_gui, row, 1, name, false, false)
			guiGridListSetItemText(skin_list_gui, row, 2, id, false, false)
		end
	end
	guiSetVisible(window, true)
	showCursor(true)
	local rx,ry,rz = getElementRotation(localPlayer)
	fadeCamera(false)
	setTimer(setCameraTarget, 800, 1, localPlayer)
	setTimer(setElementRotation, 1000, 1, localPlayer, rx,ry, rz-180)
	setTimer(fadeCamera, 1000, 1, true)
	model = getElementModel(localPlayer)
end
addEvent("GTWclothes.show_skin", true)
addEventHandler("GTWclothes.show_skin", root, show_skin)

function preview_skin()
	local row = guiGridListGetSelectedItem(skin_list_gui)
	if (not row or row == -1) then return end
	local id = guiGridListGetItemText(skin_list_gui, row, 2)
	id = tonumber(id)
	if (not id) then return end
	setElementModel(localPlayer, id)
end

function buy_the_skin()	
	local row = guiGridListGetSelectedItem(skin_list_gui)
	if (not row or row == -1) then return end
	local id = guiGridListGetItemText(skin_list_gui, row, 2)
	id = tonumber(id)
	if (not id) then return end
	setElementModel(localPlayer, model)
	setElementFrozen(localPlayer, false)
	guiSetVisible(window, false)
	showCursor(false)
	triggerServerEvent("GTWclothes.buy_the_skin", root, id)
end