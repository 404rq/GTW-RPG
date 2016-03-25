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

iron_objects 		= {{ }}
iron_markers 		= {{ }}
associated_rocks 	= { }
bomb_price 		= 1200
bomb_cooldown 		= { }

function calculate_profit(plr)
	local total = 0

	-- Minerals prices
	local platinum_price = 600
	local gold_price = 500
	local silver_price = 350
	local iron_price = 110
	local cupper_price = 80

	-- Calculate total
	total = (getElementData(plr, "GTWironminer.platinum") or 0)*platinum_price +
		(getElementData(plr, "GTWironminer.gold") or 0)*gold_price +
		(getElementData(plr, "GTWironminer.silver") or 0)*silver_price +
		(getElementData(plr, "GTWironminer.iron") or 0)*iron_price +
		(getElementData(plr, "GTWironminer.cupper") or 0)*cupper_price

	-- Return result
	return total
end

-- Plant the bomb to extract the rocks
function plant_bomb(plr)
	if getPlayerTeam(plr) ~= getTeamFromName("Civilians") or getElementData(plr, "Occupation") ~= "Iron miner" then return end

	-- Check if on the ground
	if not getElementData(plr, "isOnGround") then
		exports.GTWtopbar:dm("Ironminer: You're not on the ground!", plr, 255, 0, 0)
		return
	end

	-- Check some more stuff
	if iron_objects[plr] and iron_objects[plr][k] then
		exports.GTWtopbar:dm("Ironminer: You are already mining!", plr, 255, 0, 0)
		return
	end
	if getPlayerMoney(plr) < bomb_price then
		exports.GTWtopbar:dm("Ironminer: You are to poor to afford the bomb!", plr, 255, 0, 0)
		return
	end
	if bomb_cooldown[plr] and isTimer(bomb_cooldown[plr]) then
		exports.GTWtopbar:dm("Ironminer: Please allow up to 1 minute before you plant the next bomb!", plr, 255, 0, 0)
		return
	end

	-- Check if inside a vehicle, then it's terrorism due to the "car bomb"
	if getPedOccupiedVehicle(plr) then
		exports.GTWwanted:setWl(plr, 6, 900, "You comitted the crime of terrorism!", true, false)
	end

	-- Notice
	takePlayerMoney(plr, bomb_price)
	exports.GTWtopbar:dm("Ironminer: The bomb has been planted (10s), take cover, bomb price: $"..bomb_price, plr, 255, 100, 0)

	-- Prepare explosion
	local x,y,z = getElementPosition(plr)
	setTimer(createExplosion, 10000, 1, x,y,z, 0, plr)

	-- Create a bunch of rocks to mine from
	setTimer(create_miner, 11000, 1, plr, x,y,z-0.8)

	-- Apply a bomb cooldown
	bomb_cooldown[plr] = setTimer(function() end, 60*1000, 1)
end
addCommandHandler("plantbomb", plant_bomb)

-- Bind the n key to the command
for w,pl in pairs(getElementsByType("player")) do
	bindKey( pl, "n", "down", "plantbomb" )
end
addEventHandler("onPlayerLogin", root,
function()
    	bindKey( source, "n", "down", "plantbomb" )
end)

function clean_up_and_install(plr)
	for k=1, 16 do
		if iron_objects[plr] and iron_objects[plr][k] and isElement(iron_objects[plr][k]) then
			destroyElement(iron_objects[plr][k])
			iron_objects[plr][k] = nil
		end
		if iron_markers[plr] and iron_markers[plr][k] and isElement(iron_markers[plr][k]) then
			destroyElement(iron_markers[plr][k])
			iron_markers[plr][k] = nil
		end

	end
	if not iron_objects[plr] then iron_objects[plr] = { } end
	if not iron_markers[plr] then iron_markers[plr] = { } end
end

