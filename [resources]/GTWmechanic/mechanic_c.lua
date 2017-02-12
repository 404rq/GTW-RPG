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

local element = nil
local sx,sy = guiGetScreenSize()

--[[ Make GUI for context menu ]]--
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function()
	window = guiCreateWindow((sx-200)/2,(sy-300)/2, 200, 300, "Vehicle", false)
	btn_repair = guiCreateButton(10, 30, 180, 40, "Repair", false, window)
	btn_refuel = guiCreateButton(10, 70, 180, 40, "Refuel", false, window)
	btn_close = guiCreateButton(10, 240, 180, 40, "Close", false, window)
	-- Staff only
	btn_enter = guiCreateButton(10, 110, 180, 40, "Enter vehicle", false, window)
	btn_staff_repair = guiCreateButton(10, 150, 180, 40, "Fix and refuel", false, window)

	-- Apply walrus font
	exports.GTWgui:setDefaultFont(btn_repair, 10)
	exports.GTWgui:setDefaultFont(btn_refuel, 10)
	exports.GTWgui:setDefaultFont(btn_close, 10)
	exports.GTWgui:setDefaultFont(btn_enter, 10)
	exports.GTWgui:setDefaultFont(btn_staff_repair, 10)
	guiSetVisible(window, false)

	-- Button click events
	addEventHandler("onClientGUIClick", btn_repair, repair_destroy)
	addEventHandler("onClientGUIClick", btn_refuel, refuel_information)
	addEventHandler("onClientGUIClick", btn_close, close_win)
	addEventHandler("onClientGUIClick", btn_enter, enter_veh)
	addEventHandler("onClientGUIClick", btn_staff_repair, staff_repair)
end)

--[[ Update GUI depending on caller ]]--
function openVehicleMenu(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if not clickedElement then return end
    local dist = getDistanceBetweenPoints3D(worldX, worldY, worldZ, getElementPosition(localPlayer)) or 0
    if getElementType(clickedElement) == "vehicle" and not guiGetVisible(window) and (not getPedOccupiedVehicle(localPlayer) or
        getPedOccupiedVehicle(localPlayer) ~= clickedElement) and
        ((getPlayerTeam(localPlayer) == getTeamFromName("Civilians") and
        getElementData(localPlayer, "Occupation") == "Mechanic") or
	getPlayerTeam(localPlayer) == getTeamFromName("Staff")) and
	not guiGetInputEnabled() then
        -- Open GUI as staff
        if getPlayerTeam(localPlayer) == getTeamFromName("Staff") then
        	guiSetText(btn_repair, "Destroy")
        	guiSetText(btn_refuel, "Information")
        	guiSetVisible(btn_enter, true)
        	guiSetVisible(btn_staff_repair, true)
        -- Open GUI as mechanic
	elseif getElementData(localPlayer, "Occupation") == "Mechanic" and dist < 20 then
        	guiSetText(btn_repair, "Repair")
        	guiSetText(btn_refuel, "Refuel")
        	guiSetVisible(btn_enter, false)
        	guiSetVisible(btn_staff_repair, false)
        end
        element = clickedElement
	if not isTimer(cooldown) then
		showCursor(true)
		guiSetVisible(window, true)
	end
    end
end
addEventHandler("onClientClick", root, openVehicleMenu)

--[[ Repair or destroy a vehicle based on occupation (admin or mechanic) ]]--
function repair_destroy()
	if not isElement(element) or not guiGetEnabled(btn_repair) or not source == btn_repair then return end
	if getElementData(localPlayer, "Occupation") == "Mechanic" then
		if getElementHealth(element) < 1000 then
			local repairTime = (1000-getElementHealth(element))*30
			if repairTime < 5000 then
				repairTime = 5000
			end
			mech_pb = guiCreateProgressBar(0.4, 0.9, 0.2, 0.05, true)
			setTimer(function()
				if isElement(mech_pb) then
					local progress = guiProgressBarGetProgress(mech_pb)
					if progress < 99 then
						guiProgressBarSetProgress(mech_pb, progress+1)
					end
				end
			end, math.floor(repairTime/100), 100)  -- Progress maximum is 100
			setTimer(destroyElement, repairTime, 1, mech_pb)
			triggerServerEvent("GTWmechanic.repair", root, element, repairTime)
		else
			topBarMessage("This vehicle is already in good condition!", 255, 100, 0)
		end
	else
		triggerServerEvent("GTWmechanic.destroy", getRootElement(), element)
	end
	cooldown = setTimer(function() end, 10000, 1)
	guiSetVisible(window, false)
	showCursor(false)
end

--[[ Refule or display information? that's another question ]]--
function refuel_information()
	if not isElement(element) or not guiGetEnabled(btn_refuel) or not source == btn_refuel then return end
	if getElementData(localPlayer, "Occupation") == "Mechanic" then
		local fuel = getElementData(element, "vehicleFuel") or 0
		if fuel < 100 then
			local refuleTime = (100-fuel)*100
			if refuleTime < 5000 then
				refuleTime = 5000
			end
			mech_pb = guiCreateProgressBar(0.4, 0.9, 0.2, 0.05, true)
			setTimer(function()
				if isElement(mech_pb) then
					local progress = guiProgressBarGetProgress(mech_pb)
					if progress < 99 then
						guiProgressBarSetProgress(mech_pb, progress+1)
					end
				end
			end, math.floor(refuleTime/100), 100)  -- Progress maximum is 100
			setTimer(destroyElement, refuleTime, 1, mech_pb)
			triggerServerEvent("GTWmechanic.refuel", root, element, refuleTime)
		else
			topBarMessage("This vehicle already has enough fuel!", 255, 100, 0)
		end
	else
		--exports.GTWtopbar:dm("Vehicle was sucsessfully removed!", 0, 255, 0)
		local owner = getElementData(element, "owner") or "none"
		local fuel = getElementData(element, "vehicleFuel") or 100
		local health = getElementHealth(element) or 100
		local is_locked = isVehicleLocked(element)
		if is_locked then is_locked = "true" else is_locked = "false" end
		outputChatBox("INFO: owner="..owner..", fuel="..fuel..", health="..health..", islocked="..is_locked, 255, 255, 255)
	end
	cooldown = setTimer(function() end, 10000, 1)
	guiSetVisible(window, false)
	showCursor(false)
end

--[[ Close the window, just close it ]]--
function close_win()
	showCursor(false)
	guiSetVisible(window, false)
end

--[[ Ability for staff to enter any vehicle ]]--
function enter_veh()
	if guiGetEnabled(btn_enter) and source == btn_enter then
		guiSetVisible(window, false)
		showCursor(false)
		if isElement(element) and getElementData(localPlayer, "staff") then
			triggerServerEvent("GTWmechanic.staff.enter", root, element)
		end
	end
end

--[[ Ability for staff to fix and repair ]]--
function staff_repair()
	if guiGetEnabled(btn_staff_repair) and source == btn_staff_repair then
		guiSetVisible(window, false)
		showCursor(false)
		if isElement(element) and getElementData(localPlayer, "staff") then
			triggerServerEvent("GTWmechanic.staff.repair", root, element)
		end
	end
end

--[[ Extra feature to make everything more comfortable ]]--
function topBarMessage(message, r, g, b)
    exports.GTWtopbar:dm(message, r, g, b)
end
