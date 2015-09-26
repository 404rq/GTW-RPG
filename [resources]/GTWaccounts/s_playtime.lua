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

-- Table to keep timestamp of login times
start_times     = { }
sync_timers     = { }

function update_display(plr, old_time)
        if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
        if not getPlayerAccount(plr) then return end

        -- Get the actual online time in seconds
        local acc = getPlayerAccount(plr)
        local l_time = getRealTime()
        local p_time = (l_time.timestamp - start_times[acc]) + old_time

        -- Get the online time formatted
        local seconds = tostring(p_time%60)
        if p_time%60 < 10 then seconds = "0"..seconds end
        local minutes = tostring(math.floor(p_time/60)%60)
        if math.floor(p_time/60)%60 < 10 then minutes = "0"..minutes end
        local hours = tostring(math.floor(p_time/(60*60)))
        if math.floor(p_time/(60*60)) < 10 then hours = "0"..hours end
        local formatted_time = hours..":"..minutes..":"..seconds

        -- Update display time
        setElementData(plr, "Playtime", formatted_time)
end

--[[ Load the playtime on login (compatible with the old system) ]]--
function load_playtime(_, acc)
        -- Look for any existing playtime in previous systems
        local c_time = getAccountData(acc, "acorp.playtime") or 0
        local l_time = getRealTime()

        -- Save the current timestamp as login time
        start_times[acc] = l_time.timestamp

        -- Update display time
        update_display(source, math.floor(c_time/1000))
        sync_timers[source] = setTimer(update_display, 1000, 0, source, math.floor(c_time/1000))
end
addEventHandler("onPlayerLogin", root, load_playtime)

--[[ Save the playtime upon quit ]]--
function save_playtime( )
        -- Get account of the player that left
        if not getPlayerAccount(source) then return end
        local acc = getPlayerAccount(source)

        -- Kill sync timers
        if isTimer(sync_timers[source]) then
                killTimer(sync_timers[source])
                sync_timers[source] = nil
        end

        -- Calculate current playtime
        local l_time = getRealTime()
        --local p_time = l_time.timestamp - start_times[acc]
        --outputServerLog("ACCOUNTS: Player: "..getPlayerName(source).." left the game with a playtime of: "..p_time.." seconds")

        -- Clean memory
        start_times[acc] = nil
end
addEventHandler("onPlayerQuit", root, save_playtime)
