--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- GUI components
local work_window 	= nil
local btn_accept 	= nil
local btn_cancel 	= nil
local lbl_info 		= nil
local lst_skins 	= nil
local cooldown 		= nil
local cooldown2		= nil

-- Global data
local dummyped		= nil
local playerSkinID 	= 0
local playerCurrentSkin = 0

--[[ Create the job window  ]]--
addEventHandler("onClientResourceStart", resourceRoot,
function()
	-- Adding the gui
   	local guiX,guiY = guiGetScreenSize()
        work_window = guiCreateWindow(0, (guiY-350)/2, 372, 350, "Civilians", false)
	guiSetVisible(work_window, false)

	-- Tab panel
	tab_panel = guiCreateTabPanel(0, 30, 372, 276, false, work_window)
	tab_info = guiCreateTab("Information", tab_panel)
	tab_skin = guiCreateTab("Select skin", tab_panel)
	tab_weapons = guiCreateTab("Rent weapons/tools", tab_panel)

	-- Button accept
        btn_accept = guiCreateButton(10, 310, 110, 36, "Accept", false, work_window)
        guiSetProperty(btn_accept, "NormalTextColour", "FF00FF00")
	addEventHandler("onClientGUIClick", btn_accept, accept_work, false)
	exports.GTWgui:setDefaultFont(btn_accept, 10)

	-- Button close
        btn_cancel = guiCreateButton(252, 310, 110, 36, "Cancel", false, work_window)
	addEventHandler("onClientGUIClick", btn_cancel, close_guibutton, false)
	exports.GTWgui:setDefaultFont(btn_cancel, 10)

	-- Memo with info
	lbl_info = guiCreateMemo(0, 0, 1, 1, "Loading info...", true, tab_info)
	guiMemoSetReadOnly( lbl_info, true )
	exports.GTWgui:setDefaultFont(lbl_info, 10)

	-- Skin selection list
	lst_skins = guiCreateGridList( 0, 0, 1, 1, true, tab_skin )
	guiGridListSetSelectionMode( lst_skins, 2 )
	guiGridListAddColumn( lst_skins, "Skin name", 0.65 )
	guiGridListAddColumn( lst_skins, "ID", 0.15 )
	exports.GTWgui:setDefaultFont(lst_skins, 10)
	guiGridListSetSelectionMode(lst_skins, 0)
	guiGridListSetSortingEnabled(lst_skins, false)

	-- Weapons and tools selection list
	lst_weapons = guiCreateGridList( 0, 0, 1, 1, true, tab_weapons )
	guiGridListSetSelectionMode( lst_weapons, 2 )
	guiGridListAddColumn( lst_weapons, "Weapon name", 0.5 )
	guiGridListAddColumn( lst_weapons, "Ammo", 0.15 )
	guiGridListAddColumn( lst_weapons, "Price", 0.15 )
	guiGridListAddColumn( lst_weapons, "ID", 0.10 )
	exports.GTWgui:setDefaultFont(lst_weapons, 10)
	guiGridListSetSelectionMode(lst_weapons, 0)
	guiGridListSetSortingEnabled(lst_weapons, false)

	-- Add all markers created by this system if any
	addMarkersAndClearTable()
end)

function addMarkersAndClearTable()
	-- Add job markers to the map
	for k, v in pairs(markers) do
		-- Unpack data
		local ID, inter,dim, x,y,z, j_type = unpack(v)
		if not ID or not inter or not dim or not x or not y or not z or not j_type then return end

		-- Update color profiles
		local red,green,blue = 255,150,0
		if j_type == "government" then
			red,green,blue = 110,110,110
		elseif j_type == "emergency" then
			red,green,blue = 0,150,255
		end

		-- Create the marker
		local mark = createMarker(x, y, z-1, "cylinder", 2.0, red, green, blue, 70)
		if inter == 0 then createBlipAttachedTo( mark, 56, 2, 0, 0, 0, 0, 0, 180) end
		setElementInterior(mark, inter)
		setElementDimension(mark, dim)
		addEventHandler("onClientMarkerHit", mark, showGUI)
		addEventHandler("onClientMarkerLeave", mark, close_gui)
		setElementData( mark, "jobID", ID )
	end

	-- Clear the table
	markers = { }
