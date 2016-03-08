-- MySQL Housesystem created & released by Noneatme(MuLTi), Do not remove credits! --
-- All Rights go to Noneatme --

--[[ Total time token:
	- 3 hour
	- 1.5 hour
	________
	4.5 hours
]]

------------------------
-- CONNECTION HANDLER --
------------------------

dbpTime = 3000 -- How many Miliseconds will use the dbPoll function for waiting for a result
max_player_houses = 50 -- Define the buyable houses per player
sellhouse_value = 0.8 -- The ammount in percent that you get back if you sell a house
open_key = "z" -- Define the key for the infomenue and the housepanel
exit_key = "n"

function getUserAccount( )
    local accName = getAccountName( getPlayerAccount( client ))
	triggerClientEvent( "onReciveAccount", getRootElement(), accName )
end
addEvent( "onGetAccount", true )
addEventHandler( "onGetAccount", root, getUserAccount )

-----------------------------------------------------------------
-- IF YOU CAN'T WRITE IN LUA, DO NOT EDIT ANYTHING ABOVE HERE! --
-----------------------------------------------------------------

-- EVENTS --

addEvent("onHouseSystemHouseCreate", true)
addEvent("onHouseSystemHouseLock", true)
addEvent("onHouseSystemHouseDeposit", true)
addEvent("onHouseSystemHouseWithdraw", true)
addEvent("onHouseSystemWeaponDeposit", true)
addEvent("onHouseSystemWeaponWithdraw", true)
addEvent("onHouseSystemRentableSwitch", true)
addEvent("onHouseSystemRentalprice", true)
addEvent("onHouseSystemTenandRemove", true)
addEvent("onHouseSystemInfoBuy", true)
addEvent("onHouseSystemInfoRent", true)
addEvent("onHouseSystemInfoEnter", true)

local handler -- local only, we don't need a global handler

local saveableValues = {
	["MONEY"] = "MONEY",
	["WEAP1"] = "WEAP1",
	["WEAP2"] = "WEAP2",
	["WEAP3"] = "WEAP3",
	["LOCKED"] = "LOCKED",
	["OWNER"] = "OWNER",
	["RENTABLE"] = "RENTABLE",
	["RENTALPRICE"] = "RENTALPRICE",
	["RENT1"] = "RENT1",
	["RENT2"] = "RENT2",
	["RENT3"] = "RENT3",
	["RENT4"] = "RENT4",
	["RENT5"] = "RENT5",
}

local created = false -- DONT EDIT
local houseid = 0 -- Define the Houseid,

local house = {} -- The House array
local houseData = {} -- The House Data arry
local houseInt = {} -- The House Interior array
local houseIntData = {} -- The House Interior Data Array xD

local buildStartTick
local buildEndTick

local rentTimer

-- STARTUP EVENT HANDLER --

addEventHandler("onResourceStart", getResourceRootElement(), function()
        -- Database connection setup, MySQL or fallback SQLite
        local mysql_host    	= exports.GTWcore:getMySQLHost() or nil
        local mysql_database 	= exports.GTWcore:getMySQLDatabase() or nil
        local mysql_user    	= exports.GTWcore:getMySQLUser() or nil
        local mysql_pass    	= exports.GTWcore:getMySQLPass() or nil
        handler = dbConnect("mysql", "dbname="..mysql_database..";host="..mysql_host, mysql_user, mysql_pass, "autoreconnect=1")
        if not handler then handler = dbConnect("sqlite", "/houses.db") end

        -- Boot up system
        housesys_startup()
end)

-- SHUTDOWN EVENT HANDLER --
addEventHandler("onResourceStop", getResourceRootElement(), function()
	-- Free the arrays --
	for index, houses in pairs(house) do
		houses = nil
	end
	for index, houseDatas in pairs(houseData) do
		houseDatas = nil
	end
	for index, houseInts in pairs(houseInt) do
		houseInts = nil
	end
	for index, houseIntDatas in pairs(houseIntData) do
		houseIntDatas = nil
	end

	houseid = 0
	created = false
end)

--------------
-- COMMANDS --
--------------

-- /unrent --

addCommandHandler("unrent", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local id = tonumber(getElementData(thePlayer, "house:lastvisit"))
		if(isPlayerRentedHouse(thePlayer, id) == false) then
			exports.GTWtopbar:dm("You are not tenad of this house!", thePlayer, 255, 0, 0)
			return
		end
		local sucess = removeHouseTenand(id, thePlayer)
		if(sucess == true) then
			exports.GTWtopbar:dm("You have sucessfull terminate the tenancy!", thePlayer, 0, 255, 0)
		else
			exports.GTWtopbar:dm("An error occurred!", thePlayer, 255, 0, 0)
		end
	end
end)

