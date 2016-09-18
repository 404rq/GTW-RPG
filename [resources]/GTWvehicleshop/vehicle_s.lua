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

-- Database connection setup, MySQL or fallback SQLite
local mysql_host        = exports.GTWcore:getMySQLHost() or nil
local mysql_database    = exports.GTWcore:getMySQLDatabase() or nil
local mysql_user        = exports.GTWcore:getMySQLUser() or nil
local mysql_pass        = exports.GTWcore:getMySQLPass() or nil
veh_data = dbConnect("mysql", "dbname="..mysql_database..";host="..mysql_host, mysql_user, mysql_pass, "autoreconnect=1")
if not veh_data then veh_data = dbConnect("sqlite", "veh.db") end

inventory_markers_veh = {}
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
addEvent( "GTWvehicleshop.onPlayerVehicleBuyRequest", true )
addEventHandler( "GTWvehicleshop.onPlayerVehicleBuyRequest", root, vehicleBuyRequest )

--[[ Create a database table to store vehicle data ]]--
addEventHandler("onResourceStart", getResourceRootElement(),
function()
	dbExec(veh_data, "CREATE TABLE IF NOT EXISTS vehicles (ID INTEGER PRIMARY KEY, owner TEXT, model NUMERIC, "..
		"locked NUMERIC, engine NUMERIC, health NUMERIC, fuel NUMERIC, paint NUMERIC, pos TEXT, color TEXT, upgrades TEXT, inventory TEXT, headlight TEXT)")
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
addEvent( "GTWvehicleshop.onShowVehicles", true )
addEventHandler( "GTWvehicleshop.onShowVehicles", root, getMyVehicles )

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
addEvent( "GTWvehicleshop.onHideVehicles", true )
addEventHandler( "GTWvehicleshop.onHideVehicles", root, hideMyVehicles )

--[[ Loads all vehicles for a specific player, requires that the player is logged in ]]--
function listAllMyVehicles(query)
	local result = dbPoll( query, 0 )
	if not result then return end

	local vehicle_data_to_client = {{ }}
	local plr = nil
    	for index, row in ipairs(result) do
    		-- Get all relevant data for the vehicle
    		vehicle_data_to_client[index] = { }
    		vehicle_data_to_client[index][1] = tonumber(row["ID"])
    		vehicle_data_to_client[index][2] = tonumber(row["model"])
    		vehicle_data_to_client[index][3] = tonumber(row["health"])
    		vehicle_data_to_client[index][4] = tonumber(row["fuel"])
    		vehicle_data_to_client[index][5] = tonumber(row["locked"])
    		vehicle_data_to_client[index][6] = tonumber(row["engine"])
    		vehicle_data_to_client[index][7] = row["pos"]
    		plr = getAccountPlayer(getAccount(row["owner"]))
    	end

    	-- Send data to client
    	if plr and isElement(plr) and getElementType(plr) then
    		triggerClientEvent( plr, "GTWvehicleshop.onReceivePlayerVehicleData", plr, vehicle_data_to_client )
	end
end
function listMyVehicles( )
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) then
		dbQuery(listAllMyVehicles, veh_data, "SELECT * FROM vehicles WHERE owner=?", getAccountName(getPlayerAccount( client )))
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onListVehicles", true )
addEventHandler( "GTWvehicleshop.onListVehicles", root, listMyVehicles )

