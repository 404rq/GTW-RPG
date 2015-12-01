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

-- Initialize an account for settings
local sAcc = getAccount("settings")

-- If there is no account for settings, make one
if not sAcc then
        -- Generate a random password
        -- Nobody is supposed to login as this account, although it won't hurt
        local rnd_passwd = ""
        for k=1, 10 do
                rnd_passwd = rnd_passwd..math.random(1000, 9999)
        end
        addAccount("settings", rnd_passwd)
        sAcc = getAccount("settings")

        -- Notice server admins
        outputServerLog("CORE: account for settings was created successfully")
end


--[[ Peak event for holidays ]]--
current_peak = getAccountData(sAcc, "peak") or 0
function sendPeak(plr)
    if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
    givePlayerMoney(plr, 1000)
    exports.GTWtopbar:dm("Enjoy a peak bonus of $1000 for being online today!", plr, 255, 100, 0)
end
function doPeak()
    if current_peak >= getPlayerCount() then return end
    for i,v in ipairs(getElementsByType("player")) do
        setTimer(sendPeak, 30000, 1, v)
    end
    current_peak = current_peak + 1
    setAccountData(sAcc, "peak", current_peak or 0)
end
addEvent("onPeakTrigger", true)
addEventHandler("onPeakTrigger", root, doPeak)
function showPeak(plr)
    exports.GTWtopbar:dm("Current peak are: "..current_peak.." players online", plr, 255, 100, 0)
end
addCommandHandler("peak", showPeak)

--[[ Sync with local swedish time ]]--
--local time = getRealTime()
--setTime(time.hour, time.minute)
setMinuteDuration(1000)
setFogDistance(0)
resetSkyGradient()

-- Update time sync each day
--setTimer(function()
--	local time2 = getRealTime()
--	setTime(time2.hour, time2.minute)
--end, 24*3600*1000, 0)

--[[ Allow players to reload weapons by pressing the R key ]]--
function reloadGun(player, command)
    reloadPedWeapon(player)
end
function resourceStart()
    for k,v in pairs(getElementsByType("player")) do
        bindKey(v, "r", "down", reloadGun, "Reload")
        setPlayerBlurLevel(v, 36)

        -- Apply jetpack and other advantages if staff
       	applyStaffAdvantage(v)
    end

    -- Config
    setGameType("GTW-RPG")
    setMapName("GTW-RPG")
	setTimer(setGameType, 3600*1000, 0, "GTW-RPG")
	setTimer(setMapName, 3600*1000, 0, "GTW-RPG")
end
function playerJoin()
    bindKey(source, "r", "down", reloadGun, "Reload")
    setPlayerBlurLevel(source, 0)
end
addEventHandler("onResourceStart", root, resourceStart)
addEventHandler("onPlayerJoin", root, playerJoin)

--[[ Countdown ]]--
countdownTimers = {}
function showCountDown(plr, cmd, seconds, text)
	local x,y,z = getElementPosition(plr)
	if seconds and text and math.floor(seconds) < 20 and math.floor(seconds) > 2 then
		seconds = math.floor(seconds)
    	for k,v in ipairs(getElementsByType("player")) do
        	local rx,ry,rz = getElementPosition(v)
        	if getDistanceBetweenPoints3D(x,y,z, rx,ry,rz) < 100 and not isTimer(countdownTimers[v]) then
        		outputChatBox("-- "..getPlayerName(plr).." has requested a countdown --", v, 255, 255, 255)
        		countdownTimers[v] = setTimer(countDownTimerCount, 1000, seconds, v, seconds)
        		setTimer(outputChatBox, 1000*seconds+1000, 1, text, v, 255, 255, 255)
        	elseif isTimer(countdownTimers[v]) then
        		exports.GTWtopbar:dm("A timer is already counting down in this area, please wait!", plr, 255, 0, 0)
        	end
    	end
	else
		outputChatBox("Correct syntax: /countdown <seconds> <text>", plr, 255, 255, 255)
	end
end
addCommandHandler("countdown", showCountDown)

function countDownTimerCount(owner, timeInSeconds)
	local i1,i2,i3 = getTimerDetails(countdownTimers[owner])
    outputChatBox("#66FF00[Countdown] #FFFFFF"..i2, owner, 255, 255, 255, true)
end

function printIp(thePlayer)
	outputChatBox("IP: " .. getPlayerIP(thePlayer), thePlayer)
end
addCommandHandler("myip", printIp)

--[[ Commands to transfer money between players ]]--
function sendMoneyToPlayer(player, cmd, receiver, amount)
	local money = tonumber(amount) or 0
	if receiver and money and money > 0 and getPlayerMoney(player) >= money and getPlayerTeam(player) then
		local playerReceiver = getPlayerFromName(receiver)
		if playerReceiver then
			takePlayerMoney(player, money)
			givePlayerMoney(playerReceiver, money)
			exports.GTWtopbar:dm(money.."$ sent to "..receiver, player, 0, 255, 0)
			exports.GTWtopbar:dm(money.."$ received from: "..getPlayerName(player), playerReceiver, 0, 255, 0)
			outputServerLog("[BANK] $"..money.." sent to: "..receiver..", from: "..getPlayerName(player).." ("..getTeamName(getPlayerTeam(player))..")")
		else
			exports.GTWtopbar:dm("Player does not exist", player, 255, 0, 0)
		end
	elseif money < 0 then
		exports.GTWtopbar:dm("Negative amounts are not allowed", player, 255, 0, 0)
	elseif not getPlayerTeam(player) then
		exports.GTWtopbar:dm("You must be in a team in order to send money, please reconnect if youre not!", player, 255, 0, 0)
	else
		exports.GTWtopbar:dm("Correct syntax: /give <player-nick> <amount>", player, 255, 255, 255)
	end
