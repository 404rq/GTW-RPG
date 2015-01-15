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

local x,y = guiGetScreenSize()
local window = exports.GTWgui:createWindow((x-800)/2, (y-600)/2, 800, 600, "Grand Theft Walrus - Server updates", false )
local text = guiCreateMemo( 10, 30, 780, 526, "", false, window )
guiMemoSetReadOnly(text, true)
guiSetVisible(window,false)
exports.GTWgui:setDefaultFont(text, 10)
--showCursor(true)
local closeButton = guiCreateButton(10,560,780,30,"Close window",false,window)
exports.GTWgui:setDefaultFont(closeButton, 10)
addEventHandler("onClientGUIClick",closeButton,function() 
	guiSetVisible(window, false)
	showCursor(false)
end)

local File = fileOpen("updates.txt", true)
local Text = fileRead(File, 10000)
Text = string.gsub(Text,"'''", "")
guiSetText(text,Text)

function viewUpdateListGUI()
	guiSetVisible(window, not guiGetVisible(window))
	guiBringToFront(window)
end
function toggleUpdateListGUI()
	guiSetVisible(window, not guiGetVisible(window))
	showCursor(not isCursorShowing())
end
addCommandHandler( "updates", toggleUpdateListGUI )
exports.GTWtopbar:dm("Updates has been added! Use /updates to see what's new", 255, 100, 0 )

function getUpdatesList()
	return Text
end