--[[ Create a vehicle based on data from the vehicle database ]]--
function addVehicle(ID, owner, model, lock, engine, health, fuel, paint, pos, color, upgrades, inventory, hlight)
	if not getAccount( owner ) or not getAccountPlayer( getAccount( owner )) or getElementData(
		getAccountPlayer( getAccount( owner )), "Jailed") == "Yes" then return end
	if not vehicles[ID] then
		local x,y,z, rx,ry,rz = unpack( fromJSON( pos ))
		local isFirstSpawn = false
		if x == 0 and y == 0 and z == 0 then
			x,y,z = getElementPosition( getAccountPlayer( getAccount( owner )))
			rx,ry,rz = getElementRotation( getAccountPlayer( getAccount( owner )))
			z = z + 3
			isFirstSpawn = true
		end
		local veh = createVehicle( tonumber( model ), x,y,z )
		if supported_cars[getElementModel(veh)] then
			local dist = supported_cars[getElementModel(veh)]
			inventory_markers[veh] = createMarker(0, 0, -100, "cylinder", 3, 0, 0, 0, 0 )
			inventory_markers_veh[inventory_markers[veh]] = veh
			attachElements(inventory_markers[veh],veh,0,supported_cars[getElementModel(veh)],-1)
			addEventHandler( "onMarkerHit", inventory_markers[veh],
			function(hitElement,matchingDimension)
				if hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
					not getPedOccupiedVehicle(hitElement) and not getElementData(inventory_markers_veh[source],
					"GTWvehicleshop.the_near_player_trunk") then
					exports.GTWtopbar:dm( "Vehicle: Press F9 to open the vehicle inventory", hitElement, 0, 255, 0 )
					setElementData(hitElement,"GTWvehicleshop.the_near_veh_trunk",inventory_markers_veh[source])
					setElementData(inventory_markers_veh[source],"GTWvehicleshop.the_near_player_trunk",hitElement)
				elseif getElementData(inventory_markers_veh[source], "GTWvehicleshop.the_near_player_trunk") then
					local name = getPlayerName(getElementData(inventory_markers_veh[source], "GTWvehicleshop.the_near_player_trunk"))
					exports.GTWtopbar:dm( "Vehicle: "..name.." is browsing the trunk of this vehicle, please wait", hitElement, 255, 100, 0 )
				end
			end)
			addEventHandler( "onMarkerLeave", inventory_markers[veh],
			function(leaveElement,matchingDimension)
				if leaveElement and isElement(leaveElement) and getElementType(leaveElement) == "player" then
					setElementData(leaveElement,"GTWvehicleshop.the_near_veh_trunk",nil)
					setElementData(inventory_markers_veh[source],"GTWvehicleshop.the_near_player_trunk",nil)
				end
			end)
		end
		if isFirstSpawn then
			warpPedIntoVehicle( getAccountPlayer( getAccount( owner )), veh )
		end
		veh_blips[veh] = createBlipAttachedTo(veh, 0, 2, 100, 100, 100, 200, 10, 9999, getAccountPlayer( getAccount( owner )))
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
		local health = tonumber(health*20)
		if health < 300 then health = 300 end
		setElementHealth( veh, health )
		setElementData( veh, "owner", owner )
		setElementData( veh, "isOwnedVehicle", tonumber(ID))
		if getElementHealth( veh ) < 300 then
			setElementHealth( veh, 300 )
		end
		--outputChatBox(upgrades, getAccountPlayer( getAccount( owner )))
		for k, i in pairs( fromJSON( upgrades )) do
			addVehicleUpgrade( veh, i )
			--outputChatBox(i, getAccountPlayer( getAccount( owner )))
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
function saveAndRemoveVehicle(veh, removeVeh)
        if not veh or not isElement(veh) or getElementType(veh) ~= "vehicle" then return end
	-- Ensure that the vehicle is owned by a player
	if vehicle_owners[veh] then
		-- Get vehicle data
		local x,y,z = getElementPosition( veh )
		local ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db = getVehicleColor( veh, true )
		local rx,ry,rz = getElementRotation( veh )
		local fuel = getElementData( veh, "vehicleFuel" )
		local paint = getVehiclePaintjob( veh )
		local health = tostring(math.floor(tonumber(getElementHealth( veh ))/20))
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
			dbExec(veh_data, "UPDATE vehicles SET owner=?, locked=?, engine=?, health=?, fuel=?, paint=?, pos=?, color=?, upgrades=? WHERE ID=?",
				vehicle_owners[veh], locked, engine, health, fuel, paint, toJSON({x,y,z, rx,ry,rz}),
				toJSON({ar,ag,ab, br,bg,bb, cr,cg,cb, dr,dg,db}), toJSON(getVehicleUpgrades( veh )), ID)

			-- Clean up and free memory
			if removeVeh then
				-- Remove inventory marker
				if inventory_markers_veh[inventory_markers[veh]] and isElement(inventory_markers_veh[inventory_markers[veh]]) then
					inventory_markers_veh[inventory_markers[veh]] = nil
				end
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
addEvent( "GTWvehicleshop.onPlayerVehicleDestroy", true )
addEventHandler ( "GTWvehicleshop.onPlayerVehicleDestroy", root, saveAndRemoveVehicle )

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
addEvent( "GTWvehicleshop.onLockVehicle", true )
addEventHandler( "GTWvehicleshop.onLockVehicle", root, lockVehicle )

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
addEvent( "GTWvehicleshop.onVehicleEngineToggle", true )
addEventHandler( "GTWvehicleshop.onVehicleEngineToggle", root, toggleVehicleEngine )

