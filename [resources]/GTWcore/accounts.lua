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

save_timers     = { }

--[[ Manage leaving players and save data ]]--
function player_quit(type)
        -- Save all player data
        save_data(source)

        -- Kill the save timer
        if save_timers[source] then
        	killTimer(save_timers[source])
        end

        -- Inform everyone else that a user left the game (only if logged in)
        if getPlayerAccount(source) and not isGuestAccount(getPlayerAccount(source)) then
    	        exports.GTWtopbar:dm(getPlayerName(source).." has left the game ["..type.."]", root, 255,100,0)
        end
end
addEventHandler("onPlayerQuit", root, player_quit)

--[[ On first spawn, load all data ]]--
function player_Spawn(posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension)
        -- Check if this is the first spawn
        if not getElementData(source, "GTWdata.isFirstSpawn") then return end

	-- Play spawn sound
	playSoundFrontEnd(source, 16)

        -- Load all data
        load_data(source)

        -- Start saving timer, save every minute
        save_timers[source] = setTimer(save_data, 60*1000, 0, source)
end
-- add the player_Spawn function as a handler for onPlayerSpawn
addEventHandler("onPlayerSpawn", root, player_Spawn)

-- Start saving timer, save every minute for all players
for k,v in pairs(getElementsByType("player")) do
        save_timers[v] = setTimer(save_data, 60*1000, 0, v)
end
