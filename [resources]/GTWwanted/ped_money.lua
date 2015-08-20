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
	local x,y,z = getElementPosition(source)
	profit[killer] = math.random(1,200)
    local pickup = createPickup(x, y, z, 3, 1212, 120000, profit[killer])
    if pickup then
    	setTimer(destroyMinutePickup, 45000, 1, pickup)
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

   	-- Get wanted for stealing money
   	setWl(plr, round(0.6, 2), 10, "You committed the crime of robbery")
end
