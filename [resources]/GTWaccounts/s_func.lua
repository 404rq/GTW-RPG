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

-- Attempts cache
login_cache = {}

--[[ On client login request attempt ]]--
function client_login_attempt(user, pass)
	-- Player is already logged in
	if not getPlayerAccount(client) or not isGuestAccount(getPlayerAccount(client)) then
		triggerClientEvent(source, "GTWaccounts:onClientPlayerLogin", client, getAccountName(getPlayerAccount(client)))
		return
	end

	-- Get any account with the provided name "user"
	local acc = getAccount(user)

	-- Does the account exist?
	if not acc then
		return display_status("Account name was not found Press 'Register'\n"..
			"to create a new account with the current\n"..
			"provided credentials", client, 0)
	end

	-- Yes it does exist, let's try to login with the given password "pass"
	if not logIn(client, acc, pass) then
		return display_status("Incorrect password for this account.", client, -1)
	end

	-- Tell the client that the login was successfull
	triggerClientEvent(source, "GTWaccounts:onClientPlayerLogin", client, user)
end
addEvent("GTWaccounts:attemptClientLogin", true)
addEventHandler("GTWaccounts:attemptClientLogin", root, client_login_attempt)

--[[ Kick after 3 failed login attempts ]]--
function kick_after_three_fails()
	-- Inform the player about how to signup
	exports.GTWtopbar:dm("To register a new account: enter credentials in the fields, then click 'Register'", client, 255, 255, 255)

	-- Ignore for now, a client cooldown timer prevent spam of login
	--kickPlayer(client, "Calm down and read the status message before going insane!")
end
addEvent("GTWaccounts:kickClientSpammer", true)
addEventHandler("GTWaccounts:kickClientSpammer", root, kick_after_three_fails)

--[[ On client registration attempt ]]--
function client_registration_attempt(user, pass, facc)
	-- Check if any username or password where provided at all
	if not user or not pass then
		display_status("Expected username and password!", client, 0)
		return
	end

	-- Check how many account that has been registred from this PC
	local serial = getPlayerSerial(client)
	local accounts = getAccountsBySerial(serial)
	if #accounts > 9 then
		return display_status("Too many accounts has already been registred on "..
			"\nthis PC! Contact an admin for further assistance.", client, -1)
	end

	-- Save current
	local old_usr = user

	-- Validate input
	local char = "[^0-9a-zA-Z_]"
	user = string.gsub(user, char, "")

	-- This account name has already been used (converted names are validated too)
	local acn = getAccount(user)
	if acn then
		return display_status("Account name is already in use, \nplease try another one.", client, -1)
	end

	-- Invalid symbold where used, tell the user how a proper account name are written
	if old_usr ~= user then
		return display_status("Invalid user name, you may only use \nthe following symbols: 0-9, a-z, A-Z or _", client, -1)
	end

	-- Check if there's a friend provided
	local friend = getAccount(facc)
	acn = addAccount(user, pass)

	-- Shit, something went wrong, unable to add the account, check the
	-- servers error log for further information
	if not acn then
		display_status("Failed to add account. \nThere may already exist an account with another \ncase variation of the name you provided!", client, -1)
		return
	end

	-- Alright we're in, now let's see if this guy has a friend or not
	display_status("You have registered! \nYou can now login.", source, 1)

	-- Check the friend so that it really is a friend and not some kind of troll
	if not friend or acn == friend or getAccountData(acn, "GTWaccounts.invite.acc") or
		getAccountData(friend, "GTWaccounts.invite.serial") == getPlayerSerial(client) or
		getAccountData(friend, "GTWaccounts.invite.ip") == getPlayerIP(client) then
		if facc ~= "" then
			exports.GTWtopbar:dm("A welcome bonus has already been sent to this player", client, 255,100,0)
		end
		return
	end

	-- Looks like this member has a friend on the server, let's find out
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
		setAccountData(friend, "GTWdata.money", (getAccountData(friend, "GTWdata.money") or 0) + 4000)
		setAccountData(acn, "GTWaccounts.invite.acc", facc)

		-- Friend has received money from ip and serial ...
		if friend then
			setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(client))
			setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(client))
		end
	end
end
addEvent("GTWaccounts:onClientAttemptRegistration", true)
addEventHandler("GTWaccounts:onClientAttemptRegistration", root, client_registration_attempt)

