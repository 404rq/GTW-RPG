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

--{ x, y, z, dim, int, vehicleX, vehicleY, vehicleZ, vRotZ ,camX, camY, camZ, shopType }
shops_Coords = {
	-- LS ghetto (Lowriders & Muscle cars)
	{ 2130.1999511719, -1149.9000244141, 23.10000038147, 0, 0, 2121.6000976563, -1157, 24.10000038147, 0, 2116.6999511719, -1156.4000244141, 24.6, 7 },

	-- SF Wang autos (Suvs & Wagons)
	{ -1979.275390625, 240.814453125, 34.17187, 0, 0, -1987.9033203125, 249.564453125, 37.303623199463, 314, -1980.6455078125, 261.7392578125, 39.171875, 9 },

	-- LV gas down town station (Lowriders & Muscle cars)
	{ 1671.5, 2189.1999511719, 9.6999998092651, 0, 0, 1669.5, 2193, 10.800000190735, 180, 1670.3000488281, 2189.6, 11.4, 7 },

	-- LS, SF, LV (Bikes & Motorcycles)
	{ 2410.9150390625, -1390.8447265625, 23.31728935241, 0, 0, 2403.42578125, -1378.7783203125, 23.243619918823, 108.3131103515, 2385.05078125, -1389.0576171875, 28.8828125, 4 },
	{ -2222.7275390625, 288.10546875, 34.3203125, 0, 0, -2218.65625, 292.9560546875, 36.1171875, 0,  -2224.5205078125, 305.6826171875, 41, 4 },
	{ 1620.166015625, 2186.5546875, 9.8203125, 0, 0, 1629.005859375, 2195.88671875, 10.8203125, 184.53192138672, 1640.82421875, 2182.125, 16.8203125, 4 },

	-- LS docks, The Farm (Trucks & Vans)
	{ 2301.40625, -2333.0087890625, 12.546875, 0, 0, 2279.49609375, -2331.875, 14.046875, 313.70565795898, 2283.9375, -2312.5087890625, 20.541325569153, 6 },
	{ -1061.2890625, -1250.5947265625, 128.21875, 0, 0, -1063.1083984375, -1224.7548828125, 130.21875, 270.47927856445, -1046.2861328125, -1240.22265625, 140.53253173828, 6 },

	-- LS, SF, LV (Airplanes)
	{ 2052.4560546875, -2542.4169921875, 12.54687, 0, 0, 2079.732421875, -2542.501953125, 17.546875, 0, 2058.15234375, -2515.724609375, 20.54687, 3 },
	{ -1366.8486328125, -246.33984375, 13.148437, 0, 0, -1336.396484375, -221.6015625, 17.1484375, 315,  -1334.17578125, -182.90234375, 20, 3 },
	{ 1549.1767578125, 1738.0966796875, 9.8203125, 0, 0, 1527.3544921875, 1785.4052734375, 10.8203125, 180,  1512.5234375, 1712.833984375, 20, 3 },

	-- SF sport cars shop (street racers)
	{ -1649.1796875, 1206.5732421875, 12.671875, 0, 0, -1641.357421875, 1216.326171875, 7.0390625, 229.69764709473, -1618.8994140625, 1210.328125, 11.039062, 8 },

	-- LS rodeo parking lot (2 door compact) (4 door luxury)
	{ 552.59375, -1260.904296875, 16.2421875, 0, 0, 560.9287109375, -1277.9091796875, 18.2421875, 12.884399414063, 543.1982421875, -1270.82421875, 21.248237609863, 1 },
	{ 549.59375, -1264.904296875, 16.2421875, 0, 0, 565.9287109375, -1277.9091796875, 18.7421875, 12.884399414063, 543.1982421875, -1270.82421875, 21.248237609863, 2 },

	-- LS, SF, LV docks (Boats)
	{ 2725.5244140625, -2576.998046875, 2, 0, 0, 2742.0693359375, -2584.68359375, 1.55000001192093, 265.19476318359, 2758.974609375, -2581.08203125, 7.210937, 5 },
	{ -2975.859375, 503.7783203125, 1.4296875, 0, 0, -2984.7666015625, 503.33203125, 1.55000001192093, 358.05264282227, -2976.998046875, 492.1591796875, 7.42737579345, 5 },
	{ 2298.39453125, 525.5869140625, 0.794376373291, 0, 0, 2295.42578125, 517.0576171875, 1.2, 90, 2287.1796875, 528.7451171875, 10.1161499023438, 5 },

	-- SF docks (Trains)
	{ -1602.005859375, 54.0888671875, 2.5546875, 0, 0, -1600.578125, 72.8974609375, 3.5546875, 138.54797363281, -1619.44921875, 69.1064453125, 8, 10 },
}

 GUI_Widget = {}
 shopNames = {
	[1] = "Compact sport cars",
	[2] = "Luxury cars",
	[3] = "Aircraft",
	[4] = "Bikes & motorcycles",
	[5] = "Boats",
	[6] = "Trucks & Vans",
	[7] = "Muscle cars",
	[8] = "Street racers",
	[9] = "Suvs & Wagons",
	[10] = "Railroad",
 }
 vehicleBlips = {
	[1] = "car-shop",
	[2] = "car-shop",
	[3] = "plane-shop",
	[4] = "bike-shop",
	[5] = "boat-shop",
	[6] = "truck-shop",
	[7] = "car-shop",
	[8] = "car-shop",
	[9] = "car-shop",
	[10] = "train-shop"
}