--[[ Sell a vehicle from client GUI ]]--
function returnWeaponsOnSell(query)
	local result = dbPoll( query, 0 )
	if not result then return end
	local items = nil
	local plr = nil
	local veh_id = nil

	-- Get the json string
        for _,row in ipairs( result ) do
                -- Get all relevant data for the vehicle
                items = row["inventory"]
                plr = getAccountPlayer(getAccount(row["owner"]))
    	        veh_id = row["ID"]
    	        break
        end

        -- Extract data and give weapons back to the owner
        local data_table = fromJSON(items or "") or { }
	for k, v in pairs(data_table) do
		giveWeapon(plr, getWeaponIDFromName(k), tonumber(v))
		outputChatBox(k.." was successfully restored ("..tostring(v)..") bullets", plr, 255, 255, 255)
	end

        -- Send data to client
        if player then
    	           triggerClientEvent( player, "GTWvehicleshop.onReceiveInventoryItems", player, vehicle_data_to_client )
	end

	-- Remove vehicle from database
	dbExec(veh_data, "DELETE FROM vehicles WHERE ID=?", veh_id)
end
function sellVehicle(veh_id, model)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and model then
		-- Restore weapons to it's owner
		dbQuery(returnWeaponsOnSell, veh_data, "SELECT inventory, owner, ID FROM vehicles WHERE owner=? AND ID=?",
			getAccountName(getPlayerAccount( client )), tonumber(veh_id))

		-- Return money
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

		-- Clean up if vehicle isn't hidden while selling
		if isElement(vehicles[veh_id]) then
			local veh = vehicles[veh_id]
			if inventory_markers_veh[inventory_markers[veh]] and isElement(inventory_markers_veh[inventory_markers[veh]]) then
				inventory_markers_veh[inventory_markers[veh]] = nil
			end
			if inventory_markers[veh] and isElement(inventory_markers[veh]) then
				destroyElement(inventory_markers[veh])
			end
			vehicle_owners[veh] = nil
			destroyElement(veh_blips[veh])
			destroyElement(veh)
			vehicles[veh_id] = nil
		end

		givePlayerMoney(client, math.floor(price*priceMultiplier*0.8))
		exports.GTWtopbar:dm( "Your vehicle has been sold for 80% of it's price", client, 0, 255, 0 )
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onVehicleSell", true )
addEventHandler( "GTWvehicleshop.onVehicleSell", root, sellVehicle )

