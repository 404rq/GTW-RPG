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
local current_delivery_point 	= nil
local current_blip		= nil
local next_payment		= nil
local window			= nil
local next_stop = {
	x = nil,
	y = nil,
	z = nil
}
local sx,sy = guiGetScreenSize()

-- Reset eventual old data on load
setElementData(localPlayer, "GTWtrucker.currentRoute", nil)

--[[ Capture event "EndWork" from GTWcivilians and clean up blips,
	the global command "endwork" works as well]]--
function end_work( )
	if isElement(current_delivery_point) then destroyElement(current_delivery_point) end
	if isElement(current_blip) then destroyElement(current_blip) end
end
addCommandHandler("endwork", end_work)
addEvent("GTWdata_onEndWork", true )
addEventHandler("GTWdata_onEndWork", root, end_work)

--[[ Create next truck stop on current route ]]--
function create_delivery_point(x, y, z)
	-- Destroying previous truck stop if any
	if isElement(current_delivery_point) then destroyElement(current_delivery_point) end
	if isElement(current_blip) then destroyElement(current_blip) end

	-- Create the marker, blip and hit event handler for the new DeliveryPoint
	current_delivery_point = createMarker(x, y, z-2, "cylinder", 4, 255, 255, 255, 50)
	current_blip = createBlipAttachedTo(current_delivery_point, 41, 1, 0, 0, 0, 255, 5, 9999)
	addEventHandler("onClientMarkerHit", current_delivery_point, delivery_point_hit)

	-- Update details for the dx monitor
	next_stop.x = x
	next_stop.y = y
	next_stop.z = z

	-- Calculate the payment for next DeliveryPoint
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
	next_payment = dist*0.6
	if next_payment < 30 then next_payment = 30 end
	if next_payment > 400 then next_payment = 400 end
end
addEvent("GTWtrucker.createDeliveryPoint", true)
addEventHandler("GTWtrucker.createDeliveryPoint", root, create_delivery_point)

