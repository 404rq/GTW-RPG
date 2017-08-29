--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Anubhav

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

spawn_table = {
	['SAPD']={ 3199.2392578125, -1983.9248046875, 11.262499809265, 2.4307556152344 },
	['FBI']={ 603.8447265625, -1493.4306640625, 14.976615905 },
	['ArmedForces']={ 229.423828125, 1910.06640625, 17.640625, 86.944366455078 },
}

--[[ Check if player is in official group ]]--
function is_valid_group(plr)
	local group = getElementData(plr, "Group")
	if (spawn_table[group]) then
		return unpack(spawn_table[group])
	end
	return false
end

--[[ Allow official groups to spawn in their base ]]--
function go_to_spawn(plr)
	if (isPedDead(plr)) then
		return
	end
	local x,y,z = is_valid_group(plr)
	if x and y and z then
		setElementPosition(plr, x,y,z)
		outputChatBox("You have spawned at your group base. ("..getElementData(plr, "Group")..")", plr, 0,255,0)
	end
end
addCommandHandler("gospawn", go_to_spawn)
addCommandHandler("spawnatbase", go_to_spawn)
