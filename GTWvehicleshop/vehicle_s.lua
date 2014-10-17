--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

-- Global data
veh_data = dbConnect("sqlite", "veh.db")
inventory_items = {{ }}
inventory_markers = {}
vehicle_owners = {}
vehicles = {}
veh_blips = {}
veh_id_num = {}
veh_save_timers = {}
cooldown_vehshop_enter = {}
is_demo_ex = {}

--[[ Save the new bought vehcile to the database ]]--
function vehicleBuyRequest( model )
   	if model and not isGuestAccount( getPlayerAccount( client )) then
   		local price = 100
   		for x=1, #car_data do
   			for y=1, #car_data[x] do
   				if car_data[x][y][1] == model then
   					price = car_data[x][y][3]
   					break
   				end
   			end
   		end
   		price = price*priceMultiplier
		if model and price and getPlayerMoney(client) >= price then
			takePlayerMoney( client, price )
			exports.GTWtopbar:dm( "You have bought a "..getVehicleNameFromModel( model ), client, 0, 255, 0 )
			
			-- Save new vehicles to database
			dbExec(veh_data, "INSERT INTO vehicles VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?)", 
				getAccountName(getPlayerAccount( client )), model, 0, 0, 100, 100, 3, toJSON({0,0,0, 0,0,0}), 
				toJSON({200,200,200, 200,200,200, 0,0,0, 0,0,0}), toJSON({}), toJSON({}), toJSON({}))
		elseif getPlayerMoney(client) < price then
			exports.GTWtopbar:dm( "You can't afford this vehicle you little twat!", client, 255, 0, 0 )
		end
	else
	   	exports.GTWtopbar:dm( "You must be logged in to buy a vehicle!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onPlayerVehicleBuyRequest", true )
addEventHandler( "acorp_onPlayerVehicleBuyRequest", root, vehicleBuyRequest )

--[[ Create a database table to store vehicle data ]]--
addEventHandler("onResourceStart", getResourceRootElement(),
function()	
	dbExec(veh_data, "CREATE TABLE IF NOT EXISTS vehicles (ID INTEGER PRIMARY KEY, owner TEXT, model NUMERIC, "..
		"locked NUMERIC, engine NUMERIC, health NUMERIC, fuel NUMERIC, paint NUMERIC, pos TEXT, color TEXT, upgrades TEXT, inventory TEXT, headlight TEXT)")	
	
	-- Load all demo vehicles in the shops
	--[[local XMLCarLocations = xmlLoadFile ( "vehicle_shop_map.xml" )
	if ( not XMLCarLocations ) then
		local XMLCarLocations = xmlCreateFile ( "vehicle_shop_map.xml", "veh_map" )
		xmlSaveFile ( XMLBusLocations )
	end
	local car_locations = xmlNodeGetChildren(XMLCarLocations)
    carLocations = {}
    for i,node in ipairs(car_locations) do
		carLocations[i] = {}
		local routes = xmlNodeGetChildren(node)
		for is,subNode in ipairs(routes) do
			-- Vehicle type
			carLocations[i][is] = {}
			carLocations[i][is]["veh"] = xmlNodeGetAttribute ( subNode, "veh" )
			-- Location data
			carLocations[i][is]["x"] = xmlNodeGetAttribute ( subNode, "posX" )
			carLocations[i][is]["y"] = xmlNodeGetAttribute ( subNode, "posY" )
			carLocations[i][is]["z"] = xmlNodeGetAttribute ( subNode, "posZ" )
			carLocations[i][is]["rx"] = xmlNodeGetAttribute ( subNode, "rotX" )
			carLocations[i][is]["ry"] = xmlNodeGetAttribute ( subNode, "rotY" )
			carLocations[i][is]["rz"] = xmlNodeGetAttribute ( subNode, "rotZ" )
			
			--Create it
			local veh = createVehicle( carLocations[i][is]["veh"], carLocations[i][is]["x"], carLocations[i][is]["y"], 
				carLocations[i][is]["z"]-0.3, carLocations[i][is]["rx"], carLocations[i][is]["ry"], carLocations[i][is]["rz"] )
			setVehicleColor ( veh, 200,200,200, 200,200,200 )
			setElementDimension(veh,111)
			is_demo_ex[veh] = true
				
			-- Disable some features
			setVehicleDamageProof( veh, true )
			setTimer( fixVehicle, 3000000, 0, veh )
			setTimer( respawnVehicle, 3000000, 0, veh )
		end
    end
    xmlUnloadFile ( XMLCarLocations )]]--
end)