-- /rent --

addCommandHandler("rent", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local id = tonumber(getElementData(thePlayer, "house:lastvisit"))
		if(houseData[id]["OWNER"] == getAccountName( getPlayerAccount(thePlayer))) then
			exports.GTWtopbar:dm("You can't rent here! It's your house!", thePlayer, 255, 0, 0)
			return
		end
		if(tonumber(houseData[id]["RENTABLE"]) ~= 1) then
			exports.GTWtopbar:dm("This house is not rent able!", thePlayer, 255, 0, 0)
			return
		end
		if(getPlayerRentedHouse(thePlayer) ~= false) then
			exports.GTWtopbar:dm("You are already a tenant in a house! Use /unrent first.", thePlayer, 255, 0, 0)
			return
		end
		local sucess = addHouseTenand(thePlayer, id)
		if(sucess == true) then
			exports.GTWtopbar:dm("You are now tenant this house!", thePlayer, 0, 255, 0)
		else
			exports.GTWtopbar:dm("You can't rent this house!", thePlayer, 255, 0, 0)
		end
	end
end)

-- /createhouse --

function create_house(thePlayer)
	local accName = getAccountName ( getPlayerAccount ( thePlayer ))
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" )) then
		if(getElementInterior(thePlayer) ~= 0) then
			exports.GTWtopbar:dm("You are not outside!", thePlayer, 255, 0, 0)
			return
		end
		if(isPedInVehicle(thePlayer) == true) then
			exports.GTWtopbar:dm("Please exit your vehicle.", thePlayer, 255, 0, 0)
			return
		end
		triggerClientEvent(thePlayer, "onClientHouseSystemGUIStart", thePlayer)
	else
		exports.GTWtopbar:dm("You are not an admin!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("createhouse", create_house)
addCommandHandler("mkhouse", create_house)

-- /in --

addCommandHandler("in", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = tonumber(house)
			if(tonumber(houseData[id]["LOCKED"]) == 0) or (houseData[id]["OWNER"] == getAccountName( getPlayerAccount(thePlayer))) or (isPlayerRentedHouse(thePlayer, id) == true) then
				local int, intx, inty, intz, dim = houseIntData[id]["INT"], houseIntData[id]["X"], houseIntData[id]["Y"], houseIntData[id]["Z"], id
				setElementData(thePlayer, "house:in", true)
				setInPosition(thePlayer, intx, inty, intz, int, false, dim)
				unbindKey(thePlayer, open_key, "down", togglePlayerInfomenue, id)
				setElementData(thePlayer, "house:lastvisitINT", id)
				if(houseData[id]["OWNER"] == getAccountName( getPlayerAccount(thePlayer))) or (isPlayerRentedHouse(thePlayer, id) == true) then
					bindKey( thePlayer, open_key, "down", togglePlayerHousemenue, id)
				end
				bindKey( thePlayer, exit_key, "down", "out" )

				-- Notice
				exports.GTWtopbar:dm( "To exit your house, press n or type /out", thePlayer, 255, 200, 0)
				outputChatBox( "To exit your house, press n or type /out", thePlayer, 255, 200, 0)
			else
				exports.GTWtopbar:dm("You don't have the housekey for this House!", thePlayer, 255, 0, 0)
			end
		end
	end
end)

-- /out --

addCommandHandler("out", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisitINT")) and (getElementData(thePlayer, "house:lastvisitINT") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisitINT")
		if (house) then
			local id = tonumber(house)
			local x, y, z = houseData[id]["X"], houseData[id]["Y"], houseData[id]["Z"]
			setElementData(thePlayer, "house:in", false)
			setInPosition(thePlayer, x, y, z, 0, false, 0)
			unbindKey( thePlayer, exit_key, "down", "out" )
		end
	end
end)

-- /buyhouse --

