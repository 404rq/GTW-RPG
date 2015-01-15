--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

--{ x, y, z, dim, int, vehicleX, vehicleY, vehicleZ, vRotZ ,camX, camY, camZ, shopType }
shops_Coords = {
	-- Cars (one in each city)
	{ 1671.5, 2189.1999511719, 9.6999998092651, 0, 0, 1669.5, 2193, 10.800000190735, 180, 1670.3000488281, 2189.6, 11.4, 1 },
	{ -1979.275390625, 240.814453125, 34.17187, 0, 0, -1987.9033203125, 249.564453125, 37.303623199463, 314, -1980.6455078125, 261.7392578125, 39.171875, 1 },
	{ 2130.1999511719, -1149.9000244141, 23.10000038147, 0, 0, 2121.6000976563, -1157, 24.10000038147, 0, 2116.6999511719, -1156.4000244141, 24.6, 1 },
	
	-- Bikes LS
	{ 2410.9150390625, -1390.8447265625, 23.31728935241, 0, 0, 2403.42578125, -1378.7783203125, 23.243619918823, 108.3131103515, 2385.05078125, -1389.0576171875, 28.8828125, 3 },
	{ 1620.166015625, 2186.5546875, 9.8203125, 0, 0, 1629.005859375, 2195.88671875, 10.8203125, 184.53192138672, 1640.82421875, 2182.125, 16.8203125, 3 },
	
	-- Trucks LS, The Farm
	{ 2301.40625, -2333.0087890625, 12.546875, 0, 0, 2279.49609375, -2331.875, 14.046875, 313.70565795898, 2283.9375, -2312.5087890625, 20.541325569153, 6 },
	{ -1061.2890625, -1250.5947265625, 128.21875, 0, 0, -1063.1083984375, -1224.7548828125, 130.21875, 270.47927856445, -1046.2861328125, -1240.22265625, 140.53253173828, 6 },
	
	-- Airplanes LS, SF
	{ 2052.4560546875, -2542.4169921875, 12.54687, 0, 0, 2079.732421875, -2542.501953125, 17.546875, 0, 2058.15234375, -2515.724609375, 20.54687, 4 },
	{ -1366.8486328125, -246.33984375, 13.148437, 0, 0, -1336.396484375, -221.6015625, 17.1484375, 315,  -1334.17578125, -182.90234375, 20, 4 },
	
	-- Sport cars SF, LS
	{ -1649.1796875, 1206.5732421875, 12.671875, 0, 0, -1641.357421875, 1216.326171875, 7.0390625, 229.69764709473, -1618.8994140625, 1210.328125, 11.039062, 2 },
	{ 552.59375, -1260.904296875, 16.2421875, 0, 0, 560.9287109375, -1277.9091796875, 18.2421875, 12.884399414063, 543.1982421875, -1270.82421875, 21.248237609863, 2 },
	
	-- Boats LS, SF
	{ 2725.5244140625, -2576.998046875, 2, 0, 0, 2742.0693359375, -2584.68359375, 1.55000001192093, 265.19476318359, 2758.974609375, -2581.08203125, 7.210937, 5 },
	{ -2975.859375, 503.7783203125, 1.4296875, 0, 0, -2984.7666015625, 503.33203125, 1.55000001192093, 358.05264282227, -2976.998046875, 492.1591796875, 7.42737579345, 5 },
	
	-- Train shop SF
	{ -1602.005859375, 54.0888671875, 2.5546875, 0, 0, -1600.578125, 72.8974609375, 3.5546875, 138.54797363281, -1619.44921875, 69.1064453125, 8, 7 },
}
 
 GUI_Widget = {} 
 shopNames = {
	[1] = "Sport cars",
	[2] = "Muscle cars",
	[3] = "Bikes & motorcycles",
	[4] = "Aircraft",
	[5] = "Watercraft",
	[6] = "Trucks & Vans",
	[7] = "Railroad",
 }
 vehicleBlips = {
	[1] = "car-shop",
	[2] = "car-shop",
	[3] = "bike-shop",
	[4] = "plane-shop",
	[5] = "boat-shop",
	[6] = "truck-shop",
	[7] = "train-shop"
}

dataShop = {}
local gW, gH = guiGetScreenSize()

