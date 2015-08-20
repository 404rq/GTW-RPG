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

-- Setup data base
db_pc = dbConnect("sqlite", "bans.db")

-- Tables for quick access
police_chiefs_data 	= { }
banned_cops_data 	= { }

--[[ Create a database table to store bans data ]]--
addEventHandler("onResourceStart", resourceRoot,
function()
	dbExec(db_pc, "CREATE TABLE IF NOT EXISTS bans (ID INTEGER PRIMARY KEY, account TEXT)")
	dbExec(db_pc, "CREATE TABLE IF NOT EXISTS police_chiefs (ID INTEGER PRIMARY KEY, account TEXT)")

	-- Load database into tables
	dbQuery(load_banned_cops, db_pc, "SELECT account FROM bans ")
	dbQuery(load_police_chiefs, db_pc, "SELECT account FROM police_chiefs ")
end)

--[[ Load banned cops ]]--
function load_banned_cops(query)
	local result = dbPoll( query, 0 )
	if not result then return end
    for _,row in pairs( result ) do
    	banned_cops_data[row["account"]] = true
    end
end

--[[ Load police chiefs ]]--
function load_police_chiefs(query)
	local result = dbPoll( query, 0 )
	if not result then return end
	for _,row in pairs( result ) do
    	police_chiefs_data[row["account"]] = true
    end
end

--[[ Administrators and moderators can give a player police chief rights ]]--
function toggle_police_chief(admin, cmd, account_to_add_or_remove)
	-- Get the account of the administrator or moderator using this command
	local accName = getAccountName(getPlayerAccount(admin))

	-- Check if the command issuer has the rights
	if not isObjectInACLGroup ("user."..accName, aclGetGroup ("Admin")) and
		not isObjectInACLGroup ("user."..accName, aclGetGroup ("Moderator")) then return end

	-- Check if there is an account provided
	if not account_to_add_or_remove then
		outputChatBox("Correct syntax: /addpc <accountName>", admin, 255, 0, 0)
		return
	end

	-- Check if the provided account exist
	local current_chief = getAccount(account_to_add_or_remove)
	if not current_chief then return end

	-- Check if we shall add or remove this player
	if cmd == "addpc" then
		-- Add police chief to database
		police_chiefs_data[account_to_add_or_remove] = true
     	dbExec(db_pc, "INSERT INTO police_chiefs VALUES (NULL,?)", account_to_add_or_remove)
		outputChatBox("Player: "..getPlayerName(current_chief).." was successfully added as police chief", admin, 0, 200, 0)
	else
		-- Remove police chief from database
		police_chiefs_data[account_to_add_or_remove] = false
		dbExec(db_pc, "DELETE FROM police_chiefs WHERE account=?", account_to_add_or_remove)
		outputChatBox("Player: "..getPlayerName(current_chief).." was removed from police chief", admin, 255, 200, 0)
	end
end
addCommandHandler("addpc", toggle_police_chief)
addCommandHandler("removepc", toggle_police_chief)

--[[ Police chiefs can ban from law at unlimited time ]]--
function add_law_ban(police_chief, cmd, bad_officer)
	-- Check if an officer to kick was provided
	if not bad_officer then
		outputChatBox("Correct syntax: /lawban <account>", police_chief, 255, 0, 0)
		return
	end

	-- Check if the provided cop account exist
	local cop_to_ban = getAccount(bad_officer)
	local cop_to_ban_plr = getAccountPlayer(cop_to_ban)
	if not cop_to_ban then
		outputChatBox("Correct syntax: /lawban <account>", police_chief, 255, 0, 0)
		return
	end

	-- Notify the cop if online
	if cop_to_ban_plr then
		exports.GTWtopbar:dm("You have been kicked from the force by: "..getPlayerName(police_chief), cop_to_ban_plr, 255, 0, 0)

		-- Reset job and team if online
		setPlayerTeam(cop_to_ban_plr, getTeamFromName("Unemployed"))
		setPlayerNametagColor(cop_to_ban_plr, 255, 255, 0)
		setElementData(cop_to_ban_plr, "admin",false)
		local skinID = exports.GTWclothes:getBoughtSkin(cop_to_ban_plr)
        setElementModel(cop_to_ban_plr, skinID)
     	setElementData(cop_to_ban_plr, "Occupation", "")
	end

	-- Notify the police chief issuing the command
	outputChatBox("Police: "..bad_officer.." was kicked from the police job", police_chief, 255, 100, 0)

	-- Save ban to database
    dbExec(db_pc, "INSERT INTO bans VALUES (NULL,?)", bad_officer)
    banned_cops_data[bad_officer] = true
