--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

local x,y = guiGetScreenSize()
local window = exports.GTWgui:createWindow((x-850)/2, (y-550)/2, 850, 550, "Grand Theft Walrus - Documentation", false )
local textBox = guiCreateMemo( 246, 30, 594, 510, "", false, window )
local gList = guiCreateGridList( 10, 30, 230, 510, false, window ) 
exports.GTWgui:setDefaultFont(textBox, 10)
exports.GTWgui:setDefaultFont(gList, 10)
guiGridListSetSelectionMode(gList,2)
guiMemoSetReadOnly(textBox, true)
guiGridListAddColumn(gList,"Content",0.9)
guiSetVisible(window,false)
showCursor(false)

local F1wndShowing = false
bindKey('f1','down',
function()	
	if F1wndShowing == true then
	    guiSetVisible(window, false)
        showCursor(false)
        guiSetInputEnabled( false )
        F1wndShowing = false
    else
        guiSetVisible(window, true)
        showCursor(true)
        guiSetInputEnabled( true )
        F1wndShowing = true 
    end
end)

-- Disable sorting
--guiGridListSetSortingEnabled( gList, false )

local Text = { }
for i,val in ipairs(list) do
    local rowID = guiGridListAddRow(gList)
    if val[2] == 0 then
    	guiGridListSetItemText(gList, rowID, 1, val[1], true, true)
    	guiGridListSetItemColor( gList, rowID, 1, 100, 100, 100 ) 
    else
    	guiGridListSetItemText(gList, rowID, 1, val[1], false, true)
    	Text[rowID] = list[rowID+1][3]
    end
end
guiSetText(textBox,Text[1])

addEventHandler('onClientGUIClick',root,
function()
	local row,col = guiGridListGetSelectedItem ( gList )
	if Text[row] then
    	guiSetText(textBox,Text[row])
    end
end)
