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

-- Globals
timers = { }
profit = {}

--[[ Triggers whenever a ped is killed ]]--
function killedPed(totalAmmo, killer, killerWeapon, bodypart, stealth)
	-- Do not drop money for law units
	if killer and getElementType(killer) == "player" and getPlayerTeam(killer) and getPlayerTeam(killer) == getTeamFromName("Government") then return end

	-- Get profitability multiplier
	local probability_of_richness = math.random(1,1000)
	if probability_of_richness < 900 then
		probability_of_richness = 1
	elseif probability_of_richness < 975 then
		probability_of_richness = 3
	elseif probability_of_richness < 999 then
		probability_of_richness = 10
	else
		probability_of_richness = 100
	end
	
	-- Create a money pickup at the position of the dead bot
	local x,y,z = getElementPosition(source)
	profit[killer] = math.random(5,200)*probability_of_richness -- Max profit: $20´000
	
	-- Increase payment if the dead bot was an outlaw
	if getElementData(source, "GTWoutlaws.vBot") then 
		profit[killer] = math.random(50,500)*probability_of_richness -- Max profit: $50´000
	end
	
	-- Make the pickup and make sure it's removed after 2 minutes if not picked up
	local pickup = createPickup(x, y, z, 3, 1212, 120000, profit[killer])
	if pickup then
		setTimer(destroyMinutePickup, 120*1000, 1, pickup)
		addEventHandler("onPickupHit", pickup, givePickupMoney)
	end
end
addEventHandler("onPedWasted", root, killedPed)

--[[ Destroy the pickup after given time  ]]--
function destroyMinutePickup(pickup)
	if isElement(pickup) then
		removeEventHandler("onPickupHit", pickup, givePickupMoney)
		destroyElement(pickup)
	end
end

--[[ Make the robber wanted on money pickup ]]--
function givePickupMoney(plr)
	if not profit[plr] then profit[plr] = math.random(1,50) end
	removeEventHandler("onPickupHit", source, givePickupMoney)
	destroyElement(source)
   	givePlayerMoney(plr, profit[plr])
	
	-- Calculate wanted level
	local wanted_level = (profit[plr]/10000)
	if wanted_level < 0.6 then wanted_level = 0.6 end

   	-- Get wanted for stealing money
   	setWl(plr, round(wanted_level, 2), 10, "You committed the crime of robbery")
end
