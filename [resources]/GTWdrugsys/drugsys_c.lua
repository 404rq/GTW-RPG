--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Price

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

sec = {{{{{{},{},{},{}}}}}}

local sx, sy = guiGetScreenSize()
guiSetInputMode("no_binds_when_editing")

DrugUseWindow = guiCreateWindow(sx/2-(300/2), sy/2-(310/2), 300, 310, "Drug Panel", false)
guiWindowSetSizable(DrugUseWindow, false)
guiSetAlpha(DrugUseWindow, 0.98)
guiSetVisible(DrugUseWindow, false)

WeedRadioButton = guiCreateRadioButton(17, 27, 205, 21, "Weed (Low gravity)", false, DrugUseWindow)
guiSetProperty(WeedRadioButton, "HoverTextColour", "FFFFFF00")
guiSetProperty(WeedRadioButton, "PushedTextColour", "FFFF9900")
guiSetProperty(WeedRadioButton, "NormalTextColour", "FFFDAD01")
GodRadioButton = guiCreateRadioButton(17, 58, 205, 21, "God (Increased max health)", false, DrugUseWindow)
guiSetProperty(GodRadioButton, "HoverTextColour", "FF66FF66")
guiSetProperty(GodRadioButton, "PushedTextColour", "FF008000")
guiSetProperty(GodRadioButton, "NormalTextColour", "FF00FD06")
SpeedRadioButton = guiCreateRadioButton(17, 89, 205, 21, "Speed (Faster action)", false, DrugUseWindow)
guiSetProperty(SpeedRadioButton, "HoverTextColour", "FF800080")
guiSetProperty(SpeedRadioButton, "PushedTextColour", "FFFF66CC")
guiSetProperty(SpeedRadioButton, "NormalTextColour", "FFF606C6")
LSDRadioButton = guiCreateRadioButton(17, 120, 205, 21, "LSD (Hallucination)", false, DrugUseWindow)
guiSetProperty(LSDRadioButton, "HoverTextColour", "FF000066")
guiSetProperty(LSDRadioButton, "PushedTextColour", "FF00FFFF")
guiSetProperty(LSDRadioButton, "NormalTextColour", "FF00FBCF")
SteroidsRadioButton = guiCreateRadioButton(17, 151, 220, 21, "Steroids (+2 hp every 8seconds)", false, DrugUseWindow)
guiSetProperty(SteroidsRadioButton, "HoverTextColour", "FF336600")
guiSetProperty(SteroidsRadioButton, "PushedTextColour", "FF008000")
guiSetProperty(SteroidsRadioButton, "NormalTextColour", "FF04F643")
HeroinRadioButton = guiCreateRadioButton(17, 182, 205, 21, "Heroin (Semi invincibility)", false, DrugUseWindow)
guiSetProperty(HeroinRadioButton, "HoverTextColour", "FF660066")
guiSetProperty(HeroinRadioButton, "NormalTextColour", "FFD425BE")

WeedLabel = guiCreateLabel(255, 28, 24, 20, "0", false, DrugUseWindow)
GodLabel = guiCreateLabel(255, 59, 24, 20, "0", false, DrugUseWindow)
SpeedLabel = guiCreateLabel(255, 90, 24, 20, "0", false, DrugUseWindow)
LSDLabel = guiCreateLabel(255, 121, 24, 20, "0", false, DrugUseWindow)
SteroidsLabel = guiCreateLabel(255, 152, 24, 20, "0", false, DrugUseWindow)
HeroinLabel = guiCreateLabel(255, 183, 24, 20, "0", false, DrugUseWindow)

UseDrug = guiCreateButton(40, 250, 90, 40, "Use", false, DrugUseWindow)
CloseUseDrugPanel = guiCreateButton(170, 250, 90, 40, "Close", false, DrugUseWindow)

bindKey("F4", "down",
function()
	if getPedOccupiedVehicle(localPlayer) and not guiGetVisible(DrugUseWindow) then
		exports.GTWtopbar:dm("You can not use drugs while in a vehicle!", 255, 0, 0)
		return
	end
	guiSetVisible(DrugUseWindow, not guiGetVisible(DrugUseWindow))
	showCursor(guiGetVisible(DrugUseWindow))
	guiSetText(WeedLabel, getElementData(localPlayer, "Weed") or 0)
	guiSetText(GodLabel, getElementData(localPlayer, "God") or 0)
	guiSetText(SpeedLabel, getElementData(localPlayer, "Speed") or 0)
	guiSetText(LSDLabel, getElementData(localPlayer, "LSD") or 0)
	guiSetText(SteroidsLabel, getElementData(localPlayer, "Steroids") or 0)
	guiSetText(HeroinLabel, getElementData(localPlayer, "Heroin") or 0)
end)