addCommandHandler("buyhouse", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = house
			local owner = houseData[id]["OWNER"]
			if(owner ~= "no-one") then
				exports.GTWtopbar:dm("You can't buy this house!", thePlayer, 255, 0, 0)
			else
				local houses = 0
				for index, col in pairs(getElementsByType("colshape")) do
					if(getElementData(col, "house") == true) and (houseData[getElementData(col, "ID")]["OWNER"] == getAccountName( getPlayerAccount(thePlayer))) then
						houses = houses+1
						if(houses == max_player_houses) then
							exports.GTWtopbar:dm("You have already "..max_player_houses.." houses! Sell a house to buy this one.", thePlayer, 255, 0, 0)
							return
						end
					end
				end
				local money = getPlayerMoney(thePlayer)
				local price = tonumber(houseData[id]["PRICE"])
				if (money < price) then exports.GTWtopbar:dm("You don't have enough money! You need "..(price-money).."$ more!", thePlayer, 255, 0, 0) return end
				setHouseData(id, "OWNER", getAccountName( getPlayerAccount (thePlayer)))
				takePlayerMoney(thePlayer, math.floor(price))
				exports.GTWtopbar:dm("Congratulations! You bought the house!", thePlayer, 0, 255, 0)

                                -- Cleanup
                                if isElement(houseData[id]["BLIP"]) then destroyElement(houseData[id]["BLIP"]) end
                                if isElement(houseData[id]["PICKUP"]) then destroyElement(houseData[id]["PICKUP"]) end

                                -- HOUSE PICKUP --
                                houseData[id]["PICKUP"] = createPickup(houseData[id]["X"],
                                        houseData[id]["Y"], houseData[id]["Z"]-0.5, 3, 1272, 500)

                                -- HOUSE BLIP --
                                houseData[id]["BLIP"] = createBlip(houseData[id]["X"], houseData[id]["Y"],
                                                houseData[id]["Z"], 31, 1, 0,0,0, 255, 5, 9999, thePlayer)
			end
		end
	end
end)

-- /sellhouse --

addCommandHandler("sellhouse", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = house
			local owner = houseData[id]["OWNER"]
			if(owner ~= getAccountName( getPlayerAccount(thePlayer))) then
				exports.GTWtopbar:dm("You can't sell this house!", thePlayer, 255, 0, 0)
			else
				local price = houseData[id]["PRICE"]
				setHouseData(id, "OWNER", "no-one")
				setHouseData(id, "RENTABLE", 0)
				setHouseData(id, "RENTALPRICE", 0)
				for i = 1, 5, 1 do
					setHouseData(id, "RENT"..i, "no-one")
				end
				givePlayerMoney(thePlayer, math.floor(price*sellhouse_value))
				exports.GTWtopbar:dm("You sucessfull sold this house and got $"..tostring(math.floor(price*sellhouse_value)).." back!", thePlayer, 0, 255, 0)

                                -- Cleanup
                                if isElement(houseData[id]["BLIP"]) then destroyElement(houseData[id]["BLIP"]) end
                                if isElement(houseData[id]["PICKUP"]) then destroyElement(houseData[id]["PICKUP"]) end

                                -- HOUSE PICKUP --
                                houseData[id]["PICKUP"] = createPickup(houseData[id]["X"],
                                        houseData[id]["Y"], houseData[id]["Z"]-0.5, 3, 1273, 500)

                                -- HOUSE BLIP --
                                houseData[id]["BLIP"] = nil
			end
		end
	end
end)

-- /deletehouse --

addCommandHandler("deletehouse", function(thePlayer, cmd, id)
	if(hasObjectPermissionTo ( thePlayer, "function.kickPlayer", false ) ) then
		id = tonumber(id)
		if not(id) then return end
		if not(house[id]) then
			exports.GTWtopbar:dm("There is no house with the ID "..id.."!", thePlayer, 255, 0, 0)
			return
		end
		local query = dbQuery(handler, "DELETE FROM houses WHERE ID = '"..id.."';")
		local result = dbPoll(query, dbpTime)
		if(result) then
			if isElement(houseData[id]["BLIP"]) then
				destroyElement(houseData[id]["BLIP"])
			end
			if isElement(houseData[id]["PICKUP"]) then
				destroyElement(houseData[id]["PICKUP"])
			end
			houseData[id] = nil
			houseIntData[id] = nil
			destroyElement(house[id])
			destroyElement(houseInt[id])
			exports.GTWtopbar:dm("House "..id.." destroyed sucessfully!", thePlayer, 0, 255, 0)
			house[id] = false
		else
			error("House ID "..id.." has been created Ingame, but House is not in the database! WTF")
		end
	else
		exports.GTWtopbar:dm("You are not an admin!", thePlayer, 255, 0, 0)
	end
end)

-- /househelp --

addCommandHandler("househelp", function(thePlayer)
	outputChatBox("/buyhouse, /sellhouse, /rent", thePlayer, 0, 255, 0)
	outputChatBox("/unrent, /in, /out", thePlayer, 0, 255, 0)
	outputChatBox("For Admins: /createhouse, /deletehouse [id]", thePlayer, 0, 255, 0)
end)

-- INSERT INTO dbs_housesystem.houses (X, Y, Z, INTERIOR, INTX, INTY, INTZ, MONEY, WEAP1, WEAP2, WEAP3) values("0.1", "0.1", "0.1", "5", "0.2", "0.2", "0.2", "2000", "46,1", "22,200", "25, 200")