end
addCommandHandler("give", sendMoneyToPlayer)

--[[ Global Help system ]]--
function infoBar(thePlayer)
	if isElement(thePlayer) then
		local randNum = math.random(1,24)
		if randNum == 1 then
			topMessage("[Guide] Hit F1 for more info about how to play", thePlayer, 255, 255, 255)
		elseif randNum == 2 then
			topMessage("(Guide) Are you looking for music? Press B to open your phone", thePlayer, 255, 255, 255)
		elseif randNum == 3 then
			topMessage("(Guide) More games are available at: www.404rq.com/servers/", thePlayer, 255, 255, 255)
		elseif randNum == 4 then
			topMessage("(Guide) Improve your stats for more profit in civilian jobs, hit F3 for more info", thePlayer, 255, 255, 255)
		elseif randNum == 5 then
			topMessage("(Guide) Hit F5 to manage your occupation or to become a criminal", thePlayer, 255, 255, 255)
		elseif randNum == 6 then
			topMessage("(Guide) Need transport? Travel quickly using the orange transport markers", thePlayer, 255, 255, 255)
		elseif randNum == 7 then
			topMessage("(Guide) Stay away from law units to reduce your wanted level, or use /fine", thePlayer, 255, 255, 255)
		elseif randNum == 8 then
			topMessage("(Guide) Protect your money by put them in the bank", thePlayer, 255, 255, 255)
		elseif randNum == 9 then
			topMessage("(Guide) Invest in a business to gain money fast, whenever you can afford it", thePlayer, 255, 255, 255)
		elseif randNum == 10 then
			topMessage("(Guide) Hit F6 to create or join a group, gang or clan", thePlayer, 255, 255, 255)
		elseif randNum == 11 then
			topMessage("(Guide) Hit F2 to manage your vehicles, if you don't want to rent", thePlayer, 255, 255, 255)
		elseif randNum == 12 then
			topMessage("(Guide) Mystery bags contains secret advantages for criminals", thePlayer, 255, 255, 255)
		elseif randNum == 13 then
			topMessage("(Guide) Visit our forum at: forum.gtw-games.org to discuss anything you want", thePlayer, 255, 255, 255)
		elseif randNum == 14 then
			topMessage("(Guide) GTW-RPG is an open source project, read more at: github.com/404rq", thePlayer, 255, 255, 255)
		elseif randNum == 15 then
			topMessage("(Guide) Act and work realistic to earn more money and stats in civilian jobs", thePlayer, 255, 255, 255)
		elseif randNum == 16 then
			topMessage("(Guide) Use /updates to view the latest news", thePlayer, 255, 255, 255)
		elseif randNum == 17 then
			topMessage("(Guide) Got a suggestion or found a bug? visit: forum.404rq.com", thePlayer, 255, 255, 255)
		elseif randNum == 18 then
			topMessage("(Guide) Report annoying players or staff here: forum.404rq.com", thePlayer, 255, 255, 255)
		else
			topMessage("(Guide) Read more about GTW on our webpage: www.404rq.com", thePlayer, 255, 255, 255)
		end
	end
end

--[[ Trigger help messages ]]--
function playerLogin(_, playeraccount)
	setTimer(infoBar, 310000, 50, source)
end
addEventHandler("onPlayerLogin", root, playerLogin)

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
        	outputChatBox("Resource "..getResourceName(res).." v.3.0 r-"..version_r.." [#00cc00Started#ffffff]", v, 255, 255, 255, true)
        end
    end

    -- Increase GTW version
    local version = getAccountData(sAcc, "gtw-version") or 0
    setAccountData(sAcc, "gtw-version", version + 1)

    -- Increase resource version
    setResourceInfo(res, "version", tostring(version_r) )

    -- Display in server log if load successfull
    --outputServerLog("[GTW-RPG] "..getResourceName(res).." (v.2.4-beta r-"..(version_r)..") started successfully")
    setElementData(root, "gtw-version", "GTW-RPG v3.0 r-"..tostring(version + 1).." | www.404rq.com | ")
end
addEventHandler("onResourceStart", root, displayLoadedRes)

function displayStoppedRes(res)
	for k,v in ipairs(getElementsByType("player")) do
        local pAcc = getPlayerAccount(v)
        if pAcc and (isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) or
        	isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Developer"))) then
        	outputChatBox("Resource " .. getResourceName(res) .. " [#cc0000Stopped#ffffff]", v, 255, 255, 255, true)
        end
    end
end
addEventHandler("onResourceStop", root, displayStoppedRes)

function getGTWVersion(plr)
    local version = getAccountData(sAcc, "gtw-version") or 0
    outputChatBox("Current GTW version: 3.0 r-"..version, plr, 255, 255, 255)
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
 	        local val = getAccountData(pAcc, key) or ""
 	        outputChatBox("KEY: "..key..", has VALUE: "..val, plr, 200,200,200)
        elseif cmd == "setdata" and key and value then
	        setAccountData(pAcc, key, value)
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
