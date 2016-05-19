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

local markers = { }
local typeOfMarker = 0
local rotation = 0
local tmp_sx,tmp_sy,tmp_sz = nil,nil,nil
local is_gv = false
local e_cooldown = nil

--[[ Initialize all the vehicle spawners ]]--
function client_load_markers()
    for i,marker in pairs(spawn_markers) do
        local r,g,b = spawn_colors[marker[5]][1],spawn_colors[marker[5]][2],spawn_colors[marker[5]][3] or 255,255,255
	   	markers[i] = createMarker(marker[1], marker[2], marker[3]-0.1, "cylinder", 2, r, g, b, 70)
	   	if marker[5] == 1 then
	   		createBlipAttachedTo(markers[i], 55, 1, r, g, b, 80, 0, 400)
		else
			createBlipAttachedTo(markers[i], 0, 1, r, g, b, 80, 0, 400)
		end
	   	setElementData(markers[i], "rot", marker[4])
	   	setElementData(markers[i], "type", marker[5])
	   	if marker[6] and marker[7] and marker[8] then
	   		setElementData(markers[i], "spawn_x", marker[6])
	   		setElementData(markers[i], "spawn_y", marker[7])
	   		setElementData(markers[i], "spawn_z", marker[8])
	   	end
	   	addEventHandler("onClientMarkerHit", markers[i], marker_hit)
	   	addEventHandler("onClientMarkerLeave", markers[i], marker_leave)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, client_load_markers)

--[[ Initialize the spawner GUI ]]--
gx,gy = guiGetScreenSize()
window = guiCreateWindow(((gx-500)/2),((gy-400)/2),500,400,"Rental vehicles",false)
txt_search = guiCreateEdit(10, 32, 480, 30, "", false, window)
guiEditSetCaretIndex(txt_search, 1)
veh_grid = guiCreateGridList(10, 64, 480, 294, false, window)
guiGridListSetSelectionMode(veh_grid, 0)
col_name = guiGridListAddColumn(veh_grid, "Name", 0.45)
col_price = guiGridListAddColumn(veh_grid, "Price", 0.2)
col_details = guiGridListAddColumn(veh_grid, "Extra", 0.25)
btn_spawn = guiCreateButton(10, 360, 138, 36, "Rent", false, window)
guiSetProperty(btn_spawn, "NormalTextColour", "FF00FF00")
btn_cancel = guiCreateButton(352, 360, 138, 36, "Cancel", false, window)
guiSetVisible(window,false)
exports.GTWgui:setDefaultFont(veh_grid, 10)
exports.GTWgui:setDefaultFont(btn_spawn, 10)
exports.GTWgui:setDefaultFont(btn_cancel, 10)

--[[ Filter the list if a valid key is pressed ]]--
function filter_list(button, press)
	if press then return end
	if not guiGetVisible(window) then return end
	local isValid = false
	for k,v in pairs(valid_search_keys) do
		if v == button then isValid = true break end
	end
	if not isValid then return end
	-- Navigate in the list
        if button == "arrow_d" then
    	        local row,col = guiGridListGetSelectedItem(veh_grid)
    	        local row_c = guiGridListGetRowCount(veh_grid)
		if row + 1 >= row_c then return end
		guiGridListSetSelectedItem(veh_grid, row+1, 1)
		return
        end
        if button == "arrow_u" then
    	        local row,col = guiGridListGetSelectedItem(veh_grid)
		if row - 1 < 0 then return end
		guiGridListSetSelectedItem(veh_grid, row-1, 1)
		return
        end
        if is_gv and button ~= "enter" then
                make_vehlist(true, guiGetText(txt_search))
        elseif button ~= "enter" then
    	        make_vehlist(false, guiGetText(txt_search))
        end
        if button == "enter" and not isTimer(e_cooldown) then
    	        local row,col = guiGridListGetSelectedItem(veh_grid)
                if row and col and row ~= -1 and col ~= -1 then
		        trigger_server_spawn()
                else
           	        exports.GTWtopbar:dm("Error: Please, select a vehicle of list.", 255,0,0)
		end
        end
