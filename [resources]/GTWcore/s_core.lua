--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Table to store server core settings during runtime
server_settings = { }
core_db = nil

--[[ Load server configuration settings from xml ]]--
function load_settings()
        local data_file = xmlLoadFile("data/settings.xml")
        local options = xmlNodeGetChildren(data_file)
        for i,node in ipairs(options) do
                local name = xmlNodeGetAttribute(node, "name")
                server_settings[name] = xmlNodeGetValue(node)
        end
        xmlUnloadFile(data_file)

        -- Applying basic settings
        for k,v in pairs(getElementsByType("player")) do
                -- Bind the R key as reload for all players
                bindKey(v, "r", "down", reload_weapon, "Reload")

                -- Set the blur level
                setPlayerBlurLevel(v, 0)

                -- Apply jetpack and other advantages to staff
           	applyStaffAdvantage(v)
        end

        -- Config server display options
        setGameType(server_settings["gamemode"])
        setMapName(server_settings["map"])

	--[[ Export for other resources to figure out server language ]]--
	function getLanguage()
		return server_settings["language"]
	end

        --[[ Exports for MySQL credentials ]]--
        function getMySQLHost() return server_settings["MySQLhost"] end
        function getMySQLDatabase() return server_settings["MySQLdatabase"] end
        function getMySQLUser() return server_settings["MySQLuser"] end
        function getMySQLPass() return server_settings["MySQLpass"] end
        function getMySQLPort() return server_settings["MySQLport"] end

        -- Connect to database
	local conn_str = "dbname="..server_settings["MySQLdatabase"]..";host="..server_settings["MySQLhost"]
        core_db = dbConnect("mysql", conn_str, server_settings["MySQLuser"], server_settings["MySQLpass"], "autoreconnect=1")
	dbExec(core_db, "CREATE TABLE IF NOT EXISTS account_data(account TEXT, data_key TEXT, data_value TEXT)")
	outputServerLog("Connecting to DB: "..conn_str)
end
addEventHandler("onResourceStart", resourceRoot, load_settings)

--[[ Save server configuration settings to xml ]]-- 
function save_settings()
        local data_file = xmlLoadFile("data/settings.xml")
        local options = xmlNodeGetChildren(data_file)
        for i,node in pairs(options) do
                local name = xmlNodeGetAttribute(node, "name")
                xmlNodeSetValue(node, server_settings[name])
        end
        xmlSaveFile(data_file)
end
addEventHandler("onResourceStop", resourceRoot, save_settings)

--[[ Peak event for holidays ]]--
function send_peak_bonus()
        if tonumber(server_settings["peak"]) >= getPlayerCount() then return end
        for i,v in pairs(getElementsByType("player")) do
                givePlayerMoney(v, 1000)
                exports.GTWtopbar:dm("Enjoy a peak bonus of $1000 for being online today!", v, 255, 100, 0)
        end
        server_settings["peak"] = tonumber(server_settings["peak"]) + 1
end
addEvent("GTWcore.onPeakTrigger", true)
addEventHandler("GTWcore.onPeakTrigger", root, send_peak_bonus)

--[[ Display current peak ]]--
function show_current_peak(plr)
        exports.GTWtopbar:dm("Current peak is: "..server_settings["peak"].." players online", plr, 255, 100, 0)
end
addCommandHandler("peak", show_current_peak)

--[[ Set player language ]]--
function set_player_language(plr, cmd, lang)
	setElementData(plr, "GTWcore.language", lang)
        exports.GTWtopbar:dm("Your language is now: "..lang, plr, 0, 200, 0)
end
addCommandHandler("lang", set_player_language)
addCommandHandler("setlang", set_player_language)
addCommandHandler("setlanguage", set_player_language)

--[[ Sync with local client time ]]--
setMinuteDuration(1000)

--[[ Reset sky gradient and fog distance ]]--
setFogDistance(0)
resetSkyGradient()

--[[ Allow players to reload weapons by pressing the R key ]]--
function reload_weapon(player, command)
        reloadPedWeapon(player)
end

--[[ Apply some key bindings and reset blur level on join ]]--
function player_join_handler()
        bindKey(source, "r", "down", reload_weapon, "Reload")
        setPlayerBlurLevel(source, 0)
end
addEventHandler("onPlayerJoin", root, player_join_handler)

--[[ Commands to transfer money between players ]]--
local money_cooldown = { }
function send_player_money(plr, cmd, receiver, amount)
	local money = tonumber(amount) or 0
        if money_cooldown[plr] and getTickCount() - money_cooldown[plr] < 60000 then
                exports.GTWtopbar:dm("Please allow up to 1 minute between each transfer", plr, 255, 0, 0)
                return
        end
	if receiver and money and money > 0 and money < 1000 and getPlayerMoney(plr) >= money and getPlayerTeam(plr) then
		local playerReceiver = getPlayerFromName(receiver)
		if playerReceiver then
			takePlayerMoney(plr, money)
			givePlayerMoney(playerReceiver, money)
			exports.GTWtopbar:dm(money.."$ sent to "..receiver.." (all transactions over $500 are logged)", player, 0, 255, 0)
			exports.GTWtopbar:dm(money.."$ received from: "..getPlayerName(plr), playerReceiver, 0, 255, 0)
                        if money > 500 then
			        outputServerLog("[BANK] $"..money.." sent to: "..receiver..", from: "..getPlayerName(plr).." ("..getTeamName(getPlayerTeam(plr))..")")
                        end
		else
			exports.GTWtopbar:dm("Player does not exist", plr, 255, 0, 0)
		end
	elseif money < 0 then
		exports.GTWtopbar:dm("Negative amounts are not allowed", plr, 255, 0, 0)
        elseif money > 1000 then
                exports.GTWtopbar:dm("Amounts over $1000 is not allowed", plr, 255, 0, 0)
	elseif not getPlayerTeam(plr) then
		exports.GTWtopbar:dm("You must be in a team in order to send money, please reconnect if youre not!", plr, 255, 0, 0)
	else
		outputChatBox("Correct syntax: /give <player_nick> <amount>", plr, 180, 180, 180)
	end
        money_cooldown[plr] = getTickCount()