dataShop = {}
local gW, gH = guiGetScreenSize()

dummieCar = createVehicle(602, 0, 0, 0)
setElementFrozen(dummieCar, false)
setVehicleDamageProof(dummieCar, true)
setVehicleColor(dummieCar, 200, 200, 200, 200, 200, 200)

btn_buy = guiCreateButton(0.74, 0.86, 0.21, 0.06, "Buy", true)
guiSetProperty(btn_buy, "NormalTextColour", "FFAAAAAA")
vehicle_list_shop = guiCreateGridList(0.01, 0.81, 0.25, 0.18, true)
btn_close = guiCreateButton(0.98, 0.805, 0.02, 0.02, "X", true)
guiSetProperty(btn_close, "NormalTextColour", "FFAAAAAA")
lbl_name = guiCreateLabel(0.36, 0.81, 0.32, 0.08, "--", true)
guiSetFont(lbl_name, "clear-normal")
guiLabelSetHorizontalAlign(lbl_name, "center", false)
guiLabelSetVerticalAlign(lbl_name, "center")
lbl_price = guiCreateLabel(0.43, 0.91, 0.18, 0.04, "$0.00", true)
guiLabelSetHorizontalAlign(lbl_price, "center", false)
guiLabelSetVerticalAlign(lbl_price, "center")

-- Apply new GUI style
exports.GTWgui:setDefaultFont(btn_buy, 16)
exports.GTWgui:setDefaultFont(btn_close, 10)
exports.GTWgui:setDefaultFont(lbl_name, 14)
exports.GTWgui:setDefaultFont(lbl_price, 20)
exports.GTWgui:setDefaultFont(vehicle_list_shop, 10)

function renderShopFurning()
	dxDrawRectangle(0, gH * 0.8, gW, gH * 0.2, tocolor(0, 0, 0, 150), false)
end
guiSetVisible(vehicle_list_shop, false)
guiSetVisible(btn_close, false)
guiSetVisible(btn_buy, false)
guiSetVisible(lbl_name, false)
guiSetVisible(lbl_price, false)

--[[ Reload shop items list ]]--
function reloadShopItems(shopType)
	if not shopType then return end
	guiGridListClear(vehicle_list_shop)
	for cC = 1, guiGridListGetColumnCount(vehicle_list_shop) do
		guiGridListRemoveColumn(vehicle_list_shop, 1)
	end
	if type(shopType) ~= "number" then return end
	local column = guiGridListAddColumn(vehicle_list_shop, shopNames[shopType], 0.75)

	-- List available vehicles
	for _, data in ipairs(car_data[shopType]) do
		local row = guiGridListAddRow(vehicle_list_shop)
		guiGridListSetItemText(vehicle_list_shop, row, column, getVehicleNameFromModel(data[1]), false, false)
		guiGridListSetItemData(vehicle_list_shop, row, column, data[3])
	end

	-- Get name from dummie car
	local vehName = guiGridListGetItemText(vehicle_list_shop, 1, 1)
	setElementModel(dummieCar, getVehicleModelFromName(vehName))

	-- Select first item
	guiGridListSetSelectedItem(vehicle_list_shop, 0, column)
end

--[[ Toggle shop window ]]--
function toggleVehiclesShop(open, x, y, z, cx, cy, cz, rz, int, dim)
	if open then
		if x and y and z and cx and cy and cz then
			toggleAllControls(false, true, false)
			showCursor(true)
			guiSetVisible(vehicle_list_shop, true)
			guiSetVisible(btn_close, true)
			guiSetVisible(btn_buy, true)
			guiSetVisible(lbl_name, true)
			guiSetVisible(lbl_price, true)
			addEventHandler("onClientRender", root, renderShopFurning)
			setElementPosition(dummieCar, x, y, z)
			setCameraMatrix(cx, cy, cz, x, y, z)
			setElementRotation(dummieCar, 0, 0, tonumber(rz) or 0)
			if int then
				setElementInterior(dummieCar, int)
			end
			if dim then
				setElementDimension(dummieCar, dim)
			end
		end
	elseif not open then
		guiSetVisible(vehicle_list_shop, false)
		guiSetVisible(btn_close, false)
		guiSetVisible(btn_buy, false)
		guiSetVisible(lbl_name, false)
		guiSetVisible(lbl_price, false)
		removeEventHandler("onClientRender", getRootElement(), renderShopFurning)
		setCameraTarget(localPlayer)
		toggleAllControls(true, true, true)
		showCursor(false)
		setElementPosition(dummieCar, 0, 0, 0)
		setElementInterior(dummieCar, 0)
		setElementDimension(dummieCar, 0)
		setElementAlpha(dummieCar, 0.0)
		setElementCollisionsEnabled(dummieCar, false)
	end
