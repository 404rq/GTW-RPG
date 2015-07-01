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
		-- Save current
		local old_usr = user
		
		-- Validate input
		local char = "[^0-9a-zA-Z_]"
		user = string.gsub(user, char, "")
		
		local acn = getAccount(user)
		if acn then
			return doStatus("This account already exists\non the server.", client, -1)
		end
		if old_usr ~= user then
			return doStatus("Invalid user name, you may only use \nthe following symbols: 0-9, a-z, A-Z or _", client, -1)
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
	for i, v in pairs(getElementsByType("player")) do
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
function(_, playeraccount)
    fadeCamera(source, true, 5)
	setCameraTarget(source, source)
	
	-- Get position
	local posX = getAccountData(playeraccount, "acorp.loc.x")
    local posY = getAccountData(playeraccount, "acorp.loc.y")
    local posZ = getAccountData(playeraccount, "acorp.loc.z") 
    local rotZ = getAccountData(playeraccount, "acorp.loc.rot.z")
	
	-- Get player location x y z
    if (posX and posY and posZ) then
       	spawnPlayer(source, posX, posY, posZ, rotZ, getElementModel(source), getElementInterior(source), getElementDimension(source), getPlayerTeam(source))
		setCameraTarget(source, source)
		
		-- Temporary (from 2015-07-01) restore health and armor
		local health = getAccountData(playeraccount, "acorp.health")
        local armor = getAccountData(playeraccount, "acorp.armor")
        setPedArmor(source, armor) 
        setElementHealth(source, health) 
	else
		local x,y,z,r = unpack(spawn_loc[math.random(#spawn_loc)])
		spawnPlayer(source, x, y, z+3, r, skin_id[math.random(#skin_id)], 0, 0, getTeamFromName("Unemployed"))
		setElementFrozen(source, true)
		setTimer(setElementFrozen, 1000, 1, source, false)
    end
end)

--[[ Show downloading information ]]--
addEventHandler("onPlayerJoin", root, function()
    s_display[source] = {}
    s_text[source] = {}
    
    s_text[source][1] = textCreateTextItem("Downloading resources, please wait...", 0.5, 0.5,1,200,200,200,255,2.2,"center","center",200) 
	s_text[source][2] = textCreateTextItem("#  www.gtw-games.org  #", 0.5, 0.91,1,200,200,200,255,1.4,"center","center",200) 
	s_text[source][3] = textCreateTextItem("Grand Theft Walrus # Real life/RPG", 0.5, 0.1,1,200,200,200,255,1.4,"center","center",200) 
	
    for w=1, #s_text[source] do
    	s_display[source][w] = textCreateDisplay()
		textDisplayAddObserver(s_display[source][w], source)
		textDisplayAddText(s_display[source][w], s_text[source][w]) 
	end
end)

addEvent("GTWaccounts.onClientSend",true)
addEventHandler("GTWaccounts.onClientSend",root,
function()
	if isGuestAccount(getPlayerAccount(client)) then
		-- Clear text from screen
		if s_display[client] then
			for k=1, #s_display[client] do
				textDisplayRemoveObserver(s_display[client][k], client)
			   	s_display[client][k] = nil
			   	s_text[client][k] = nil
			end 
		end
		
		-- Setup a default view
		local x,y,z,x2,y2,z2 = unpack(s_views[math.random(#s_views)])
		setCameraMatrix( client, x,y,z, x2,y2,z2, 2 )
		fadeCamera(client, true, 1)
		
		-- Ability fopr clients to see if a player is logged in or not
		setElementData(client, "isLoggedIn", true)
	end
end)