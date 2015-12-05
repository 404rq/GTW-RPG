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

-- Redcue damage made by minigun
setWeaponProperty(38, "pro", "damage", 2)
setWeaponProperty(38, "std", "damage", 2)
setWeaponProperty(38, "poor", "damage", 2)

-- Reduce health when falling into cold water
setTimer(function()
	for k,v in pairs(getElementsByType("player")) do
		if isElementInWater(v) and not getPedOccupiedVehicle(v) then
			local health = getElementHealth(v)
			local new_health = health - math.random(4, 12)
			local x,y,z = getElementPosition(v)
			-- Check if the area is north west (SF), south LS or if it's night
			local hour, minutes = getTime()
			if (y > 1500 and x < 1000) or y < -2800 or hour > 22 or hour < 9 then
				if new_health > 0 then
					setElementHealth(v, new_health)
					exports.GTWtopbar:dm("This water is cold! get up before you die!", v, 255, 0, 0)
				else
					killPed(v)
					exports.GTWtopbar:dm("You frooze to death in the cold water", v, 100, 255, 100)
				end
			end
		end
	end
end, 4000, 0)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
