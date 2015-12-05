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
local current_tram_station 	= nil
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
	if isElement(current_tram_station) then destroyElement(current_tram_station) end
	if isElement(current_blip) then destroyElement(current_blip) end
end
addCommandHandler("endwork", end_work)
addEvent("GTWdata_onEndWork", true )
addEventHandler("GTWdata_onEndWork", root, end_work)

--[[ Create next tram station on current route ]]--
function create_tram_station(x, y, z)
	-- Destroying previous tram station if any
	if isElement(current_tram_station) then destroyElement(current_tram_station) end
	if isElement(current_blip) then destroyElement(current_blip) end

	-- Create the marker, blip and hit event handler for the new tramstation
	current_tram_station = createMarker(x, y, z-2, "cylinder", 4, 255, 255, 255, 50)
	current_blip = createBlipAttachedTo(current_tram_station, 41, 1, 0, 0, 0, 255, 5, 9999)
	addEventHandler("onClientMarkerHit", current_tram_station, tram_station_hit)

	-- Update details for the dx monitor
	next_station.x = x
	next_station.y = y
	next_station.z = z

	-- Calculate the payment for next tramstation
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
	next_payment = dist*0.6
	if next_payment < 30 then next_payment = 30 end
	if next_payment > 400 then next_payment = 400 end
end
addEvent("GTWtramdriver.createtramstation", true)
addEventHandler("GTWtramdriver.createtramstation", root, create_tram_station)

--[[ When a tram stations at the tram station ... ]]--
function tram_station_hit(plr)
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
	-- vehicle is a tram thanks to other limitations, don't worry. Time
	-- to apply the handbrake and pay the driver
	setTrainSpeed(veh, 0)
	toggle_controls(plr, false)
	setTimer(toggle_controls, 11000, 1, plr, true)

	-- Payment has to be done on server side
	triggerServerEvent("GTWtramdriver.paytramDriver", resourceRoot, next_payment)

	-- Alright, the driver has been paid, let's clean up some shit and give
	-- him a new tram station shall we?
	removeEventHandler("onClientMarkerHit", current_tram_station, tram_station_hit)
	if isElement(current_tram_station) then destroyElement(current_tram_station) end
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

	-- Destroy the tram station
	if isElement( current_tram_station ) then
		removeEventHandler("onClientMarkerHit", current_tram_station, tram_station_hit)
		destroyElement(current_tram_station)
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

function enter_the_tram(plr, seat)
	-- Make sure the driver is the local player
	if plr ~= localPlayer then return end
	if seat > 0 then return end

	-- Make sure that the vehicle is a tram
	if not tram_vehicles[getElementModel(source)] then return end

	-- Add a render event handler to show information about hte next tramstation
	addEventHandler("onClientRender", root, display_next_station)
end
addEventHandler("onClientVehicleEnter", root, enter_the_tram)

--[[ Opens a GUI in where the driver can pick his route ]]--
function select_tram_route( )
	-- Create the selection GUI
	window = guiCreateWindow((sx-450)/2, (sy-300)/2, 450, 300, "Select tram route", false)
	local close_button = guiCreateButton(330, 260, 110, 36, "Close", false, window)
	local routes_list = guiCreateGridList(10, 30, 430, 230, false, window)
	local tmp_col = guiGridListAddColumn(routes_list, "Route name", 0.86 )
	exports.GTWgui:setDefaultFont(close_button, 10)
	exports.GTWgui:setDefaultFont(routes_list, 10)
	showCursor(true)

	-- List all tram routes
	for k,v in pairs(tram_routes) do
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
		triggerServerEvent("GTWtramdriver.selectRouteReceive", localPlayer, route)

		-- Close the GUI
		close_gui()
	end)
end
addEvent("GTWtramdriver.selectRoute", true)
addEventHandler( "GTWtramdriver.selectRoute", root, select_tram_route)

--[[ Helperfunction to close the GUI ]]
function close_gui()
	if isElement(window) then destroyElement(window) end
	if isElement(routes_list) then destroyElement(routes_list) end
	showCursor(false)
end

--[[ DX text to display the location of next tramstation ]]
function display_next_station()
	if not next_station.x then return end

	-- Check that the player is still a Tram Driver and nothing else
	if not getPlayerTeam(localPlayer) or getPlayerTeam(localPlayer) ~= getTeamFromName("Civilians") then
		if getElementData(localPlayer, "Occupation") ~= "Tram Driver" then
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
	dxDrawText("tramdriver: next station: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
		(sx/2)-381,sy-31, 0,0, tocolor(0,0,0,200), 0.7, "bankgothic" )
	dxDrawText("tramdriver: next station: "..dest..", in "..city..". Distance: "..math.floor(dist).."m",
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
