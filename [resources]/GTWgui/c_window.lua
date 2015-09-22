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

--[[ Make a custom GTW window ]]--
function createWindow(x, y, width, height, text, relative, source_resource)
	local window = guiCreateStaticImage(x, y, width, height, "img/back.png", relative )
	local winTitle = guiCreateLabel((width/2)-((string.len(text)*7)/2), 3, (string.len(text)*10), 20, text, relative, window)
	local winTitleFont = guiCreateFont( "fonts/roboto.ttf", 11 )
	local winFont = guiCreateFont( "fonts/roboto.ttf", 10 )

	-- Add resource to restart list
	if source_resource then
		triggerServerEvent("GTWgui.addToRefreshList", resourceRoot, source_resource)
	end

	-- Add a close button TODO: repair this
	--local close_button = guiCreateButton(width-30, 0, 30, 28, "X", false, window)
	--addEventHandler("onClientGUIClick", close_button, function()
	--	guiSetVisible(window, false)
	--	showCursor(false, false)
	--end)

	-- Apply the new font style of the GUI
	guiSetFont(winTitle, winTitleFont)
	return window
end

--[[ Walrus default font ]]--
function setDefaultFont(inputElement, size)
	local font = guiCreateFont("fonts/roboto.ttf", size)
	guiSetFont(inputElement, font)
end

--[[ Toggle the cursor (globally) ]]--
function toggle_cursor()
	if isCursorShowing(localPlayer) then
    		showCursor(false, false)
    	else
    		showCursor(true, true)
    	end
end
bindKey("x", "down", toggle_cursor, "Toggle cursor")
