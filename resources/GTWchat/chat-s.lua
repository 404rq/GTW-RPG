--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.5]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.5
	Status:			Stable release
********************************************************************************
]]--

-- Keep track of spam and vandalism
local last_msg 			= {{ }}
local cooldownTimers 	= { }

-- Global settings
local characteraddition = 100
local antiSpamTime 		= 1000
local maxbubbles 		= 4
local chat_range 		= 180
local showtime 			= 7500
local hideown 			= true
local defR,defG,defB	= 240,235,255

-- Change only if you have the IRC module and renamed the irc resource
local nameOfIRCResource	= "irc"

-- Define law 
local lawTeams = {
	["Government"] = true,
	["Emergency service"] = true,
}
local policeTeams = {
	["Government"] = true, 
}

--[[ Compatibility with other servers, deal with export calls here ]]--
function dm(plr, msg, r, g, b, col)
	-- Replaces outputChatBox with identical syntax
	exports.GTWtopbar:dm(plr, msg, r, g, b, col)
	
	-- If you don't have GTWtopbar, uncommend this instead
	--outputChatBox(plr, msg, r, g, b, col)
end
function getGroupChatColor(group)
	-- Call whatever group system you use and ask for a 
	-- group as a string to receive it's chat color as RGB
	local r,g,b = exports.GTWgroupsys:getGroupChatColor(group)
	if not r or not g or not b then
		r,g,b = defR,defG,defB
	end
	return r,g,b
end

--[[ Clear anti spam cache on quit ]]--
function cleanUpChat(quitType)
	last_msg[source] = nil
	cooldownTimers[source] = nil
end
addEventHandler("onPlayerQuit", root, cleanUpChat)

--[[ Bind local chat on join ]]--
function bindLocalChat()
	bindKey(source, "u", "down", "chatbox", "Local")
	last_msg[source] = { }
end
addEventHandler("onPlayerJoin", root, bindLocalChat)

--[[ Check if a player should hear another player in local ]]--
function isPlayerInRangeOfPoint(player,x,y,z,range)
   local px,py,pz = getElementPosition(player)
   return((x-px)^2+(y-py)^2+(z-pz)^2)^0.5<=range
end

--[[ Initialize chat, bind local chat to all players ]]--
function initChat()
	for i,v in pairs(getElementsByType("player")) do
		bindKey(v, "u", "down", "chatbox", "Local")
		last_msg[v] = { }
	end
end
addEventHandler("onResourceStart", resourceRoot, initChat)

--[[ Securely check if a player is in the staff team ]]--
function isServerStaff(plr)
	-- Check if the player exist and are logged in properly
	if not plr then return false end
	if not getPlayerAccount(plr) then return false end
	
	-- Check if the player is in any of the staff ACL groups
	local acc = getAccountName(getPlayerAccount(plr))
	if isObjectInACLGroup("user."..acc, aclGetGroup("Admin")) or
		isObjectInACLGroup("user."..acc, aclGetGroup("Developer")) or 
		isObjectInACLGroup("user."..acc, aclGetGroup("Moderator")) or
		isObjectInACLGroup("user."..acc, aclGetGroup("Supporter")) then
		return true
	else
		return false
	end
end

