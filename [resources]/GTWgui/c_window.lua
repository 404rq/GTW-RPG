--[[
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

--[[ Make a custom GTW window ]]--
function createWindow(x, y, width, height, text, relative, source_resource )
	local window = guiCreateStaticImage(x, y, width, height, "img/back.png", relative )
	local winTitle = guiCreateLabel((width/2)-((string.len(text)*7)/2), 3, (string.len(text)*10), 20, text, relative, window)
	local winTitleFont = guiCreateFont( "fonts/RobotoSlab-Bold.ttf", 11 )
	local winFont = guiCreateFont( "fonts/RobotoSlab-Bold.ttf", 10 )
	
	-- Add resource to restart list
	if source_resource then
		triggerServerEvent("GTWgui.addToRefreshList", resourceRoot, source_resource)
	end	
	
	-- Apply the new font style of the GUI
	guiSetFont( winTitle, winTitleFont )	
	return window
end

--[[ Walrus default font ]]--
function setDefaultFont(inputElement, size)
	local font = guiCreateFont("fonts/RobotoSlab-Bold.ttf", size) 
	guiSetFont( inputElement, font )
end