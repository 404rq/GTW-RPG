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

--[[ Display play time as up to date ]]--
function update_display(plr, init_time)
        if not plr or not isElement(plr) or
                getElementType(plr) ~= "player" then return end
        if not getPlayerAccount(plr) then return end

        -- Get the actual online time in seconds
        local acc = getPlayerAccount(plr)
        local l_time = getRealTime()
        local p_time = (l_time.timestamp - start_times[acc]) + init_time

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
	
	-- Define neew player
	if tonumber(hours) or 0 < 12 then
		setElementData(plr, "GTWcore.isNoob", true)
	else
		setElementData(plr, "GTWcore.isNoob", nil)
	end
end

--[[ Helper function to launch the play time system ]]--
function start_playtime_counter(plr, init_time)
        update_display(plr, math.floor(init_time))
        sync_timers[plr] = setTimer(update_display,
                1000, 0, plr, math.floor(init_time))
end

--[[ Load the playtime on login (compatible with the old system) ]]--
function load_playtime(_, acc)
        -- Look for any existing playtime in previous systems
        local c_time = getAccountData(acc, "GTWdata.playtime") or 0
        local l_time = getRealTime()

        -- Save the current timestamp as login time
        start_times[acc] = l_time.timestamp

        -- Set a insecure backup timestamp as login
        -- time in case the table data is unreachable
        setElementData(source, "GTWdata.temp.playtime", l_time.timestamp)

        -- Update display time
        start_playtime_counter(source, c_time/1000)
end
addEventHandler("onPlayerLogin", root, load_playtime)

--[[ Save the playtime upon quit ]]--
function save_playtime( )
        -- Get account of the player that left
        local acc = getPlayerAccount(source)
        if not acc or isGuestAccount(acc) then return end

        -- Kill sync timers
        if isTimer(sync_timers[source]) then
                killTimer(sync_timers[source])
                sync_timers[source] = nil
        end

        -- Calculate current playtime
        local l_time = getRealTime()
        local p_time = l_time.timestamp - (start_times[acc] or
                getElementData(source, "GTWdata.temp.playtime") or 0)

        -- Save playtime to database together with current
        setAccountData(acc, "GTWdata.playtime", (getAccountData(acc,
                "GTWdata.playtime") or 0) + ((p_time*1000) or 0))

        -- Clean memory
        start_times[acc] = nil
end
addEventHandler("onPlayerQuit", root, save_playtime)

--[[ Restart play time system on resource restart ]]--
function load_playtime_system()
	for k,v in pairs(getElementsByType("player")) do
                local acc = getPlayerAccount(v)
                if getElementData(v, "GTWdata.temp.playtime") and
                        acc and not isGuestAccount(acc) then
                        start_times[acc] = getElementData(v, "GTWdata.temp.playtime")
                        local c_time = getAccountData(acc, "GTWdata.playtime") or 0
                        start_playtime_counter(v, c_time/1000)
                end
        end
end
addEventHandler("onResourceStart", resourceRoot, load_playtime_system)
