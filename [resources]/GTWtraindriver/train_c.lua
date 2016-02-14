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

-- Global client data
local current_train_station 	= nil
local current_blip		= nil
local next_payment		= nil
local window			= nil
local next_station = {
	x = nil,
	y = nil,
	z = nil
}
local sx,sy = guiGetScreenSize()

--[[ Capture event "EndWork" from GTWcivilians and clean up blips,
	the global command "endwork" works as well]]--
function end_work( )
	if isElement(current_train_station) then destroyElement(current_train_station) end
	if isElement(current_blip) then destroyElement(current_blip) end
end
addCommandHandler("endwork", end_work)
addEvent("GTWdata_onEndWork", true )
addEventHandler("GTWdata_onEndWork", root, end_work)

--[[ Create next train station on current route ]]--
function create_train_station(x, y, z)
	-- Destroying previous train station if any
	if isElement(current_train_station) then destroyElement(current_train_station) end
	if isElement(current_blip) then destroyElement(current_blip) end

	-- Create the marker, blip and hit event handler for the new trainstation
	current_train_station = createMarker(x, y, z-2, "cylinder", 4, 255, 255, 255, 50)
	current_blip = createBlipAttachedTo(current_train_station, 41, 1, 0, 0, 0, 255, 5, 9999)
	addEventHandler("onClientMarkerHit", current_train_station, train_station_hit)

	-- Update details for the dx monitor
	next_station.x = x
	next_station.y = y
	next_station.z = z

	-- Calculate the payment for next trainstation
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
	next_payment = dist*0.6
	if next_payment < 30 then next_payment = 30 end
	if next_payment > 400 then next_payment = 400 end
end
addEvent("GTWtraindriver.createtrainstation", true)
addEventHandler("GTWtraindriver.createtrainstation", root, create_train_station)

--[[ When a train stations at the train station ... ]]--
function train_station_hit(plr)
	-- Check that the hit element is the local player
	if plr ~= localPlayer then return end

	-- Get the vehicle that just stationped, (if any)
	local veh = getPedOccupiedVehicle(localPlayer)

	-- Did a vehicle station by or was it something else?
	if not veh then return end

	-- Alright, this was a vehicle, let's see how fast it's driving
	local kmh = math.abs(getTrainSpeed(veh)*160)

	-- Did this player drive faster than 30km/h? if so then we tell him he's
	-- an idiot who drove to fast.
	if kmh > 5 then
		exports.GTWtopbar:dm( "You are driving too fast!", 255, 0, 0 )
		return
	end

	-- Alright, everything seems fine here, at this moment we know the
	-- vehicle is a train thanks to other limitations, don't worry. Time
	-- to apply the handbrake and pay the driver
	setTrainSpeed(veh, 0)
	toggle_controls(plr, false)
	setTimer(toggle_controls, 11000, 1, plr, true)

	-- Payment has to be done on server side
	triggerServerEvent("GTWtraindriver.paytrainDriver", resourceRoot, next_payment)

	-- Alright, the driver has been paid, let's clean up some shit and give
	-- him a new train station shall we?
	removeEventHandler("onClientMarkerHit", current_train_station, train_station_hit)
	if isElement(current_train_station) then destroyElement(current_train_station) end
	if isElement(current_blip) then destroyElement(current_blip) end
end

--[[ Helper function to toggle controls safely ]]--
function toggle_controls(plr, state)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	toggleControl("accelerate", state)
	toggleControl("brake_reverse", state)
end