end
addEventHandler("onClientKey", root, filter_list)

--[[ (Staff) Get all vehicles ]]--
function getValidVehicleModels()
	local validVehicles = { }
	local invalidModels = {
		['435']=true, ['449']=true, ['450']=true, ['537']=true,
		['538']=true, ['569']=true, ['570']=true, ['584']=true,
		['590']=true, ['591']=true, ['606']=true, ['607']=true,
		['608']=true
	}
	for i=400, 609 do
		if not invalidModels[tostring(i)] then
			table.insert(validVehicles, getVehicleNameFromModel(i))
		end
	end
	table.sort(validVehicles)
	return validVehicles
end

--[[ Load vehicles into gridlist ]]--
function make_vehlist(is_staff, filter)
    if typeOfMarker and not is_staff then
    	if isElement(veh_grid) then
    		guiGridListClear(veh_grid)
    	end
    	if filter then filter = string.lower(filter) end
    	for i, vehicle in pairs(spawn_names[typeOfMarker]) do
    		-- Make a new row if filter says it ok or if filter isnt applied
    		local row = nil
    		if filter and string.find(string.lower(vehicle), filter) then
	        	row = guiGridListAddRow(veh_grid)
	        elseif not filter then
	        	row = guiGridListAddRow(veh_grid)
	        end

	        -- Do the rest if the row was added
	        if row then
                        -- Add extra Information
                        local veh_extra_data = veh_extra_plr
                        if veh_extra_data[vehicle] then
                                local is_admin = exports.GTWstaff:isAdmin(localPlayer) or false
                                if is_admin then veh_extra_data = veh_extra end
                                for k,v in ipairs(veh_extra_data[vehicle]) do
                                        local row2 = guiGridListAddRow(veh_grid)
                                        guiGridListSetItemText(veh_grid, row2, col_name, vehicle, false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_details, v, false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_price, tostring(
                                                spawn_prices[typeOfMarker][i]).."$/minute", false, false)
                                        if spawn_prices[typeOfMarker][i] > 0 then
                        			guiGridListSetItemText(veh_grid, row2, col_price,
                                                        tostring(spawn_prices[typeOfMarker][i]).."$/minute", false, false)
                        			if spawn_prices[typeOfMarker][i] > getPlayerMoney() then
                        				guiGridListSetItemColor(veh_grid, row2, col_name, 200, 0, 0)
                        				guiGridListSetItemColor(veh_grid, row2, col_details, 200, 0, 0)
                        				guiGridListSetItemColor(veh_grid, row2, col_price, 200, 0, 0)
                        			else
                        				guiGridListSetItemColor(veh_grid, row2, col_name, 0, 200, 0)
                        				guiGridListSetItemColor(veh_grid, row2, col_details, 0, 200, 0)
                        				guiGridListSetItemColor(veh_grid, row2, col_price, 0, 200, 0)
                        			end
                        		else
                        			guiGridListSetItemText(veh_grid, row2, col_price, "Free", false, false)
                        			guiGridListSetItemColor(veh_grid, row2, col_name, 0, 200, 0)
                        			guiGridListSetItemColor(veh_grid, row2, col_details, 0, 200, 0)
                        			guiGridListSetItemColor(veh_grid, row2, col_price, 0, 200, 0)
                        		end
                                end
                        end

                        -- Color code and set data
		    	guiGridListSetItemText(veh_grid, row, col_name, vehicle, false, false)
		        guiGridListSetItemText(veh_grid, row, col_details, "", false, false)
		        if spawn_prices[typeOfMarker][i] > 0 then
		        	guiGridListSetItemText(veh_grid, row, col_price,
                                        tostring(spawn_prices[typeOfMarker][i]).."$/minute", false, false)
		        	if spawn_prices[typeOfMarker][i] > getPlayerMoney() then
		        		guiGridListSetItemColor(veh_grid, row, col_name, 200, 0, 0)
		        		guiGridListSetItemColor(veh_grid, row, col_details, 200, 0, 0)
		        		guiGridListSetItemColor(veh_grid, row, col_price, 200, 0, 0)
		        	else
		        		guiGridListSetItemColor(veh_grid, row, col_name, 0, 200, 0)
		        		guiGridListSetItemColor(veh_grid, row, col_details, 0, 200, 0)
		        		guiGridListSetItemColor(veh_grid, row, col_price, 0, 200, 0)
		        	end
		        else
		        	guiGridListSetItemText(veh_grid, row, col_price, "Free", false, false)
		        	guiGridListSetItemColor(veh_grid, row, col_name, 0, 200, 0)
		        	guiGridListSetItemColor(veh_grid, row, col_details, 0, 200, 0)
		        	guiGridListSetItemColor(veh_grid, row, col_price, 0, 200, 0)
		        end
		  end
	    end
	    guiGridListSetSelectedItem(veh_grid, 0, 1)
	end
	if is_staff then
		typeOfMarker = 12
		if isElement(veh_grid) then
    		guiGridListClear(veh_grid)
    	end
    	local allVehList = getValidVehicleModels()
    	table.insert(allVehList, "Streak")
    	table.insert(allVehList, "Freight")
    	table.insert(allVehList, "Tram")
    	table.sort(allVehList)
    	if filter then filter = string.lower(filter) end
    	for i, vehicle in pairs(allVehList) do
    		if filter and string.find(string.lower(vehicle), filter) then
                        -- Vehicles with trailers
                        local veh_extra_data = veh_extra_plr
                        if veh_extra_data[vehicle] then
                                local is_admin = exports.GTWstaff:isAdmin(localPlayer) or false
                                if is_admin then veh_extra_data = veh_extra end
                                for k,v in ipairs(veh_extra_data[vehicle]) do
                                        local row2 = guiGridListAddRow(veh_grid)
                                        guiGridListSetItemText(veh_grid, row2, col_name, vehicle, false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_price, "Free", false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_details, v, false, false)
                                        guiGridListSetItemColor(veh_grid, row2, col_name, 0, 200, 0)
                	        	guiGridListSetItemColor(veh_grid, row2, col_details, 0, 200, 0)
                	        	guiGridListSetItemColor(veh_grid, row2, col_price, 0, 200, 0)
                                end
			-- Vehicles without trailers
			else
				local row = guiGridListAddRow(veh_grid)
				guiGridListSetItemText(veh_grid, row, col_name, vehicle, false, false)
				guiGridListSetItemText(veh_grid, row, col_details, "", false, false)
				guiGridListSetItemText(veh_grid, row, col_price, "Free", false, false)
				guiGridListSetItemColor(veh_grid, row, col_name, 0, 200, 0)
				guiGridListSetItemColor(veh_grid, row, col_details, 0, 200, 0)
				guiGridListSetItemColor(veh_grid, row, col_price, 0, 200, 0)
                        end
	        elseif not filter then
                        -- Vehicles with trailers
                        if veh_extra[vehicle] then
                                for k,v in ipairs(veh_extra[vehicle]) do
                                        local row2 = guiGridListAddRow(veh_grid)
                                        guiGridListSetItemText(veh_grid, row2, col_name, vehicle, false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_price, "Free", false, false)
                                        guiGridListSetItemText(veh_grid, row2, col_details, v, false, false)
                                        guiGridListSetItemColor(veh_grid, row2, col_name, 0, 200, 0)
                	        	guiGridListSetItemColor(veh_grid, row2, col_details, 0, 200, 0)
                	        	guiGridListSetItemColor(veh_grid, row2, col_price, 0, 200, 0)
                                end
			-- Vehicles without trailers
			else
				local row = guiGridListAddRow(veh_grid)
				guiGridListSetItemText(veh_grid, row, col_name, vehicle, false, false)
				guiGridListSetItemText(veh_grid, row, col_details, "", false, false)
				guiGridListSetItemText(veh_grid, row, col_price, "Free", false, false)
				guiGridListSetItemColor(veh_grid, row, col_name, 0, 200, 0)
				guiGridListSetItemColor(veh_grid, row, col_details, 0, 200, 0)
				guiGridListSetItemColor(veh_grid, row, col_price, 0, 200, 0)
                        end
	        end
	    end
	    guiGridListSetSelectedItem(veh_grid, 0, 1)
	end
	e_cooldown = setTimer(function() end, 500, 1)