--------------------
-- BIND FUNCTIONS --
--------------------

function togglePlayerInfomenue(thePlayer, key, state, id)
	if id then
		local locked = houseData[id]["LOCKED"]
		local rentable = houseData[id]["RENTABLE"]
		local rentalprice = houseData[id]["RENTALPRICE"]
		local owner = houseData[id]["OWNER"]
		local price = houseData[id]["PRICE"]
		local x, y, z = getElementPosition(house[id])
		local house = getPlayerRentedHouse(thePlayer)
		if house ~= false then house = true end
		local isrentedin = isPlayerRentedHouse(thePlayer, id)
		triggerClientEvent(thePlayer, "onClientHouseSystemInfoMenueOpen", thePlayer, owner, x, y, z, price, locked, rentable, rentalprice, id, house, isrentedin)
	end
end

function togglePlayerHousemenue(thePlayer, key, state, id)
	if id then
		if getElementInterior(thePlayer) > 0 then
			local locked = houseData[id]["LOCKED"]
			local money = houseData[id]["MONEY"]
			local weap1 = houseData[id]["WEAPONS"][1]
			local weap2 = houseData[id]["WEAPONS"][2]
			local weap3 = houseData[id]["WEAPONS"][3]
			local rentable = houseData[id]["RENTABLE"]
			local rent = houseData[id]["RENTALPRICE"]
			local tenands = getHouseTenands(id)
			local owner = false
			if(getAccountName( getPlayerAccount(thePlayer)) == houseData[id]["OWNER"]) then
				owner = getAccountName( getPlayerAccount(thePlayer))
			end
			local canadd = canAddHouseTenand(id)
			triggerClientEvent(thePlayer, "onClientHouseSystemMenueOpen", thePlayer, owner, locked, money, weap1, weap2, weap3, id, rentable, rent, tenands, canadd)
		end
	else
		triggerClientEvent(thePlayer, "onClientHouseSystemMenueOpen", thePlayer )
	end
end

-------------------------------
-- HOUSE CREATION ON STARTUP --
-------------------------------

