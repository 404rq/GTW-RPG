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
local current_bus_stop 	= nil
local current_blip	= nil
local next_payment	= nil
local window		= nil
local next_stop = {
	x = nil,
	y = nil,
	z = nil
}
local sx,sy = guiGetScreenSize()

--[[ Capture event "EndWork" from GTWcivilians and clean up blips,
	the global command "endwork" works as well]]--
function end_work( )
	if isElement(current_bus_stop) then destroyElement(current_bus_stop) end
	if isElement(current_blip) then destroyElement(current_blip) end
end
addCommandHandler("endwork", end_work)
addEvent("GTWdata_onEndWork", true )
addEventHandler("GTWdata_onEndWork", root, end_work)

--[[ Create next bus stop on current route ]]--
function create_bus_stop(x, y, z)
	-- Destroying previous bus stop if any
	if isElement(current_bus_stop) then destroyElement(current_bus_stop) end
	if isElement(current_blip) then destroyElement(current_blip) end

	-- Create the marker, blip and hit event handler for the new busstop
	current_bus_stop = createMarker(x, y, z-2, "cylinder", 4, 255, 255, 255, 50)
	current_blip = createBlipAttachedTo(current_bus_stop, 41, 1, 0, 0, 0, 255, 5, 9999)
	addEventHandler("onClientMarkerHit", current_bus_stop, bus_stop_hit)

	-- Update details for the dx monitor
	next_stop.x = x
	next_stop.y = y
	next_stop.z = z

	-- Calculate the payment for next busstop
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
	next_payment = dist*0.6
	if next_payment < 30 then next_payment = 30 end
	if next_payment > 400 then next_payment = 400 end
end
addEvent("GTWbusdriver.createBusStop", true)
addEventHandler("GTWbusdriver.createBusStop", root, create_bus_stop)

--[[ When a bus stops at the bus stop ... ]]--
function bus_stop_hit(plr)
	-- Check that the hit element is the local player
	if plr ~= localPlayer then return end

	-- Get the vehicle that just stopped, (if any)
	local veh = getPedOccupiedVehicle(localPlayer)

	-- Did a vehicle stop by or was it something else?
	if not veh then return end

	-- Alright, this was a vehicle, let's see how fast it's driving
	local speedx, speedy, speedz = getElementVelocity ( veh )
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
	local kmh = actualspeed * 180

	-- Did this player drive faster than 30km/h? if so then we tell him he's
	-- an idiot who drove to fast.
	if kmh > 50 then
		exports.GTWtopbar:dm( "You are driving too fast!", 255, 0, 0 )
		return
	end

	-- Alright, everything seems fine here, at this moment we know the
	-- vehicle is a bus thanks to other limitations, don't worry. Time
	-- to apply the handbrake and pay the driver
	setControlState( "handbrake", true )
	setTimer(setControlState, 6000, 1, "handbrake", false)

	-- Payment has to be done on server side
	triggerServerEvent("GTWbusdriver.payBusDriver", resourceRoot, next_payment)

	-- Alright, the driver has been paid, let's clean up some shit and give
	-- him a new bus stop shall we?
	removeEventHandler("onClientMarkerHit", current_bus_stop, bus_stop_hit)
	if isElement(current_bus_stop) then destroyElement(current_bus_stop) end
	if isElement(current_blip) then destroyElement(current_blip) end
end

--[[ Pause the route on vehicle exit ]]--
function pause_route(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end

	-- Destroy the bus stop
	if isElement( current_bus_stop ) then
		removeEventHandler("onClientMarkerHit", current_bus_stop, bus_stop_hit)
		destroyElement(current_bus_stop)
	end

	-- Destroy the blip
	if isElement( current_blip ) then
		destroyElement(current_blip)
	end

	-- Remove dx render information to save CPU
	if isEventHandlerAdded("onClientRender", root, display_next_stop) then
		removeEventHandler("onClientRender", root, display_next_stop)
	end

	-- Note, all this stuff will be recreated once the driver enter his
	-- verhicle again, maybe he want to take a break for smoking or to
	-- revenge on someone who blocked his way. We're flexible.
end
addEventHandler("onClientVehicleExit", root, pause_route)

function enter_the_bus(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end
	if seat > 0 then return end

	-- Make sure that the vehicle is a bus
	if not bus_vehicles[getElementModel(source)] then return end

	-- Add a render event handler to show information about hte next busstop
	addEventHandler("onClientRender", root, display_next_stop)
end
addEventHandler("onClientVehicleEnter", root, enter_the_bus)

--[[ Opens a GUI in where the driver can pick his route ]]--
function select_bus_route( )
	-- Create the selection GUI
	window = guiCreateWindow((sx-600)/2, (sy-350)/2, 600, 350, "Select bus route", false)
	local close_button = guiCreateButton(480, 310, 110, 36, "Close", false, window)
	local routes_list = guiCreateGridList(10, 30, 580, 276, false, window)
	local tmp_col = guiGridListAddColumn(routes_list, "Route name", 0.86 )
	exports.GTWgui:setDefaultFont(close_button, 10)
	exports.GTWgui:setDefaultFont(routes_list, 10)
	showCursor(true)

	-- List all bus routes
	for k,v in pairs(bus_routes) do
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
		triggerServerEvent("GTWbusdriver.selectRouteReceive", localPlayer, route)

		-- Notice about how to change
		outputChatBox("[Busdriver]#BBBBBB Mission assigned, type /routes to change your mission", 255,200,0, true)
		
		-- Close the GUI
		close_gui()
	end)
end
addEvent("GTWbusdriver.selectRoute", true)
addEventHandler( "GTWbusdriver.selectRoute", root, select_bus_route)

--[[ Helperfunction to close the GUI ]]
function close_gui()
	if isElement(window) then destroyElement(window) end
	if isElement(routes_list) then destroyElement(routes_list) end
	showCursor(false)
end

--[[ DX text to display the location of next busstop ]]
function display_next_stop()
	if not next_stop.x then return end

	-- Check that the player is still a bus driver and nothing else
	if not getPlayerTeam(localPlayer) or getPlayerTeam(localPlayer) ~= getTeamFromName("Civilians") then
		if getElementData(localPlayer, "Occupation") ~= "Bus Driver" then
			-- alright, something went wrong, fire this driver and stop this event.
			removeEventHandler("onClientRender", root, display_next_stop)
			end_work( )
			return
		end
	end
	local px,py,pz = getElementPosition(localPlayer)
	local dest = getZoneName(next_stop.x, next_stop.y, next_stop.z)
	local city = getZoneName(next_stop.x, next_stop.y, next_stop.z, true)
	local dist = getDistanceBetweenPoints3D(px,py,pz, next_stop.x,next_stop.y,next_stop.z) or 0
	dxDrawText("Busdriver: next stop: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-381,sy-31, 0,0, tocolor(0,0,0,200), 0.7, "bankgothic" )
	dxDrawText("Busdriver: next stop: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
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