end
addCommandHandler("banfromlaw", add_law_ban)
addCommandHandler("lawban", add_law_ban)

--[[ Police chiefs can revoke law bans ]]--
function revoke_law_ban(police_chief, cmd, bad_officer)
	-- Check if an officer to kick was provided
	if not bad_officer then
		outputChatBox("Correct syntax: /revokelawban <account>", police_chief, 255, 0, 0)
		return
	end

	-- Check if the provided cop account exist
	local cop_to_ban = getAccount(bad_officer)
	local cop_to_ban_plr = getAccountPlayer(cop_to_ban)
	if not cop_to_ban then
		outputChatBox("Correct syntax: /revokelawban <account>", police_chief, 255, 0, 0)
		return
	end

	-- Notify the cop if online
	if cop_to_ban_plr then
		exports.GTWtopbar:dm("You are now allowed to work as a cop again, (thanks to: "..getPlayerName(police_chief)..")", cop_to_ban_plr, 0, 255, 0)
	end

	-- Notify the police chief issuing the command
	outputChatBox("Police: "..bad_officer.." is now allowed to work again", police_chief, 255, 100, 0)

	-- Remove ban from database
    dbExec(db_pc, "DELETE FROM bans WHERE account=?", bad_officer)
    banned_cops_data[bad_officer] = false
end
addCommandHandler("revokebanfromlaw", revoke_law_ban)
addCommandHandler("revokelawban", revoke_law_ban)

--[[ List banned cops ]]--
function list_banned_cops(plr)
	local list = ""
    for k,v in pairs(banned_cops_data) do
    	local name = nil
    	if getAccountPlayer(getAccount(k)) then
    		name = getPlayerName(getAccountPlayer(getAccount(k)))
    		if name then k = k.." ("..name..")" end
    	end
    	list = list..k..", "
    end
    outputChatBox("Lawbans: "..list, plr, 200, 200, 200)
end
addCommandHandler("listlawbans", list_banned_cops)
addCommandHandler("listlawban", list_banned_cops)

--[[ List police chiefs ]]--
function list_police_chiefs(plr)
    local list = ""
    for k,v in pairs(police_chiefs_data) do
    	local name = nil
    	if getAccountPlayer(getAccount(k)) then
    		name = getPlayerName(getAccountPlayer(getAccount(k)))
    		if name then k = k.." ("..name..")" end
    	end
    	list = list..k..", "
    end
    outputChatBox("Police chiefs: "..list, plr, 200, 200, 200)
end
addCommandHandler("listpolicechiefs", list_police_chiefs)
addCommandHandler("listpolicechief", list_police_chiefs)

--[[ Exported: check if a player is a police chief ]]--
function isPoliceChief(plr)
	if not plr or not getPlayerAccount(plr) or not getAccountName(getPlayerAccount(plr)) then return false end
	return police_chiefs_data[getAccountName(getPlayerAccount(plr))] or false
end

--[[ Exported: check if a player is a banned from law ]]--
function isLawBanned(plr)
	if not plr or not getPlayerAccount(plr) or not getAccountName(getPlayerAccount(plr)) then return false end
	return banned_cops_data[getAccountName(getPlayerAccount(plr))] or false
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