-- BUILDHOUSE FUNCTION --
local function buildHouse(id, x, y, z, interior, intx, inty, intz, money, weapons, locked, price, owner, rentable, rentalprice, rent1, rent2, rent3, rent4, rent5)
	if(id) and (x) and(y) and (z) and (interior) and (intx) and (inty) and (intz) and (money) and (weapons) then
		houseid = id
		house[id] = createColSphere(x, y, z, 3) -- This is the house, hell yeah
		houseData[id] = {}
		local house = house[id] -- I'm too lazy...
		setElementData(house, "house", true) -- Just for client code only

		local houseIntPickup = createPickup(intx, inty, intz, 3, 1318, 500)
		setElementInterior(houseIntPickup, interior)
		setElementDimension(houseIntPickup, id)

		-- Hide the ugly stuff inside
		setElementAlpha(houseIntPickup, 0)

		houseInt[id] = createColSphere(intx, inty, intz, 1.5) -- And this is the Exit
		setElementInterior(houseInt[id], interior)
		setElementDimension(houseInt[id], id) -- The House Dimension is the house ID
		setElementData(houseInt[id], "house", false)
		--------------------
		-- EVENT HANDLERS --
		--------------------

		-- IN --
		addEventHandler("onColShapeHit", house, function(hitElement)
			if(getElementType(hitElement) == "player") then
				setElementData(hitElement, "house:lastvisit", id)
				bindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
				exports.GTWtopbar:dm("Press "..open_key.." to open the information-gui for this house.",
                                        hitElement, 255, 200, 0)
			end
		end)

		addEventHandler("onColShapeLeave", house, function(hitElement)
			if(getElementType(hitElement) == "player") then
				setElementData(hitElement, "house:lastvisit", false)
				unbindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
				--outputChatBox(id)
			end
		end)

		-- OUT --
		addEventHandler("onColShapeHit", houseInt[id], function(hitElement, dim)
			if(dim == true) then
				if(getElementType(hitElement) == "player") then
					unbindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
					setElementData(hitElement, "house:lastvisitINT", id)
					if(houseData[id]["OWNER"] == getAccountName( getPlayerAccount(hitElement))) or (isPlayerRentedHouse(hitElement, id) == true) then
						bindKey(hitElement, open_key, "down", togglePlayerHousemenue, id)
					end
					--outputChatBox(id)
				end
			end
		end)

		addEventHandler("onColShapeLeave", houseInt[id], function(hitElement, dim)
			if(dim == true) then
				if(getElementType(hitElement) == "player") then
					setElementData(hitElement, "house:lastvisitINT", false)
					if(houseData[id]["OWNER"] == getAccountName( getPlayerAccount(hitElement))) or (isPlayerRentedHouse(hitElement, id) == true) then
						unbindKey(hitElement, open_key, "down", togglePlayerHousemenue, id)
					end
					--outputChatBox(id)
				end
			end
		end)

		-- Set data for HOUSE --
		houseData[id]["HOUSE"] = house
		houseData[id]["DIM"] = id
		houseData[id]["MONEY"] = money
		houseData[id]["WEAPONS"] = weapons
		houseData[id]["INTHOUSE"] = houseInt[id]
		houseData[id]["LOCKED"] = locked
		houseData[id]["PRICE"] = price
		houseData[id]["OWNER"] = owner
		houseData[id]["X"] = x
		houseData[id]["Y"] = y
		houseData[id]["Z"] = z
		houseData[id]["RENTABLE"] = rentable
		houseData[id]["RENTALPRICE"] = rentalprice
		houseData[id]["RENT1"] = rent1
		houseData[id]["RENT2"] = rent2
		houseData[id]["RENT3"] = rent3
		houseData[id]["RENT4"] = rent4
		houseData[id]["RENT5"] = rent5

		-- HOUSE PICKUP --
                if owner == "no-one" then
		        houseData[id]["PICKUP"] = createPickup(x, y, z-0.5, 3, 1273, 500)
                else
                        houseData[id]["PICKUP"] = createPickup(x, y, z-0.5, 3, 1272, 500)
                end

                -- HOUSE BLIP --
                if getAccount(owner) and getAccountPlayer(getAccount(owner)) then
                        houseData[id]["BLIP"] = createBlip( x,y,z, 31, 1, 0,0,0, 255, 5, 9999, getAccountPlayer(getAccount(owner)))
                end

		setElementData(house, "PRICE", price)
		setElementData(house, "OWNER", owner)
		setElementData(house, "LOCKED", locked)
		setElementData(house, "ID", id)
		setElementData(house, "RENTABLE", rentable)
		setElementData(house, "RENTALPRICE", rentalprice)

		-- SET DATA FOR HOUSEINTERIOR --
		houseIntData[id] = {}
		houseIntData[id]["OUTHOUSE"] = houseData[id]["HOUSE"]
		houseIntData[id]["INT"] = interior
		houseIntData[id]["X"] = intx
		houseIntData[id]["Y"] = inty
		houseIntData[id]["Z"] = intz
		buildEndTick = getTickCount()
		-- TRIGGER TO ALL CLIENTS THAT THE HOUSE HAS BEEN CREATED --
		setTimer(triggerClientEvent, 1000, 1, "onClientHouseSystemColshapeAdd", getRootElement(), house)
	else
		if not(id) then
			error("Arguments @buildHouse not valid! There is no Houseid!")
		else
			error("Arguments @buildHouse not valid! Houseid = "..id)
		end
	end
end

-- ON PLAYER Login, create blips to houses owned by this player
addEventHandler("onPlayerLogin", root,
function(_, acc)
        local owner = getAccountName(acc)
        for k,house in pairs(houseData) do
                if house["OWNER"] == owner then
                        house["BLIP"] = createBlip(house["X"], house["Y"],
                                house["Z"], 31, 1, 0,0,0, 255, 5, 9999, source)
                end
        end
end)


-- TAKE PLAYER RENT --
local function takePlayerRent()
	for index, player in pairs(getElementsByType("player")) do
		if(getPlayerRentedHouse(player) ~= false) then
			local id = getPlayerRentedHouse(player)
			local owner = houseData[id]["OWNER"]
			local rentable = tonumber(houseData[id]["RENTABLE"])
			if(rentable == 1) then
				local rentprice = tonumber(houseData[id]["RENTALPRICE"])
				takePlayerMoney(player, rentprice) -- Takes the player money for the rent
				exports.GTWtopbar:dm("You paid $"..rentprice.." rentalprice!", player, 255, 200, 0)
				if ( getAccountPlayer( getAccount( owner ))) then
					givePlayerMoney( getAccountPlayer( getAccount( owner )), rentprice) -- Gives the owner the rentalprice
					exports.GTWtopbar:dm("You got $"..rentprice.." from a tenand of your house!", getAccountPlayer( getAccount( owner )), 255, 200, 0)
				end
			end
		end
	end
end

-- HOUSE DATABASE EXECUTION --