--[[ Handle spam and mutes, returns true if passed, false if failed ]]--
function validateChatInput(plr, chatID, text)
	if isPlayerMuted(plr) then 
		dm("You are muted, visit games.albonius.com if you wish to appeal your mute", plr, 255, 100, 0) 
		return false 
	end
	if isTimer(cooldownTimers[plr]) then 
		dm("Do not spam the chat!", plr, 255, 100, 0) 
		return false 
	end
	if last_msg[plr][chatID] and last_msg[plr][chatID] == text then
		dm("Do not repeat yourself!", plr, 255, 100, 0)
		return false
	end
	-- Special case for car chat
	if chatID == "car" and not getPedOccupiedVehicle(plr) then 
		dm("Car chat can only be used inside vehicles!", plr, 255, 100, 0) 
		return false
	end
	-- Special case for law chat
	if chatID == "law" and getPlayerTeam(plr) and not lawTeams[getTeamName(getPlayerTeam(plr))] then 
		dm("You are not a law enforcer!", plr, 255, 100, 0)
		return false
	end
	if chatID == "law" and not getPlayerTeam(plr) then 
		dm("You are not in a team!", plr, 255, 100, 0)
		return false
	end
	-- Special case for group chat
	if chatID == "group" and not getElementData(plr, "Group") then
		dm("You are not in a group! Hit F6 to create or join a group", plr, 255, 100, 0)
		return false
	end
	return true
end

--[[ Handle incoming IRC messages ]]--
function IRCMessageReceive(channel, message)
	-- Verify that the resource is running, added support for custom names 2014-11-14
	local res = getResourceFromName(nameOfIRCResource)
	if getResourceState(res) ~= "running" then return end
	if string.match(message, '%d%d*') then return end
	local nick = exports[nameOfIRCResource]:ircGetUserNick(source)
	outputChatBox("#444444[IRC] #CCCCCC"..nick..":#FFFFFF "..message, root, 255, 255, 255, true)
	outputServerLog("[IRC] "..nick..": "..message)
end
addEvent("onIRCMessage")
addEventHandler("onIRCMessage", root, IRCMessageReceive)