end

-- Check if a refresh is needed
setTimer(addMarkersAndClearTable, 5000, 0)

--[[ Shows the gui on marker hit and edit it's variables ]]--
function showGUI( hitElement, matchingdimension, jobID )
 	if not isTimer(cooldown) and hitElement and isElement(hitElement) and getElementType(hitElement) == "player"
 		and not getPedOccupiedVehicle(hitElement) and getElementData(hitElement, "Jailed") ~= "Yes" and hitElement == localPlayer
 		and matchingdimension then

 		-- Get job id from marker
 		local ID  = ""
 		if source then ID = getElementData( source, "jobID" ) else
 		ID = jobID end
 		local team, max_wl, description, skins, skin_names, work_tools, welcome_message = unpack(work_items[ID])

 		-- Check group membership
		local is_staff = exports.GTWstaff:isStaff(localPlayer)
 		if restricted_jobs[ID] then
 			if restricted_jobs[ID] ~= getElementData(localPlayer, "Group") and not is_staff then
 				exports.GTWtopbar:dm( ID..": This job is restricted to: "..restricted_jobs[ID], 255, 100, 0 )
 				return
 			end
 		end

 		-- Check wanted level
 		if getPlayerWantedLevel() > max_wl then
 			exports.GTWtopbar:dm( ID..": Go away, we don't hire criminals!", 255, 0, 0 )
 			return
 		end

 		if getElementData(localPlayer, "Occupation") == ID then
 			guiSetEnabled(tab_info, false)
 			guiSetEnabled(tab_skin, false)
 			guiSetSelectedTab(tab_panel, tab_weapons)
 			guiSetVisible(btn_accept, false)
 			guiSetText(btn_cancel, "OK")
 		else
 			guiSetEnabled(tab_info, true)
 			guiSetEnabled(tab_skin, true)
 			guiSetSelectedTab(tab_panel, tab_info)
 			guiSetVisible(btn_accept, true)
 			guiSetText(btn_cancel, "Cancel")
 		end

 		-- Freeze the player
 		setTimer(setElementFrozen, 250, 1, localPlayer, true)

 		-- Move to skin selection area
 		g_px,g_py,g_pz = getElementPosition(localPlayer)
 		g_prx,g_pry,g_prz = getElementRotation(localPlayer)
 		g_pdim = getElementDimension(localPlayer)
 	 	g_pint = getElementInterior(localPlayer)
 		fadeCamera(false)
 		dummyped = createPed(0, -1618.2958984375, 1400.9755859375, 7.1753273010254, 180)

 		-- Fade and move the camera
 		local new_dim = math.random(100,200)
 		setTimer(fadeCamera, 1000, 1, true)
 		setTimer(setElementDimension, 1000, 1, localPlayer, new_dim)
 		setTimer(setElementInterior, 1000, 1, localPlayer, 0)
 		setTimer(setElementDimension, 1000, 1, dummyped, new_dim)
 		setTimer(setElementInterior, 1000, 1, dummyped, 0)
 		setTimer(setCameraMatrix, 1000, 1, -1618.2958984375, 1398, 7.1753273010254, -1618.2958984375, 1400.9755859375, 7.1753273010254, 5, 100)

	 	-- Set GUI information and save skin information
 		guiSetText(lbl_info, ID.."\n"..description)
 		setElementData(localPlayer, "jobID", ID)
 		setElementData(localPlayer, "GTWcivilians.skins.current", getElementModel(localPlayer))
 		playerCurrentSkin = getElementModel(localPlayer)

 		-- Clear skins list
 		guiGridListClear( lst_skins )

 		-- Add category
 		local tmp_row_cat = guiGridListAddRow( lst_skins )
		guiGridListSetItemText( lst_skins, tmp_row_cat, 1,ID.." skins",true,false)

 		-- Add available skins
 		for k=1, #skins do
		    if skins[k] == -1 then
		    	-- Alias for default skin
 				local tmp_row = guiGridListAddRow( lst_skins )
		    	guiGridListSetItemText( lst_skins, tmp_row, 1,"Default",false,false)
 			elseif skins[k] > -1 then
 				-- All other available skins
	    		local tmp_row = guiGridListAddRow( lst_skins )
		    	guiGridListSetItemText( lst_skins,tmp_row,2,skins[k],false,false)
		    	guiGridListSetItemText( lst_skins,tmp_row,1,skin_names[k],false,false)
		    end
		end

		-- Clear weapons list
 		guiGridListClear( lst_weapons )

 		-- Add available weapons
 		for i=1, #work_tools do
	    	local tmp_row = guiGridListAddRow( lst_weapons )
	    	local wep_id,ammo,price,name = unpack(work_tools[i])
		    guiGridListSetItemText(lst_weapons,tmp_row,1, name, false,false)
		    guiGridListSetItemText(lst_weapons,tmp_row,2, ammo, false,false)
		    guiGridListSetItemText(lst_weapons,tmp_row,3, price, false,false)
		    guiGridListSetItemText(lst_weapons,tmp_row,4, wep_id, false,false)
		end

		-- Select default item
		guiGridListSetSelectedItem( lst_skins, 0, 0 )
		row,col = 0,0 -- Default
		setTimer(function()
			if skins[1] > -1 then
				setElementModel( dummyped, skins[1] )
				playerSkinID = skins[1]
			else
				local currSkinID = tonumber(getElementData(localPlayer, "GTWclothes.personal.skin")) or 0
				setElementModel( dummyped, currSkinID )
				playerSkinID = currSkinID
			end
		end, 1000, 1)

		-- On skin change
		addEventHandler("onClientGUIClick",lst_skins,
		function()
			row,col = guiGridListGetSelectedItem( lst_skins )
			if row and col and row > 0 then
				playerSkinID = (skins[row] or 0)
				if playerSkinID > -1 then
					setElementModel( dummyped, playerSkinID )
				elseif playerSkinID == -1 then
					local currSkinID = tonumber(getElementData(localPlayer, "GTWclothes.personal.skin")) or 0
					setElementModel( dummyped, currSkinID )
				end
			end
		end)

		addEventHandler( "onClientGUIDoubleClick", lst_weapons, function( )
    		local r,c = guiGridListGetSelectedItem(lst_weapons)
    		local name = guiGridListGetItemText(lst_weapons, r,1)
    		local ammo = guiGridListGetItemText(lst_weapons, r,2)
    		local price = guiGridListGetItemText(lst_weapons, r,3)
    		local weapon_id = guiGridListGetItemText(lst_weapons, r,4)
    		if not isTimer(cooldown2) and r > -1 and c > -1 then
    			triggerServerEvent("GTWcivilians.buyTools", localPlayer, name, ammo, price, weapon_id)
    			cooldown2 = setTimer(function() end, 200, 1)
    		end
		end)

 		-- Showing the gui
 		setTimer(guiSetVisible, 1000, 1, work_window, true)
 		setTimer(guiSetInputEnabled, 1000, 1, true)
 		setTimer(showCursor, 1000, 1, true)
 	end
end

function staffWork(cmdName, ID)
	-- Configuration
	-- Setup by name
	if isPedDead( localPlayer ) then
		return 
	end
	
	if cmdName ~= "gowork"  then
		if cmdName == "gobusdriver" then
	 		ID = "Bus Driver"
		elseif cmdName == "gotrain" then
	 		ID = "Train Driver"
		elseif cmdName == "gotaxi" then
	 		ID = "Taxi Driver"
		elseif cmdName == "gotrucker" then
	 		ID = "Trucker"
		elseif cmdName == "gopilot" then
	 		ID = "Pilot"
		elseif cmdName == "gomechanic" then
	 		ID = "Mechanic"
		elseif cmdName == "gofisher" then
	 		ID = "Fisher"
		elseif cmdName == "gofarmer" then
	 		ID = "Farmer"
	 	elseif cmdName == "gotram" then
	 		ID = "Tram Driver"
	 	elseif cmdName == "gofireman" then
	 		ID = "Fireman"
	 	elseif cmdName == "gomedic" then
	 		ID = "Paramedic"
	 	elseif cmdName == "goironminer" then
	 		ID = "Iron miner"
	 	elseif cmdName == "golaw" then
	 		ID = "Police officer"
	 	elseif cmdName == "sapd" then
	 		ID = "SAPD officer"
                elseif cmdName == "swat" then
	 		ID = "SWAT officer"
                elseif cmdName == "fbi" then
	 		ID = "FBI agent"
	 	elseif cmdName == "army" then
	 		ID = "Armed forces"
		end
	end

	-- Check if a user is in the staff team, if so, allow access
	local is_staff = exports.GTWstaff:isStaff(localPlayer)
	if not is_staff and restricted_jobs[ID] and restricted_jobs[ID] ~= getElementData(localPlayer, "Group") then
		exports.GTWtopbar:dm( ID..": Only staff and official groups can use this command!", 255, 100, 0 )
		return
	end
	if ID then
		showGUI(localPlayer, true, ID)
	end
end
addCommandHandler( "gowork", staffWork )
addCommandHandler( "gobusdriver", staffWork )
addCommandHandler( "gotrucker", staffWork )
addCommandHandler( "gotaxi", staffWork )
addCommandHandler( "gotrain", staffWork )
addCommandHandler( "gopilot", staffWork )
addCommandHandler( "gofisher", staffWork )
addCommandHandler( "gofarmer", staffWork )
addCommandHandler( "gomechanic", staffWork )
addCommandHandler( "gotram", staffWork )
addCommandHandler( "gofireman", staffWork )
addCommandHandler( "gomedic", staffWork )
addCommandHandler( "goironminer", staffWork )
addCommandHandler( "golaw", staffWork )

-- Group commands
addCommandHandler( "fbi", staffWork )
addCommandHandler( "swat", staffWork )
addCommandHandler( "sapd", staffWork )
addCommandHandler( "army", staffWork )

--[[ Closes the GUI on marker leave ]]--
function close_gui( leaveElement, matchingdimension )
	if ( leaveElement and isElement(leaveElement) and getElementType(leaveElement) == "player"
 		and not getPedOccupiedVehicle(leaveElement) and leaveElement == localPlayer
 		and matchingdimension ) then
 	end
end

--[[ When the user clicks on the Accept job button ]]--
function accept_work()
	-- Trigger server event
	local ID = getElementData(localPlayer, "jobID")
	if not playerSkinID then
		playerSkinID = 0
	end

	-- Accept job
	if ID then
    	           triggerServerEvent("GTWcivilians.accept", localPlayer, ID, playerSkinID)
        end

        -- Reset camera details
 	fadeCamera(false)
 	setTimer(reset_close_gui, 1000, 1)
 	cooldown = setTimer(function() end, 3000, 1)

 	-- Unfreeze player
 	setTimer(setElementFrozen, 2000, 1, localPlayer, false)

	-- Closing the gui
 	guiSetVisible( work_window, false )
 	guiSetInputEnabled( false )
 	showCursor( false )

        -- Display job info message in chat box
        local team, max_wl, description, skins, skin_names, work_tools, welcome_message = unpack(work_items[ID])
        outputChatBox("["..ID.."]#FFFFFF "..welcome_message, 180,180,180, true)
end

--[[ When the user clicks on the Close button ]]--
function close_guibutton()
	-- Closing the gui
 	guiSetVisible( work_window, false )
 	guiSetInputEnabled( false )
 	showCursor( false )

 	-- Unfreeze player
 	setTimer(setElementFrozen, 2000, 1, localPlayer, false)

 	-- Reset camera details
 	fadeCamera(false)
 	setTimer(reset_close_gui, 1000, 1)
 	cooldown = setTimer(function() end, 3000, 1)

 	-- Reset Skin
 	--local skinID = getElementData(localPlayer, "GTWcivilians.skins.current") or 0
 	--setElementModel(localPlayer, skinID)
end

function reset_close_gui()
 	-- Fade and move the camera back to default
 	fadeCamera(true)
 	setElementDimension(localPlayer, g_pdim)
 	setElementInterior(localPlayer, g_pint)
 	setElementPosition(localPlayer, g_px,g_py,g_pz)
 	setElementRotation(localPlayer, g_prx,g_pry,g_prz)
 	destroyElement(dummyped)
 	setCameraTarget(localPlayer)
 	setElementFrozen(localPlayer, false)
end
