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

GUIEditor_Window = {}
GUIEditor_Button = {}

x,y = guiGetScreenSize() 
GUIEditor_Window[1] = exports.GTWgui:createWindow((x-320)/2,(y-297)/2, 320, 297, "Well Stacked Pizza Co. Menu", false)
guiSetVisible(GUIEditor_Window[1],false)
GUIEditor_Button[1] = guiCreateButton(210,257,100,36,"Close",false,GUIEditor_Window[1])
GUIEditor_Button[2] = guiCreateButton(10,100,160,36, "Buster("..prices[1].."$)",false,GUIEditor_Window[1])
GUIEditor_Button[3] = guiCreateButton(10,217,160,36, "Double D-Luxe("..prices[2].."$)",false,GUIEditor_Window[1])
GUIEditor_Button[4] = guiCreateButton(170,100,160,36, "Full rack("..prices[3].."$)",false,GUIEditor_Window[1])
GUIEditor_Button[5] = guiCreateButton(170,217,160,36, "Sallad meal("..prices[4].."$)",false,GUIEditor_Window[1])

function showGUI(hitPlayer, type)
	if type == "cluckin_bell" then
		guiSetText(GUIEditor_Window[1], "Cluckin' Bell Menu")
		guiSetText(GUIEditor_Button[2], "Cluckin' Little Meal("..prices[1].."$)")
		guiSetText(GUIEditor_Button[3], "Cluckin' Big Meal("..prices[2].."$)")
		guiSetText(GUIEditor_Button[4], "Cluckin' Huge Meal("..prices[3].."$)")
		guiSetText(GUIEditor_Button[5], "Salad Meal("..prices[4].."$)")
		-- menu images
		if img1 and isElement(img1) then destroyElement(img1) end
		if img2 and isElement(img2) then destroyElement(img2) end
		if img3 and isElement(img3) then destroyElement(img3) end
		if img4 and isElement(img4) then destroyElement(img4) end
		img1 = guiCreateStaticImage(10, 23, 160, 77, "img/CLUHEAL.png", false, GUIEditor_Window[1])
		img2 = guiCreateStaticImage(10,140, 160, 77, "img/CLUHIG.png", false, GUIEditor_Window[1])
		img3 = guiCreateStaticImage(170, 23, 160, 77, "img/CLULOW.png", false, GUIEditor_Window[1])
		img4 = guiCreateStaticImage(170, 140, 160, 77, "img/CLUMED.png", false, GUIEditor_Window[1])
	elseif type == "burger" then
		guiSetText(GUIEditor_Window[1], "Burger Shot Menu")
		guiSetText(GUIEditor_Button[2], "Moo kids Meal("..prices[1].."$)")
		guiSetText(GUIEditor_Button[3], "Beef Tower Meal("..prices[2].."$)")
		guiSetText(GUIEditor_Button[4], "Meat Stack Meal("..prices[3].."$)")
		guiSetText(GUIEditor_Button[5], "Salad Meal("..prices[4].."$)")
		-- menu images
		if img1 and isElement(img1) then destroyElement(img1) end
		if img2 and isElement(img2) then destroyElement(img2) end
		if img3 and isElement(img3) then destroyElement(img3) end
		if img4 and isElement(img4) then destroyElement(img4) end
		img1 = guiCreateStaticImage(10, 23, 160, 77, "img/BURHEAL.png", false, GUIEditor_Window[1])
		img2 = guiCreateStaticImage(10, 140, 160, 77, "img/BURHIG.png", false, GUIEditor_Window[1])
		img3 = guiCreateStaticImage(170, 23, 160, 77, "img/BURLOW.png", false, GUIEditor_Window[1])
		img4 = guiCreateStaticImage(170, 140, 160, 77, "img/BURMED.png", false, GUIEditor_Window[1])
	else
		if img1 and isElement(img1) then destroyElement(img1) end
		if img2 and isElement(img2) then destroyElement(img2) end
		if img3 and isElement(img3) then destroyElement(img3) end
		if img4 and isElement(img4) then destroyElement(img4) end
		img1 = guiCreateStaticImage(10, 23, 160, 77, "img/PIZHEAL.png", false, GUIEditor_Window[1])
		img2 = guiCreateStaticImage(10, 140, 160, 77, "img/PIZHIG.png", false, GUIEditor_Window[1])
		img3 = guiCreateStaticImage(170, 23, 160, 77, "img/PIZLOW.png", false, GUIEditor_Window[1])
		img4 = guiCreateStaticImage(170, 140, 160, 77, "img/PIZMED.png", false, GUIEditor_Window[1])
	end
	guiSetVisible(GUIEditor_Window[1], true)
	showCursor(true)
end
addEvent("GTWfastfood.gui.show",true)
addEventHandler("GTWfastfood.gui.show",getRootElement(),showGUI)

exports.GTWgui:setDefaultFont(GUIEditor_Button[1], 10)
exports.GTWgui:setDefaultFont(GUIEditor_Button[2], 10)
exports.GTWgui:setDefaultFont(GUIEditor_Button[3], 10)
exports.GTWgui:setDefaultFont(GUIEditor_Button[4], 10)
exports.GTWgui:setDefaultFont(GUIEditor_Button[5], 10)

function hideGUI()
	guiSetVisible(GUIEditor_Window[1], false)
	showCursor(false)
end
addEvent("GTWfastfood.gui.hide",true)
addEventHandler("GTWfastfood.gui.hide",getRootElement(),hideGUI)

addEventHandler("onClientGUIClick",getRootElement(),
function(player)
	local player2 = getLocalPlayer()
	local money = getPlayerMoney(player2)
   	if(source == GUIEditor_Button[1]) then
   		guiSetVisible(GUIEditor_Window[1],false)
   		showCursor(false)
   	elseif(source == GUIEditor_Button[2]) then
   		if(money > prices[1]) and not isTimer(cooldown) then
   			triggerServerEvent("GTWfastfood.buy", getLocalPlayer(), prices[1], health[1])
   			cooldown = setTimer(function() end, 500, 1)
  		end
  	elseif(source == GUIEditor_Button[3]) then
   		if(money > prices[2]) and not isTimer(cooldown) then
   			triggerServerEvent("GTWfastfood.buy", getLocalPlayer(), prices[2], health[2])
   			cooldown = setTimer(function() end, 500, 1)
  		end
  	elseif(source == GUIEditor_Button[4]) then
   		if(money > prices[3]) and not isTimer(cooldown) then
   			triggerServerEvent("GTWfastfood.buy", getLocalPlayer(), prices[3], health[3])
   			cooldown = setTimer(function() end, 500, 1)
  		end
  	elseif(source == GUIEditor_Button[5]) then
   		if(money > prices[4]) and not isTimer(cooldown) then
   			triggerServerEvent("GTWfastfood.buy", getLocalPlayer(), prices[4], health[4])
   			cooldown = setTimer(function() end, 500, 1)
  		end
  	end
end)

function cancelPedDamage(attacker)
	cancelEvent() -- cancel any damage done to peds
end
addEventHandler("onClientPedDamage", resourceRoot, cancelPedDamage)