--[[ Pause the route on vehicle exit ]]--
function pause_route(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end

	-- Destroy the train station
	if isElement( current_train_station ) then
		removeEventHandler("onClientMarkerHit", current_train_station, train_station_hit)
		destroyElement(current_train_station)
	end

	-- Destroy the blip
	if isElement( current_blip ) then
		destroyElement(current_blip)
	end

	-- Remove dx render information to save CPU
	if isEventHandlerAdded("onClientRender", root, display_next_station) then
		removeEventHandler("onClientRender", root, display_next_station)
	end

	-- Note, all this stuff will be recreated once the driver enter his
	-- verhicle again, maybe he want to take a break for smoking or to
	-- revenge on someone who blocked his way. We're flexible.
end
addEventHandler("onClientVehicleExit", root, pause_route)

function enter_the_train(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end
	if seat > 0 then return end

	-- Make sure that the vehicle is a train
	if not train_vehicles[getElementModel(source)] then return end

	-- Add a render event handler to show information about hte next trainstation
	addEventHandler("onClientRender", root, display_next_station)
end
addEventHandler("onClientVehicleEnter", root, enter_the_train)

--[[ Opens a GUI in where the driver can pick his route ]]--
function select_train_route( )
	-- Create the selection GUI
	window = guiCreateWindow((sx-600)/2, (sy-350)/2, 600, 350, "Select train route", false)
	local close_button = guiCreateButton(480, 310, 110, 36, "Close", false, window)
	local routes_list = guiCreateGridList(10, 30, 580, 276, false, window)
	local tmp_col = guiGridListAddColumn(routes_list, "Route name", 0.86 )
	local info_label = guiCreateLabel(10, 318, 460, 20, "* Use max 3 carriages for the local routes or you may not fit!", false, window)
	exports.GTWgui:setDefaultFont(close_button, 10)
	exports.GTWgui:setDefaultFont(routes_list, 10)
	exports.GTWgui:setDefaultFont(info_label, 10)
	showCursor(true)

	-- List all train routes
	for k,v in pairs(train_routes) do
		local tmp_row = guiGridListAddRow(routes_list)
		guiGridListSetItemText(routes_list, tmp_row, tmp_col, k, false, false )
	end

	-- Add event handlers
	addEventHandler("onClientGUIClick", close_button, function()
		close_gui()
	end)
	addEventHandler("onClientGUIDoubleClick", routes_list, function()
		local row,col = guiGridListGetSelectedItem(routes_list)
		local route = guiGridListGetItemText(routes_list, row,col)

		-- Send the choice to the server for further instructions
		triggerServerEvent("GTWtraindriver.selectRouteReceive", localPlayer, route)
		
		-- Notice about how to change
		outputChatBox("[Engineer]#BBBBBB Mission assigned, type /routes to change your mission", 255,200,0, true)

		-- Close the GUI
		close_gui()
	end)
end
addEvent("GTWtraindriver.selectRoute", true)
addEventHandler( "GTWtraindriver.selectRoute", root, select_train_route)

--[[ Helperfunction to close the GUI ]]
function close_gui()
	if isElement(window) then destroyElement(window) end
	if isElement(routes_list) then destroyElement(routes_list) end
	showCursor(false)
end

--[[ DX text to display the location of next trainstation ]]
function display_next_station()
	if not next_station.x then return end

	-- Check that the player is still a Train Driver and nothing else
	if not getPlayerTeam(localPlayer) or getPlayerTeam(localPlayer) ~= getTeamFromName("Civilians") then
		if getElementData(localPlayer, "Occupation") ~= "Train Driver" then
			-- alright, something went wrong, fire this driver and station this event.
			removeEventHandler("onClientRender", root, display_next_station)
			end_work( )
			return
		end
	end
	local px,py,pz = getElementPosition(localPlayer)
	local dest = getZoneName(next_station.x, next_station.y, next_station.z)
	local city = getZoneName(next_station.x, next_station.y, next_station.z, true)
	local dist = getDistanceBetweenPoints3D(px,py,pz, next_station.x,next_station.y,next_station.z) or 0
	dxDrawText("traindriver: next station: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-381,sy-31, 0,0, tocolor(0,0,0,200), 0.7, "bankgothic" )
	dxDrawText("traindriver: next station: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-380,sy-30, 0,0, tocolor(220,220,220,200), 0.7, "bankgothic" )
end

--[[ Verify that an event handler actually exist ]]--
function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == "string" and isElement(pElementAttachedTo) and
		type(func) == "function" then
		local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
		if type( aAttachedFunctions ) == "table" and #aAttachedFunctions > 0 then
			for i,v in ipairs(aAttachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end