dummieCar = createVehicle( 602, 0, 0, 0 )
setElementFrozen( dummieCar, false )
setVehicleDamageProof( dummieCar, true )
setVehicleColor( dummieCar, 200, 200, 200, 200, 200, 200 )
	
GUI_Widget[1] = guiCreateButton(0.74, 0.86, 0.21, 0.06, "Buy", true)
guiSetProperty(GUI_Widget[1], "NormalTextColour", "FFAAAAAA")
GUI_Widget[2] = guiCreateGridList(0.06, 0.82, 0.22, 0.17, true)  
GUI_Widget[3] = guiCreateButton(0.98, 0.805, 0.02, 0.02, "X", true )
guiSetProperty(GUI_Widget[3], "NormalTextColour", "FFAAAAAA")
GUI_Widget[4] = guiCreateLabel(0.36, 0.82, 0.32, 0.08, "--", true)
guiSetFont(GUI_Widget[4], "clear-normal")
guiLabelSetHorizontalAlign(GUI_Widget[4], "center", false)
guiLabelSetVerticalAlign(GUI_Widget[4], "center")  
GUI_Widget[5] = guiCreateLabel(0.43, 0.9, 0.18, 0.04, "$0.00", true)
guiLabelSetHorizontalAlign(GUI_Widget[5], "center", false)
guiLabelSetVerticalAlign(GUI_Widget[5], "center")    
	
function renderShopFurning()
	dxDrawRectangle(0, gH * 0.8, gW, gH * 0.2, tocolor(0, 0, 0, 150), false)
end	
for k, i in ipairs( GUI_Widget ) do
	guiSetVisible( i, false )
end	
function reloadShopItems( shopType )
	if shopType then
		guiGridListClear(GUI_Widget[2])
		for cC = 1, guiGridListGetColumnCount( GUI_Widget[2] ) do
			guiGridListRemoveColumn( GUI_Widget[2], 1 )
		end
		if type(shopType) == "number" then
			local column = guiGridListAddColumn( GUI_Widget[2], shopNames[shopType], 0.75 ) 
			for _, data in ipairs ( car_data[shopType] ) do
				local row = guiGridListAddRow( GUI_Widget[2] )
				guiGridListSetItemText( GUI_Widget[2], row, column, getVehicleNameFromModel( data[1] ), false, false )
				guiGridListSetItemData( GUI_Widget[2], row, column, data[3] )
			end
			local vehName = guiGridListGetItemText( GUI_Widget[2], 1, 1 )
			setElementModel( dummieCar, getVehicleModelFromName ( vehName ) )
		end
	end
end

function toggleVehiclesShop( open, x, y, z, cx, cy, cz, rz, int, dim )
	if open then
		if x and y and z and cx and cy and cz then
			toggleAllControls( false, true, false)
			showCursor( true )
			for k, i in ipairs( GUI_Widget ) do
				guiSetVisible( i, true )
			end
			addEventHandler( "onClientRender", root, renderShopFurning )
			setElementPosition(dummieCar, x, y, z)
			setCameraMatrix( cx, cy, cz, x, y, z)
			setElementRotation( dummieCar, 0, 0, tonumber(rz) or 0 )
			if int then
				setElementInterior( dummieCar, int )
			end
			if dim then
				setElementDimension( dummieCar, dim )
			end
		end
	elseif not open then
		for k, i in ipairs( GUI_Widget ) do
			guiSetVisible( i, false )
		end
		removeEventHandler( "onClientRender", getRootElement(), renderShopFurning )
		setCameraTarget( localPlayer )
		toggleAllControls( true, true, true)
		showCursor( false )
		setElementPosition(dummieCar, 0, 0, 0)
		setElementInterior(dummieCar, 0)
		setElementDimension(dummieCar, 0)
		setElementAlpha(dummieCar, 0.0)
		setElementCollisionsEnabled(dummieCar, false)
	end
end
	
addEventHandler( "onClientGUIClick", GUI_Widget[2],
function ()
	local row, column = guiGridListGetSelectedItem ( GUI_Widget[2] )
	if row ~= -1 and column ~= -1 then
		local vehName = guiGridListGetItemText( source, row, column )
		if getVehicleModelFromName ( vehName ) then
			dataShop[1] = guiGridListGetItemText( source, row, column )
			dataShop[2] = tostring(guiGridListGetItemData( GUI_Widget[2], row, column) ) 
			guiSetText(GUI_Widget[4], dataShop[1] )
			guiSetText(GUI_Widget[5], "$"..dataShop[2]*priceMultiplier )
			setElementModel( dummieCar, getVehicleModelFromName ( vehName ) )
		end
	end
end)
	