end

--[[ Allow staff to spawn any vehicle using /gv ]]--
function spawn_the_vehicle()
	local is_staff = exports.GTWstaff:isStaff(localPlayer)
	if is_staff and not getPedOccupiedVehicle(localPlayer) then
		local is_admin = exports.GTWstaff:isAdmin(localPlayer)
		if getTeamName( getPlayerTeam( localPlayer ) ) ~= "Staff" and not is_admin then
			exports.GTWtopbar:dm( "You are not on duty!", 255, 0, 0 )
			return
		end
		local px,py,pz = getElementPosition(localPlayer)
		local rx,ry,rz = getElementRotation(localPlayer)
		rotation = rz
		make_vehlist(true)
	    if(window ~= nil) then
	        guiSetVisible(window, true)
	        showCursor(true)
	        guiSetInputEnabled(true)
	        guiSetText(txt_search, "")
	        guiBringToFront(txt_search)
	        guiEditSetCaretIndex(txt_search, 1)
	        is_gv = true
		end
	elseif getPedOccupiedVehicle(localPlayer) then
		exports.GTWtopbar:dm("Exit your vehicle before spawning a new one!", 255, 0, 0)
	else
		exports.GTWtopbar:dm("You are not in the staff team!", 255, 0, 0)
	end
end
addCommandHandler("gv", spawn_the_vehicle)

