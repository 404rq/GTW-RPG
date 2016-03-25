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

--[[ Create global vehicle data storage for clients ]]--
currentVehID = nil
veh_data_list = {{ }}
row,col = nil,nil

--[[ Create vehicle management GUI ]]--
x,y = guiGetScreenSize()
window = guiCreateWindow((x-600)/2, (y-400)/2, 600, 400, "Vehicle manager", false)
btn_show = guiCreateButton(10, 350, 90, 30, "Show", false, window)
btn_hide = guiCreateButton(100, 350, 90, 30, "Hide", false, window)
btn_lock = guiCreateButton(200, 350, 90, 30, "Lock", false, window)
btn_engine = guiCreateButton(290, 350, 90, 30, "Engine", false, window)
btn_recover = guiCreateButton(380, 350, 90, 30, "Recover", false, window)
btn_sell = guiCreateButton(470, 350, 90, 30, "Sell", false, window)
guiSetVisible( window, false )

--[[ Create the vehicle grid list ]]--
vehicle_list = guiCreateGridList( 10, 23, 580, 325, false, window )
col1 = guiGridListAddColumn( vehicle_list, "Name", 0.25 )
col2 = guiGridListAddColumn( vehicle_list, "Health", 0.1 )
col3 = guiGridListAddColumn( vehicle_list, "Fuel", 0.1 )
col4 = guiGridListAddColumn( vehicle_list, "Locked", 0.1 )
col5 = guiGridListAddColumn( vehicle_list, "Engine", 0.1 )
col6 = guiGridListAddColumn( vehicle_list, "Location", 0.3 )
guiGridListSetSelectionMode( vehicle_list, 0 )
guiGridListSetSortingEnabled(vehicle_list, false)

--[[ Apply GTWgui style ]]--
exports.GTWgui:setDefaultFont(btn_show, 10)
exports.GTWgui:setDefaultFont(btn_hide, 10)
exports.GTWgui:setDefaultFont(btn_lock, 10)
exports.GTWgui:setDefaultFont(btn_engine, 10)
exports.GTWgui:setDefaultFont(btn_recover, 10)
exports.GTWgui:setDefaultFont(btn_sell, 10)
exports.GTWgui:setDefaultFont(vehicle_list, 10)

--[[ Create vehicle trunk GUI ]]--
window_trunk = guiCreateWindow((x-600)/2, (y-400)/2, 600, 400, "Vehicle inventory", false)
btn_withdraw = guiCreateButton(275, 73, 50, 40, "<", false, window_trunk)
btn_deposit = guiCreateButton(275, 115, 50, 40, ">", false, window_trunk)
btn_withdraw_all = guiCreateButton(275, 163, 50, 40, "<<", false, window_trunk)
btn_deposit_all = guiCreateButton(275, 205, 50, 40, ">>", false, window_trunk)
btn_close = guiCreateButton(500, 350, 90, 30, "Close", false, window_trunk)
guiSetVisible( window_trunk, false )

--[[ Create the trunk grid list ]]--
label_vehicle = guiCreateLabel( 10, 23, 250, 20, "Vehicle trunk", false, window_trunk )
label_player = guiCreateLabel( 302, 23, 250, 20, "Your pocket", false, window_trunk )
inventory_list = guiCreateGridList( 10, 43, 263, 305, false, window_trunk )
player_items_list = guiCreateGridList( 327, 43, 263, 305, false, window_trunk )
col7 = guiGridListAddColumn( inventory_list, "Item", 0.61 )
col8 = guiGridListAddColumn( inventory_list, "Amount", 0.31 )
col9 = guiGridListAddColumn( player_items_list, "Item", 0.61 )
col10 = guiGridListAddColumn( player_items_list, "Amount", 0.31 )
guiGridListSetSelectionMode( inventory_list, 0 )
guiGridListSetSelectionMode( player_items_list, 0 )

--[[ Apply GTWgui style (inventory GUI )]]--
exports.GTWgui:setDefaultFont(label_vehicle, 10)
exports.GTWgui:setDefaultFont(label_player, 10)
exports.GTWgui:setDefaultFont(inventory_list, 10)
exports.GTWgui:setDefaultFont(player_items_list, 10)
exports.GTWgui:setDefaultFont(btn_withdraw, 16)
exports.GTWgui:setDefaultFont(btn_deposit, 16)
exports.GTWgui:setDefaultFont(btn_withdraw_all, 16)
exports.GTWgui:setDefaultFont(btn_deposit_all, 16)
exports.GTWgui:setDefaultFont(btn_close, 10)

