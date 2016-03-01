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

local timer 		= nil
local messages 		=  { }
local last_msg 		= ""
local display_time_ms 	= 12000

--[[ Display a DX topbar message ]]--
function dm(text, r,g,b, col, bell)
	-- Insert message
	local tick = getTickCount()
	if text == last_msg then return end
	if not col then col = false end
	if bell then playSoundFrontEnd(11) end
	table.insert(messages, {text, true, tick + display_time_ms, 170, r,g,b, col })
	outputConsole("[TOPBAR] "..text)
	last_msg = text
	setTimer(function() last_msg = "" end, 10000, 1)

	-- Play a message notification sound
	--playSoundFrontEnd(11)
end
addEvent("GTWtopbar.addText", true)
addEventHandler("GTWtopbar.addText", root, dm)

--[[ Render all DX messages ]]--
local sx,sy = guiGetScreenSize()
function render_topbar( )
	local tick = getTickCount()

	-- Prevent to many messages to display at the same time
	if #messages > 7 then table.remove(messages, 1) end

	-- Loop through all messages
	for k,data in ipairs(messages) do
		-- Draw the messages
		dxDrawRectangle(sx/2 - 400, (-26)+(k*25), 800, 25, tocolor(0, 0, 0, data[4]))
		dxDrawText(data[1], sx/2, (-25)+(k*46), sx/2, 0, tocolor(data[5], data[6], data[7],
			data[4]+75), 0.55, "bankgothic", "center", "center", false, true, false, data[8])

		-- Remove after fading out
		if tick >= data[3] then
			messages[k][4] = data[4]-2
			if data[4] <= 1 then table.remove(messages, k) end
		end
	end
end
addEventHandler("onClientRender", root, render_topbar)
