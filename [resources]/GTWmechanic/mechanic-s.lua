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

local default_money = 428  	-- Global definition based on what mechanics earn IRL/year 
							-- divided by 12 and then 31 as in days multiplied by 4

--[[ Pay for repair and refuel ]]--
function pay_repair(mech, owner)
	local pacc = getPlayerAccount(mech)
	local repaired_cars = getAccountData(pacc, "acorp_stats_repaired_cars") or 0
	if isElement(owner) then
		takePlayerMoney(owner, default_money*3)
	end
	givePlayerMoney(mech, (default_money*2)+repaired_cars)
end
function pay_refuel(mech, owner)
	local pacc = getPlayerAccount(mech)
	local repaired_cars = getAccountData(pacc, "acorp_stats_repaired_cars") or 0
	if owner and isElement(owner) then
		takePlayerMoney(owner, default_money)
	end
	givePlayerMoney(mech, (default_money/2)+repaired_cars)
end

--[[ Repair vehicle as mechanic ]]--
function repair_veh(veh, repairTime)
	if not veh or not isElement(veh) then outPutTopbarMessage("No vehicle found", client, 255, 0, 0) return end
	local acc = getElementData(veh, "owner")
	if not acc then return end
	local owner = getAccountPlayer(getAccount(acc))
	if not owner then outPutTopbarMessage("The owner of this vehicle is currently offline!", client, 255, 0, 0) return end
	
	-- Freeze elements during repair
	setElementFrozen(veh, true)
	setElementFrozen(client, true)
	setPedAnimation(client, "GRAFFITI", "spraycan_fire", -1, true, false)
	showCursor(client, true)
	outPutTopbarMessage("Reparing vehicle...", client, 0, 255, 0)
	outPutTopbarMessage("Your vehicle is repaired...", owner, 0, 255, 0)
	
	-- Reset after repair
	setTimer(fixVehicle, math.floor(repairTime), 1, veh)
	setTimer(showCursor, math.floor(repairTime), 1, client, false)
	setTimer(setElementFrozen, math.floor(repairTime), 1, veh, false)
	setTimer(setElementFrozen, math.floor(repairTime), 1, client, false)
	setTimer(outPutTopbarMessage, math.floor(repairTime), 1, "Vehicle was sucsessfully repaired!", client, 0, 255, 0)
	setTimer(outPutTopbarMessage, math.floor(repairTime), 1, "Your vehicle was repaired by: "..getPlayerName(client), owner, 0, 255, 0)
	setTimer(pay_repair, math.floor(repairTime), 1, client, owner)
	setTimer(setPedAnimation, math.floor(repairTime), 1, client, nil, nil)
				
	-- Increase stats by 1 (if not your own car, solution to abuse 2014-11-13)
	if owner == client then return end
	local playeraccount = getPlayerAccount(client)
	local repaired_cars = getAccountData(playeraccount, "acorp_stats_repaired_cars") or 0
	setAccountData(playeraccount, "acorp_stats_repaired_cars", repaired_cars + 1)
end
addEvent("GTWmechanic.repair", true)
addEventHandler("GTWmechanic.repair", root, repair_veh)