-- Show the gui window
function marker_hit(hitElement)
	local x,y,z = getElementPosition(localPlayer)
	local nx,ny,nz = getElementPosition(source)
	if localPlayer == hitElement and z < nz+5 and z > nz-3 then
		typeOfMarker = tonumber(getElementData(source, "type"))
		rotation = tonumber(getElementData(source, "rot"))
		tmp_sx = tonumber(getElementData(source, "spawnx"))
		tmp_sy = tonumber(getElementData(source, "spawny"))
		tmp_sz = tonumber(getElementData(source, "spawnz"))
		local occupation = spawn_rights[typeOfMarker][1]
		local team = spawn_rights[typeOfMarker][2]
		local wanted = spawn_rights[typeOfMarker][3]
		local is_staff = exports.GTWstaff:isStaff(localPlayer)
		if not getPedOccupiedVehicle(localPlayer) and getPlayerWantedLevel() <= wanted and
			(getPlayerTeam(localPlayer) == getTeamFromName(team) or team == "" or is_staff) and
			((getElementData(localPlayer, "Occupation") == occupation) or occupation == "" or is_staff) or
			((typeOfMarker == 4 or typeOfMarker == 17) and (getPlayerTeam(localPlayer) == getTeamFromName("Government"))) then
	        make_vehlist(false)
	        if(window ~= nil) then
	            guiSetVisible(window, true)
	            showCursor(true)
	            guiSetInputEnabled(true)
	            guiSetText(txt_search, "")
	            guiBringToFront(txt_search)
	            guiEditSetCaretIndex(txt_search, 1)
	            is_gv = false
			end
		elseif (getPlayerWantedLevel() > wanted) then
			exports.GTWtopbar:dm("Go away, we don't provide vehicles for criminals!",255,0,0)
		elseif (not getPedOccupiedVehicle(localPlayer)) then
			exports.GTWtopbar:dm("You need a job to access these vehicles!",255,0,0)
        end
    end