DrugBuyWindow = guiCreateWindow(sx/2-(550/2), sy/2-(310/2), 600, 310, "Drugs by Price for GTW-RPG", false)
guiWindowSetSizable(DrugBuyWindow, false)
guiSetVisible(DrugBuyWindow, false)
guiSetAlpha(DrugBuyWindow, 0.98)

WeedBuyLabel = guiCreateLabel(25, 38, 205, 15, "Weed (Low gravity)", false, DrugBuyWindow)
WeedPriceLabel = guiCreateLabel(67.5, 58, 205, 15, "$900", false, DrugBuyWindow)
WeedBuyEdit = guiCreateEdit(47.5, 88, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(WeedBuyLabel, 251, 213, 3)
guiLabelSetColor(WeedPriceLabel, 0, 255, 0)

GodBuyLabel = guiCreateLabel(235, 38, 205, 15, "God (Increased max health)", false, DrugBuyWindow)
GodPriceLabel = guiCreateLabel(280, 58, 205, 15, "$3000", false, DrugBuyWindow)
GodBuyEdit = guiCreateEdit(260, 88, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(GodBuyLabel, 0, 253, 5)
guiLabelSetColor(GodPriceLabel, 0, 255, 0)

--

SpeedBuyLabel = guiCreateLabel(25, 125, 205, 15, "Speed (Faster action)", false, DrugBuyWindow)
SpeedPriceLabel = guiCreateLabel(67.5, 145, 205, 15, "$1100", false, DrugBuyWindow)
SpeedBuyEdit = guiCreateEdit(47.5, 175, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(SpeedBuyLabel, 250, 2, 194)
guiLabelSetColor(SpeedPriceLabel, 0, 255, 0)

LSDBuyLabel = guiCreateLabel(235, 125, 205, 15, "LSD (Hallucination)", false, DrugBuyWindow)
LSDPriceLabel = guiCreateLabel(280, 145, 205, 15, "$2000", false, DrugBuyWindow)
LSDBuyEdit = guiCreateEdit(260, 175, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(LSDBuyLabel, 0, 248, 251)
guiLabelSetColor(LSDPriceLabel, 0, 255, 0)

--

SteroidsBuyLabel = guiCreateLabel(25, 212, 205, 15, "Steroids (+2 hp every 8seconds)", false, DrugBuyWindow)
SteroidsPriceLabel = guiCreateLabel(67.5, 232, 205, 15, "$800", false, DrugBuyWindow)
SteroidsBuyEdit = guiCreateEdit(47.5, 262, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(SteroidsBuyLabel, 2, 248, 60)
guiLabelSetColor(SteroidsPriceLabel, 0, 255, 0)

HeroinBuyLabel = guiCreateLabel(235, 212, 205, 15, "Heroin (Semi invincibility)", false, DrugBuyWindow)
HeroinPriceLabel = guiCreateLabel(280, 232, 205, 15, "$4000", false, DrugBuyWindow)
HeroinBuyEdit = guiCreateEdit(260, 262, 75, 18, "0", false, DrugBuyWindow)
guiLabelSetColor(HeroinBuyLabel, 201, 48, 196)
guiLabelSetColor(HeroinPriceLabel, 0, 255, 0)

guiCreateStaticImage(450, 50, 125, 125, "drug.png", false, DrugBuyWindow)

Total = guiCreateLabel(410, 200, 35, 16, "Total:", false, DrugBuyWindow)
guiSetFont(Total, "default-bold-small")
TotalLabel = guiCreateLabel(450, 200, 94, 16, "$0", false, DrugBuyWindow)
guiSetFont(TotalLabel, "default-bold-small")
guiLabelSetColor(TotalLabel, 0, 255, 0)

BuyDrug = guiCreateButton(400, 250, 90, 35, "Buy", false, DrugBuyWindow)
CloseBuyDrugPanel = guiCreateButton(500, 250, 90, 35, "Close", false, DrugBuyWindow)

function showBuyDrug()
	guiSetText(TotalLabel, "$0")
	guiSetText(WeedBuyEdit, "0")
	guiSetText(GodBuyEdit, "0")
	guiSetText(SpeedBuyEdit, "0")
	guiSetText(LSDBuyEdit, "0")
	guiSetText(SteroidsBuyEdit, "0")
	guiSetText(HeroinBuyEdit, "0")
	guiSetVisible(DrugBuyWindow, true)
	showCursor(true)
	if drugDealer then
		guiSetText(DrugBuyWindow, "Buying drugs from "..getPlayerName(drugDealer))
	else
		guiSetText(DrugBuyWindow, "Buying drugs from drug Dealer Ped")
	end
end

addEventHandler("onClientGUIChanged", guiRoot,
function()
	if drugDealer then
		if getElementData(drugDealer, "DurgsDealer") then
			MaxWeed = (getElementData(drugDealer, "Weed") or 0) + (getElementData(localPlayer, "Weed") or 0)
			MaxGod = (getElementData(drugDealer, "God") or 0) + (getElementData(localPlayer, "God") or 0)
			MaxSpeed = (getElementData(drugDealer, "Speed") or 0) + (getElementData(localPlayer, "Speed") or 0)
			MaxLSD = (getElementData(drugDealer, "LSD") or 0) + (getElementData(localPlayer, "LSD") or 0)
			MaxSteroids = (getElementData(drugDealer, "Steroids") or 0) + (getElementData(localPlayer, "Steroids") or 0)
			MaxHeroin = (getElementData(drugDealer, "Heroin") or 0) + (getElementData(localPlayer, "Heroin") or 0)
		else
			exports.GTWtopbar:dm("This player does not sell drugs anymore!", 255, 0, 0)
			drugDealer = nil
			guiSetVisible(DrugBuyWindow, false)
			showCursor(false)
		end
	else
		MaxWeed = 10000
		MaxGod = 10000
		MaxSpeed = 10000
		MaxLSD = 10000
		MaxSteroids = 10000
		MaxHeroin = 10000
	end
	local Text = guiGetText(source)
	local Text = tonumber(Text)
	if source == WeedBuyEdit then
		local Amount = getElementData(localPlayer, "Weed") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxWeed then
			guiSetText(source, MaxWeed-Amount >= 0 and MaxWeed-Amount or "0")
		end
		WeedCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(WeedPriceLabel), 2))
	elseif source == GodBuyEdit then
		local Amount = getElementData(localPlayer, "God") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxGod then
			guiSetText(source, MaxGod-Amount >= 0 and MaxGod-Amount or "0")
		end
		GodCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(GodPriceLabel), 2))
	elseif source == SpeedBuyEdit then
		local Amount = getElementData(localPlayer, "Speed") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxSpeed then
			guiSetText(source, MaxSpeed-Amount >= 0 and MaxSpeed-Amount or "0")
		end
		SpeedCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(SpeedPriceLabel), 2))
	elseif source == LSDBuyEdit then
		local Amount = getElementData(localPlayer, "LSD") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxLSD then
			guiSetText(source, MaxLSD-Amount >= 0 and MaxLSD-Amount or "0")
		end
		LSDCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(LSDPriceLabel), 2))
	elseif source == SteroidsBuyEdit then
		local Amount = getElementData(localPlayer, "Steroids") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxSteroids then
			guiSetText(source, MaxSteroids-Amount >= 0 and MaxSteroids-Amount or "0")
		end
		SteroidsCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(SteroidsPriceLabel), 2))
	elseif source == HeroinBuyEdit then
		local Amount = getElementData(localPlayer, "Heroin") or 0
		if not Text then
			guiSetText(source, "0")
		elseif Text+Amount > MaxHeroin then
			guiSetText(source, MaxHeroin-Amount >= 0 and MaxHeroin-Amount or "0")
		end
		HeroinCost = tonumber(guiGetText(source)) * tonumber(string.sub(guiGetText(HeroinPriceLabel), 2))
	end
	local TotalCost = (WeedCost or 0) + (GodCost or 0) + (SpeedCost or 0) + (LSDCost or 0) + (SteroidsCost or 0) + (HeroinCost or 0)
	guiSetText(TotalLabel, "$"..TotalCost)