function housesys_startup()
	if(created == true) then
		error("Houses Allready created!")
		return
	end
	buildStartTick = getTickCount()
	local query = dbQuery(handler, "SELECT * FROM houses;" )
	local result, numrows = dbPoll(query, dbpTime)
	if (result and numrows > 0) then
		for index, row in pairs(result) do
			local id = row['ID']
			local x, y, z = row['X'], row['Y'], row['Z']
			local int, intx, inty, intz = row['INTERIOR'], row['INTX'], row['INTY'], row['INTZ']
			local money, weap1, weap2, weap3 = row['MONEY'], row['WEAP1'], row['WEAP2'], row['WEAP3']
			local locked = row['LOCKED']
			local price = row['PRICE']
			local owner = row['OWNER']
			local rentable = row['RENTABLE']
			local rentalprice = row['RENTALPRICE']
			local rent1, rent2, rent3, rent4, rent5 = row['RENT1'],row['RENT2'], row['RENT3'], row['RENT4'], row['RENT5']
			local weapontable = {}
			weapontable[1] = weap1
			weapontable[2] = weap2
			weapontable[3] = weap3
			buildHouse(id, x, y, z, int, intx, inty, intz, money, weapontable, locked, price, owner, rentable, rentalprice, rent1, rent2, rent3, rent4, rent5)
		end
		dbFree(query)
	else
		error("Houses Table not Found/empty!")
	end
	created = true
	setTimer(function()
		local elapsed = (buildEndTick-buildStartTick)
		outputServerLog("It took "..(elapsed/1000).." seconds to build all houses.")
	end, 1000, 1)
	rentTimer = setTimer(takePlayerRent, 60*60*1000, -1)
end

-- House Data array set --

function setHouseData(ID, typ, value)
	-- Security array --
	if ID and typ and value then
		houseData[ID][typ] = value
		setElementData(house[ID], typ, value)
		if saveableValues[typ] then
			local query = dbQuery(handler, "UPDATE houses SET "..saveableValues[typ].." = '"..value.."' WHERE ID = '"..ID.."';" )
			local result = dbPoll(query, dbpTime)
			if(result) then
				dbFree(query)
			else
				error("Can't save Data: "..typ.." with the value: "..value.." for house ID "..ID.."!")
			end
		end
	end
end


--------------------
-- EVENT HANDLERS --
--------------------

-- INFO RENT -

addEventHandler("onHouseSystemInfoRent", getRootElement(), function(id, value)
	if(houseData[id]) then
		if(value == true) then
			executeCommandHandler("rent", source)
		else
			executeCommandHandler("unrent", source)
		end
	end
end)


-- INFO ENTER --

addEventHandler("onHouseSystemInfoEnter", getRootElement(), function(id)
	if(houseData[id]) then
		executeCommandHandler("in", source)
	end
end)

-- INFO BUY --
addEventHandler("onHouseSystemInfoBuy", getRootElement(), function(id, value)
	if(houseData[id]) then
		if(value == true) then
			executeCommandHandler("buyhouse", source)
		else
			executeCommandHandler("sellhouse", source)
		end
	end
end)


-- TENAND REMOVE --

addEventHandler("onHouseSystemTenandRemove", getRootElement(), function(id, value)
	if(houseData[id]) then
		local sucess = removeHouseTenand(id, value)
		if(sucess == true) then
			exports.GTWtopbar:dm("You sucessfull removed the tenand "..value.."!", source, 0, 255, 0)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "TENANDS", getHouseTenands(id))
		end
	end
end)

-- SET RENTALPRICE --