addEventHandler( "onClientGUIClick", GUI_Widget[3],
function ()
	toggleVehiclesShop( false )
end)
	
addEventHandler( "onClientGUIClick", GUI_Widget[1],
function ()
	local row, column = guiGridListGetSelectedItem ( GUI_Widget[2] )
	if row ~= -1 and column ~= -1 then
		local vehName = guiGridListGetItemText( GUI_Widget[2], row, column )
		if getVehicleModelFromName ( vehName ) then
			if (guiGridListGetItemData ( GUI_Widget[2], row, column)*priceMultiplier) <= getPlayerMoney ( ) then
				local x, y, z = getElementPosition( dummieCar )
				local rx, ry, rz = getElementRotation( dummieCar )
				local dim = getElementDimension( dummieCar )
				local int = getElementInterior( dummieCar )
				triggerServerEvent( "acorp_onPlayerVehicleBuyRequest", localPlayer, getVehicleModelFromName( vehName ), 
					guiGridListGetItemData ( GUI_Widget[2], row, column) * 1000, x, y, z, rx, ry, rz, dim, int )
				toggleVehiclesShop( false )
			else 
				exports.GTWtopbar:dm( "You can't afford this vehicle, you little twat!", 255, 0, 0 )
			end
		end
	end
end)
	
--Shop creation
vehicleShops = {}
for k, i in ipairs( shops_Coords ) do
	local x, y, z, dim, int, vehicleX, vehicleY, vehicleZ, rotZ, camX, camY, camZ, shopType = unpack( i )
	local aMarker = createMarker( x, y, z, "cylinder", 1.6, 200, 200, 200, 50 )
	setElementDimension( aMarker, dim )
	setElementInterior( aMarker, int )
	vehicleShops[aMarker] = {shopType, vehicleX, vehicleY, vehicleZ, camX, camY, camZ, rotZ}
	--createBlip( vehicleX, vehicleY, vehicleZ, vehicleBlips[shopType], 1, 0, 0, 0, 255, 0, 180 )
	--exports["radblips"]:createCustomBlipAt( vehicleX, vehicleY, vehicleBlips[shopType] )
	local blip = exports.customblips:createCustomBlip( x, y, 16, 16, "icon/"..tostring(vehicleBlips[shopType])..".png", 100 ) 
	exports.customblips:setCustomBlipRadarScale( blip, 1.6 )
end
		
addEventHandler( "onClientRender", getRootElement(),
function ( )
	for k, i in pairs ( vehicleShops ) do
		local x, y, z = getElementPosition( k )
		local px, py, pz = getElementPosition( localPlayer )
		if getDistanceBetweenPoints3D( x, y, z + 0.4, px, py, pz ) < 18 then
			local dx, dy = getScreenFromWorldPosition ( x, y, z + 1.4 )
			if dx and dy then
				local text = shopNames[(i[1])]
				dxDrawText( text, dx - ( #text * 2 ), dy - 3, dx + ( #text * 2 ), dy + 2 , tocolor( 250, 250, 250, 250 ), 1, "bankgothic", "center", "center" )
			end
		end
	end
end)

addEventHandler( "onClientMarkerHit", getRootElement(),
function ( thePlayer, matchDim )
	if vehicleShops[source] then
		if matchDim then
			if not isPedInVehicle( thePlayer ) then
				local x, y, z = getElementPosition( localPlayer )
				local mx, my, mz = getElementPosition( source )
				if getDistanceBetweenPoints3D( x, y, z, mx, my, mz ) < 2 then
					local dim, int = getElementDimension( source ), getElementInterior( source ) 
					toggleVehiclesShop( true, vehicleShops[source][2], vehicleShops[source][3], vehicleShops[source][4], vehicleShops[source][5], 
						vehicleShops[source][6], vehicleShops[source][7], vehicleShops[source][8], dim, int )
					reloadShopItems( tonumber(vehicleShops[source][1]) )
					setElementAlpha(dummieCar, 255)
					setElementCollisionsEnabled(dummieCar, true)
				end
			end
		end
	end
end)