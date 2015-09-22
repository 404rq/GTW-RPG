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

-- Define the menu GUI window
local sx,sy = guiGetScreenSize()
local win_menu = guiCreateWindow((sx-320)/2, (sy-297)/2, 320, 297, "Restaurant menu", false)
guiSetVisible(win_menu, false)

-- Define the menu buttons
btn_close = guiCreateButton(210,257,100,36,"Close",false,win_menu)
btn_choice_1 = guiCreateButton(10,100,160,36, "Buster("..prices[1].."$)",false,win_menu)
btn_choice_2 = guiCreateButton(10,217,160,36, "Double D-Luxe("..prices[2].."$)",false,win_menu)
btn_choice_3 = guiCreateButton(170,100,160,36, "Full rack("..prices[3].."$)",false,win_menu)
btn_choice_4 = guiCreateButton(170,217,160,36, "Sallad meal("..prices[4].."$)",false,win_menu)

-- Apply GTWgui styles
exports.GTWgui:setDefaultFont(btn_close, 10)
exports.GTWgui:setDefaultFont(btn_choice_1, 10)
exports.GTWgui:setDefaultFont(btn_choice_2, 10)
exports.GTWgui:setDefaultFont(btn_choice_3, 10)
exports.GTWgui:setDefaultFont(btn_choice_4, 10)

--[[ Update the GUI depending on restaurant type ]]--
function initialize_menu_choices(r_type)
	-- Set the text and prices on buttons and window title
	guiSetText(win_menu, menu_choices[r_type]["title"])
	guiSetText(btn_choice_1, menu_choices[r_type]["choice_1"][1]..", "..prices[1].."$")
	guiSetText(btn_choice_2, menu_choices[r_type]["choice_2"][1]..", "..prices[2].."$)")
	guiSetText(btn_choice_3, menu_choices[r_type]["choice_3"][1]..", "..prices[3].."$)")
	guiSetText(btn_choice_4, menu_choices[r_type]["choice_4"][1]..", "..prices[4].."$)")

	-- Destroy current images if any
	if img1 and isElement(img1) then destroyElement(img1) end
	if img2 and isElement(img2) then destroyElement(img2) end
	if img3 and isElement(img3) then destroyElement(img3) end
	if img4 and isElement(img4) then destroyElement(img4) end

	-- Make new images, (load from files when needed)
	img1 = guiCreateStaticImage(10, 23, 160, 77, menu_choices[r_type]["choice_1"][2], false, win_menu)
	img2 = guiCreateStaticImage(10,140, 160, 77, menu_choices[r_type]["choice_2"][2], false, win_menu)
	img3 = guiCreateStaticImage(170, 23, 160, 77, menu_choices[r_type]["choice_3"][2], false, win_menu)
	img4 = guiCreateStaticImage(170, 140, 160, 77, menu_choices[r_type]["choice_4"][2], false, win_menu)
end

--[[ Open the menu GUI to choose food ]]--
function open_menu(plr, r_type)
	initialize_menu_choices(r_type)
	guiSetVisible(win_menu, true)
	showCursor(true)
end
addEvent("GTWfastfood.gui.show",true)
addEventHandler("GTWfastfood.gui.show", root, open_menu)

--[[ Close the menu ]]--
function close_menu()
	guiSetVisible(win_menu, false)
	showCursor(false)
end
addEvent("GTWfastfood.gui.hide", true)
addEventHandler("GTWfastfood.gui.hide", root, close_menu)

--[[ Handle menu click ]]--
function menu_click()
	-- Make sure that the player can afford his food
	local money = getPlayerMoney(localPlayer)

	-- Shall we close this menu?
   	if source == btn_close then
   		guiSetVisible(win_menu, false)
   		showCursor(false)
		return
	end

	-- Alright, let's continue shopping, can I take your order?
	local ID_choice = 1
   	if source == btn_choice_1 then ID_choice = 1 end
	if source == btn_choice_2 then ID_choice = 2 end
	if source == btn_choice_3 then ID_choice = 3 end
	if source == btn_choice_4 then ID_choice = 4 end

	-- Take care of the order server side
   	if money > prices[ID_choice] and not isTimer(cooldown) then
   		triggerServerEvent("GTWfastfood.buy", localPlayer, prices[ID_choice], health[ID_choice])
   		cooldown = setTimer(function() end, 200, 1)
  	end
end
addEventHandler("onClientGUIClick", btn_close, menu_click)
addEventHandler("onClientGUIClick", btn_choice_1, menu_click)
addEventHandler("onClientGUIClick", btn_choice_2, menu_click)
addEventHandler("onClientGUIClick", btn_choice_3, menu_click)
addEventHandler("onClientGUIClick", btn_choice_4, menu_click)

--[[ Protect fastfood workers from being killed ]]--
function protect_worker(attacker)
	if not getElementData(source, "GTWfastfood.isWorker") then return end
	cancelEvent() -- cancel any damage done to peds
end
addEventHandler("onClientPedWasted", root, protect_worker)