--[[ Loads all vehicles for a specific player, requires that the player is logged in ]]--
function loadMyVehicles(query)
	local result = dbPoll( query, 0 )
	if result then
    	for _, row in ipairs( result ) do
            addVehicle(row["ID"], row["owner"], row["model"], row["locked"], row["engine"], 
            	row["health"], row["fuel"], row["paint"], row["pos"], row["color"], 
            	row["upgrades"], row["inventory"], row["headlight"])        
    	end
	end
end
function getMyVehicles(veh_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and 
		getElementInterior(client) == 0 and getElementDimension(client) == 0 then
		dbQuery(loadMyVehicles, veh_data, "SELECT * FROM vehicles WHERE owner=? AND ID=?", getAccountName(getPlayerAccount( client )), tonumber(veh_id))
	elseif getElementInterior(client) ~= 0 or getElementDimension(client) ~= 0 then
		exports.GTWtopbar:dm( "You can't use vehicles inside!", client, 255, 0, 0 )
	elseif not veh_id then
		exports.GTWtopbar:dm( "Please specify vehicle ID to show it!", client, 255, 0, 0 )
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onShowVehicles", true )
addEventHandler( "acorp_onShowVehicles", root, getMyVehicles )

--[[ Loads all vehicles for a specific player, requires that the player is logged in ]]--
function unloadMyVehicles(query)
	local result = dbPoll( query, 0 )
	if result then
    	for _, row in ipairs( result ) do
            saveAndRemoveVehicle(vehicles[row["ID"]],true)        
    	end
	end
end
function hideMyVehicles(veh_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id then
		dbQuery(unloadMyVehicles, veh_data, "SELECT * FROM vehicles WHERE owner=? AND ID=?", getAccountName(getPlayerAccount( client )), tonumber(veh_id))
	elseif not veh_id then
		exports.GTWtopbar:dm( "Please specify vehicle ID to hide it!", client, 255, 0, 0 )
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onHideVehicles", true )
addEventHandler( "acorp_onHideVehicles", root, hideMyVehicles )

--[[ Loads all vehicles for a specific player, requires that the player is logged in ]]--
function listAllMyVehicles(query)
	local result = dbPoll( query, 0 )
	if result then
		local vehicle_data_to_client = {{ }}
		local player = nil
    	for index, row in ipairs( result ) do
    		-- Get all relevant data for the vehicle
    		vehicle_data_to_client[index] = { }
    		vehicle_data_to_client[index][1] = tonumber(row["ID"])
    		vehicle_data_to_client[index][2] = tonumber(row["model"])
    		vehicle_data_to_client[index][3] = tonumber(row["health"])
    		vehicle_data_to_client[index][4] = tonumber(row["fuel"])
    		vehicle_data_to_client[index][5] = tonumber(row["locked"])
    		vehicle_data_to_client[index][6] = tonumber(row["engine"])
    		vehicle_data_to_client[index][7] = row["pos"]
    		player = getAccountPlayer( getAccount( row["owner"] ))
    	end
    	
    	-- Send data to client
    	if player then
    		triggerClientEvent( player, "acorp_onReceivePlayerVehicleData", player, vehicle_data_to_client ) 
		end    		
	end
end
function listMyVehicles( )
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) then
		dbQuery(listAllMyVehicles, veh_data, "SELECT * FROM vehicles WHERE owner=?", getAccountName(getPlayerAccount( client )))
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onListVehicles", true )
addEventHandler( "acorp_onListVehicles", root, listMyVehicles )

--[[ Create a vehicle based on data from the vehicle database ]]--
function addVehicle(ID, owner, model, lock, engine, health, fuel, paint, pos, color, upgrades, inventory, hlight)
	if not vehicles[ID] then
		local x,y,z, rx,ry,rz = unpack( fromJSON( pos ))
		local isFirstSpawn = false
		if x == 0 and y == 0 and z == 0 then
			x,y,z = getElementPosition( getAccountPlayer( getAccount( owner )))
			z = z + 3
			isFirstSpawn = true
		end
		if tonumber( getElementData( getAccountPlayer( getAccount( owner )), "Wanted" )) < 3 then
			local veh = createVehicle( tonumber( model ), x,y,z )
			if supported_cars[getElementModel(veh)] then
				local dist = supported_cars[getElementModel(veh)]
				inventory_markers[veh] = createMarker(0, 0, -100, "cylinder", 3, 0, 0, 0, 0 )
				attachElements(inventory_markers[veh],veh,0,supported_cars[getElementModel(veh)],-1)
				addEventHandler( "onMarkerHit", inventory_markers[veh], 
				function(hitElement,matchingDimension)
					if hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
						getAccountName(getPlayerAccount(hitElement)) == owner then
						exports.GTWtopbar:dm( "Vehicle: Press F4 to open your trunk where you can store items", hitElement, 0, 255, 0 )
						setElementData(hitElement,"isNearTrunk",veh)
					end						
				end) 
				addEventHandler( "onMarkerLeave", inventory_markers[veh], 
				function(hitElement,matchingDimension)
					if hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
						getAccountName(getPlayerAccount(hitElement)) == owner then
						setElementData(hitElement,"isNearTrunk",nil)
					end						
				end) 
			end
			if isFirstSpawn then
				warpPedIntoVehicle( getAccountPlayer( getAccount( owner )), veh )
			end
			veh_blips[veh] = createBlipAttachedTo( veh, 0, 1, 100, 100, 100, 200, 10, 9999, getAccountPlayer( getAccount( owner )))
			setElementRotation( veh, rx, ry, rz )					
			vehicle_owners[veh] = owner
			veh_id_num[veh] = ID
			vehicles[ID] = veh
			local ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db = unpack( fromJSON( color ))
			local locked = false
			if lock == 1 then
				locked = true
			end
			if hlight then
				local hr,hg,hb = unpack( fromJSON( hlight ))
				if hr and hg and hb then
					setVehicleHeadLightColor( veh, hr, hg, hb )
				end
			end
			setVehicleColor( veh, ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db )
			setVehiclePaintjob( veh, tonumber( paint ))
			setVehicleLocked( veh, locked )
			setElementData( veh, "vehicleFuel", tonumber(fuel))
			setElementHealth( veh, tonumber(health*10))
			setElementData( veh, "owner", owner )
			setElementData( veh, "isOwnedVehicle", tonumber(ID))
			if getElementHealth( veh ) < 300 then
				setElementHealth( veh, 300 )
			end
			for k, i in ipairs( fromJSON( upgrades )) do
				addVehicleUpgrade( veh, i )
			end
			inventory_items[veh] = {}
			if inventory then
				for k, i in ipairs( fromJSON( inventory )) do
					inventory_items[veh][k] = i
				end
			end
		else
			exports.GTWtopbar:dm( "Due to your wanted level you can't use this feature!", client, 255, 0, 0 )
		end
	end
end

--[[ Manage saving of vehicle data ]]--
function saveVehicleData( thePlayer, seat, jacked )
	if vehicle_owners[source] then
		if isTimer(veh_save_timers[thePlayer]) then
			killTimer(veh_save_timers[thePlayer])
		end
   		veh_save_timers[thePlayer] = setTimer(saveVehicle, 5000, 0, source )
   	end
   	-- Show the price
	--[[if is_demo_ex[source] then
		outputChatBox( "Use /buyveh to purchase this "..getVehicleName(source).." for: $"..car_data[getElementModel(source)][2], thePlayer, 255, 200, 0)
		exports.GTWtopbar:dm( "Use /buyveh to purchase this "..getVehicleName(source).." for: $"..car_data[getElementModel(source)][2], thePlayer, 255, 200, 0)
	end]]--
end
addEventHandler( "onVehicleEnter", getRootElement(), saveVehicleData )
function vehicleExit( thePlayer, seat, jacked )
    if isTimer(veh_save_timers[thePlayer]) then
		killTimer(veh_save_timers[thePlayer])
	end
end
addEventHandler( "onVehicleExit", root, vehicleExit )
function saveVehicle(veh)
	if veh and isElement(veh) then
		saveAndRemoveVehicle(veh, false)
	end
end

--[[ Destroys and saves a vehicle into vehicle database ]]--
function saveAndRemoveVehicle(veh,removeVeh)
	-- Ensure that the vehicle is owned by a player
	if vehicle_owners[veh] then
		-- Get vehicle data
		local x,y,z = getElementPosition( veh )
		local ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db = getVehicleColor( veh, true )
		local rx,ry,rz = getElementRotation( veh )
		local fuel = getElementData( veh, "vehicleFuel" )
		local paint = getVehiclePaintjob( veh )
		local health = tostring(math.floor(tonumber(getElementHealth( veh ))/10))
		local locked = 0
		if isVehicleLocked( veh ) then
			locked = 1
		end
		local engine = 0
		if getVehicleEngineState( veh ) then
			engine = 1
		end
		local ID = getElementData( veh, "isOwnedVehicle" )
		if ID then
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET owner=?, locked=?, engine=?, health=?, fuel=?, paint=?, pos=?, color=?, upgrades=?, inventory=? WHERE ID=?", 
				vehicle_owners[veh], locked, engine, health, fuel, paint, toJSON({x,y,z, rx,ry,rz}), 
				toJSON({ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db}), toJSON(getVehicleUpgrades( veh )), toJSON(inventory_items[veh]), ID)
						
			-- Clean up and free memory
			if removeVeh then
				-- Remove inventory marker
				if inventory_markers[veh] and isElement(inventory_markers[veh]) then
					destroyElement(inventory_markers[veh])
				end	
				vehicles[ID] = nil
				vehicle_owners[veh] = nil
				destroyElement(veh_blips[veh])
				destroyElement(veh)
			end
		end
	elseif isElement(veh) then
		destroyElement(veh)
	end
