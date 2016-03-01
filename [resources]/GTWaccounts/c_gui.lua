--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Global client properites
p_account = nil
p_loggedIn = false
sec_login_attempts = 0
login_cooldown = nil

-- Display status messages from the server
addEvent("GTWaccounts:onStatusReceive", true)
addEventHandler("GTWaccounts:onStatusReceive", root, function(msg, statusCode)
	if statusCode == -1 then
		guiLabelSetColor(labelInfo, 255, 0, 0)
	elseif statusCode == 0 then
		guiLabelSetColor(labelInfo, 255, 255, 0)
	elseif statusCode == 1 then
		guiLabelSetColor(labelInfo, 0, 255, 0)
	end
	guiSetText(labelInfo, msg)
end)

-- Setup the login GUI (GTWgui must be running)
function make_login()
	x,y = guiGetScreenSize()
	window = guiCreateWindow((x-600)/2, (y-450)/2, 600, 450, "RageQuit 404 | GTW-RPG v3.0", false )
	loginButton = guiCreateButton(480,400,110,40,"Login",false,window)
	registerButton = guiCreateButton(368,400,110,40,"Register",false,window)
	introButton = guiCreateButton(256,400,110,40,"View intro",false,window)
	updatesButton = guiCreateButton(10,400,116,40,"What's new",false,window)
	labelUser = guiCreateLabel(30, 40, 290, 25, "Username:", false, window)
	labelPwrd = guiCreateLabel(30, 100, 290, 25, "Password:", false, window)
	textUser = guiCreateEdit(30,65,290,25,"",false,window)
	textPwrd = guiCreateEdit(30,125,290,25,"",false,window)
	labelInfo = guiCreateLabel(30, 210, 290, 80, "", false, window)
	checkBoxUser = guiCreateCheckBox(30, 160, 290, 20, "Remember Username", false, false, window)
	checkBoxPwrd = guiCreateCheckBox(30, 180, 290, 20, "Remember Password", false, false, window)
	-- Shaders control panel
	labelShaders = guiCreateLabel(360, 40, 230, 25, "Select shaders:", false, window)
	checkBoxDetail = guiCreateCheckBox(360, 80, 290, 20, "Enable detail shader", false, false, window)
	checkBoxContrast = guiCreateCheckBox(360, 100, 290, 20, "Enable contrast shader", false, false, window)
	checkBoxWater = guiCreateCheckBox(360, 120, 290, 20, "Enable water shader", false, false, window)
	checkBoxCarPaint = guiCreateCheckBox(360, 140, 290, 20, "Enable car reflection shader", false, false, window)
	labelInfoRight = guiCreateLabel(360, 180, 290, 170,
[[Welcome! to sign up, choose account
name and password then click register.
To login, enter credentials then click
login. You may also select shaders to
make the game look more realistic or
disable shaders for better FPS.

Regards: RageQuit 404 community
Website: https://404rq.com]], false, window)
	guiEditSetMasked(textPwrd, true)
	guiSetInputEnabled(true)

	-- Friends invite bonus
	labelFacc = guiCreateLabel(30, 300, 190, 25, "Send your friend a gift", false, window)
	textFacc = guiCreateEdit(30,325,260,25,"",false,window)
	faccButtonHelp = guiCreateButton(290,325,30,25,"?",false,window)

	-- Set GUI font
	exports.GTWgui:setDefaultFont(loginButton, 10)
	exports.GTWgui:setDefaultFont(registerButton, 10)
	exports.GTWgui:setDefaultFont(introButton, 10)
	exports.GTWgui:setDefaultFont(updatesButton, 10)
	exports.GTWgui:setDefaultFont(labelUser, 10)
	exports.GTWgui:setDefaultFont(labelPwrd, 10)
	exports.GTWgui:setDefaultFont(labelInfo, 10)
	exports.GTWgui:setDefaultFont(textUser, 9)
	exports.GTWgui:setDefaultFont(textPwrd, 9)
	exports.GTWgui:setDefaultFont(checkBoxUser,10)
	exports.GTWgui:setDefaultFont(checkBoxPwrd, 10)
	exports.GTWgui:setDefaultFont(labelFacc, 10)
	exports.GTWgui:setDefaultFont(textFacc, 10)
	exports.GTWgui:setDefaultFont(faccButtonHelp, 10)
	exports.GTWgui:setDefaultFont(checkBoxDetail, 10)
	exports.GTWgui:setDefaultFont(checkBoxContrast, 10)
	exports.GTWgui:setDefaultFont(checkBoxCarPaint, 10)
	exports.GTWgui:setDefaultFont(checkBoxWater, 10)
	exports.GTWgui:setDefaultFont(labelInfoRight, 10)
	showCursor(true)

	-- Load login details from xml
	local f = xmlLoadFile('@data.xml', 'account')
	if f then
		local user = xmlNodeGetAttribute(xmlFindChild(f, 'user', 0), 'value') or ""
		local pass = xmlNodeGetAttribute(xmlFindChild(f, 'pass', 0), 'value') or ""
		local sh_detail = xmlNodeGetAttribute(xmlFindChild(f, 'detail', 0), 'value') or ""
		local sh_contrast = xmlNodeGetAttribute(xmlFindChild(f, 'contrast', 0), 'value') or ""
		local sh_water = xmlNodeGetAttribute(xmlFindChild(f, 'water', 0), 'value') or ""
		local sh_carpaint = xmlNodeGetAttribute(xmlFindChild(f, 'carpaint', 0), 'value') or ""
		guiSetText(textUser, tostring(user))
		guiSetText(textPwrd, tostring(pass))
		if user ~= "" then
			guiCheckBoxSetSelected(checkBoxUser, true)
		end
		if pass ~= "" then
			guiCheckBoxSetSelected(checkBoxPwrd, true)
		end
		if sh_detail == "enabled" then
			guiCheckBoxSetSelected(checkBoxDetail, true)
			exports.shader_detail:toggleShaderDetail(true)
		else
			exports.shader_detail:toggleShaderDetail(false)
		end
		if sh_contrast == "enabled" then
			guiCheckBoxSetSelected(checkBoxContrast, true)
			exports.shader_contrast:toggleShaderContrast(true)
		else
			exports.shader_contrast:toggleShaderContrast(false)
		end
		if sh_water == "enabled" then
			guiCheckBoxSetSelected(checkBoxWater, true)
			exports.shader_water:toggleShaderWater(true)
		else
			exports.shader_water:toggleShaderWater(false)
		end
		if sh_carpaint == "enabled" then
			guiCheckBoxSetSelected(checkBoxCarPaint, true)
			exports.shader_car_paint_reflect:toggleShaderCarPaint(true)
		else
			exports.shader_car_paint_reflect:toggleShaderCarPaint(false)
		end
	end
end

-- Login GUI click events
addEventHandler("onClientGUIClick",root,function()
	-- On login (asyncron function)
	if source == loginButton then
		if isTimer(login_cooldown) then return end
		guiLabelSetColor(labelInfo, 255, 255, 255)
		guiSetText(labelInfo, "Attempting to login... please wait")
		fadeCamera(false, 1)
		setTimer(triggerServerEvent, 1100, 1, "GTWaccounts:attemptClientLogin", localPlayer, guiGetText(textUser), guiGetText(textPwrd))
		if sec_login_attempts > 2 then
			-- Kick after 3 failed login attempts
			triggerServerEvent("GTWaccounts:kickClientSpammer", localPlayer)
		end
		sec_login_attempts = sec_login_attempts + 1
		login_cooldown = setTimer(function()
			toggle_gui_enable(true)
		end, 3000, 1)
		toggle_gui_enable(false)
	-- On registration
	elseif source == registerButton then
		triggerServerEvent("GTWaccounts:onClientAttemptRegistration", localPlayer, guiGetText(textUser), guiGetText(textPwrd), guiGetText(textFacc))
	-- On view intro start
	elseif source == introButton then
		addEventHandler("onClientRender", root, view_gtw_intro)
		guiSetVisible(window, false)
	-- On view updates button click (requires GTWupdates)
	elseif source == updatesButton then
		exports.GTWupdates:viewUpdateListGUI()
	-- On help request click
	elseif source == faccButtonHelp then
		guiSetText(labelInfo, "Enter your friends account name \nto send him/her an invite bonus\nof $4'000 as a reward.")
		guiLabelSetColor(labelInfo, 255, 255, 255)
	-- Toggle shaders
	elseif source == checkBoxDetail then
		exports.shader_detail:toggleShaderDetailCMD()
	elseif source == checkBoxContrast then
		exports.shader_contrast:toggleShaderContrastCMD()
	elseif source == checkBoxWater then
		exports.shader_water:toggleShaderWaterCMD()
	elseif source == checkBoxCarPaint then
		exports.shader_car_paint_reflect:toggleShaderCarPaintCMD()
	end
end)

-- Enable/disable buttons
function toggle_gui_enable(state)
	guiSetEnabled(loginButton, state)
	guiSetEnabled(registerButton, state)
	guiSetEnabled(updatesButton, state)
	guiSetEnabled(faccButtonHelp, state)
	guiSetEnabled(textUser, state)
	guiSetEnabled(textPwrd, state)
	guiSetEnabled(textFacc, state)
end

-- On client attempt login
addEvent("GTWaccounts:onClientPlayerLogin", true)
addEventHandler("GTWaccounts:onClientPlayerLogin", root, function(acnt)
	local f = xmlCreateFile("@data.xml", "account")
	local user, pass = "", ""
	if guiCheckBoxGetSelected(checkBoxUser) then
		user = guiGetText(textUser)
	end
	if guiCheckBoxGetSelected(checkBoxPwrd) then
		pass = guiGetText(textPwrd)
	end
	xmlNodeSetAttribute(xmlCreateChild(f, "user"), "value", user)
	xmlNodeSetAttribute(xmlCreateChild(f, "pass"), "value", pass)
	-- Save shaders
	if guiCheckBoxGetSelected(checkBoxDetail) then
		xmlNodeSetAttribute(xmlCreateChild(f, "detail"), "value", "enabled")
	else
		xmlNodeSetAttribute(xmlCreateChild(f, "detail"), "value", "disabled")
	end
	if guiCheckBoxGetSelected(checkBoxContrast) then
		xmlNodeSetAttribute(xmlCreateChild(f, "contrast"), "value", "enabled")
	else
		xmlNodeSetAttribute(xmlCreateChild(f, "contrast"), "value", "disabled")
	end
	if guiCheckBoxGetSelected(checkBoxWater) then
		xmlNodeSetAttribute(xmlCreateChild(f, "water"), "value", "enabled")
	else
		xmlNodeSetAttribute(xmlCreateChild(f, "water"), "value", "disabled")
	end
	if guiCheckBoxGetSelected(checkBoxCarPaint) then
		xmlNodeSetAttribute(xmlCreateChild(f, "carpaint"), "value", "enabled")
	else
		xmlNodeSetAttribute(xmlCreateChild(f, "carpaint"), "value", "disabled")
	end
	xmlSaveFile(f)
	xmlUnloadFile(f)
	guiSetVisible(window, false)
	showCursor(false)
	guiSetInputEnabled(false)
	showChat(true)

	-- Set account obtained from the server and login status
	p_loggedIn = true
	p_account = acnt
end)

-- Exported functions to check if logged in or to obtain account name
function getPlayerAccount()
	return p_account or "Guest"
end
function isClientLoggedIn()
	return p_loggedIn
end

-- Get a players ID
function getPlayerId(p)
	local id = nil
	for i, v in pairs(getElementsByType('player')) do
		if v == p then
			id = i
			break
		end
	end
	return id
end

-- Display login screen to players who isn't currently logged in
addEventHandler("onClientResourceStart", resourceRoot, function()
	if not getElementData(localPlayer, "isLoggedIn") then
		exports.GTWtopbar:dm("Welcome! please read the instructions before trying to register", 0,200,0)
		setTimer(make_login, 500, 1)
		setBlurLevel(0)
		showChat(false)
		triggerServerEvent("GTWaccounts.onClientSend",localPlayer)
	else
		p_loggedIn = true
	end
end)