--[[ Didn't knew about this feature? don't worry, you can still give your friend his invite bonus ]]--
function send_invite_bonus(thePlayer, cmd, facc)
	-- Is there a friend provided?
	local friend = getAccount(facc)
	if not friend or not facc then
		outputChatBox("Correct syntax: /sendinvitebonus <friends_account_name>", thePlayer, 255, 255, 255)
		return
	end

	-- Alright, we're good. Let's send the bonus
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
			setAccountData(friend, "GTWdata.money", (getAccountData(friend, "GTWdata.money") or 0) + 4000)
			setAccountData(acn, "GTWaccounts.invite.acc", facc)

			-- Friend has received money from ip and serial ...
			setAccountData(friend, "GTWaccounts.invite.serial", getPlayerSerial(thePlayer))
			setAccountData(friend, "GTWaccounts.invite.ip", getPlayerIP(thePlayer))
		end
	else
		exports.GTWtopbar:dm("Welcome bonus has already been sent to this player", thePlayer, 255, 100, 0)
	end
end
addCommandHandler("sendinvitebonus", send_invite_bonus)

-- Send status message to clients, code -1 = red, 0 = yellow, 1 = green
function display_status(msg, p, statusCode)
	return triggerClientEvent(p, "GTWaccounts:onStatusReceive", p, msg, statusCode)
end

-- Set player unique ID on login
addEventHandler("onPlayerJoin", resourceRoot,
	function ()
		setElementData(source, "ID", tostring(getPlayerId(source)))
	end
)

-- Give all players their unique ID once resource is restarted
addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, v in pairs(getElementsByType("player")) do
			setElementData(v, "ID", tostring(i))
		end
	end
)

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
	function (_, acc)
		fadeCamera(source, true, 5)
		setCameraTarget(source, source)

		-- Get position
		local posX = getAccountData(acc, "GTWdata.loc.x")
		local posY = getAccountData(acc, "GTWdata.loc.y")
		local posZ = getAccountData(acc, "GTWdata.loc.z")
		local rotZ = getAccountData(acc, "GTWdata.loc.rot.z")

		-- Set a value indicating this is the first spawn to
	        -- ensure player data is loaded as soon the player spawns
	        setElementData(source, "GTWdata.isFirstSpawn", true)

		-- Get player location x y z
	    	if (posX and posY and posZ) then
		 	spawnPlayer(source, posX, posY, posZ, rotZ, getElementModel(source), getElementInterior(source), getElementDimension(source), getPlayerTeam(source))
			setCameraTarget(source, source)

			-- Temporary (from 2015-07-01) restore health and armor
			--local health = getAccountData(playeraccount, "GTWdata.health")
			--local armor = getAccountData(playeraccount, "GTWdata.armor")
	        	--setPedArmor(source, armor)
			--setElementHealth(source, health)
		else
			local x,y,z,r = unpack(spawn_loc[math.random(#spawn_loc)])
			spawnPlayer(source, x, y, z+3, r, skin_id[math.random(#skin_id)], 0, 0, getTeamFromName("Unemployed"))
			setElementFrozen(source, true)
			setTimer(setElementFrozen, 1000, 1, source, false)
	    	end
	end
)

--[[ Show downloading information ]]--
addEventHandler("onPlayerJoin", root,
	function ()
		s_display[source] = {}
		s_text[source] = {}

		s_text[source][1] = textCreateTextItem("Welcome to RageQuit community!", 0.5, 0.5,1,200,200,200,255,2.2,"center","center",200)
		s_text[source][2] = textCreateTextItem("#  www.404rq.com | forum.404rq.com | code.404rq.com | media.404rq.com  #", 0.5, 0.91,1,200,200,200,255,1.4,"center","center",200)
		s_text[source][3] = textCreateTextItem("Please wait while we're downloading the GTW-RPG v3.0 game mode for you...", 0.5, 0.1,1,200,200,200,255,1.4,"center","center",200)

		for w=1, #s_text[source] do
		   	s_display[source][w] = textCreateDisplay()
			textDisplayAddObserver(s_display[source][w], source)
			textDisplayAddText(s_display[source][w], s_text[source][w])
		end
	end
)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

addEvent("GTWaccounts.onClientSend",true)
addEventHandler("GTWaccounts.onClientSend", root,
	function ()
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

			-- Save view coordinates
			setElementData(client, "GTWaccounts.login.coordinates.x", x)
			setElementData(client, "GTWaccounts.login.coordinates.y", y)
			setElementData(client, "GTWaccounts.login.coordinates.z", z)
			setElementData(client, "GTWaccounts.login.coordinates.x2", x2)
			setElementData(client, "GTWaccounts.login.coordinates.y2", y2)
			setElementData(client, "GTWaccounts.login.coordinates.z2", z2)

			-- Ability for clients to see if a player is logged in or not
			setElementData(client, "isLoggedIn", true)
		end
	end
)