--[[ Local chat ]]--
function useLocalChat(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "local", msg) then return end
  	local px,py,pz = getElementPosition(plr)
	local nick = getPlayerName(plr)
	local r,g,b = 255,255,0
	if not getElementData(plr, "anon") then
	    displayChatBubble("(LOCAL): "..firstToUpper(msg), 0, plr)
	end
  	if getPlayerTeam(plr) then
		if getTeamColor(getPlayerTeam(plr)) then
		 	r,g,b = getTeamColor(getPlayerTeam(plr))
		end
	end
	-- (2014-11-19) Count local players
	local sumOfLocal = 0
	for n,v in ipairs(getElementsByType("player")) do
	   	if isPlayerInRangeOfPoint(v, px,py,pz, chat_range) then
	   		sumOfLocal = sumOfLocal + 1
	  	end
	end
	for n,v in ipairs(getElementsByType("player")) do
	   	if isPlayerInRangeOfPoint(v, px,py,pz, chat_range) then
	   		local occupation = ""
	   		if getElementData(plr, "isPoliceChief") and getPlayerTeam(plr) and policeTeams[getTeamName(getPlayerTeam(plr))] then
	   			occupation = RGBToHex(defR, defG, defB).."[PoliceChief]"..RGBToHex(r,g,b)
	   		end
	   		local outText = RGBToHex(r,g,b).."(LOCAL) "..occupation.."["..tostring(sumOfLocal).."] "..RGBToHex(r,g,b)..nick..": "..RGBToHex(defR,defG,defB)
			local length = string.len(outText..firstToUpper(msg))
			if length < 128 then
	   			outputChatBox(outText..firstToUpper(msg), v, r,g,b, true)
	   		else
	   			outputChatBox(outText, v, r,g,b, true)
	   			outputChatBox(RGBToHex(defR, defG, defB)..firstToUpper(msg), v, r,g,b, true)
	   		end
	  	end
	end
		
	-- Prevent spam and log the chat
	last_msg[plr]["local"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
  	outputServerLog("[LOCAL] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("LocalChat", useLocalChat)
addCommandHandler("localchat", useLocalChat)
addCommandHandler("Local", useLocalChat)
addCommandHandler("local", useLocalChat)
addCommandHandler("lc", useLocalChat)

--[[ Car and vehicle chat]]--
function useCarChat(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "car", msg) then return end	
	local r,g,b = defR,defG,defB
	if getPlayerTeam(plr) then
		r,g,b = getTeamColor(getPlayerTeam(plr))
	end
	local veh = getPedOccupiedVehicle(plr)
	local nick = getPlayerName(plr)	
	for n,v in pairs(getVehicleOccupants(veh)) do
		local outText = "(CC) ["..tostring(n).."] "..nick..": "..RGBToHex(defR,defG,defB)
		local length = string.len(outText..firstToUpper(msg))
		if length < 128 then
			outputChatBox(outText..firstToUpper(msg),v,200,0,200,true)
		else
			outputChatBox(outText,v,200,0,200,true)
			outputChatBox(firstToUpper(msg),v,200,0,200,true)
		end
	end
		
	-- Prevent spam and log the chat
	last_msg[plr]["car"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[Car] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("carchat", useCarChat)
addCommandHandler("car", useCarChat)
addCommandHandler("cc", useCarChat)

--[[ Law and emergency chat ]]--
function useEmergencyChat(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "law", msg) then return end
	local r,g,b = getTeamColor(getPlayerTeam(plr))
	local nick = getPlayerName(plr)	
	local occupation = ""
   	if getElementData(plr, "isPoliceChief") and policeTeams[getTeamName(getPlayerTeam(plr))] then
   		occupation = RGBToHex(defR,defG,defB).."[PoliceChief]"..RGBToHex(r,g,b)
   	end
	for m,v in pairs(getElementsByType("player")) do
		if lawTeams[getTeamName(getPlayerTeam(v))] then
    		local outText = RGBToHex(r,g,b).."(E)("..getTeamName(getPlayerTeam(plr))..")"..occupation.." "..nick..": "
			local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg))
			if length < 128 then
	   			outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	   		else
	   			outputChatBox(outText, v, r,g,b,true)
	   			outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	   		end
	   	end
  	end	
  	
  	-- Prevent spam and log the chat
	last_msg[plr]["law"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[EMT] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("lawchat", useEmergencyChat)
addCommandHandler("law", useEmergencyChat)
addCommandHandler("e", useEmergencyChat)

--[[ Group chat, (only appliable on servers running a group system) ]]--
function useGroupChat(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "group", msg) then return end	
	local r,g,b = getGroupChatColor(getElementData(plr, "Group")) or defR,defG,defB
	local nick = getPlayerName(plr)
	for n,v in pairs(getElementsByType("player")) do
		if getElementData(plr, "Group") == getElementData(v, "Group") then
	    		local outText = RGBToHex(r, g, b).."(GROUP) ["..getElementData(plr, "Group").."] "..nick..": "
			local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg))
			if length < 128 then
	   			outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	  		else
	   			outputChatBox(outText, v, r,g,b, true)
	   			outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	   		end
    	end
  	end
  		
  	-- Prevent spam and log the chat
	last_msg[plr]["group"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[GROUP]["..getElementData(plr, "Group").."] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("group", useGroupChat)
addCommandHandler("gc", useGroupChat)

--[[ Staff chat, private chat for members of the staff team ]]--
function useStaffChat(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "mod", msg) then return end	
	if not isServerStaff(plr) then return end
	local r,g,b = defR,defG,defB
	if getPlayerTeam(plr) then
		r,g,b = getTeamColor(getPlayerTeam(plr))
	end
	local nick = getPlayerName(plr)
	for n,v in pairs(getElementsByType("player")) do
		if isServerStaff(v) then
	    	local outText = RGBToHex(255, 255, 255).."(STAFF) "..RGBToHex(r, g, b)..nick..": "
			local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg))
			if length < 128 then
	   			outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	  		else
	   			outputChatBox(outText, v, r,g,b, true)
	   			outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	   		end
    	end
  	end
  		
  	-- Prevent spam and log the chat
	last_msg[plr]["mod"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[STAFF] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("staff", useStaffChat)
addCommandHandler("mod", useStaffChat)

--[[ Staff chat, to reply to a certain team ]]--
function useStaffTeamChat(plr, n, team, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "mod-team", msg) then return end	
	if not isServerStaff(plr) then return end
	local r,g,b = defR,defG,defB
	if team and getTeamFromName(team) then
		r,g,b = getTeamColor(getTeamFromName(team))
	end
	local nick = getPlayerName(plr)
	for n,v in pairs(getElementsByType("player")) do
		if team and getTeamFromName(team) and ((getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName(team)) or (v == plr)) then
	    	local outText = RGBToHex(255, 255, 255).."(STAFF-T) "..RGBToHex(r, g, b)..nick..": "
			local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg))
			if length < 128 then
	   			outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	  		else
	   			outputChatBox(outText, v, r,g,b, true)
	   			outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(msg), v, r,g,b, true)
	   		end
    	end
  	end
  		
  	-- Prevent spam and log the chat
	last_msg[plr]["mod-team"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[STAFF-T] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("cteam", useStaffTeamChat)

--[[ Roleplay action chat, "/do <action>" ]]--
function useActionChatDo(plr, n, ...)
	local msg = table.concat({...}, " ")
	if not validateChatInput(plr, "do", msg) then return end
	local nick = getPlayerName(plr)
	outputChatBox("* "..firstToUpper(msg).." ("..nick..")", root, 255, 0, 255)
	   	
	-- Prevent spam and log the chat
	last_msg[plr]["do"] = msg
	cooldownTimers[plr] = setTimer(function() end, antiSpamTime, 1)
	outputServerLog("[*DO*] "..getPlayerName(plr)..": "..msg)
end
addCommandHandler("do", useActionChatDo)

--[[ Global chat, (Main, Team and Me) ]]--
function useGlobalChat(message, messageType)
	cancelEvent() -- Important, do not call return before cancelling the event!
	if messageType == 0 then
		if not validateChatInput(source, "main", message) then return end
	    local occupation = ""
	    local r,g,b = defR,defG,defB
	    if getPlayerTeam(source) then
	    	r,g,b = getTeamColor(getPlayerTeam(source))
	    end
	    if getElementData(source, "isPoliceChief") and getPlayerTeam(source) and policeTeams[getTeamName(getPlayerTeam(source))] then
	    	occupation = RGBToHex(defR,defG,defB).."[PoliceChief]"..RGBToHex(r,g,b)
	    end
		local px,py,pz = getElementPosition(source)
		local loc = getZoneName(px,py,pz)
		if not loc then
			loc = "Guest"
		end
		local outText = "("..loc..") "..occupation.." "..getPlayerName(source)..": "
		local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(message))
		if length < 128 then
		   	outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(message), root, r,g,b, true)
		else
		 	outputChatBox(outText, root, r,g,b, true)
		  	outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(message), root, r,g,b, true)
		end    
		outputServerLog("[CHAT] "..getPlayerName(source)..": "..message)
		if not getElementData(source, "anon") then
		   	displayChatBubble("(MAIN): "..firstToUpper(message), 2, source)
		end
				
		-- Prevent spam and log the chat
		last_msg[source]["main"] = message
		cooldownTimers[source] = setTimer(function() end, antiSpamTime, 1)
	elseif messageType == 1 then
		if not validateChatInput(source, "me", message) then return end
	  	local nick = getPlayerName(source)
		outputChatBox("* "..nick..": "..firstToUpper(message), root, 255, 0, 255)
		outputServerLog("[*ME*] "..getPlayerName(source)..": "..message)
		
		-- Prevent spam and log the chat
		last_msg[source]["me"] = message
		cooldownTimers[source] = setTimer(function() end, antiSpamTime, 1)
	elseif messageType == 2 then	    
		if not validateChatInput(source, "team", message) then return end
		local team = getPlayerTeam(source)
		if not team then return end
		local r,g,b = getTeamColor(getPlayerTeam(source))
		local occupation = ""
		if getElementData(source, "isPoliceChief") and policeTeams[getTeamName(getPlayerTeam(source))] then
			occupation = RGBToHex(defR,defG,defB).."[PoliceChief]"..RGBToHex(r,g,b)
		end		
		outputServerLog("[TEAM]["..getTeamName(getPlayerTeam(source)).."] "..getPlayerName(source)..": "..message)
		if not getElementData(source, "anon") then
		  	displayChatBubble("(TEAM): "..firstToUpper(message), 2, source)
		end
		for i, v in pairs(getElementsByType("player")) do
		    if getPlayerTeam(v) and (team == getPlayerTeam(v) or isServerStaff(v)) then
		    	-- Team chat is visible to team members and server staff
	     		if isServerStaff(v) and team ~= getPlayerTeam(v) then
	     			occupation = "["..getTeamName(team).."] "..occupation
	     		end
				local outText = "(TEAM) "..occupation.." "..getPlayerName(source)..": "
				local length = string.len(outText..RGBToHex(defR,defG,defB)..firstToUpper(message))
				if length < 128 then
			    	outputChatBox(outText..RGBToHex(defR,defG,defB)..firstToUpper(message), v, r,g,b, true)
			    else
			    	outputChatBox(outText, v, r,g,b, true)
			    	outputChatBox(RGBToHex(defR,defG,defB)..firstToUpper(message), v, r,g,b, true)
			    end
			end
		end
				
		-- Prevent spam and log the chat
		last_msg[source]["team"] = message
		cooldownTimers[source] = setTimer(function() end, antiSpamTime, 1)
	end