--[[ Respawn a broken vehicle ]]--
function respawnVehicleToStart(veh_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and
		veh_id and not vehicles[veh_id] and not isElement(vehicles[veh_id]) then
                local dist_to_cop = exports.GTWpolice:distanceToCop(client)
                -- Tolerate less than 30 seconds violent time or distance to cop larger than 180m
		if ((tonumber(getElementData(client, "violent_seconds")) or 0) < 50 or
                        dist_to_cop > 180) and getElementData(client, "Jailed") ~= "Yes" then
			local price = 500
			if price and getPlayerMoney(client) > price then
				takePlayerMoney( client, price )
				-- Save to database
				dbExec(veh_data, "UPDATE vehicles SET pos=? WHERE ID=?", toJSON({ 0,0,0, 0,0,0 }), veh_id)
				exports.GTWtopbar:dm( "Your vehicle has been respawned!", client, 0, 255, 0 )
			else
				exports.GTWtopbar:dm( "You can't afford to recover your vehicle, you need $500!", client, 255, 0, 0 )
			end
		elseif getElementData(client, "Jailed") == "Yes" then
			exports.GTWtopbar:dm( "You can not recover while you are jailed!", client, 255, 0, 0 )
		elseif dist_to_cop <= 180 then
			exports.GTWtopbar:dm( "You are either to violent or a cop is to close!", client, 255, 0, 0 )
		end
	elseif vehicles[veh_id] and isElement(vehicles[veh_id]) then
		exports.GTWtopbar:dm( "You must hide your vehicle before you can recover it!", client, 255, 0, 0 )
	elseif not getPlayerAccount( client ) or isGuestAccount( getPlayerAccount( client )) then
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onVehicleRespawn", true )
addEventHandler( "GTWvehicleshop.onVehicleRespawn", root, respawnVehicleToStart )

--[[ Withdraw weapons to vehicle inventory ]]--
temp_weapon_store = {}
temp_ammo_store = {}
temp_plr_store = {}
function onVehicleWeaponWithdrawGet(query)
	local result = dbPoll( query, 0 )
	if not result then return end
    for _, row in ipairs( result ) do
    	-- Add weapon to JSON string (Only executed once)
    	local input_table = fromJSON(row["inventory"])
    	local plr_owner = temp_plr_store[row["ID"]]
    	if not plr_owner or not input_table then break end
    	-- Debug info
    	--outputChatBox(row["inventory"],plr_owner)

    	-- Update value to be saved into database
    	input_table[temp_weapon_store[plr_owner]] = ((input_table[
    		temp_weapon_store[plr_owner]] or 0) + temp_ammo_store[plr_owner])
    	local new_res = toJSON(input_table)

    	-- Debug info
    	--outputChatBox(new_res, plr_owner)

    	-- Cleanup
    	temp_weapon_store[plr_owner] = nil
    	temp_ammo_store[plr_owner] = nil
    	temp_plr_store[row["ID"]] = nil

    	-- Save to database
		dbExec(veh_data, "UPDATE vehicles SET inventory=? WHERE ID=?", new_res, row["ID"])
		break
	end
end
function onVehicleWeaponWithdraw(veh_id, weap, ammo)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and weap and ammo then
		takeWeapon(client, getWeaponIDFromName(weap), tonumber(ammo))

		-- Save to temp storage
		temp_weapon_store[client] = weap
		temp_ammo_store[client] = ammo
		temp_plr_store[veh_id] = client

		-- Save to database
		dbQuery(onVehicleWeaponWithdrawGet, veh_data, "SELECT inventory, owner, ID FROM vehicles WHERE ID=?", tonumber(veh_id))

		exports.GTWtopbar:dm( "Your weapon has been withdrawed", client, 0, 255, 0 )
	elseif not getPlayerAccount( client ) or isGuestAccount( getPlayerAccount( client )) then
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	else
		exports.GTWtopbar:dm( "Error, please specify a weapon to put in your vehicle trunk!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onVehicleWeaponWithdraw", true )
addEventHandler( "GTWvehicleshop.onVehicleWeaponWithdraw", root, onVehicleWeaponWithdraw )

--[[ Deposit from vehicle inventory ]]--
function onVehicleWeaponDepositGet(query)
	local result = dbPoll( query, 0 )
	if not result then return end
    for _, row in ipairs( result ) do
    	-- Add weapon to JSON string (Only executed once)
    	local input_table = fromJSON(row["inventory"])
    	local plr_owner = temp_plr_store[row["ID"]]
    	if input_table and plr_owner and temp_weapon_store[plr_owner] then
    		local new_val = (input_table[temp_weapon_store[plr_owner]] or 0) - temp_ammo_store[plr_owner]

	    	-- Debug info
	    	--outputChatBox(row["inventory"], plr_owner)

	    	-- Update value to be saved into database
	    	if new_val > 0 then
	    		input_table[temp_weapon_store[plr_owner]] = new_val
	    	else
	    		input_table[temp_weapon_store[plr_owner]] = nil
	    	end
	    	local new_res = toJSON(input_table)

	    	-- Debug info
	    	--outputChatBox(new_res, plr_owner)

	    	-- Cleanup
	    	temp_weapon_store[plr_owner] = nil
	    	temp_ammo_store[plr_owner] = nil
	    	temp_plr_store[row["ID"]] = nil

	    	-- Save to database
			dbExec(veh_data, "UPDATE vehicles SET inventory=? WHERE ID=?", new_res, row["ID"])
		end
		break
	end
end
function onVehicleWeaponDeposit(veh_id, weap, ammo)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id and weap and ammo then
		giveWeapon(client, getWeaponIDFromName(weap), tonumber(ammo))

		-- Save to temp storage
		temp_weapon_store[client] = weap
		temp_ammo_store[client] = ammo
		temp_plr_store[veh_id] = client

		-- Save to database
		dbQuery(onVehicleWeaponDepositGet, veh_data, "SELECT inventory, owner, ID FROM vehicles WHERE ID=?", tonumber(veh_id))
		exports.GTWtopbar:dm( "Your weapon has been deposited", client, 0, 255, 0 )
	elseif not getPlayerAccount( client ) or isGuestAccount( getPlayerAccount( client )) then
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	else
		exports.GTWtopbar:dm( "Error, please specify a weapon to put in your vehicle trunk!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onVehicleWeaponDeposit", true )
addEventHandler( "GTWvehicleshop.onVehicleWeaponDeposit", root, onVehicleWeaponDeposit )

--[[ Get weapons from inventory ]]--
function getInventoryWeapons(query)
	local result = dbPoll( query, 0 )
	if result then
		local vehicle_data_to_client = nil
		local plr = nil
    	for _,row in ipairs( result ) do
    		-- Get all relevant data for the vehicle
    		vehicle_data_to_client = row["inventory"]
    		plr = temp_plr_store[row["ID"]]

    		-- Send data to client
	    	if plr then
	    		triggerClientEvent( plr, "GTWvehicleshop.onReceiveInventoryItems", plr, vehicle_data_to_client )
			end

			-- Cleanup
			temp_plr_store[row["ID"]] = nil
			break
		end
	end
end
function openInventory(veh_id)
	if getPlayerAccount( client ) and not isGuestAccount( getPlayerAccount( client )) and veh_id then
		temp_plr_store[veh_id] = client
		setVehicleDoorOpenRatio( getElementData(client, "GTWvehicleshop.the_near_veh_trunk"), 1, 1, 1000 )
		dbQuery(getInventoryWeapons, veh_data, "SELECT inventory, owner, ID FROM vehicles WHERE ID=?", tonumber(veh_id))
	else
		exports.GTWtopbar:dm( "You must be logged in to own and use your vehicles!", client, 255, 0, 0 )
	end
end
addEvent( "GTWvehicleshop.onOpenInventory", true )
addEventHandler( "GTWvehicleshop.onOpenInventory", root, openInventory )
function closeInventory()
	setVehicleDoorOpenRatio( getElementData(client, "GTWvehicleshop.the_near_veh_trunk"), 1, 0, 1000 )
end
addEvent( "GTWvehicleshop.onCloseInventory", true )
addEventHandler( "GTWvehicleshop.onCloseInventory", root, closeInventory )

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
addCommandHandler("hlcolor", vehicleHeadLightColors)
addCommandHandler("headlight", vehicleHeadLightColors)
addCommandHandler("headlightcol", vehicleHeadLightColors)
addCommandHandler("headlightcolor", vehicleHeadLightColors)
addCommandHandler("setheadlight", vehicleHeadLightColors)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

function saveAllVehicles(quitType)
	dbQuery(unloadMyVehicles, veh_data, "SELECT * FROM vehicles WHERE owner=?", getAccountName(getPlayerAccount( source )))
end
addEventHandler("onPlayerQuit", root, saveAllVehicles)