addEventHandler("onHouseSystemRentalprice", getRootElement(), function(id, value)
	if(houseData[id]) then
		local oldvalue = tonumber(houseData[id]["RENTALPRICE"])
		if(oldvalue < value) then
			local tenands = getHouseTenands(id)
			local users = {}
			for i = 1, 5, 1 do
				if(tenands[i] ~= "no-one") then
					users[i] = tenands[i]
				end
			end
			if(#users > 0) then
				exports.GTWtopbar:dm("You can't change the rentalprice to a highter value because there are tenands in your house!", source, 255, 0, 0)
				return
			end
		end
		setHouseData(id, "RENTALPRICE", value)
		exports.GTWtopbar:dm("You sucessfull set the rentalprice to $"..value.."!", source, 0, 255, 0)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTALPRICE", value)
	end
end)

-- RENTABLE SWITCH --
addEventHandler("onHouseSystemRentableSwitch", getRootElement(), function(id)
	if(houseData[id]) then
		local state = tonumber(houseData[id]["RENTABLE"])
		if(state == 0) then
			setHouseData(id, "RENTABLE", 1)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTABLE", true)
			exports.GTWtopbar:dm("The house is now rentable!", source, 0, 255, 0)
		else
			setHouseData(id, "RENTABLE", 0)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTABLE", false)
			exports.GTWtopbar:dm("The house is no longer rentable!", source, 255, 200, 0)
		end
	end
end)


-- CREATE HOUSE --

addEventHandler("onHouseSystemHouseCreate", getRootElement(), function(x, y, z, int, intx, inty, intz, price)
	local query = dbQuery(handler, "INSERT INTO houses (ID, X, Y, Z, INTERIOR, INTX, INTY, INTZ, MONEY, WEAP1, WEAP2, WEAP3, LOCKED, PRICE, OWNER, RENTABLE, RENTALPRICE, RENT1, RENT2, RENT3, RENT4, RENT5) values ('"..
		(houseid+1).."', '"..x.."', '"..y.."', '"..z.."', '"..int.."', '"..intx.."', '"..inty.."', '"..intz.."', '0', '0', '0', '0', '0', '"..price.."', 'no-one', '0', '0', 'no-one', 'no-one', 'no-one', 'no-one', 'no-one');")
	local result, numrows = dbPoll(query, dbpTime)
	if(result) then
		local newid = houseid+1
		exports.GTWtopbar:dm("House "..newid.." created sucessfully!", source, 0, 255, 0)
		local weapontable = {}
		weapontable[1] = 0
		weapontable[2] = 0
		weapontable[3] = 0
		buildHouse(newid, x, y, z, int, intx, inty, intz, 0, weapontable, 0, price, "no-one", 0, 0, "no-one", "no-one", "no-one", "no-one", "no-one")
	else
		exports.GTWtopbar:dm("An Error occurred while creating the house!", source, 255, 0, 0)
		error("House "..(houseid+1).." could not create!")
	end
end)

-- WITHDRAW WEAPON --

addEventHandler("onHouseSystemWeaponWithdraw", getRootElement(), function(id, value)
	local weapons = houseData[id]["WEAPONS"]
	if (gettok(weapons[value], 1, ",")) and getPlayerTeam(source) == getTeamFromName("Unemployed") then
		local weapon, ammo = gettok(weapons[value], 1, ","), gettok(weapons[value], 2, ",")
		giveWeapon(source, weapon, ammo, true)
		exports.GTWtopbar:dm("You sucessfull withdraw your weapon slot "..value.."!", source, 0, 255, 0)
		weapons[value] = 0
		setHouseData(id, "WEAPONS", weapons)
		setHouseData(id, "WEAP1", weapons[1])
		setHouseData(id, "WEAP2", weapons[2])
		setHouseData(id, "WEAP3", weapons[3])
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "WEAPON", value, 0)
	elseif getPlayerTeam(source) ~= getTeamFromName("Unemployed") then
		exports.GTWtopbar:dm("End your work before using this!", source, 255, 0, 0)
	end
end)

-- DEPOSIT WEAPON --


addEventHandler("onHouseSystemWeaponDeposit", getRootElement(), function(id, value)
	local weapons = houseData[id]["WEAPONS"]
	if (tonumber(weapons[value]) == 0) and getPlayerTeam(source) == getTeamFromName("Unemployed") then
		local weapon = getPedWeapon(source)
		local ammo = getPedTotalAmmo(source)
		if(weapon) and (ammo) and(weapon ~= 0) and (ammo ~= 0) then
			weapons[value] = weapon..", "..ammo
			takeWeapon(source, weapon)
			exports.GTWtopbar:dm("You sucessfull deposit your weapon "..getWeaponNameFromID(weapon).." into your weaponbox!", source, 0, 255, 0)
			setHouseData(id, "WEAPONS", weapons)
			setHouseData(id, "WEAP1", weapons[1])
			setHouseData(id, "WEAP2", weapons[2])
			setHouseData(id, "WEAP3", weapons[3])
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "WEAPON", value, weapons[value])
		else
			exports.GTWtopbar:dm("You don't have a weapon!", source, 255, 0, 0)
		end
	elseif getPlayerTeam(source) ~= getTeamFromName("Unemployed") then
		exports.GTWtopbar:dm("End your work before using this!", source, 255, 0, 0)
	else
		exports.GTWtopbar:dm("There is already a weapon in that slot!", source, 255, 0, 0)
	end
end)

-- LOCK HOUSE --

addEventHandler("onHouseSystemHouseLock", getRootElement(), function(id)
	local state = tonumber(houseData[id]["LOCKED"])
	if(state == 1) then
		setHouseData(id, "LOCKED", 0)
		exports.GTWtopbar:dm("The house has been unlocked.", source, 0, 255, 0)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "LOCKED", 0)
	else
		setHouseData(id, "LOCKED", 1)
		exports.GTWtopbar:dm("The house has been locked!", source, 0, 255, 0)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "LOCKED", 1)
	end
end)

-- DEPOSIT MONEY --