end
addEventHandler("onPlayerChat", root, useGlobalChat)

--[[ Send chat message to clients to display a chat bubble ]]--
function displayChatBubble(message, messagetype, plr)
	if isPlayerMuted(plr) then return end
	if source then 
		triggerClientEvent("GTWchat.makeChatBubble", source, message, messagetype, plr)
	else 
		triggerClientEvent("GTWchat.makeChatBubble", plr, message, messagetype, plr) 
	end
end

--[[ Convert RGB color to hex color ]]--
function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or(alpha and(alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

--[[ Make first char in a string uppercase ]]--
function firstToUpper(str)
	if str and str:sub(1,4) ~= "http" and str:sub(1,4) ~= "www." then
    	return str:sub(1,1):upper()..str:sub(2)
    else
    	return str
    end
end

--[[ Show help and available commands ]]--
function displayHelp(plr)
	outputChatBox("#000000**************************************************", plr, 255, 255, 255, true)
	outputChatBox("#444444"..getResourceInfo(getThisResource(), "name").." #FFFFFF(#00AA00"..
		getResourceInfo(getThisResource(), "version").."#FFFFFF), available commands:", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /local		#FFFFFF Local chat (U key)", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /cc		#FFFFFF Car chat, visible to all in your vehicle", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /gc		#FFFFFF Group chat, visible to group members", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /e			#FFFFFF Emergency chat, visible to law units", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /me /do	#FFFFFF Basic roleplay", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - T and Y	#FFFFFF Main and team chat", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /staff 	#FFFFFF Staff chat", plr, 255, 255, 255, true)
	outputChatBox("#00AA00 - /cteam		#FFFFFF Staff chat to a specific team", plr, 255, 255, 255, true)
	outputChatBox("#000000**************************************************", plr, 255, 255, 255, true)
end
addCommandHandler("chathelp", displayHelp)

--[[ Get bubble settings from clients ]]--
function receiveSettings()
	local settings =
	{
		showtime,
		characteraddition,
		maxbubbles,
		hideown
	}
	triggerClientEvent(source,"GTWchat.returnSettings", root, settings)
end
addEvent("GTWchat.askForSettings",true)
addEventHandler("GTWchat.askForSettings", root, receiveSettings)