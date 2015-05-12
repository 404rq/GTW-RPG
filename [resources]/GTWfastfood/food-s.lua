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

-- Add all the required stuff
function addMarkers(res)
	for k=1, #markers do
		-- Add the marker
		local markSize = 2
		local lower = 0
		if markers[k][5] == 0 then
			markSize = 3
			lower = 1
		end
    	marker[k] = createMarker(markers[k][1], markers[k][2], markers[k][3]-lower, "cylinder", markSize, 255, 255, 255, 30)
    	addEventHandler("onMarkerHit", marker[k], showGUI)
    	addEventHandler("onMarkerLeave", marker[k], hideGUI)
    	setElementDimension(marker[k], markers[k][4])
		setElementInterior(marker[k], markers[k][5])	
	end
	
	-- Setup invincible peds
	respawn_all_peds()
	setTimer(respawn_all_peds, 60*60*12*1000, 0)
end
addEventHandler("onResourceStart", resourceRoot, addMarkers)

-- Respawn ped if dead
function respawn_all_peds()
	for k=1, #blips do	
		-- Clean up old data
		if isElement(blip[k]) then destroyElement(blip[k]) end
		if isElement(ped[k]) then destroyElement(ped[k]) end
		
		-- Create blips
		blip[k] = createBlip(blips[k][1], blips[k][2], blips[k][3], blips[k][4], 1, 0, 0, 0, 255, 111, 180)
		ped[k] = createPed(peds[k][7], peds[k][1], peds[k][2], peds[k][3])
		setElementData(marker[k], "location", peds[k][8])
		
    	-- Create the ped
		setElementDimension(ped[k], peds[k][4])
		setElementInterior(ped[k], peds[k][5])
		setPedRotation(ped[k], peds[k][6])
		setElementData(ped[k], "robLoc", peds[k][8])
    end
end

-- Open the gui
function showGUI(hitPlayer, matchingDimension)
	if matchingDimension then
		local counter = 1
		for k=1, #markers do
			if source == marker[k] then
				counter = k
			end
		end
		-- if hitPlayer and isElement(hitPlayer) and getElementType(hitPlayer) == "player" and getPlayerWantedLevel(hitPlayer) > 0 then return end
		if getElementInterior(source) > 0 then
			local location = getElementData(source, "location")
			if location and not getElementData(hitPlayer, "rob") then
				exports.GTWtopbar:dm("Welcome to "..location.."!", hitPlayer, 0, 255, 0)
			end
			if matchingDimension and not getElementData(hitPlayer, "rob")  then
				triggerClientEvent(hitPlayer, "GTWfastfood.gui.show", getRootElement(), hitPlayer, markers[counter][6])
			end
			if matchingDimension and getElementData(hitPlayer, "rob") then
				exports.GTWtopbar:dm("You can't shop while robbing a store idiot!", client, 255, 0, 0)
			end
		else
			if matchingDimension and hitPlayer and isElement(hitPlayer) and getElementType(hitPlayer) == "player" and getPedOccupiedVehicle(hitPlayer) then
				triggerClientEvent(hitPlayer, "GTWfastfood.gui.show", getRootElement(), hitPlayer, markers[counter][6])
			end
		end
	end
end
-- Close the gui
function hideGUI(leavePlayer)
	if not isTimer(antiSpam) and not getElementData(leavePlayer, "rob") then
		exports.GTWtopbar:dm("Thank you sir! welcome back next time you're hungry", leavePlayer, 0, 255, 0)
		antiSpam = setTimer(function() end, 20000, 1)
	end
	triggerClientEvent(leavePlayer,"GTWfastfood.gui.hide",getRootElement(),leavePlayer)
end

-- Take money and increase health
function buyFood(money, health)
	if not getElementData(client, "rob") then
		if (getElementHealth(client) + health) < 100 then
			takePlayerMoney(client, money)
			setElementHealth(client, getElementHealth(client) + health)
		elseif getElementHealth(client) < 100 then
			takePlayerMoney(client, money)
			setElementHealth(client, 100)
		else
			exports.GTWtopbar:dm("You already ate enough fatty!", client, 255, 0, 0)
		end
	else
		exports.GTWtopbar:dm("You can't shop when robbing a store idiot!", client, 255, 0, 0)
	end
end
addEvent("GTWfastfood.buy",true)
addEventHandler("GTWfastfood.buy",getRootElement(),buyFood)
