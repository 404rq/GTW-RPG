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

-- Variable to check of a player has spawn protection
is_spawn_protected 	= nil

--[[ Get spawn protection ]]--
function set_spawn_protection(time_s)
        is_spawn_protected = setTimer(function() end, time_s*1000, 1)
end
addEvent("GTWhospital.setSpawnProtection", true)
addEventHandler("GTWhospital.setSpawnProtection", localPlayer, set_spawn_protection)

--[[ Protect players from taking damage on spawn]]--
function protect_spawn(attacker, weapon, bodypart)
	if not isTimer(is_spawn_protected) then return end
	cancelEvent()
end
addEventHandler("onClientPlayerDamage", localPlayer, protect_spawn)

--[[ Protect players from being choked upon spawn ]]--
function protect_spawn_choke(weaponID, responsiblePed)
	if not isTimer(is_spawn_protected) then return end
	cancelEvent()
end
addEventHandler("onClientPlayerChoke", localPlayer, protect_spawn_choke)

--[[ Global spawn sound handler ]]--
function onSoundEvent(cmd, sound)
        playSoundFrontEnd(tonumber(sound))
end
addCommandHandler("sound", onSoundEvent)