end
addCommandHandler("give", send_player_money)

function topMessage(message, player, r, g, b)
	exports.GTWtopbar:dm(message, player, r, g, b)
end

function displayLoadedRes(res)
	-- Get current version
	local version_r = (tonumber(getResourceInfo(res, "version")) or 0)+1
	for k,v in pairs(getElementsByType("player")) do
                local pAcc = getPlayerAccount(v)
                if pAcc and (isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) or
        	       isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Developer")) or
        	       isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Moderator")) or
        	       isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Supporter"))) then
        	       outputChatBox("Resource "..getResourceName(res).." v4.0-beta r-"..
                              version_r.." [#00cc00Started#ffffff]", v, 255, 255, 255, true)
                end
        end

        -- Increase GTW version (for official development servers only)
        if server_settings["developmentserver"] then
                server_settings["revision"] = server_settings["revision"] + 1
        end

        -- Increase resource version
        setResourceInfo(res, "version", tostring(version_r) )

        -- Display in server log if load successfull
        --outputServerLog("[GTW-RPG] "..getResourceName(res).." (v.2.4-beta r-"..(version_r)..") started successfully")
        setElementData(root, "gtw-version", "GTW-RPG v4.0 r-"..tostring(server_settings["revision"]).." | www.404rq.com | ")
end
addEventHandler("onResourceStart", root, displayLoadedRes)

function displayStoppedRes(res)
	for k,v in ipairs(getElementsByType("player")) do
        local pAcc = getPlayerAccount(v)
        if pAcc and (isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) or
        	isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Developer"))) then
        	outputChatBox("Resource " .. (getResourceName(res) or "unknown") .. " [#cc0000Stopped#ffffff]", v, 255, 255, 255, true)
        end
    end
end
addEventHandler("onResourceStop", root, displayStoppedRes)

function getGTWVersion(plr)
        outputChatBox("Current GTW version: 3.0 r-"..server_settings["revision"], plr, 255, 255, 255)
end
addCommandHandler("gtwversion", getGTWVersion)

function manageGTWData(plr, cmd, acc, key, value)
	local aAcc = getPlayerAccount(plr)
        if not acc then
                outputChatBox("Correct syntax: "..cmd.." <account> <key> [<value>]", plr, 200,200,200)
                return
        end
        local pAcc = getAccount(acc)
        if not acc or not pAcc or not isObjectInACLGroup("user."..getAccountName(aAcc), aclGetGroup("Admin")) then return end
        if cmd == "getdata" and key then
 	        local val = get_account_data(pAcc, key) or ""
 	        outputChatBox("KEY: "..key..", has VALUE: "..val, plr, 200,200,200)
        elseif cmd == "setdata" and key and value then
	        exports.GTWcore:set_account_data(pAcc, key, value)
	        outputChatBox("KEY: "..key..", was updated to: "..value..", successfully!", plr, 200,200,200)
        elseif cmd == "listdata" then
                local data = getAllAccountData(pAcc)
                if ( data ) then
                        outputConsole(" *** ACCOUNT DATA LIST ("..acc..") STARTED *** ", plr)
                        for k,v in pairs(data) do
                                outputConsole(k..": "..v, plr) -- print the key and value of each entry of data
                        end
                        outputConsole(" *** ACCOUNT DATA LIST END *** ", plr)
                        outputChatBox("All keys was successfully listed, press F8 to view!", plr, 200,200,200)
                end
        else
	        outputChatBox("Correct syntax: "..cmd.." <account> <key> [<value>]", plr, 200,200,200)
        end
end
addCommandHandler("setdata", manageGTWData)
addCommandHandler("getdata", manageGTWData)
addCommandHandler("listdata", manageGTWData)

--[[ Allow server admins to reset a users password ]]--
function reset_account(admin, cmd, acc, passwd)
        local acc = getAccount(acc)
        if not acc or not passwd then
                outputChatBox("Correct syntax: /resetpassword account password", admin, 255,255,255)
        end

        local pAcc = getPlayerAccount(admin)

        if not pAcc or not isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) then return end
        setAccountPassword(acc, passwd)
end
addCommandHandler("resetpassword", reset_account)

-- Round float values
function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end

-- Validate account calls from gaems.albonius.com store
function validateAccount(acc)
	if getAccount(acc) then
		return true
	else
		return false
	end
end