--[[ When a truck stops at the truck stop ... ]]--
function delivery_point_hit(plr)
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
	if kmh > 40 then
		exports.GTWtopbar:dm( "You are driving too fast!", 255, 0, 0 )
		return
	end

	-- Alright, everything seems fine here, at this moment we know the
	-- vehicle is a truck thanks to other limitations, don't worry. Time
	-- to apply the handbrake and pay the driver
	local load_time = math.random(25, 40)*1000
	-- Adjust load time for drop off
	local current_stop = getElementData(localPlayer, "GTWtrucker.currentStop") or 1
	if current_stop > 1 then
		load_time = (load_time/(#truck_routes[getElementData(localPlayer, "GTWtrucker.currentRoute")] or 1))
	end
	toggle_controls(false)
	setTimer(toggle_controls, load_time, 1, true)
	setElementData(localPlayer, "GTWtrucker.loadTime", getTickCount()+load_time)
	setElementData(localPlayer, "GTWtrucker.isLoading", true)

	-- Payment has to be done on server side
	triggerServerEvent("GTWtrucker.payTrucker", resourceRoot, next_payment, load_time)

	-- Alright, the driver has been paid, let's clean up some shit and give
	-- him a new truck stop shall we?
	removeEventHandler("onClientMarkerHit", current_delivery_point, delivery_point_hit)
	if isElement(current_delivery_point) then destroyElement(current_delivery_point) end
	if isElement(current_blip) then destroyElement(current_blip) end
end

--[[ Helper function to disable controls ]]--
function toggle_controls(state)
	toggleControl("accelerate", state)
	toggleControl("break_reverse", state)
	setControlState("handbrake", not state)
end

--[[ Pause the route on vehicle exit ]]--
function pause_route(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end

	-- Destroy the truck stop
	if isElement( current_delivery_point ) then
		removeEventHandler("onClientMarkerHit", current_delivery_point, delivery_point_hit)
		destroyElement(current_delivery_point)
	end

	-- Destroy the blip
	if isElement( current_blip ) then
		destroyElement(current_blip)
	end

	-- Remove dx render information to save CPU
	if isEventHandlerAdded("onClientRender", root, display_destination) then
		removeEventHandler("onClientRender", root, display_destination)
	end

	-- Note, all this stuff will be recreated once the driver enter his
	-- verhicle again, maybe he want to take a break for smoking or to
	-- revenge on someone who blocked his way. We're flexible.
end
addEventHandler("onClientVehicleExit", root, pause_route)

function enter_the_truck(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end
	if seat > 0 then return end

	-- Make sure that the vehicle is a truck
	if not truck_vehicles[getElementModel(source)] then return end

	-- Add a render event handler to show information about hte next DeliveryPoint
	addEventHandler("onClientRender", root, display_destination)
end
addEventHandler("onClientVehicleEnter", root, enter_the_truck)

--[[ Opens a GUI in where the driver can pick his route ]]--
function select_truck_route( )
	-- Create the selection GUI
	window = guiCreateWindow((sx-800)/2, (sy-600)/2, 800, 600, "Select truck route", false)
	local close_button = guiCreateButton(680, 560, 110, 36, "Close", false, window)
	local routes_list = guiCreateGridList(10, 30, 780, 530, false, window)
	local tmp_col = guiGridListAddColumn(routes_list, "Route name", 0.9 )
	exports.GTWgui:setDefaultFont(close_button, 10)
	exports.GTWgui:setDefaultFont(routes_list, 10)
	showCursor(true)

	-- List all truck routes
	for k,v in pairs(truck_routes) do
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
		triggerServerEvent("GTWtrucker.selectRouteReceive", localPlayer, route)

		-- Notice about how to change
		outputChatBox("[Trucker]#BBBBBB Mission assigned, type /routes to change your mission", 255,200,0, true)

		-- Close the GUI
		close_gui()
	end)
end
addEvent("GTWtrucker.selectRoute", true)
addEventHandler( "GTWtrucker.selectRoute", root, select_truck_route)

--[[ Helperfunction to close the GUI ]]
function close_gui()
	if isElement(window) then destroyElement(window) end
	if isElement(routes_list) then destroyElement(routes_list) end
	showCursor(false)
end

--[[ DX text to display the location of next DeliveryPoint ]]
function display_destination()
	if not next_stop.x then return end

	-- Manage cargo prefix
	if not getPedOccupiedVehicle(localPlayer) then return end
	local prefix = "kg"
	if getVehicleTowedByVehicle(getPedOccupiedVehicle(localPlayer)) and
		getElementModel(getVehicleTowedByVehicle(
		getPedOccupiedVehicle(localPlayer))) == 584 then
		prefix = "liter"
	end
	-- Check that the player is still a truck driver and nothing else
	if not getPlayerTeam(localPlayer) or getPlayerTeam(localPlayer) ~= getTeamFromName("Civilians") then
		if getElementData(localPlayer, "Occupation") ~= "Trucker" then
			-- alright, something went wrong, fire this driver and stop this event.
			removeEventHandler("onClientRender", root, display_destination)
			end_work( )
			return
		end
	end
	local px,py,pz = getElementPosition(localPlayer)
	local dest = getZoneName(next_stop.x, next_stop.y, next_stop.z)
	local city = getZoneName(next_stop.x, next_stop.y, next_stop.z, true)
	local dist = getDistanceBetweenPoints3D(px,py,pz, next_stop.x,next_stop.y,next_stop.z) or 0
	dxDrawText("Destination: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-381,sy-31, 0,0, tocolor(0,0,0,200), 0.7, "bankgothic" )
	dxDrawText("Destination: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-380,sy-30, 0,0, tocolor(220,220,220,200), 0.7, "bankgothic" )

	if not getElementData(localPlayer, "GTWtrucker.isLoading") then return end
	local time_left = convert_number(math.round(getElementData(localPlayer, "GTWtrucker.loadTime") - getTickCount(), 2))
	dxDrawText("Processing cargo ("..time_left..prefix.." remaining) please wait!",
		(sx/2)-381,sy-53, 0,0, tocolor(0,0,0,255), 0.7, "bankgothic" )
	dxDrawText("Processing cargo ("..time_left..prefix.." remaining) please wait!",
		(sx/2)-380,sy-52, 0,0, tocolor(255,100,0,255), 0.7, "bankgothic" )

	-- Check if finished
	if getElementData(localPlayer, "GTWtrucker.loadTime") <= getTickCount() then
		setElementData(localPlayer, "GTWtrucker.loadTime", nil)
		setElementData(localPlayer, "GTWtrucker.isLoading", nil)
	end
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

--[[ Rounds a number ]]--
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

--[[ Change number formatting style ]]--
function convert_number(number)
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end
