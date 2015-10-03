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

-- Create the updates window
local x,y = guiGetScreenSize()
local window = guiCreateWindow((x-800)/2, (y-600)/2, 800, 600, "RageQuit 404 - MTA servers updates", false )
local txt_memo = guiCreateMemo(10, 30, 780, 526, "", false, window)
local old_text = ""

-- Set readonly, apply GUI style and hide
guiMemoSetReadOnly(txt_memo, true)
guiSetVisible(window,false)
exports.GTWgui:setDefaultFont(txt_memo, 10)

-- Add close button and triggers
local closeButton = guiCreateButton(10,560,780,30,"Close window",false,window)
exports.GTWgui:setDefaultFont(closeButton, 10)
addEventHandler("onClientGUIClick",closeButton,function()
	guiSetVisible(window, false)
	showCursor(false)
end)

-- Refresh and toggle updates list
function requestUpdates()
	-- Request updates list from RageQuit network (unavailable)
	old_text = guiGetText(txt_memo)
	if old_text == "" then
		guiSetText(txt_memo, "Connecting to 404rq.com/updates/ for latest updates, please wait...")
	end
	triggerServerEvent("GTWupdates.request", resourceRoot)
end
setTimer(requestUpdates,5*60*1000,0)

function onResponseFromServer(message)
    	-- Report changes to online players
    	if old_text ~= message and guiGetVisible(window) then
		guiSetText(txt_memo, message)
		exports.GTWtopbar:dm("Updates downloaded from: 404rq.com/updates/", 180, 180, 180 )
    	elseif old_text ~= message then
		guiSetText(txt_memo, message)
		exports.GTWtopbar:dm("Updates downloaded from: 404rq.com/updates/! "..
			"Use /updates to see what's new", 180, 180, 180)
    	end
end
addEvent( "GTWupdates.respond", true )
addEventHandler("GTWupdates.respond", root, onResponseFromServer)

function viewUpdateListGUI()
	guiSetVisible(window, not guiGetVisible(window))
	guiBringToFront(window)
	requestUpdates()
end
function toggleUpdateListGUI()
	guiSetVisible(window, not guiGetVisible(window))
	showCursor(not isCursorShowing())
	requestUpdates()
end
addCommandHandler("updates", toggleUpdateListGUI)

function getUpdatesList()
	return guiGetText(txt_memo)
end
