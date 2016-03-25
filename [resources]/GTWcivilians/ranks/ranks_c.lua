--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Get the rank for given occupation ]]--
function get_player_rank(occupation)
	triggerServerEvent("onAskForPlayerRank", localPlayer, getElementData(localPlayer, "Occupation"))
end

--[[ Response from server are handled here ]]--
function receive_rank(rank, nextRank, curr, next, statLevel)
    triggerEvent( "onReceivePlayerRank", localPlayer, rank, nextRank, curr, next, statLevel )
end
addEvent("onRankReceive", true)
addEventHandler("onRankReceive", localPlayer, receive_rank)