-- Setup the mining place
function create_miner(plr, x,y,z)
	clean_up_and_install(plr)
	for k=1, math.random(5,15) do
		local add_x = math.random(1,8)-4
		local add_y = math.random(1,8)-4
		local rock = createObject(3929, x+add_x,y+add_y,z, 0,0,0)
		table.insert(iron_objects[plr], rock)

		local marker = createMarker(x+add_x,y+add_y,z, "cylinder", 1.8, 0,0,0, 0, root)
		addEventHandler("onMarkerHit", marker, start_digging)
		associated_rocks[marker] = rock
		table.insert(iron_markers[plr], marker)
	end
	setTimer(clean_up_and_install, 1200000, 1, plr)
end

function start_digging(hitElement, matchingDimension)
	if not hitElement or not isElement(hitElement) or getElementType(hitElement) ~= "player" or
		getPedOccupiedVehicle(hitElement) or doesPedHaveJetPack(hitElement) or
		getElementData(hitElement, "isMining") then return end

	-- Check team and occupation
	if getPlayerTeam(hitElement) ~= getTeamFromName("Civilians") or getElementData(hitElement, "Occupation") ~= "Iron miner" then return end

	-- Check if the miner owns a shovel
	if getPedWeapon(hitElement, 1) ~= 6 then
		exports.GTWtopbar:dm("Ironminer: You need a shovel in order to mine!", hitElement, 255, 0, 0)
		return
	end

	-- Start and stop mining animation
	local x,y,z = getElementPosition(hitElement)
	toggleControl(hitElement, "forwards", false)
	setElementData(hitElement, "isMining", true)
    	setPedAnimation(hitElement, "SWORD", "sword_4", -1, true, true, false)
    	setCameraMatrix(hitElement, x,y,z+8, x,y,z, 5)
    	setTimer(give_iron, 7000, 1, hitElement, source)
    	setPedWeaponSlot(hitElement, 1)
end

function sell_iron(hitElement, matchingDimension)
	if not hitElement or not isElement(hitElement) or getElementType(hitElement) ~= "player" or
		getPedOccupiedVehicle(hitElement) or doesPedHaveJetPack(hitElement) or calculate_profit(hitElement) == 0 then return end

	-- Pay for iron
	local money = calculate_profit(hitElement)
	givePlayerMoney(hitElement, money)
	exports.GTWtopbar:dm("You have sold your minerals for: $"..money, hitElement, 0, 255, 0)

	-- Clear iron
	setElementData(hitElement, "GTWironminer.platinum", 0)
    	setElementData(hitElement, "GTWironminer.gold", 0)
    	setElementData(hitElement, "GTWironminer.silver", 0)
    	setElementData(hitElement, "GTWironminer.iron", 0)
    	setElementData(hitElement, "GTWironminer.cupper", 0)
    	setElementData(hitElement, "GTWironminer.profit", 0)
end

function give_iron(plr, marker)
	-- Destroy rock and it's hidden marker
	if isElement(associated_rocks[marker]) then destroyElement(associated_rocks[marker]) end
	if isElement(marker) then destroyElement(marker) end

	-- Stop the animation
	setPedAnimation(plr, nil,nil)
	setCameraTarget(plr, plr)
	toggleControl(plr, "forwards", true)

	-- Reset mining data
	setElementData(plr, "isMining", nil)

	-- Update the info
	setElementData(plr, "GTWironminer.platinum", (getElementData(plr, "GTWironminer.platinum") or 0)+math.floor(math.random(1,50)/47))
	setElementData(plr, "GTWironminer.gold", (getElementData(plr, "GTWironminer.gold") or 0)+math.floor(math.random(1,40)/36))
	setElementData(plr, "GTWironminer.silver", (getElementData(plr, "GTWironminer.silver") or 0)+math.floor(math.random(1,40)/33))
	setElementData(plr, "GTWironminer.iron", (getElementData(plr, "GTWironminer.iron") or 0)+math.floor(math.random(1,30)/10))
	setElementData(plr, "GTWironminer.cupper", (getElementData(plr, "GTWironminer.cupper") or 0)+math.floor(math.random(1,30)/7))

	-- Set iron value
	setElementData(plr, "GTWironminer.profit", calculate_profit(plr))
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

-- Set up sale spot
local iron_sell_marker = createMarker(814,837,8.7, "cylinder", 3, 200,200,200, 70, root)
addEventHandler("onMarkerHit", iron_sell_marker, sell_iron)