--[[ Create a function to handle toggling of vehicle GUI ]]--
function toggleGUI( source )
	-- Show the vehicle GUI
	if not guiGetVisible( window ) then
		showCursor( true )
		guiSetVisible( window, true )
		guiSetInputEnabled( true )
		triggerServerEvent( "GTWvehicleshop.onListVehicles", localPlayer )
	else
		showCursor( false )
		guiSetVisible( window, false )
		guiSetInputEnabled( false )
	end
end
addCommandHandler( "vehicles", toggleGUI )
bindKey( "F2", "down", "vehicles" )

--[[ Create a function to handle toggling of vehicle inventory GUI ]]--
function toggleInventoryGUI( plr )
	-- Show the vehicle inventory GUI
	if not guiGetVisible( window_trunk ) and isElement(getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk")) then
		local browsing_player = getElementData(getElementData(
			localPlayer, "GTWvehicleshop.the_near_veh_trunk"),
			"GTWvehicleshop.the_near_player_trunk")
		if getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk") and
			browsing_player and browsing_player == localPlayer then
			showCursor( true )
			guiSetVisible( window_trunk, true )
			guiSetInputEnabled( true )
			loadWeaponsToList()
		else
			if not browsing_player then return end
			exports.GTWtopbar:dm(getPlayerName(browsing_player).." is currently browsing this trunk, please wait!", 255, 0, 0)
		end
	else
		showCursor( false )
		guiSetVisible( window_trunk, false )
		guiSetInputEnabled( false )
		if isElement(getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk")) then
			triggerServerEvent( "GTWvehicleshop.onCloseInventory", localPlayer )
		end
	end
end
addCommandHandler( "inventory", toggleInventoryGUI )
bindKey( "F9", "down", "inventory" )

function loadWeaponsToList()
	if col7 and col8 and col9 and col10 then
		local weapons = getPedWeapons(localPlayer)
		guiGridListClear( player_items_list )
		guiGridListClear( inventory_list )
		for i,wep in pairs(getPedWeapons(localPlayer)) do
			local row = guiGridListAddRow( player_items_list )
			local slot = getSlotFromWeapon(wep)
			if getPedTotalAmmo(localPlayer,slot) > 0 then
				guiGridListSetItemText( player_items_list, row, col9, getWeaponNameFromID(wep), false, false )
				guiGridListSetItemText( player_items_list, row, col10, getPedTotalAmmo(localPlayer,slot), false, false )
			end
		end

		-- Load weapons from vehicle inventory
		local veh_id = getElementData( getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk"), "isOwnedVehicle")
		if veh_id then triggerServerEvent( "GTWvehicleshop.onOpenInventory", localPlayer, veh_id ) end
	end
end

function receiveVehicleData(data_table)
	if col1 and col2 and col3 and col4 and col5 and col6 then
		-- Clear and refresh
		guiGridListClear( vehicle_list )
		veh_data_list = data_table

		-- Load vehicles to list
		for id, veh in pairs(data_table) do
			local row = guiGridListAddRow( vehicle_list )
			guiGridListSetItemText( vehicle_list, row, col1, getVehicleNameFromModel(data_table[id][2]), false, false )
			if currentVehID == tonumber(data_table[id][1]) then
				guiGridListSetItemColor( vehicle_list, row, col1, 100, 100, 255 )
			end
			guiGridListSetItemText( vehicle_list, row, col2, data_table[id][3], false, false )
			if data_table[id][3] > 70 then
				guiGridListSetItemColor( vehicle_list, row, col2, 0, 255, 0 )
			elseif data_table[id][3] > 30 then
				guiGridListSetItemColor( vehicle_list, row, col2, 255, 200, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col2, 255, 0, 0 )
			end
			guiGridListSetItemText( vehicle_list, row, col3, data_table[id][4], false, false )
			if data_table[id][4] > 80 then
				guiGridListSetItemColor( vehicle_list, row, col3, 0, 255, 0 )
			elseif data_table[id][4] > 20 then
				guiGridListSetItemColor( vehicle_list, row, col3, 255, 200, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col3, 255, 0, 0 )
			end
			local locked = "Open"
			if data_table[id][5] == 1 then
				locked = "Yes"
			end
			guiGridListSetItemText( vehicle_list, row, col4, locked, false, false )
			if data_table[id][5] == 1 then
				guiGridListSetItemColor( vehicle_list, row, col4, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col4, 255, 200, 0 )
			end
			local engine = "Off"
			if data_table[id][6] == 1 then
				engine = "On"
			end
			guiGridListSetItemText( vehicle_list, row, col5, engine, false, false )
			if data_table[id][6] == 1 then
				guiGridListSetItemColor( vehicle_list, row, col5, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col5, 255, 0, 0 )
			end
			local x,y,z, rx,ry,rz = unpack( fromJSON( data_table[id][7] ))
			local location = getZoneName(x,y,z)
			local city = getZoneName(x,y,z,true)
			guiGridListSetItemText( vehicle_list, row, col6, location.." ("..city..")", false, false )
			local px,py,pz = getElementPosition(localPlayer)
			local dist = getDistanceBetweenPoints3D( x,y,z, px,py,pz )
			if dist < 180 then
				guiGridListSetItemColor( vehicle_list, row, col6, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col6, 255, 200, 0 )
			end
		end
	end
end
addEvent( "GTWvehicleshop.onReceivePlayerVehicleData", true )
addEventHandler( "GTWvehicleshop.onReceivePlayerVehicleData", root, receiveVehicleData )

function receiveInventoryItems(item)
	if col7 and col8 then
		-- Clear and refresh
		guiGridListClear( inventory_list )

		-- Load vehicles to list
		local data_table = fromJSON(item)
		for k, v in pairs(data_table) do
			local row = guiGridListAddRow( inventory_list )
			guiGridListSetItemText( inventory_list, row, col7, k, false, false )
			guiGridListSetItemText( inventory_list, row, col8, v, false, false )
		end
	end
end
addEvent( "GTWvehicleshop.onReceiveInventoryItems", true )
addEventHandler( "GTWvehicleshop.onReceiveInventoryItems", root, receiveInventoryItems )

--[[ Toggle vehicle visibility on click ]]--
addEventHandler("onClientGUIClick",vehicle_list,
function()
	row,col = guiGridListGetSelectedItem( vehicle_list )
	if row and col and veh_data_list[row+1] then
		currentVehID = veh_data_list[row+1][1]
		for w=0, #veh_data_list do
			guiGridListSetItemColor( vehicle_list, w, col1, 255, 255, 255 )
		end
		guiGridListSetItemColor( vehicle_list, row, col1, 100, 100, 255 )
		guiGridListSetSelectedItem( vehicle_list, 0, 0)
	end
end)

--[[ Close the inventory GUI ]]--
addEventHandler("onClientGUIClick",btn_close,
function()
	toggleInventoryGUI(localPlayer)
end)

--[[ Options in the button menu ]]--
addEventHandler( "onClientGUIClick", root,
function ( )
	--if not currentVehID then exports.GTWtopbar:dm("Please select a vehicle from the list!", 255, 0, 0) return end
	if source == btn_show and currentVehID then
		triggerServerEvent( "GTWvehicleshop.onShowVehicles", localPlayer, currentVehID )
	end
	if source == btn_hide and currentVehID then
		triggerServerEvent( "GTWvehicleshop.onHideVehicles", localPlayer, currentVehID )
	end
	if source == btn_lock and currentVehID then
		-- Update vehiclelist and lock status
		if guiGridListGetItemText( vehicle_list, row, col4 ) == "Yes" then
			triggerServerEvent( "GTWvehicleshop.onLockVehicle", localPlayer, currentVehID, 0 )
			guiGridListSetItemText( vehicle_list, row, col4, "Open", false, false )
			guiGridListSetItemColor( vehicle_list, row, col4, 255, 200, 0 )
		else
			triggerServerEvent( "GTWvehicleshop.onLockVehicle", localPlayer, currentVehID, 1 )
			guiGridListSetItemText( vehicle_list, row, col4, "Yes", false, false )
			guiGridListSetItemColor( vehicle_list, row, col4, 0, 255, 0 )
		end
	end
	if source == btn_engine and currentVehID then
		-- Update vehiclelist and engine status
		if guiGridListGetItemText( vehicle_list, row, col5 ) == "On" then
			triggerServerEvent( "GTWvehicleshop.onVehicleEngineToggle", localPlayer, currentVehID, 0 )
			guiGridListSetItemText( vehicle_list, row, col5, "Off", false, false )
			guiGridListSetItemColor( vehicle_list, row, col5, 255, 0, 0 )
		else
			triggerServerEvent( "GTWvehicleshop.onVehicleEngineToggle", localPlayer, currentVehID, 1 )
			guiGridListSetItemText( vehicle_list, row, col5, "On", false, false )
			guiGridListSetItemColor( vehicle_list, row, col5, 0, 255, 0 )
		end
	end
	if source == btn_recover and currentVehID then
		triggerServerEvent( "GTWvehicleshop.onVehicleRespawn", localPlayer, currentVehID )
	end
	if source == btn_sell and currentVehID then
		triggerServerEvent( "GTWvehicleshop.onVehicleSell", localPlayer, currentVehID, veh_data_list[row+1][2] )
		guiGridListRemoveRow( vehicle_list, row )
		currentVehID = nil
	end
	-- Vehicle inventory
	if source == btn_withdraw then
        vehicle_shop_withdraw()
    end
	if source == btn_deposit then
		vehicle_shop_deposit()
	end
	if source == btn_withdraw_all then
        vehicle_shop_withdraw(true)
    end
	if source == btn_deposit_all then
		vehicle_shop_deposit(true)
	end
end)

--[[ Withdraw weapon from inventory ]]--
function vehicle_shop_withdraw(withdraw_all)
	if not withdraw_all then withdraw_all = false end
	local row_pil, col_pil = guiGridListGetSelectedItem( player_items_list )
	local veh_id = getElementData( getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk"), "isOwnedVehicle")

	-- Validate operation
	if row_pil == -1 or col_pil == -1 or not veh_id then return end

	-- Get current values
	local object = guiGridListGetItemText( player_items_list, row_pil, col9 )
	local pocket = guiGridListGetItemText( player_items_list, row_pil, col10 )

	-- Get current data
	local slot = getSlotFromWeapon( getWeaponIDFromName( object ))
	local ammo = getPedAmmoInClip(localPlayer, slot)
	if withdraw_all then
		ammo = tonumber(guiGridListGetItemText(player_items_list, row_pil, col10))
	end
	local is_empty = false

	-- Justify values
	if ammo > tonumber(guiGridListGetItemText(player_items_list, row_pil, col10)) then
		ammo = tonumber(guiGridListGetItemText(player_items_list, row_pil, col10))
	end

	-- Send to database
	triggerServerEvent( "GTWvehicleshop.onVehicleWeaponWithdraw", localPlayer, veh_id, object, ammo)

	-- Manage lists add new item
	local ex_row = isElementInList(inventory_list, object, col7)
	if not ex_row then
		local tmp_row = guiGridListAddRow( inventory_list )
        guiGridListSetItemText( inventory_list, tmp_row, col7, object, false, false )
        guiGridListSetItemText( inventory_list, tmp_row, col8, ammo, false, false )
    else
       	guiGridListSetItemText( inventory_list, ex_row, col8, tonumber(guiGridListGetItemText(inventory_list, ex_row, col8)) + ammo, false, false )
    end
    guiGridListSetItemText( player_items_list, row_pil, col10, tonumber(guiGridListGetItemText(player_items_list, row_pil, col10)) - ammo, false, false )

    -- Remove if empty
    if guiGridListGetItemText(player_items_list, row_pil, col10) == "0" then
      	guiGridListRemoveRow( player_items_list, row_pil )
     	is_empty = true
    end

    -- Reload data
    --loadWeaponsToList()

    -- Clear selection if empty, otherwise reselect
    if not is_empty then
     	guiGridListSetSelectedItem(player_items_list, row_pil, col_pil)
     	guiGridListSetSelectedItem(inventory_list, -1, -1)
    else
      	guiGridListSetSelectedItem(player_items_list, -1, -1)
      	guiGridListSetSelectedItem(inventory_list, -1, -1)
    end

    -- Restore GUI style !Important if using GTWgui
    setTimer(resetGTWguistyle, 1000, 1)
end

--[[ Deposit weapon from inventory ]]--
function vehicle_shop_deposit(deposit_all)
	if not deposit_all then deposit_all = false end
	local row_il, col_il = guiGridListGetSelectedItem( inventory_list )
	local veh_id = getElementData( getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk"), "isOwnedVehicle")

	-- Validate operation
	if row_il == -1 or col_il == -1 or not veh_id then return end

	-- Get current values
	local object = guiGridListGetItemText( inventory_list, row_il, col7 )
	local trunk = guiGridListGetItemText( inventory_list, row_il, col8 )

	-- Get current data
	local ammo = getWeaponProperty(object, "std", "maximum_clip_ammo")
	if deposit_all then
		ammo = tonumber(guiGridListGetItemText(inventory_list, row_il, col8))
	end
	local is_empty = false

	-- Justify values
	if ammo > tonumber(guiGridListGetItemText(inventory_list, row_il, col8)) then
		ammo = tonumber(guiGridListGetItemText(inventory_list, row_il, col8))
	end

	-- Send to database
	triggerServerEvent( "GTWvehicleshop.onVehicleWeaponDeposit", localPlayer, veh_id, object, ammo)

	-- Manage lists add new item
	local ex_row = isElementInList(player_items_list, object, col9)
	if not ex_row then
		local tmp_row = guiGridListAddRow( player_items_list )
      	guiGridListSetItemText( player_items_list, tmp_row, col9, object, false, false )
      	guiGridListSetItemText( player_items_list, tmp_row, col10, ammo, false, false )
    else
     	guiGridListSetItemText( player_items_list, ex_row, col10, tonumber(guiGridListGetItemText(player_items_list, ex_row, col10)) + ammo, false, false )
    end
    guiGridListSetItemText( inventory_list, row_il, col8, tonumber(guiGridListGetItemText(inventory_list, row_il, col8)) - ammo, false, false )

    -- Remove if empty
    if guiGridListGetItemText(inventory_list, row_il, col8) == "0" then
      	guiGridListRemoveRow( inventory_list, row_il )
      	is_empty = true
    end

    -- Reload data
    --loadWeaponsToList()

    -- Clear selection if empty, otherwise reselect
    if not is_empty then
      	guiGridListSetSelectedItem(player_items_list, -1, -1)
     	guiGridListSetSelectedItem(inventory_list, row_il, col_il)
    else
      	guiGridListSetSelectedItem(player_items_list, -1, -1)
     	guiGridListSetSelectedItem(inventory_list, -1, -1)
    end

    -- Restore GUI style !Important if using GTWgui
    setTimer(resetGTWguistyle, 1000, 1)

	--[[local row_il, col_il = guiGridListGetSelectedItem( inventory_list )
	local veh_id = getElementData( getElementData(localPlayer, "GTWvehicleshop.the_near_veh_trunk"), "isOwnedVehicle")
	if row_il == -1 or col_il == -1 or not veh_id then return end
	triggerServerEvent( "GTWonVehicleWeaponDeposit", localPlayer, veh_id,
		guiGridListGetItemText( inventory_list, row_il, col7 ), guiGridListGetItemText( inventory_list, row_il, col8 ))
	local tmp_row = guiGridListAddRow( player_items_list )
    guiGridListSetItemText( player_items_list, tmp_row, col9, guiGridListGetItemText( inventory_list, row_il, col7 ), false, false )
    guiGridListSetItemText( player_items_list, tmp_row, col10, guiGridListGetItemText( inventory_list, row_il, col8 ), false, false )
    guiGridListRemoveRow( inventory_list, row_il )
    -- Clear selection
    guiGridListSetSelectedItem(player_items_list, -1, -1)
    guiGridListSetSelectedItem(inventory_list, -1, -1)]]--
end

function resetGTWguistyle()
	-- Apply GUI style again !Important if using GTWgui
    exports.GTWgui:setDefaultFont(inventory_list, 10)
	exports.GTWgui:setDefaultFont(player_items_list, 10)
end

--[[ Find element in list ]]--
function isElementInList(g_list, text, col)
	local items_count = guiGridListGetRowCount(g_list)
	for r=0, items_count do
		--outputChatBox("R: "..r..", C: "..col.." "..guiGridListGetItemText(g_list, r, col).." = "..text)
		if guiGridListGetItemText(g_list, r, col) == text then return r end
	end
	return false
end

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end
