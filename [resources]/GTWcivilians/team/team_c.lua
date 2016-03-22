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

local refreshTimer = nil
x,y = guiGetScreenSize()
window = guiCreateWindow((x-400)/2, (y-300)/2, 400, 300, "Manage job", false )
closeButton = guiCreateButton(280,260,110,36,"Close",false,window)
endWorkButton = guiCreateButton(10,260,110,36,"End work",false,window)
crimWorkButton = guiCreateButton(124,260,110,36,"Criminal",false,window)
jobRankLabel = guiCreateLabel( 20, 70, 100, 70, "", false, window )
jobValueLabel = guiCreateLabel( 120, 70, 200, 70, "", false, window )
exports.GTWgui:setDefaultFont(closeButton, 10)
exports.GTWgui:setDefaultFont(endWorkButton, 10)
exports.GTWgui:setDefaultFont(crimWorkButton, 10)
exports.GTWgui:setDefaultFont(jobRankLabel, 10)
exports.GTWgui:setDefaultFont(jobValueLabel, 10)
guiSetVisible(window,false)
addEventHandler("onClientGUIClick",root,function()
	if source == closeButton then
		guiSetVisible(window, false)
		showCursor(false)
	elseif source == endWorkButton then
		if getPlayerWantedLevel() > 0 then exports.GTWtopbar:dm("You can't end your work due to your wanted level!", 255, 0, 0) return end
		triggerServerEvent( "acorp_onEndWork", localPlayer, localPlayer )
		triggerEvent( "acorp_onEndWork", localPlayer, localPlayer )
		refreshTimer = setTimer(refreshRank, 500, 20)
	elseif source == crimWorkButton then
		triggerServerEvent( "acorp_gocrim", localPlayer, localPlayer )
		refreshTimer = setTimer(refreshRank, 500, 20)
	end
end)

-- Asyncron event to receive a player rank client side
addEvent ( "onReceivePlayerRank", true )
function receiveRankEventHandler( rank, next, currentValue, nextValue, levelID )
	guiSetText( jobRankLabel, "Occupation: \nCurrent level: \nNext level: \nProgress: " )
	local occ = getElementData(localPlayer,"Occupation")
	if not occ or occ == "" then
		occ = "Unemployed"
	end
	guiSetText( jobValueLabel, occ.."\n"..rank.." (Level: "..levelID..")".."\n"..next.."\n"..currentValue.." of "..nextValue )
end
addEventHandler ( "onReceivePlayerRank", localPlayer, receiveRankEventHandler )

function refreshRank()
	if not guiGetVisible(window) then return end
	if isTimer(refreshTimer) then killTimer(refreshTimer) end
	get_player_rank(getElementData(localPlayer,"Occupation"))
end

function showWorkGUI( )
	guiSetVisible(window, not guiGetVisible(window))
	showCursor(not isCursorShowing())
	get_player_rank(getElementData(localPlayer,"Occupation"))
end
addCommandHandler( "managework", showWorkGUI )
bindKey( "F5", "down", "managework" )