end)

addEventHandler("onClientGUIClick", guiRoot,
function()
	if source == BuyDrug then
		local WeedAmount = tonumber(guiGetText(WeedBuyEdit))
		local GodAmount = tonumber(guiGetText(GodBuyEdit))
		local SpeedAmount = tonumber(guiGetText(SpeedBuyEdit))
		local LSDAmount = tonumber(guiGetText(LSDBuyEdit))
		local SteroidsAmount = tonumber(guiGetText(SteroidsBuyEdit))
		local HeroinAmount = tonumber(guiGetText(HeroinBuyEdit))
		local Cost = tonumber(string.sub(guiGetText(TotalLabel), 2))
		if Cost > 0 then
			if drugDealer then
				if getElementData(drugDealer, "DurgsDealer") then
					MaxWeed = getElementData(drugDealer, "Weed") or 0
					MaxGod = getElementData(drugDealer, "God") or 0
					MaxSpeed = getElementData(drugDealer, "Speed") or 0
					MaxLSD = getElementData(drugDealer, "LSD") or 0
					MaxSteroids = getElementData(drugDealer, "Steroids") or 0
					MaxHeroin = getElementData(drugDealer, "Heroin") or 0
					if MaxWeed >= WeedAmount and MaxGod >= GodAmount and MaxSpeed >= SpeedAmount and MaxLSD >= LSDAmount and MaxSteroids >= SteroidsAmount and MaxHeroin >= HeroinAmount then
						triggerServerEvent("BuyDrugs", localPlayer, Cost, WeedAmount, GodAmount, SpeedAmount, LSDAmount, SteroidsAmount, HeroinAmount, drugDealer)
					else
						exports.GTWtopbar:dm("This dealer doesn't have enough drugs!", 255, 0, 0)
					end
				else
					exports.GTWtopbar:dm("This player does not sell drugs anymore!", 255, 0, 0)
					drugDealer = nil
					guiSetVisible(DrugBuyWindow, false)
					showCursor(false)
				end
			else
				if MaxWeed >= WeedAmount and MaxGod >= GodAmount and MaxSpeed >= SpeedAmount and MaxLSD >= LSDAmount and MaxSteroids >= SteroidsAmount and MaxHeroin >= HeroinAmount then
					triggerServerEvent("BuyDrugs", localPlayer, Cost, WeedAmount, GodAmount, SpeedAmount, LSDAmount, SteroidsAmount, HeroinAmount, false)
				end
			end
			guiSetText(TotalLabel, "0")
			guiSetText(WeedBuyEdit, "0")
			guiSetText(GodBuyEdit, "0")
			guiSetText(SpeedBuyEdit, "0")
			guiSetText(LSDBuyEdit, "0")
			guiSetText(SteroidsBuyEdit, "0")
			guiSetText(HeroinBuyEdit, "0")
		end
		exports.GTWwanted:setWl(0.25, 0, "You committed the crime of buying drugs", true, false)
	elseif source == CloseBuyDrugPanel then
		guiSetVisible(DrugBuyWindow, false)
		showCursor(false)
		drugDealer = nil
	elseif source == UseDrug then
		if guiRadioButtonGetSelected(WeedRadioButton) then
			if (getElementData(localPlayer, "Weed") or 0) > 0 then
				setElementData(localPlayer, "Weed", (getElementData(localPlayer, "Weed") or 0) - 1)
				exports.GTWtopbar:dm("You have injected the Weed drug!", 255, 0, 255)
				setGravity(0.005)
				if not isTimer(WeedTimer) then
					WeedTimer = setTimer(function() setGravity(0.008) exports.GTWtopbar:dm("Weed: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(WeedTimer)
					killTimer(WeedTimer)
					WeedTimer = setTimer(function() setGravity(0.008) exports.GTWtopbar:dm("Weed: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
			else
				exports.GTWtopbar:dm("You don't have any Weed drug!", 255, 0, 0)
			end
		elseif guiRadioButtonGetSelected(GodRadioButton) then
			if (getElementData(localPlayer, "God") or 0) > 0 then
				setElementData(localPlayer, "God", (getElementData(localPlayer, "God") or 0) - 1)
				exports.GTWtopbar:dm("You have injected the God drug!", 255, 0, 255)
				triggerServerEvent("takeDrug", localPlayer, "God", 1000)
				if not isTimer(GodTimer) then
					GodTimer = setTimer(function() triggerServerEvent("takeDrug", localPlayer, "God", 569) exports.GTWtopbar:dm("God: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(GodTimer)
					killTimer(GodTimer)
					GodTimer = setTimer(function() triggerServerEvent("takeDrug", localPlayer, "God", 569) exports.GTWtopbar:dm("God: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
			else
				exports.GTWtopbar:dm("You don't have any God drug!", 255, 0, 0)
			end
		elseif guiRadioButtonGetSelected(SpeedRadioButton) then
			if (getElementData(localPlayer, "Speed") or 0) > 0 then
				setElementData(localPlayer, "Speed", (getElementData(localPlayer, "Speed") or 0) - 1)
				exports.GTWtopbar:dm("You have injected the Speed drug!", 255, 0, 255)
				setGameSpeed(1.4)
				if not isTimer(SpeedTimer) then
					SpeedTimer = setTimer(function() setGameSpeed(1) exports.GTWtopbar:dm("Speed: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(SpeedTimer)
					killTimer(SpeedTimer)
					SpeedTimer = setTimer(function() setGameSpeed(1) exports.GTWtopbar:dm("Speed: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
			else
				exports.GTWtopbar:dm("You don't have any Speed drug!", 255, 0, 0)
			end
		elseif guiRadioButtonGetSelected(LSDRadioButton) then
			if (getElementData(localPlayer, "LSD") or 0) > 0 then
				setElementData(localPlayer, "LSD", (getElementData(localPlayer, "LSD") or 0) - 1)
				exports.GTWtopbar:dm("You have injected the LSD drug!", 255, 0, 255)
				setHeatHaze(65, 50, 80, 80, 20, 80, 20, 1500, true)
				setSkyGradient(255, 255, 255, 0,  200, 0)
				if not isTimer(LSDTimer) then
					LSDTimer = setTimer(function() resetSkyGradient() resetHeatHaze() exports.GTWtopbar:dm("LSD: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(LSDTimer)
					killTimer(LSDTimer)
					LSDTimer = setTimer(function() resetSkyGradient() resetHeatHaze() exports.GTWtopbar:dm("LSD: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
			else
				exports.GTWtopbar:dm("You don't have any LSD drug!", 255, 0, 0)
			end
		elseif guiRadioButtonGetSelected(SteroidsRadioButton) then
			if (getElementData(localPlayer, "Steroids") or 0) > 0 then
				setElementData(localPlayer, "Steroids", (getElementData(localPlayer, "Steroids") or 0) - 1)
				exports.GTWtopbar:dm("You have injected the Steroids drug!", 255, 0, 255)
				if not isTimer(SteroidsHealthTimer) then
					SteroidsHealthTimer = setTimer(function() setElementHealth(localPlayer, getElementHealth(localPlayer) + 2) end, 8000, 0)
				end
				if not isTimer(SteroidsTimer) then
					SteroidsTimer = setTimer(function() killTimer(SteroidsHealthTimer) exports.GTWtopbar:dm("Steroids: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(SteroidsTimer)
					killTimer(SteroidsTimer)
					SteroidsTimer = setTimer(function() killTimer(SteroidsHealthTimer) exports.GTWtopbar:dm("Steroids: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
			else
				exports.GTWtopbar:dm("You don't have any Steroids drug!", 255, 0, 0)
			end
		elseif guiRadioButtonGetSelected(HeroinRadioButton) then
			if (getElementData(localPlayer, "Heroin") or 0) > 0 then
				setElementData(localPlayer, "Heroin", (getElementData(localPlayer, "Heroin") or 0) - 1)
				if not isTimer(HeroinTimer) then
					addEventHandler("onClientPlayerDamage", localPlayer, hardToDie)
					HeroinTimer = setTimer(function() removeEventHandler("onClientPlayerDamage", localPlayer, hardToDie) exports.GTWtopbar:dm("Heroin: This drug does not have any effect anymore.", 255, 255, 0) end, 60000, 1)
				else
					local remaining = getTimerDetails(HeroinTimer)
					killTimer(HeroinTimer)
					HeroinTimer = setTimer(function() removeEventHandler("onClientPlayerDamage", localPlayer, hardToDie) exports.GTWtopbar:dm("Heroin: This drug does not have any effect anymore.", 255, 255, 0) end, 60000+remaining, 1)
				end
				exports.GTWtopbar:dm("You have injected the Heroin drug!", 255, 0, 255)
			else
				exports.GTWtopbar:dm("You don't have any Heroin drug!", 255, 0, 0)
			end
		end

		-- Become wanted
		exports.GTWwanted:setWl(0.8, 30, "You committed the crime of using drugs in public", true, false)
	elseif source == CloseUseDrugPanel then
		guiSetVisible(DrugUseWindow, false)
		showCursor(false)
	end
end)

function hardToDie()
	local rnd = math.random(1, 5)
	if rnd == 5 then
		cancelEvent()
	end
end

local OpenDrugShopMarker = createMarker( 2776.7998046875, -2403.021484375, 12.632472991943, "cylinder", 2, 200, 0, 0, 50)
createBlipAttachedTo(OpenDrugShopMarker, 24)

addEventHandler("onClientMarkerHit", root,
function(player)
	if player == localPlayer and not isPedInVehicle(player) then
		if source == OpenDrugShopMarker then
			showBuyDrug()
		else
			local seller = getElementData(source, "sellDrugMarker")
			if seller and isElement(seller) and getElementType(seller) == "player" and seller ~= localPlayer then
				local mInt = getElementInterior(seller)
				local mDim = getElementDimension(seller)
				if mInt == getElementInterior(player) and mDim == getElementDimension(player) and not drugDealer then
					drugDealer = seller
					showBuyDrug()
				end
			end
		end
	end
end)

addEventHandler("onClientMarkerLeave", root,
function(player)
	if player == localPlayer then
		if source == OpenDrugShopMarker or getElementData(source, "sellDrugMarker") then
			guiSetVisible(DrugBuyWindow, false)
			showCursor(false)
			drugDealer = nil
		end
	end
end)

function drawCircle(x, y, z, radius, color)
    local numPoints = math.floor(math.pow(radius, 4) * 50)
    local step = math.pi*2/numPoints
    local sx, sy
	local z = getGroundPosition(x, y, z) + 0.03
    for p=0, numPoints do
        local ex = math.cos(p*step) * radius
        local ey = math.sin(p*step) * radius
        if sx then
            dxDrawLine3D(x+sx, y+sy, z, x+ex, y+ey, z, color, 4)
        end
        sx, sy, sz = ex, ey
    end
end

--[[ Disable unfair drugs when entering a vehicle ]]--
addEventHandler("onClientVehicleEnter", getRootElement(),
function(thePlayer, seat)
	if thePlayer == localPlayer then
            	if isTimer(WeedTimer) then
			killTimer(WeedTimer)
			setGravity(0.008)
		end
		if isTimer(GodTimer) then
			killTimer(GodTimer)
			triggerServerEvent("takeDrug", localPlayer, "God", 0)
		end
		if isTimer(SpeedTimer) then
			killTimer(SpeedTimer)
			setGameSpeed(1)
		end
		if isTimer(SteroidsHealthTimer) then
			killTimer(SteroidsHealthTimer)
		end
		if isTimer(HeroinTimer) then
			killTimer(HeroinTimer)
		end
        end
end)

addEventHandler("onClientRender", root,
function()
	local drugTimeTable = {}
	if isTimer(WeedTimer) then table.insert(drugTimeTable, {"Weed: ", (math.floor(getTimerDetails(WeedTimer)/1000))}) end
	if isTimer(GodTimer) then table.insert(drugTimeTable, {#drugTimeTable >= 1 and " | God: " or "God: ", (math.floor(getTimerDetails(GodTimer)/1000))}) end
	if isTimer(SpeedTimer) then table.insert(drugTimeTable, {#drugTimeTable >= 1 and " | Speed: " or "Speed: ", (math.floor(getTimerDetails(SpeedTimer)/1000))}) end
	if isTimer(LSDTimer) then table.insert(drugTimeTable, {#drugTimeTable >= 1 and " | LSD: " or "LSD: ", (math.floor(getTimerDetails(LSDTimer)/1000))}) end
	if isTimer(SteroidsTimer) then table.insert(drugTimeTable, {#drugTimeTable >= 1 and " | Steroids: " or "Steroids: ", (math.floor(getTimerDetails(SteroidsTimer)/1000))}) end
	if isTimer(HeroinTimer) then table.insert(drugTimeTable, {#drugTimeTable >= 1 and " | Heroin: " or "Heroin: ", (math.floor(getTimerDetails(HeroinTimer)/1000))}) end
	local TimeDrawText = ""
	for i, value in ipairs(drugTimeTable) do
		TimeDrawText = TimeDrawText..value[1]..value[2]
	end
	dxDrawText(TimeDrawText, sx*0.5, sy*0.05, sx*0.5, sy*0.5, tocolor(200, 0, 200, 255), 0.9, "bankgothic", "center", "top")
	--[[for i, marker in ipairs(getElementsByType("marker")) do
		if getElementData(marker, "sellDrugMarker") then
			local x, y, z = getElementPosition(marker)
			drawCircle(x, y, z, 0.75, tocolor(200, 0, 0, 70))
		end
	end]]--
end)