end

--[[ GUI elements click ]]--
addEventHandler("onClientGUIClick", vehicle_list_shop,
function()
	local row, column = guiGridListGetSelectedItem(vehicle_list_shop)
	if row == -1 or column == -1 then return end
	local vehName = guiGridListGetItemText(source, row, column)
	if getVehicleModelFromName(vehName) then
		dataShop[1] = guiGridListGetItemText(source, row, column)
		dataShop[2] = tostring(guiGridListGetItemData(vehicle_list_shop, row, column))
		guiSetText(lbl_name, dataShop[1])
		guiSetText(lbl_price, "$"..dataShop[2]*priceMultiplier)
		setElementModel(dummieCar, getVehicleModelFromName(vehName))
	end
end)
addEventHandler("onClientGUIClick", btn_buy,
function()
	local row, column = guiGridListGetSelectedItem(vehicle_list_shop)
	if row == -1 or column == -1 then return end
	local vehName = guiGridListGetItemText(vehicle_list_shop, row, column)
	if getVehicleModelFromName(vehName) then
		if guiGridListGetItemData(vehicle_list_shop, row, column)*priceMultiplier <= getPlayerMoney() then
			local x, y, z = getElementPosition(dummieCar)
			local rx, ry, rz = getElementRotation(dummieCar)
			local dim = getElementDimension(dummieCar)
			local int = getElementInterior(dummieCar)
			triggerServerEvent("GTWvehicleshop.onPlayerVehicleBuyRequest", localPlayer, getVehicleModelFromName(vehName),
				guiGridListGetItemData(vehicle_list_shop, row, column) * 1000, x, y, z, rx, ry, rz, dim, int)
			toggleVehiclesShop(false)
		else
			exports.GTWtopbar:dm("You can't afford this vehicle, you little twat!", 255, 0, 0)
		end
	end
end)
addEventHandler("onClientGUIClick", btn_close,
function()
	toggleVehiclesShop(false)
end)

--[[ Shop creation ]]--
vehicleShops = {}
for k, i in ipairs(shops_Coords) do
	local x, y, z, dim, int, vehicleX, vehicleY, vehicleZ, rotZ, camX, camY, camZ, shopType = unpack(i)
	local aMarker = createMarker(x, y, z, "cylinder", 1.6, 200, 200, 200, 50)
	setElementDimension(aMarker, dim)
	setElementInterior(aMarker, int)
	vehicleShops[aMarker] = {shopType, vehicleX, vehicleY, vehicleZ, camX, camY, camZ, rotZ}
	--createBlip(vehicleX, vehicleY, vehicleZ, vehicleBlips[shopType], 1, 0, 0, 0, 255, 0, 180)
	--exports["radblips"]:createCustomBlipAt(vehicleX, vehicleY, vehicleBlips[shopType])
	local blip = exports.customblips:createCustomBlip(x, y, 16, 16, "icon/"..tostring(vehicleBlips[shopType])..".png", 100)
	exports.customblips:setCustomBlipRadarScale(blip, 1.6)
end

--[[ Draw label info ]]--
addEventHandler("onClientRender", getRootElement(),
function()
	for k, i in pairs(vehicleShops) do
		local x, y, z = getElementPosition(k)
		local px, py, pz = getElementPosition(localPlayer)
		if getDistanceBetweenPoints3D(x, y, z + 0.4, px, py, pz) < 18 then
			local dx, dy = getScreenFromWorldPosition(x, y, z + 1.4)
			if dx and dy then
				local text = shopNames[(i[1])]
				dxDrawText(text, dx -(#text * 2), dy - 3, dx +(#text * 2), dy + 2 , tocolor(250, 250, 250, 250), 1, "bankgothic", "center", "center")
			end
		end
	end
end)

--[[ Hit vehicle marker ]]--
addEventHandler("onClientMarkerHit", getRootElement(),
function(thePlayer, matchDim)
	if vehicleShops[source] then
		if matchDim then
			if not isPedInVehicle(thePlayer) then
				local x, y, z = getElementPosition(localPlayer)
				local mx, my, mz = getElementPosition(source)
				if getDistanceBetweenPoints3D(x, y, z, mx, my, mz) < 2 then
					local dim, int = getElementDimension(source), getElementInterior(source)
					toggleVehiclesShop(true, vehicleShops[source][2], vehicleShops[source][3], vehicleShops[source][4], vehicleShops[source][5],
						vehicleShops[source][6], vehicleShops[source][7], vehicleShops[source][8], dim, int)
					reloadShopItems(tonumber(vehicleShops[source][1]))
					setElementAlpha(dummieCar, 255)
					setElementCollisionsEnabled(dummieCar, true)
				end
			end
		end
	end
end)
