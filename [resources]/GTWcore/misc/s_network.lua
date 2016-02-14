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

--[[ Freeze a player upon packet loss ]]--
function disable_lagging_players(status, ticks)
        if status == 0 then
                if (getElementData(source, "GTWcore.packetLoosCount") or 0) < 3 then
                        outputServerLog("NETWORK: packet loss: "..getPlayerName(source)..", begin: "..ticks.." ticks ago")
                end
                --outputChatBox("Packet loss detected, you will be frozen until your connection is working again!", source, 200,0,0)
                --setElementFrozen(source, true)
                setElementData(source, "GTWcore.packetLoosCount", (getElementData(source, "GTWcore.packetLoosCount") or 0) + 1)
        elseif status == 1 then
                if (getElementData(source, "GTWcore.packetLoosCount") or 0) < 3 then
                        outputServerLog("NETWORK: packet loss: "..getPlayerName(source).." ended: "..ticks.." ticks ago")
                end

                --outputChatBox("Packet loss ended, enjoy the game!", source, 0,200,0)
                --setElementFrozen(source, false)
        end
end
addEventHandler("onPlayerNetworkStatus", root, disable_lagging_players)

--[[ Disable the ability to logout by command ]]--
function player_logout(acc, _)
        -- Display message
	exports.GTWtopbar:dm("You can't logout! use /disconnect or /reconnect to switch accounts", source, 255,0,0)
	outputChatBox("You can't logout! use /disconnect or /reconnect", source, 200,0,0)

        -- Cancel the event
        cancelEvent()
end
addEventHandler("onPlayerLogout", root, player_logout)

--[[ Display client IP adress ]]--
function display_my_ip(plr)
	outputChatBox("Your IP is: " .. getPlayerIP(plr), plr, 255,255,255)
end
addCommandHandler("myip", display_my_ip)
