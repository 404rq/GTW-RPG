------------------------------------------------------------------------------------
--	PROJECT:			Business System v1.2
--	RIGHTS:				All rights reserved by developers
-- FILE:						business/client/main.lua
--	PURPOSE:			Main clientside script
--	DEVELOPERS:	JR10
------------------------------------------------------------------------------------

local messages = {}
local sX, sY = guiGetScreenSize()
local cursorOverGUI = false
local action
local settings = {}

function build_cbGUI()
	
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 511, 461
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Create Business", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetVisible(gui["_root"], false)
	guiSetAlpha(gui["_root"], 1)
	
	gui["cbPoszL"] = guiCreateLabel(270, 75, 101, 20, "Position Z", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbPoszL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbPoszL"], "center")
	guiLabelSetColor(gui["cbPoszL"], 0, 100, 255)
	
	gui["cbPosxL"] = guiCreateLabel(10, 75, 101, 20, "Position X", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbPosxL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbPosxL"], "center")
	guiLabelSetColor(gui["cbPosxL"], 0, 100, 255)
	
	gui["cbPosyL"] = guiCreateLabel(140, 75, 101, 20, "Position Y", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbPosyL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbPosyL"], "center")
	guiLabelSetColor(gui["cbPosyL"], 0, 100, 255)
	
	gui["cbIntdimL"] = guiCreateLabel(400, 75, 101, 20, "Interior, Dim", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbIntdimL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbIntdimL"], "center")
	guiLabelSetColor(gui["cbIntdimL"], 0, 100, 255)
	
	gui["cbIntdimE"] = guiCreateEdit(400, 105, 101, 21, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbIntdimE"], 32767)
	guiEditSetReadOnly(gui["cbIntdimE"], true)
	
	gui["cbInfoL"] = guiCreateLabel(0, 25, 511, 51, "Pickup The Coordinates And Enter The Data To Create The Business.", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbInfoL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbInfoL"], "center")
	guiLabelSetColor(gui["cbInfoL"], 0, 173, 0)
	
	gui["cbPosxE"] = guiCreateEdit(10, 105, 101, 21, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbPosxE"], 32767)
	guiEditSetReadOnly(gui["cbPosxE"], true)
	
	gui["cbPosyE"] = guiCreateEdit(140, 105, 101, 21, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbPosyE"], 32767)
	guiEditSetReadOnly(gui["cbPosyE"], true)
	
	gui["cbPoszE"] = guiCreateEdit(270, 105, 101, 21, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbPoszE"], 32767)
	guiEditSetReadOnly(gui["cbPoszE"], true)
	
	gui["cbPickcB"] = guiCreateButton(60, 145, 391, 41, "Pickup Coordinates", false, gui["_root"])
	if on_cbPickcB_clicked then
		addEventHandler("onClientGUIClick", gui["cbPickcB"], on_cbPickcB_clicked, false)
	end
	
	gui["cbNameL"] = guiCreateLabel(0, 225, 141, 31, "Business Name:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbNameL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbNameL"], "center")
	guiLabelSetColor(gui["cbNameL"], 255, 0, 0)
	
	gui["cbCostL"] = guiCreateLabel(0, 265, 141, 31, "Business Cost:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbCostL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbCostL"], "center")
	guiLabelSetColor(gui["cbCostL"], 255, 0, 0)
	
	gui["cbPayoutL"] = guiCreateLabel(0, 305, 141, 31, "Business Payout:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbPayoutL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbPayoutL"], "center")
	guiLabelSetColor(gui["cbPayoutL"], 255, 0, 0)
	
	gui["cbPayouttL"] = guiCreateLabel(0, 345, 141, 31, "Business Payout Time:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbPayouttL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbPayouttL"], "center")
	guiLabelSetColor(gui["cbPayouttL"], 255, 0, 0)
	
	gui["cbNameE"] = guiCreateEdit(160, 225, 281, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbNameE"], 32767)
	
	gui["cbCostE"] = guiCreateEdit(160, 265, 281, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbCostE"], 32767)
	
	gui["cbPayoutE"] = guiCreateEdit(160, 305, 281, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbPayoutE"], 32767)
	
	gui["cbPayouttE"] = guiCreateEdit(160, 345, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbPayouttE"], 32767)
	
	gui["cbPayoutuCB"] = guiCreateComboBox(360, 345, 141, 96,"Unit", false, gui["_root"])
	
	guiComboBoxAddItem(gui["cbPayoutuCB"], "Seconds")
	guiComboBoxAddItem(gui["cbPayoutuCB"], "Minutes")
	guiComboBoxAddItem(gui["cbPayoutuCB"], "Hours")
	guiComboBoxAddItem(gui["cbPayoutuCB"], "Days")
	
	guiComboBoxSetSelected(gui["cbPayoutuCB"], 1)
	
	gui["cbClearB"] = guiCreateButton(0, 415, 121, 31, "Clear", false, gui["_root"])
	if on_cbClearB_clicked then
		addEventHandler("onClientGUIClick", gui["cbClearB"], on_cbClearB_clicked, false)
	end
	
	gui["cbCancelB"] = guiCreateButton(390, 415, 121, 31, "Cancel", false, gui["_root"])
	if on_cbCancelB_clicked then
		addEventHandler("onClientGUIClick", gui["cbCancelB"], on_cbCancelB_clicked, false)
	end
	
	gui["cbCreateB"] = guiCreateButton(145, 415, 231, 31, "Create Business", false, gui["_root"])
	if on_cbCreateB_clicked then
		addEventHandler("onClientGUIClick", gui["cbCreateB"], on_cbCreateB_clicked, false)
	end
	
	return gui, windowWidth, windowHeight
end

function on_cbPickcB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	local posX, posY, posZ = getElementPosition(localPlayer)
	local int = getElementInterior(localPlayer)
	local dim = getElementDimension(localPlayer)
	guiSetText(cbGUI["cbPosxE"], posX)
	guiSetText(cbGUI["cbPosyE"], posY)
	guiSetText(cbGUI["cbPoszE"], posZ)
	guiSetText(cbGUI["cbIntdimE"], int..", "..dim)
end

function on_cbClearB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(cbGUI["cbPosxE"], "")
	guiSetText(cbGUI["cbPosyE"], "")
	guiSetText(cbGUI["cbPoszE"], "")
	guiSetText(cbGUI["cbIntdimE"], "")
	guiSetText(cbGUI["cbNameE"], "")
	guiSetText(cbGUI["cbCostE"], "")
	guiSetText(cbGUI["cbPayoutE"], "")
	guiSetText(cbGUI["cbPayouttE"], "")
	guiComboBoxSetSelected(cbGUI["cbPayoutuCB"], 1)
end

function on_cbCancelB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetVisible(cbGUI["_root"], false)
	showCursor(false)
	guiSetInputMode("allow_binds")
end

function on_cbCreateB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	local posX, posY, posZ, intDim = guiGetText(cbGUI["cbPosxE"]), guiGetText(cbGUI["cbPosyE"]), guiGetText(cbGUI["cbPoszE"]), guiGetText(cbGUI["cbIntdimE"])
	local name = guiGetText(cbGUI["cbNameE"])
	local cost = guiGetText(cbGUI["cbCostE"])
	local payout = guiGetText(cbGUI["cbPayoutE"])
	local payoutTime = guiGetText(cbGUI["cbPayouttE"])
	local payoutUnit = guiComboBoxGetItemText(cbGUI["cbPayoutuCB"], guiComboBoxGetSelected(cbGUI["cbPayoutuCB"]))
	if posX ~= "" and name ~= "" and cost ~= ""  and tonumber(cost) ~= nil and payout ~= "" and tonumber(payout) ~= nil and payoutTime ~= "" and tonumber(payoutTime) ~= nil and tonumber(payoutTime) > 0 and tonumber(cost) > 0 and tonumber(payout) > 0 then
		if #name > 30 then return outputMessage("BUSINESS: Business Name Must Be Lower Than 31 Character", 255, 0, 0) end
		local zone = getZoneName(tonumber(posX), tonumber(posY), tonumber(posZ), false)
		local zonec = getZoneName(tonumber(posX), tonumber(posY), tonumber(posZ), true)
		if zone == "Unknown" then
			guiSetText(cbcGUI["cbcLocE"], "In The Middle Of No Where")
		else
			guiSetText(cbcGUI["cbcLocE"], zone.."("..zonec..")")
		end
		guiSetText(cbcGUI["cbcNameE"], name)
		intDim = intDim : gsub(" ", "")
		local interior = tonumber(gettok(intDim, 1, ","))
		local dimension = tonumber(gettok(intDim, 2, ","))
		guiSetText(cbcGUI["cbcPosE"], posX..","..posY..","..posZ..","..interior..","..dimension)
		guiSetText(cbcGUI["cbcCostE"], tostring(tonumber(cost)))
		guiSetText(cbcGUI["cbcPayoutE"], tostring(tonumber(payout)))
		guiSetText(cbcGUI["cbcPayouttE"], tostring(tonumber(payoutTime)).." "..payoutUnit)
		guiSetVisible(cbcGUI["_root"], true)
	else
		outputMessage("BUSINESS: The data isn't correct, please correct it.", 255, 0, 0)
	end
end

addEvent("client:showCreateBusinessGUI", true)
addEventHandler("client:showCreateBusinessGUI", root,
	function()
		guiSetVisible(cbGUI["_root"], true)
		showCursor(true)
		guiSetInputMode("no_binds_when_editing")
	end
)

_showCursor = showCursor
function showCursor(bool)
	if bool then
		_showCursor(true)
	else
		_showCursor(false)
		setTimer(
			function()
				for index, window in ipairs(getElementsByType("gui-window", resourceRoot)) do
					if guiGetVisible(window) then
						_showCursor(true)
					end
				end
			end
		, 300, 1)
	end
end

function outputMessage(message, r, g, b)
	exports.GTWtopbar:dm(message, r, g, b)
end

function build_cbcGUI()
	
	local gui = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 369, 378
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Create Business Check", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetVisible(gui["_root"], false)
	guiSetProperty(gui["_root"], "AlwaysOnTop", "true")
	guiSetAlpha(gui["_root"], 1)
	
	gui["cbcInfoL"] = guiCreateLabel(0, 15, 371, 41, "Are you sure you want to create the business with these data?", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcInfoL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcInfoL"], "center")
	guiLabelSetColor(gui["cbcInfoL"], 0, 173, 0)
	
	gui["cbcNameL"] = guiCreateLabel(10, 65, 100, 30, "Business Name:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcNameL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcNameL"], "center")
	guiLabelSetColor(gui["cbcNameL"], 255, 0, 0)
	
	gui["cbcPosL"] = guiCreateLabel(10, 105, 100, 30, "Business Position:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcPosL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcPosL"], "center")
	guiLabelSetColor(gui["cbcPosL"], 255, 0, 0)
	
	gui["cbcLocL"] = guiCreateLabel(10, 145, 100, 30, "Business Location:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcLocL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcLocL"], "center")
	guiLabelSetColor(gui["cbcLocL"], 255, 0, 0)
	
	gui["cbcCostL"] = guiCreateLabel(10, 185, 100, 30, "Business Cost:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcCostL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcCostL"], "center")
	guiLabelSetColor(gui["cbcCostL"], 255, 0, 0)
	
	gui["cbcPayoutL"] = guiCreateLabel(10, 225, 100, 31, "Business Payout:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcPayoutL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcPayoutL"], "center")
	guiLabelSetColor(gui["cbcPayoutL"], 255, 0, 0)
	
	gui["cbcPayouttL"] = guiCreateLabel(0, 265, 140, 30, "Business Payout Time:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["cbcPayouttL"], "center", false)
	guiLabelSetVerticalAlign(gui["cbcPayouttL"], "center")
	guiLabelSetColor(gui["cbcPayouttL"], 255, 0, 0)
	
	gui["cbcNameE"] = guiCreateEdit(150, 65, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcNameE"], 32767)
	guiEditSetReadOnly(gui["cbcNameE"], true)
	
	gui["cbcPosE"] = guiCreateEdit(150, 105, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcPosE"], 32767)
	guiEditSetReadOnly(gui["cbcPosE"], true)
	
	gui["cbcLocE"] = guiCreateEdit(150, 145, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcLocE"], 32767)
	guiEditSetReadOnly(gui["cbcLocE"], true)
	
	gui["cbcCostE"] = guiCreateEdit(150, 185, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcCostE"], 32767)
	guiEditSetReadOnly(gui["cbcCostE"], true)
	
	gui["cbcPayoutE"] = guiCreateEdit(150, 225, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcPayoutE"], 32767)
	guiEditSetReadOnly(gui["cbcPayoutE"], true)
	
	gui["cbcPayouttE"] = guiCreateEdit(150, 265, 191, 31, "", false, gui["_root"])
	guiEditSetMaxLength(gui["cbcPayouttE"], 32767)
	guiEditSetReadOnly(gui["cbcPayouttE"], true)
	
	gui["cbcAcceptI"] = guiCreateStaticImage(60, 315, 81, 51, "files/images/tick.png", false, gui["_root"])
	gui["cbcCancelI"] = guiCreateStaticImage(220, 315, 81, 51, "files/images/wrong.png", false, gui["_root"])
	addEventHandler("onClientMouseEnter", gui["cbcAcceptI"], on_cbcAcceptI_entered, false)
	addEventHandler("onClientMouseEnter", gui["cbcCancelI"], on_cbcCancelI_entered, false)
	addEventHandler("onClientMouseLeave", gui["cbcAcceptI"], on_cbcAcceptI_left, false)
	addEventHandler("onClientMouseLeave", gui["cbcCancelI"], on_cbcCancelI_left, false)
	addEventHandler("onClientGUIClick", gui["cbcAcceptI"], on_cbcAcceptI_clicked, false)
	addEventHandler("onClientGUIClick", gui["cbcCancelI"], on_cbcCancelI_clicked, false)
	
	return gui, windowWidth, windowHeight
end

function on_cbcAcceptI_entered()
	guiSetAlpha(source, 0.5)
end

function on_cbcCancelI_entered()
	guiSetAlpha(source, 0.5)
end

function on_cbcAcceptI_left()
	guiSetAlpha(source, 1)
end

function on_cbcCancelI_left()
	guiSetAlpha(source, 1)
end

function on_cbcAcceptI_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	
	guiSetVisible(cbcGUI["_root"], false)
	local left, top = sX / 2 - 500 / 2, sY / 2 - 50 / 2
	local cbProgressP = guiCreateProgressBar(left, top, 500, 50, false)
	local cbProgressL = guiCreateLabel(left, top, 500, 50, "Creating Business 0%", false)
	guiLabelSetHorizontalAlign(cbProgressL, "center")
	guiLabelSetVerticalAlign(cbProgressL, "center")
	local function fillP()
		local progress = tonumber(("%.f") : format(tostring(guiProgressBarGetProgress(cbProgressP) + 4)))
		guiProgressBarSetProgress(cbProgressP, progress)
		guiSetText(cbProgressL, "Creating Business "..tostring(progress).."%")
		
		if progress < 30 then
			guiLabelSetColor(cbProgressL, 170, 0, 0)
		elseif progress < 70 and progress > 30 then
			guiLabelSetColor(cbProgressL, 180, 100, 0)
		elseif progress < 99 and progress > 70 then
			guiLabelSetColor(cbProgressL, 0, 130, 0)
		elseif progress >= 100 then
			guiSetText(cbProgressL, "Created Business Successfully...Proceeding")
			playSound("files/sounds/cash.mp3", false)
			destroyElement(cbProgressP)
			destroyElement(cbProgressL)
			guiSetVisible(cbGUI["_root"], false)
			guiSetInputMode("allow_binds")
			showCursor(false)
			on_cbClearB_clicked("left", "up")
			local posX, posY, posZ, interior, dimension = gettok(guiGetText(cbcGUI["cbcPosE"]), 1, ","), gettok(guiGetText(cbcGUI["cbcPosE"]), 2, ","), gettok(guiGetText(cbcGUI["cbcPosE"]), 3, ","), gettok(guiGetText(cbcGUI["cbcPosE"]), 4, ","), gettok(guiGetText(cbcGUI["cbcPosE"]), 5, ",")
			local name = guiGetText(cbcGUI["cbcNameE"])
			local cost = guiGetText(cbcGUI["cbcCostE"])
			local payout = guiGetText(cbcGUI["cbcPayoutE"])
			local payoutTime, payoutUnit = gettok(guiGetText(cbcGUI["cbcPayouttE"]), 1, " "), gettok(guiGetText(cbcGUI["cbcPayouttE"]), 2, " ")
			triggerServerEvent("server:createBusiness", localPlayer, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
			removeEventHandler("onClientRender", root, fillP)
		end
	end
	addEventHandler("onClientRender", root, fillP)
end

function on_cbcCancelI_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetVisible(cbcGUI["_root"], false)
end

addEventHandler("onClientMouseEnter", root, function() cursorOverGUI = true end)
addEventHandler('onClientMouseLeave', root, function() cursorOverGUI = false end)
 
addEventHandler("onClientRender", root,
	function()
		if not isCursorShowing() then return end
		if cursorOverGUI then return end
		if not guiGetVisible(cbGUI["_root"]) then return end
		if guiGetVisible(cbcGUI["_root"]) then return end
		local csX, csY = getCursorPosition()
		if csX and csY then
			dxDrawFramedText("RMB to show/hide cursor", sX  * csX + 10, sY  * csY - 5, 100, 50, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, true)
		end
	end
)

bindKey("mouse2", "up",
	function()
		if not guiGetVisible(cbGUI["_root"]) then return end
		if guiGetVisible(cbcGUI["_root"]) then return end
		if isCursorShowing() then
			if cursorOverGUI then return end
			guiSetAlpha(cbGUI["_root"], 0.1)
			_showCursor(false)
			guiSetInputMode("allow_binds")
		else
			guiSetAlpha(cbGUI["_root"], 1)
			_showCursor(true)
			guiSetInputMode("no_binds_when_editing")
		end
	end
)

function convertNumber(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

--[[addEventHandler("onClientRender", root,
	function()
		for index, bMarker in pairs(getElementsByType("marker", resourceRoot)) do
			local posX, posY, posZ = getElementPosition(bMarker)
			local camX, camY, camZ = getCameraMatrix()
			local dim,int = getElementDimension(bMarker),getElementInterior(bMarker)
			local pdim,pint = getElementDimension(localPlayer),getElementInterior(localPlayer)
			if getDistanceBetweenPoints3D(camX, camY, camZ, posX, posY, posZ) < 16 and dim == pdim and int == pint then
				local bData = getElementData(bMarker, "bData")
				local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
				local scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 1.2)
				if settings["business.showBusinessInfoOnMarker"] then
					local output_str = ""
					if scX then
						if #tostring(id) == 1 then id = "0"..tostring(id) end
						output_str = output_str.."ID: #"..id.."\n\n"
						output_str = output_str.."Name: "..name.."\n\n"
						output_str = output_str.."Owner: "..owner.."\n\n"
						output_str = output_str.."Cost: $"..convertNumber(cost).."\n\n"
						output_str = output_str.."Payout: $"..convertNumber(payout).."\n\n"
						output_str = output_str.."Payout Time: "..payoutOTime.." "..payoutUnit.."\n\n"
						output_str = output_str.."Bank: $"..convertNumber(bank).."\n\n"
						dxDrawFramedText(output_str, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false)
					end
				end
			end
		end
	end
)]]--

addEvent("client:showInstructions", true)
addEventHandler("client:showInstructions", root,
	function()
		addEventHandler("onClientRender", root, showInstructions)
	end
)

function showInstructions()
	if settings["business.key"] then
		dxDrawText("Press",(sX / 1440) * 550,(sY / 900) * 450,(sX / 1440) * 100,(sY / 900) * 100, tocolor(255, 255, 255, 255),(sX / 1440) * 2.0)
		dxDrawText(settings["business.key"]:upper(),(sX / 1440) * 615,(sY / 900) * 450,(sX / 1440) * 100,(sY / 900) * 100, tocolor(255, 0, 0, 255),(sX / 1440) * 2.0)
		dxDrawText(" To Open The Business",(sX / 1440) * 630,(sY / 900) * 450,(sX / 1440) * 100,(sY / 900) * 100, tocolor(255, 255, 255, 255),(sX / 1440) * 2.0)
	end
end

addEvent("client:hideInstructions", true)
addEventHandler("client:hideInstructions", root,
	function()
		removeEventHandler("onClientRender", root, showInstructions)
	end
)

function build_bGUI()
	
	local gui = {}
	gui._placeHolders = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 524, 398
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetAlpha(gui["_root"], 1)
	guiSetVisible(gui["_root"], false)
	
	gui["bBusinessL"] = guiCreateStaticImage(220, 25, 101, 80, "files/images/business.png", false, gui["_root"])
	
	gui["bTP"] = guiCreateTabPanel(10, 125, 511, 231, false, gui["_root"])
	
	gui["bInfoT"] = guiCreateTab("Information", gui["bTP"])
	
	gui["bIDL"] = guiCreateLabel(10, 20, 81, 16, "ID: #", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bIDL"], "left", false)
	guiLabelSetVerticalAlign(gui["bIDL"], "center")
	
	gui["bNameL"] = guiCreateLabel(10, 70, 241, 16, "Name:", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bNameL"], "left", false)
	guiLabelSetVerticalAlign(gui["bNameL"], "center")
	
	gui["bOwnerL"] = guiCreateLabel(10, 120, 231, 16, "Owner: ", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bOwnerL"], "left", false)
	guiLabelSetVerticalAlign(gui["bOwnerL"], "center")
	
	gui["bCostL"] = guiCreateLabel(10, 170, 191, 16, "Cost: ", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bCostL"], "left", false)
	guiLabelSetVerticalAlign(gui["bCostL"], "center")
	
	gui["bPayoutL"] = guiCreateLabel(290, 20, 211, 16, "Payout: ", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bPayoutL"], "left", false)
	guiLabelSetVerticalAlign(gui["bPayoutL"], "center")
	
	gui["bPayouttL"] = guiCreateLabel(290, 70, 211, 16, "Payout Time:", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bPayouttL"], "left", false)
	guiLabelSetVerticalAlign(gui["bPayouttL"], "center")
	
	gui["bLocL"] = guiCreateLabel(290, 120, 211, 16, "Location:", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bLocL"], "left", false)
	guiLabelSetVerticalAlign(gui["bLocL"], "center")
	
	gui["bBankL"] = guiCreateLabel(290, 170, 211, 16, "Bank:", false, gui["bInfoT"])
	guiLabelSetHorizontalAlign(gui["bBankL"], "left", false)
	guiLabelSetVerticalAlign(gui["bBankL"], "center")
	
	gui["bactionsT"] = guiCreateTab("Actions", gui["bTP"])
	
	gui["bBuyB"] = guiCreateButton(10, 10, 101, 31, "Buy", false, gui["bactionsT"])
	if on_bBuyB_clicked then
		addEventHandler("onClientGUIClick", gui["bBuyB"], on_bBuyB_clicked, false)
	end
	
	gui["bSellB"] = guiCreateButton(10, 60, 101, 31, "Sell", false, gui["bactionsT"])
	if on_bSellB_clicked then
		addEventHandler("onClientGUIClick", gui["bSellB"], on_bSellB_clicked, false)
	end
	
	gui["bDepositB"] = guiCreateButton(10, 110, 101, 31, "Deposit", false, gui["bactionsT"])
	if on_bDepositB_clicked then
		addEventHandler("onClientGUIClick", gui["bDepositB"], on_bDepositB_clicked, false)
	end
	
	gui["bWithdrawB"] = guiCreateButton(10, 160, 101, 31, "Withdraw", false, gui["bactionsT"])
	if on_bWithdrawB_clicked then
		addEventHandler("onClientGUIClick", gui["bWithdrawB"], on_bWithdrawB_clicked, false)
	end
	
	gui["bNameB"] = guiCreateButton(390, 10, 101, 31, "Set Name", false, gui["bactionsT"])
	if on_bNameB_clicked then
		addEventHandler("onClientGUIClick", gui["bNameB"], on_bNameB_clicked, false)
	end
	
	gui["bOwnerB"] = guiCreateButton(390, 60, 101, 31, "Set Owner", false, gui["bactionsT"])
	if on_bOwnerB_clicked then
		addEventHandler("onClientGUIClick", gui["bOwnerB"], on_bOwnerB_clicked, false)
	end
	
	gui["bCostB"] = guiCreateButton(390, 110, 101, 31, "Set Cost", false, gui["bactionsT"])
	if on_bCostB_clicked then
		addEventHandler("onClientGUIClick", gui["bCostB"], on_bCostB_clicked, false)
	end
	
	gui["bBankB"] = guiCreateButton(390, 160, 101, 31, "Set Bank", false, gui["bactionsT"])
	if on_bBankB_clicked then
		addEventHandler("onClientGUIClick", gui["bBankB"], on_bBankB_clicked, false)
	end
	
	gui["bactionE"] = guiCreateEdit(130, 50, 241, 31, "", false, gui["bactionsT"])
	guiEditSetMaxLength(gui["bactionE"], 32767)
	
	gui["bactionL"] = guiCreateLabel(130, 10, 241, 21, "Action:", false, gui["bactionsT"])
	guiLabelSetHorizontalAlign(gui["bactionL"], "center", false)
	guiLabelSetVerticalAlign(gui["bactionL"], "center")
	guiLabelSetColor(gui["bactionL"], 255, 0, 0)
	
	gui["bAcceptB"] = guiCreateButton(130, 100, 241, 41, "Accept", false, gui["bactionsT"])
	if on_bAcceptB_clicked then
		addEventHandler("onClientGUIClick", gui["bAcceptB"], on_bAcceptB_clicked, false)
	end
	
	gui["bDestroyB"] = guiCreateButton(130, 155, 241, 41, "Destroy", false, gui["bactionsT"])
	if on_bDestroyB_clicked then
		addEventHandler("onClientGUIClick", gui["bDestroyB"], on_bDestroyB_clicked, false)
	end
	
	gui["AboutL"] = guiCreateLabel(10, 365, 511, 31, "Made By JR10", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["AboutL"], "center", false)
	guiLabelSetVerticalAlign(gui["AboutL"], "center")
	guiLabelSetColor(gui["AboutL"], 255, 170, 0)
	
	gui["bXB"] = guiCreateButton(480, 25, 31, 31, "X", false, gui["_root"])
	if on_bXB_clicked then
		addEventHandler("onClientGUIClick", gui["bXB"], on_bXB_clicked, false)
	end
	
	return gui, windowWidth, windowHeight
end

function on_bBuyB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bacGUI["_root"], "Buy Business")
	guiSetText(bacGUI["bacInfoL"], "Buy This Business?")
	guiSetVisible(bacGUI["_root"], true)
	action = "Buy"
end

function on_bSellB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bacGUI["_root"], "Sell Business")
	guiSetText(bacGUI["bacInfoL"], "Sell This Business?")
	guiSetVisible(bacGUI["_root"], true)
	action = "Sell"
end

function on_bDepositB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Deposit:")
	action = "Deposit"
end

function on_bWithdrawB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Withdraw:")
	action = "Withdraw"
end

function on_bNameB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Set Name:")
	action = "SName"
end

function on_bOwnerB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Set Owner:")
	action = "SOwner"
end

function on_bCostB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Set Cost:")
	action = "SCost"
end

function on_bBankB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bGUI["bactionL"], "Set Bank:")
	action = "SBank"
end

function on_bAcceptB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	if action == "Deposit" then
		local text = guiGetText(bGUI["bactionE"])
		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Deposit")
		guiSetText(bacGUI["bacInfoL"], "Deposit $"..tostring(tonumber(text)).." ?")
		guiSetVisible(bacGUI["_root"], true)
	elseif action == "Withdraw" then
		local text = guiGetText(bGUI["bactionE"])
		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Withdraw")
		guiSetText(bacGUI["bacInfoL"], "Withdraw $"..tostring(tonumber(text)).." ?")
		guiSetVisible(bacGUI["_root"], true)
	elseif action == "SName" then
		local text = guiGetText(bGUI["bactionE"])
		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		if #text > 30 then return outputMessage("BUSINESS: Business Name Must Be Lower Than 31 Character", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Set Name")
		guiSetText(bacGUI["bacInfoL"], "Set This Business Name To "..text.." ?")
		guiSetVisible(bacGUI["_root"], true)
	elseif action == "SOwner" then
		local text = guiGetText(bGUI["bactionE"])
		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Set Owner")
		guiSetText(bacGUI["bacInfoL"], "Set This Business Owner To "..text.." ?")
		guiSetVisible(bacGUI["_root"], true)
	elseif action == "SCost" then
		local text = guiGetText(bGUI["bactionE"])
		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Set Cost")
		guiSetText(bacGUI["bacInfoL"], "Set This Business Cost To "..tostring(tonumber(text)).." ?")
		guiSetVisible(bacGUI["_root"], true)
	elseif action == "SBank" then
		local text = guiGetText(bGUI["bactionE"])
		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(bacGUI["_root"], "Set Bank")
		guiSetText(bacGUI["bacInfoL"], "Set This Business Bank To "..tostring(tonumber(text)).." ?")
		guiSetVisible(bacGUI["_root"], true)
	end
end

function on_bXB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetVisible(bGUI["_root"], false)
	showCursor(false)
	guiSetInputMode("allow_binds")
	setElementFrozen(localPlayer, false)
end

function on_bDestroyB_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetText(bacGUI["_root"], "Destroy Business")
	guiSetText(bacGUI["bacInfoL"], "Destroy This Business?")
	guiSetVisible(bacGUI["_root"], true)
	action = "Destroy"
end

addEvent("client:showBusinessGUI", true)
addEventHandler("client:showBusinessGUI", root,
	function(bMarker, isOwner, isAdmin)
		local bData = getElementData(bMarker, "bData")
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
		local posX, posY, posZ = getElementPosition(bMarker)
		if #tostring(id) == 1 then id = "0"..tostring(id) end
		guiSetText(bGUI["_root"], name)
		guiSetText(bGUI["bIDL"], "ID: #"..id)
		guiSetText(bGUI["bNameL"], "Name: "..name)
		guiSetText(bGUI["bOwnerL"], "Owner: "..owner)
		guiSetText(bGUI["bCostL"], "Cost: $"..cost)
		guiSetText(bGUI["bPayoutL"], "Payout: $"..payout)
		guiSetText(bGUI["bPayouttL"], "Payout Time: "..payoutOTime.." "..payoutUnit)
		guiSetText(bGUI["bLocL"], "Location: "..getZoneName(posX, posY, posZ, false).."("..getZoneName(posX, posY, posZ, true)..")")
		guiSetText(bGUI["bBankL"], "Bank: $"..bank)
		
		if isAdmin and isOwner then
			guiSetEnabled(bGUI["bactionsT"], true)
			guiSetEnabled(bGUI["bSellB"], true)
			guiSetEnabled(bGUI["bactionE"], true)
			guiSetEnabled(bGUI["bDepositB"], true)
			guiSetEnabled(bGUI["bWithdrawB"], true)
			guiSetEnabled(bGUI["bAcceptB"], true)
			guiSetEnabled(bGUI["bNameB"], true)
			guiSetEnabled(bGUI["bOwnerB"], true)
			guiSetEnabled(bGUI["bCostB"], true)
			guiSetEnabled(bGUI["bBankB"], true)
			guiSetEnabled(bGUI["bBuyB"], false)
		elseif isAdmin and not isOwner and owner ~= "For Sale" then
			guiSetEnabled(bGUI["bactionsT"], true)
			guiSetEnabled(bGUI["bNameB"], true)
			guiSetEnabled(bGUI["bOwnerB"], true)
			guiSetEnabled(bGUI["bCostB"], true)
			guiSetEnabled(bGUI["bBankB"], true)
			guiSetEnabled(bGUI["bAcceptB"], true)
			guiSetEnabled(bGUI["bactionE"], true)
			guiSetEnabled(bGUI["bSellB"], true)
			guiSetEnabled(bGUI["bBuyB"], false)
			guiSetEnabled(bGUI["bDepositB"], false)
			guiSetEnabled(bGUI["bWithdrawB"], false)
		elseif isAdmin and not isOwner and owner == "For Sale" then
			guiSetEnabled(bGUI["bactionsT"], true)
			guiSetEnabled(bGUI["bNameB"], true)
			guiSetEnabled(bGUI["bOwnerB"], true)
			guiSetEnabled(bGUI["bCostB"], true)
			guiSetEnabled(bGUI["bBankB"], true)
			guiSetEnabled(bGUI["bAcceptB"], true)
			guiSetEnabled(bGUI["bactionE"], true)
			guiSetEnabled(bGUI["bSellB"], false)
			guiSetEnabled(bGUI["bBuyB"], true)
			guiSetEnabled(bGUI["bDepositB"], false)
			guiSetEnabled(bGUI["bWithdrawB"], false)
		elseif not isAdmin and isOwner then
			guiSetEnabled(bGUI["bactionsT"], true)
			guiSetEnabled(bGUI["bNameB"], false)
			guiSetEnabled(bGUI["bOwnerB"], false)
			guiSetEnabled(bGUI["bCostB"], false)
			guiSetEnabled(bGUI["bBankB"], false)
			guiSetEnabled(bGUI["bAcceptB"], true)
			guiSetEnabled(bGUI["bactionE"], true)
			guiSetEnabled(bGUI["bSellB"], true)
			guiSetEnabled(bGUI["bDepositB"], true)
			guiSetEnabled(bGUI["bWithdrawB"], true)
			guiSetEnabled(bGUI["bBuyB"], false)
		elseif not isAdmin and not isOwner and owner ~= "For Sale" then
			guiSetEnabled(bGUI["bactionsT"], false)
			guiSetSelectedTab(bGUI["bTP"], bGUI["bInfoT"])
		elseif not isAdmin and not isOwner and owner == "For Sale" then
			guiSetEnabled(bGUI["bactionsT"], true)
			guiSetEnabled(bGUI["bNameB"], false)
			guiSetEnabled(bGUI["bOwnerB"], false)
			guiSetEnabled(bGUI["bCostB"], false)
			guiSetEnabled(bGUI["bBankB"], false)
			guiSetEnabled(bGUI["bAcceptB"], false)
			guiSetEnabled(bGUI["bactionE"], false)
			guiSetEnabled(bGUI["bSellB"], false)
			guiSetEnabled(bGUI["bDepositB"], false)
			guiSetEnabled(bGUI["bWithdrawB"], false)
			guiSetEnabled(bGUI["bBuyB"], true)
		end
		
		guiSetVisible(bGUI["_root"], true)
		showCursor(true)
		guiSetInputMode("no_binds_when_editing")
	end
)

function build_bacGUI()
	
	local gui = {}
	gui._placeHolders = {}
	
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 332, 193
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Buy Business", false)
	guiWindowSetSizable(gui["_root"], false)
	guiWindowSetMovable(gui["_root"], false)
	guiSetProperty(gui["_root"], "AlwaysOnTop", "true")
	guiSetAlpha(gui["_root"], 1)
	guiSetVisible(gui["_root"], false)
	
	gui["bacInfoL"] = guiCreateLabel(0, 15, 331, 51, "Are you sure you want to Buy This Business", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["bacInfoL"], "center", false)
	guiLabelSetVerticalAlign(gui["bacInfoL"], "center")
	guiLabelSetColor(gui["bacInfoL"], 0, 255, 255)
	
	gui["bacAcceptI"] = guiCreateStaticImage(50, 125, 71, 51, "files/images/tick.png", false, gui["_root"])
	if on_bacAcceptI_clicked then
		addEventHandler("onClientGUIClick", gui["bacAcceptI"], on_bacAcceptI_clicked, false)
	end
	
	gui["bacCancelI"] = guiCreateStaticImage(220, 125, 71, 51, "files/images/wrong.png", false, gui["_root"])
	if on_bacCancelI_clicked then
		addEventHandler("onClientGUIClick", gui["bacCancelI"], on_bacCancelI_clicked, false)
	end
	addEventHandler("onClientMouseEnter", gui["bacAcceptI"], on_bacAcceptI_entered, false)
	addEventHandler("onClientMouseEnter", gui["bacCancelI"], on_bacCancelI_entered, false)
	addEventHandler("onClientMouseLeave", gui["bacAcceptI"], on_bacAcceptI_left, false)
	addEventHandler("onClientMouseLeave", gui["bacCancelI"], on_bacCancelI_left, false)
	
	return gui, windowWidth, windowHeight
end

function on_bacAcceptI_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	local text = guiGetText(bGUI["bactionE"])
	triggerServerEvent("server:onActionAttempt", localPlayer, action, text)
	guiSetVisible(bacGUI["_root"], false)
end

function on_bacCancelI_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return
	end
	guiSetVisible(bacGUI["_root"], false)
end

function on_bacAcceptI_entered()
	guiSetAlpha(source, 0.5)
end

function on_bacCancelI_entered()
	guiSetAlpha(source, 0.5)
end

function on_bacAcceptI_left()
	guiSetAlpha(source, 1)
end

function on_bacCancelI_left()
	guiSetAlpha(source, 1)
end

addEvent("client:onAction", true)
addEventHandler("client:onAction", root,
	function(close, playCash)
		if close then
			guiSetVisible(bGUI["_root"], false)
			showCursor(false)
		end
		if playCash then
			playSound("files/sounds/cash.mp3", false)
		end
		guiSetText(bGUI["bactionL"], "Action:")
		guiSetText(bGUI["bactionE"], "")
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		cbGUI = build_cbGUI()
		cbcGUI = build_cbcGUI()
		bGUI = build_bGUI()
		bacGUI = build_bacGUI()
		triggerServerEvent("onClientCallSettings", localPlayer)
	end
)

addEvent("onClientCallSettings", true)
addEventHandler("onClientCallSettings", root,
	function(settings2)
		settings = settings2
	end
)