addEventHandler("onHouseSystemHouseDeposit", getRootElement(), function(id, value)
	if(value > getPlayerMoney(source)-1) then return end
	setHouseData(id, "MONEY", tonumber(houseData[id]["MONEY"])+value)
	exports.GTWtopbar:dm("You sucessfull insert "..value.."$ into your cashbox!", source, 0, 255, 0)
	triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "MONEY", tonumber(houseData[id]["MONEY"]))
	givePlayerMoney(source, -value)
end)

-- WITHDRAW MONEY --

addEventHandler("onHouseSystemHouseWithdraw", getRootElement(), function(id, value)
	local money = tonumber(houseData[id]["MONEY"])
	if(money < value) then
		exports.GTWtopbar:dm("You don't have enough money!", source, 255, 0, 0)
		return
	end
	setHouseData(id, "MONEY", tonumber(houseData[id]["MONEY"])-value)
	exports.GTWtopbar:dm("You sucessfull tok "..value.."$ out of your cashbox!", source, 0, 255, 0)
	triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "MONEY", money-value)
	givePlayerMoney(source, value)
end)


----------------------------
-- SETTINGS AND FUNCTIONS --
----------------------------


-- FADE PLAYERS POSITION --
local fadeP = {}
function setInPosition(thePlayer, x, y, z, interior, typ, dim)
	if not(thePlayer) then return end
	if (getElementType(thePlayer) == "vehicle") then return end
	if(isPedInVehicle(thePlayer)) then return end
	if not(x) or not(y) or not(z) then return end
	if not(interior) then interior = 0 end
	if(fadeP[thePlayer] == 1) then return end
	fadeP[thePlayer] = 1
	fadeCamera(thePlayer, false)
	setElementFrozen(thePlayer, true)
	setTimer(
		function()
		fadeP[thePlayer] = 0
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		if(dim) then setElementDimension(thePlayer, dim) end
		fadeCamera(thePlayer, true)
		if not(typ) then
			setElementFrozen(thePlayer, false)
		else
			if(typ == true)  then
				setTimer(setElementFrozen, 1000, 1, thePlayer, false)
			end
		end
	end, 1000, 1)
end


-- canAddHouseTenand
-- Checks if there is a free slot in the house

function canAddHouseTenand(id)
	if not(houseData[id]) then return false end
	for i = 1, 5, 1 do
		local name = houseData[id]["RENT"..i]
		if(name == "no-one") then
			return true, i
		end
	end
	return false;
end

-- addHouseTenand
-- Adds a player to a house as tenand

function addHouseTenand(player, id)
	if not(houseData[id]) then return false end
	for i = 1, 5, 1 do
		local name = houseData[id]["RENT"..i]
		if(name == "no-one") then
			setHouseData(id,"RENT"..i, getPlayerName(player))
			return true, i
		end
	end
	return false;
end

-- removeHouseTenand
-- Removes a player from a house

function removeHouseTenand(id, player)
	if not(houseData[id]) then return false end
	if(type(player) == "string") then
		for i = 1, 5, 1 do
			local name = houseData[id]["RENT"..i]
			if(name == player) then
				setHouseData(id,"RENT"..i,"no-one")
				return true
			end
		end
	else
		for i = 1, 5, 1 do
			local name = houseData[id]["RENT"..i]
			if(name == getPlayerName(player)) then
				setHouseData(id,"RENT"..i,"no-one")
				return true
			end
		end
	end
	return false;
end

-- getHouseTenands(houseid)
-- Returns a table within all tenands in this house

function getHouseTenands(id)
	if not(houseData[id]) then return false end
	local rent = {}
	for i = 1, 5, 1 do
		rent[i] = houseData[id]["RENT"..i]
	end
	return rent;
end

-- getPlayerRentedHouse
-- Gets the House where a player is rented in --

function getPlayerRentedHouse(thePlayer)
	for index, house in pairs(getElementsByType("colshape")) do
		if(getElementData(house, "house") == true) and (getElementData(house, "ID")) then
			local id = tonumber(getElementData(house, "ID"))
			if not(id) then return false end
			local rent = {}
			for i = 1, 5, 1 do
				rent[i] = houseData[id]["RENT"..i]
			end
			for index, player in pairs(rent) do
				if(player == getPlayerName(thePlayer)) then
					return id;
				end
			end
		end
	end
	return false;
end

-- isPlayerRentedHouse
-- Checks if a player is rented in a specific house

function isPlayerRentedHouse(thePlayer, id)
	if not(houseData[id]) then return false end
	local rent = {}
	for i = 1, 5, 1 do
		rent[i] = houseData[id]["RENT"..i]
	end
	for index, player in pairs(rent) do
		if(player == getPlayerName(thePlayer)) then
			return true;
		end
	end
	return false;
end
