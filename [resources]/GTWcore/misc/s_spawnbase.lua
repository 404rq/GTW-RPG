--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Anubhav

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

spawnTable = {
	['SAPD']={ 3199.2392578125, -1983.9248046875, 11.262499809265, 2.4307556152344 },
	['FBI']={ 603.8447265625, -1493.4306640625, 14.976615905 },
	['ArmedForces']={ 229.423828125, 1910.06640625, 17.640625, 86.944366455078 },
}

function getPlayerElgibleGroup( p )
	local g = getElementData( p, "Group" )
	if (spawnTable[g]) then
		return unpack(spawnTable[g])
	end
	return false
end

function goSpawn( p )
	if (isPedDead( p )) then
		return
	end
	local x, y, z = getPlayerElgibleGroup(p)
	if (x) then
		setElementPosition( p, x, y, z )
		outputChatBox( "You have spawned at your group base. ("..getElementData(p, "Group")..")", p, 0, 255, 0 )
	end
end
addCommandHandler( "gospawn", goSpawn )