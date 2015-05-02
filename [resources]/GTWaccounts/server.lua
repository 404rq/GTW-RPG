--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.gtw-games.org/bug-reports/
	Suggestions:		http://forum.gtw-games.org/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

-- Attempts cache
login_cache = { }

-- On login request
addEvent("GTWaccounts:attemptClientLogin", true)
addEventHandler("GTWaccounts:attemptClientLogin", root, function(user, pass)
	if isGuestAccount(getPlayerAccount(source)) then
		local accnt = getAccount(user)
		if not accnt then
			return doStatus("This account doesn't exist\non the server.", source, 0)
		end		
		if not logIn(source, accnt, pass) then
			return doStatus("Incorrect password for\nthis account.", source, -1)
		end
		triggerClientEvent(source, "GTWaccounts:onClientPlayerLogin", source, user)
	else
		triggerClientEvent(source, "GTWaccounts:onClientPlayerLogin", source, getAccountName(getPlayerAccount(source)))
	end
end)

-- On register request
addEvent("GTWaccounts:onClientAttemptRegistration", true)
addEventHandler("GTWaccounts:onClientAttemptRegistration", root, function(user, pass, facc)
	if user and pass then
		local char = "[^0-9a-zA-Z_]"
		user = string.gsub(user, char, "")
		local acn = getAccount(user)
		if acn then
			return doStatus("This account already exists\non the server.", client, -1)
		end
		local friend = getAccount(facc)
		local acn = addAccount(user, pass)
		if acn then
			doStatus("You have registered! \nYou can now login.", source, 1)
			if friend and acn ~= friend and not getAccountData(acn, "GTWaccounts.invite.acc") and
				getAccountData(friend, "GTWaccounts.invite.serial") ~= getPlayerSerial(client) and
				getAccountData(friend, "GTWaccounts.invite.ip") ~= getPlayerIP(client) then
				local friendPlayer = getAccountPlayer(friend)
				if friendPlayer then
					givePlayerMoney(friendPlayer, 4000)
					outputChatBox("#66FF00[GTW]#FFFFFF Your friend just joined the server, here's your welcome bonus of 4'000$", friendPlayer, 255, 255, 255, true)
					setAccountData(acn, "GTWaccounts.invite.acc", facc)
					-- Friend has received money from ip and serial ...
					if friend then
						setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(client))
						setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(client))
					end
				else
					setAccountData(friend, "acorp.money", (getAccountData(friend, "acorp.money") or 0) + 4000)
					setAccountData(acn, "GTWaccounts.invite.acc", facc)
					-- Friend has received money from ip and serial ...
					if friend then
						setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(client))
						setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(client))
					end
				end
			else
				exports.GTWtopbar:dm("A welcome bonus has already been sent to this player", client, 255, 100, 0)
			end
		else
			doStatus("Failed to add account.", client, -1)
		end
	else
		doStatus("Expected username and password.", client, 0)
	end
end)

-- Manage the invite bonus
function sendInviteBonus(thePlayer, cmd, facc)
	local friend = getAccount(facc)
	if friend and facc then
		local acn = getPlayerAccount(thePlayer)
		if acn ~= friend and not getAccountData(acn, "GTWaccounts.invite.acc") and 
			getAccountData(friend, "GTWaccounts.invite.serial") ~= getPlayerSerial(thePlayer) and
			getAccountData(friend, "GTWaccounts.invite.ip") ~= getPlayerIP(thePlayer) then
			local friendPlayer = getAccountPlayer(friend)
			if friendPlayer then
				givePlayerMoney(friendPlayer, 4000)
				outputChatBox("#66FF00[GTW]#FFFFFF Your friend just joined the server, here's youre welcome bonus of 4'000$", friendPlayer, 255, 255, 255, true)
				setAccountData(acn, "GTWaccounts.invite.acc", facc)
				-- Friend has received money from ip and serial ...
				setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(thePlayer))
				setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(thePlayer))
			else
				setAccountData(friend, "acorp.money", (getAccountData(friend, "acorp.money") or 0) + 4000)
				setAccountData(acn, "GTWaccounts.invite.acc", facc)
				-- Friend has received money from ip and serial ...
				setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(thePlayer))
				setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(thePlayer))
			end
		else
			exports.GTWtopbar:dm("Welcome bonus has already been sent to this player", thePlayer, 255, 100, 0)
		end
	else
		outputChatBox("Correct syntax: /sendinvitebonus <friends_account_name>", thePlayer, 255, 255, 255)
	end
end
addCommandHandler("sendinvitebonus", sendInviteBonus)

-- Send status message to clients, code -1 = red, 0 = yellow, 1 = green
function doStatus(msg, p, statusCode)
	return triggerClientEvent(p, "GTWaccounts:onStatusReceive", p, msg, statusCode)
end

-- Set player unique ID on login
addEventHandler("onPlayerJoin", resourceRoot, function()
	setElementData(source, "ID", tostring(getPlayerId(source)))
end)

-- Give all players their unique ID once resource is restarted
addEventHandler("onResourceStart", resourceRoot, function()
	for i, v in ipairs(getElementsByType("player")) do
		setElementData(v, "ID", tostring(i))
	end
end)

-- Helper function to obtain a players IP
function getPlayerId(p)
	for i, v in pairs(getElementsByType("player")) do
		if p == v then
			return i
		end
	end
end

-- Fade camera and set the player as target on login
addEventHandler("onPlayerLogin", root,
function()
    fadeCamera(source, true, 5)
	setCameraTarget(source, source)
end)