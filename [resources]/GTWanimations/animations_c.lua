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

--[[ Initialize the GUI ]]--
local resX, resY = guiGetScreenSize()
function create_gui()
	win_anim = guiCreateWindow(resX-400, resY/2-250, 400, 500, "Animations", false)
	guiSetVisible(win_anim, false)
	category_list = guiCreateGridList(10, 33, 187, 400, false, win_anim)
	anim_list = guiCreateGridList(203,33,187,400,false,win_anim)
	column1 = guiGridListAddColumn(category_list,"Category",0.8)
	column2 = guiGridListAddColumn(anim_list,"Animation",0.8)
	btn_stop = guiCreateButton(10,439,187,50,"Stop Animation",false,win_anim)
	btn_close = guiCreateButton(203,439,187,50,"Close",false,win_anim)
	addEventHandler("onClientGUIClick",btn_stop,function()
		triggerServerEvent("GTWanimations.setAnimation",localPlayer,nil,nil)
		setElementFrozen( localPlayer, false )
	end)
	for k,v in pairs(animations_table) do
		local row = guiGridListAddRow(category_list)
		guiGridListSetItemText(category_list, row, column1, k, false, false)
	end
	addEventHandler("onClientGUIClick", category_list, load_anim)
	addEventHandler("onClientGUIClick", anim_list, set_anim)
	addEventHandler("onClientGUIClick", btn_close, window_close)
end
addEventHandler("onClientResourceStart", resourceRoot, create_gui)

--[[ Close the window ]]--
function window_close()
	guiSetVisible(win_anim, false)
	showCursor(false)
end

--[[ Toggle window visibility ]]--
function window_toggle()
	if not guiGetVisible(win_anim) then
		guiSetVisible(win_anim, true)
		showCursor(true)
	else
		guiSetVisible(win_anim, false)
		showCursor(false)
	end
end
bindKey("F10", "down", window_toggle)

--[[ Load animations from category ]]--
function load_anim()
	curr_category = guiGridListGetItemText(category_list, guiGridListGetSelectedItem(category_list), 1)
	if curr_category ~= "" then
		guiGridListClear(anim_list)
		for k,v in ipairs(animations_table[curr_category]) do
			local row = guiGridListAddRow(anim_list)
			guiGridListSetItemText(anim_list, row, column1, v[1], false, false)
		end
	end
	if curr_category == "" then
		guiGridListClear(anim_list)
	end
end

--[[ Apply animation ]]--
function set_anim()
	local curr_anim = guiGridListGetItemText(anim_list,guiGridListGetSelectedItem(anim_list),1)
	if curr_anim == "" then return end

	-- Skip if dead
	if isPedDead(localPlayer) then
		exports.GTWtopbar:dm("You cannot use animations while you are dead.", 255, 0, 0)
		return
	end

	-- Skip if inside a vehicle
	if isPedInVehicle(localPlayer) then
		exports.GTWtopbar:dm("You cannot use animations while in a vehicle.", 255, 0, 0)
		return
	end

	-- Start animation
	triggerServerEvent("GTWanimations.setAnimation", localPlayer, curr_category, curr_anim)
end