end
addEvent( "acorp_onPlayerVehicleDestroy", true )
addEventHandler ( "acorp_onPlayerVehicleDestroy", root, saveAndRemoveVehicle )

--[[ Lock vehicle from client ]]--
function lockVehicle(veh_id, lock_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and 
		veh_id and vehicles[veh_id] and isElement(vehicles[veh_id]) then
		if isVehicleLocked( vehicles[veh_id] ) then
			setVehicleLocked( vehicles[veh_id], false )
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET locked=? WHERE ID=?", 0, veh_id)
			exports.GTWtopbar:dm( "Your vehicle has been unlocked!", client, 0, 255, 0 )
		else
			setVehicleLocked( vehicles[veh_id], true )
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET locked=? WHERE ID=?", 1, veh_id)
			exports.GTWtopbar:dm( "Your vehicle has been locked!", client, 0, 255, 0 )
		end
	elseif getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and lock_id then
		-- Save to database
		dbExec(veh_data, "UPDATE vehicles SET locked=? WHERE ID=?", lock_id, veh_id)
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onLockVehicle", true )
addEventHandler( "acorp_onLockVehicle", root, lockVehicle )

--[[ Toggle vehicle engine state from client ]]--
function toggleVehicleEngine(veh_id, engine_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and 
		veh_id and vehicles[veh_id] and isElement(vehicles[veh_id]) then
		if getVehicleEngineState( vehicles[veh_id] ) then
			setVehicleEngineState( vehicles[veh_id], false )
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET engine=? WHERE ID=?", 0, veh_id)
			exports.GTWtopbar:dm( "Vehicle engine was turned off!", client, 0, 255, 0 )
		else
			setVehicleEngineState( vehicles[veh_id], true )
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET engine=? WHERE ID=?", 1, veh_id)
			exports.GTWtopbar:dm( "Vehicle engine was turned on!", client, 0, 255, 0 )
		end
	elseif getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and engine_id then
		-- Save to database
		dbExec(veh_data, "UPDATE vehicles SET engine=? WHERE ID=?", engine_id, veh_id)
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onVehicleEngineToggle", true )
addEventHandler( "acorp_onVehicleEngineToggle", root, toggleVehicleEngine )

--[[ Sell a vehicle from client GUI ]]--
function sellVehicle(veh_id, model)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and model then
		-- Save to database
		dbExec(veh_data, "DELETE FROM vehicles WHERE ID=?", veh_id)
		local price = 0
		for i=1, #car_data do
			if car_data[i] then
				for key, value in pairs(car_data[i]) do
					if value[1] and value[1] == model then				
						price = value[3]
					end
				end
			end
		end
		
		if isElement(vehicles[veh_id]) then
			destroyElement(vehicles[veh_id])
			vehicles[veh_id] = nil
		end
		
		givePlayerMoney(client, math.floor(price*priceMultiplier*0.9))
		exports.GTWtopbar:dm( "Your vehicle has been sold for 90% of it's price", client, 0, 255, 0 )
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onVehicleSell", true )
addEventHandler( "acorp_onVehicleSell", root, sellVehicle )

--[[ Respawn a broken vehicle ]]--
function respawnVehicleToStart(veh_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and 
		veh_id and not vehicles[veh_id] and not isElement(vehicles[veh_id]) then
		local price = 999
		if price and getPlayerMoney(client) > price then
			takePlayerMoney( client, price )
			-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET pos=? WHERE ID=?", toJSON({ 0,0,0, 0,0,0 }), veh_id)
			exports.GTWtopbar:dm( "Your vehicle has been respawned!", client, 0, 255, 0 )
		else
			exports.GTWtopbar:dm( "Poor bastard, you can't afford to recover your vehicle, you need 999$!", client, 255, 0, 0 )
		end
	elseif vehicles[veh_id] and isElement(vehicles[veh_id]) then
		exports.GTWtopbar:dm( "You must hide your vehicle before you can recover it!", client, 255, 0, 0 )
	elseif not getPlayerAccount( client ) or isGuestAccount( getPlayerAccount( client )) then
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "acorp_onVehicleRespawn", true )
addEventHandler( "acorp_onVehicleRespawn", root, respawnVehicleToStart )

--[[ Toggle vehicle engine state from client ]]--
function vehicleHeadLightColors(player, cmd, r,g,b)
    if getPlayerAccount( player ) and not isGuestAccount( getPlayerAccount( player )) and
        r and g and b and veh_id_num[getPedOccupiedVehicle(player)] then      
       	-- Save to database and update colors
        dbExec(veh_data, "UPDATE vehicles SET headlight=? WHERE ID=?", toJSON({r,g,b}), veh_id_num[getPedOccupiedVehicle(player)])
        setVehicleHeadLightColor( getPedOccupiedVehicle(player), r, g, b )
    else
        exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
    end
end
addCommandHandler("headlight", vehicleHeadLightColors)