--[[ Refule as mechanic ]]--
function refuel_veh(veh, refuelTime)
	if not veh or not isElement(veh) then outPutTopbarMessage("No vehicle found", client, 255, 0, 0) return end
	local acc = getElementData(veh, "owner")
	if not acc then return end
	local owner = getAccountPlayer(getAccount(acc))
	if not owner then outPutTopbarMessage("The owner of this vehicle is currently offline!", client, 255, 0, 0) return end
	
	-- Freeze elements during repair
	setElementFrozen(veh, true)
	setElementFrozen(client, true)
	setPedAnimation(client, "GRAFFITI", "spraycan_fire", -1, true, false)
	showCursor(client, true)
	outPutTopbarMessage("Refueling vehicle...", client, 0, 255, 0)
	outPutTopbarMessage("Your vehicle is being refuled...", owner, 0, 255, 0)
	
	-- Reset after repair
	setTimer(showCursor, math.floor(refuelTime), 1, client, false)
	setTimer(setElementFrozen, math.floor(refuelTime), 1, veh, false)
	setTimer(setElementFrozen, math.floor(refuelTime), 1, client, false)
	setTimer(outPutTopbarMessage, math.floor(refuelTime), 1, "Vehicle was sucsessfully refuled!", client, 0, 255, 0)
	setTimer(outPutTopbarMessage, math.floor(refuelTime), 1, "Your vehicle was refuled by: "..getPlayerName(client), owner, 0, 255, 0)
	setTimer(setPedAnimation, math.floor(refuelTime), 1, client, nil, nil)
	setTimer(pay_refuel, math.floor(refuelTime), 1, client, owner)
	setTimer(setElementData, math.floor(refuelTime), 1, veh, "vehicleFuel", 100)
end
addEvent("GTWmechanic.refuel", true)
addEventHandler("GTWmechanic.refuel", root, refuel_veh)

--[[ Fix and repair as staff ]]--
function staff_repair(veh)
	local is_staff = exports.GTWstaff:isStaff(client)
    if not is_staff then
		outPutTopbarMessage("You are not allowed to use this feature!", client, 255, 0, 0)    	
    	return 
    end
	if not veh or not isElement(veh) then return end
	outPutTopbarMessage("Vehicle was sucsessfully repaired!", client, 0, 255, 0)
	setElementData(veh, "vehicleFuel", 100)
	fixVehicle(veh)
	local x,y,z = getElementPosition(client)
	outputServerLog("ADMIN: "..getPlayerName(client).." has repaired and refuled a vehicle at: ["..math.floor(x)..","..math.floor(y)..","..math.floor(z).."]")
end
addEvent("GTWmechanic.staff.repair", true)
addEventHandler("GTWmechanic.staff.repair", root, staff_repair)

--[[ Enter any vehicle as staff ]]--
function staff_enter(veh)
	local is_staff = exports.GTWstaff:isStaff(client)
    if not is_staff then
		outPutTopbarMessage("You are not allowed to use this feature!", client, 255, 0, 0)    	
    	return 
    end
	if not veh or not isElement(veh) then return end
	warpPedIntoVehicle(client, veh)
	local x,y,z = getElementPosition(client)
	outputServerLog("ADMIN: "..getPlayerName(client).." has warped into a vehicle at: ["..math.floor(x)..","..math.floor(y)..","..math.floor(z).."]")
end
addEvent("GTWmechanic.staff.enter", true)
addEventHandler("GTWmechanic.staff.enter", root, staff_enter)

--[[ Staff destroy vehicle ]]--
function staff_destroy(veh)
	local accName = getAccountName(getPlayerAccount(client)) 
	if not (isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) or 
    	isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) or 
    	isObjectInACLGroup("user."..accName, aclGetGroup("Moderator"))) then
		outPutTopbarMessage("You are not allowed to use this feature!", client, 255, 0, 0)    	
    	return 
    end
	if not veh or not isElement(veh) then return end
	if getElementData(veh,"owner") then
		outPutTopbarMessage("Vehicle was sucsessfully removed!", client, 0, 255, 0)
		outputServerLog("VEH_ADMIN: Vehicle was removed at: "..getZoneName(getElementPosition(veh))..
			", by: "..getPlayerName(client).." owner was: "..getElementData(veh,"owner"))
	end
	
	-- Clean up if owned vehicle bought in shop
	triggerEvent("GTWvehicleshop.onPlayerVehicleDestroy", root, veh, true)
end
addEvent("GTWmechanic.destroy", true)
addEventHandler("GTWmechanic.destroy", root, staff_destroy)
function outPutTopbarMessage(message, thePlayer, r, g, b)
	exports.GTWtopbar:dm(message, thePlayer, r, g, b)
end