end

--[[ Event trigger for GUI buttons ]]--
function on_button_click()
    if source == btn_spawn then
        local row,col = guiGridListGetSelectedItem(veh_grid)
        if row and col and row ~= -1 and col ~= -1 then
			trigger_server_spawn()
        else
           	exports.GTWtopbar:dm("Error: Please, select a vehicle of list.",255,0,0)
		end
	elseif source == btn_cancel then
		triggerEvent("GTWvehicles.closeWindow", localPlayer)
	end
end
addEventHandler("onClientGUIClick", window, on_button_click)

--[[ Event trigger for GUI double click ]]--
function gui_double_click()
	if source == veh_grid then
		local row,col = guiGridListGetSelectedItem(veh_grid)
        if row and col and row ~= -1 and col ~= -1 then
			trigger_server_spawn()
		end
	end
end
addEventHandler("onClientGUIDoubleClick", window, gui_double_click)

--[[ Finally trigger the spawn ]]--
function trigger_server_spawn()
	local row,col = guiGridListGetSelectedItem(veh_grid)
	local vehName = guiGridListGetItemText(veh_grid, row, 1)
	local vehID = getVehicleModelFromName(vehName)
        local price = 0
        local extra = guiGridListGetItemText(veh_grid, row, 3) or 0
	--if not is_staff then price = spawn_prices[typeOfMarker][(row+1)] end
	if spawn_prices[typeOfMarker] and spawn_prices[typeOfMarker][(row+1)] then price = spawn_prices[typeOfMarker][(row+1)] end
	triggerServerEvent("GTWvehicles.spawnvehicle", root, vehID, rotation, price, extra, tmp_sx,tmp_sy,tmp_sz)
	triggerServerEvent("GTWvehicles.colorvehicle",root, typeOfMarker)
	triggerEvent("GTWvehicles.closeWindow", localPlayer)
end

--[[ Close the window + it's triggers ]]--
function marker_leave(leaveElement)
	if localPlayer == leaveElement then
		triggerEvent("GTWvehicles.closeWindow", localPlayer)
	end
end
function close_the_window()
	guiSetVisible(window, false)
	showCursor(false)
	guiSetInputEnabled(false)
end
addEvent("GTWvehicles.closeWindow", true)
addEventHandler("GTWvehicles.closeWindow", root, close_the_window)

--[[ Check when the train streams out and destroys it ]]--
function check_stream_out(c_train)
	setElementStreamable(c_train, true)
end
addEvent("GTWvehicles.onStreamOut", true)
addEventHandler("GTWvehicles.onStreamOut", root, check_stream_out)

addEventHandler("onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementData(source, "GTWvehicles.isTrailerTowingVehile") then
                local trailer = getElementData(source, "GTWvehicles.attachedTrailer")
                if not trailer then return end
                if isElementStreamedIn(trailer) then
                        attachTrailerToVehicle(source, trailer)
                end
        end
        if getElementData(source, "GTWvehicles.isTrailer") then
                local tower = getElementData(source, "GTWvehicles.towingVehicle")
                if not tower then return end
                if isElementStreamedIn(tower) then
                        attachTrailerToVehicle(tower, source)
                end
        end
    end
);

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
            if getElementData(source, "GTWvehicles.isTrailerTowingVehile") then
                    local trailer = getElementData(source, "GTWvehicles.attachedTrailer")
                    if isElementStreamedIn(source) and isElementStreamedIn(trailer) then
                            detachTrailerFromVehicle(source, trailer)
                    end
            elseif getElementData(source, "GTWvehicles.isTrailer") then
                    local tower = getElementData(source, "GTWvehicles.towingVehicle")
                    if isElementStreamedIn(tower) and isElementStreamedIn(source) then
                            detachTrailerFromVehicle(tower, source)
                    end
            end
    end
);
