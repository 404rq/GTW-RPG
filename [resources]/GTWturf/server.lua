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

-- GTWmoney max turf earnings: max $6000/hour for owned turfs, max $1000/captured turf (3 minutes to capture)

-- Resource loaded event handler
addEventHandler("onResourceStart", getResourceRootElement(),
function()
	dbExec(db, "CREATE TABLE IF NOT EXISTS turfs(X NUMERIC, Y NUMERIC, Z NUMERIC, sizeX NUMERIC, sizeY NUMERIC, red NUMERIC, green NUMERIC, blue NUMERIC, owner TEXT)")
	dbQuery(loadTurfs, db, "SELECT * FROM turfs")
end)

-- Pay all online players for their owned turfs
function payForTurfs()
	dbQuery(turfPayout, db, "SELECT * FROM turfs")
end
function turfPayout(query)
	local result = dbPoll(query, 0)
	local turfs_counter = { }
	if result then
    		for _, row in ipairs(result) do
    			if not turfs_counter[row["owner"]] then
    				turfs_counter[row["owner"]] = 0
    			end
            		turfs_counter[row["owner"]] = turfs_counter[row["owner"]] + ((row["sizeX"] * row["sizeY"])/1000)
    		end
	end
	for w,player in pairs(getElementsByType("player")) do
		if getElementData(player, "Group") and getElementData(player, "Group") ~= "None" then
			local members = getGroupMembers(player)
			local money = turfs_counter[getElementData(player,"Group")] or 0

			-- Notice about turf money
			if money > 0 then
				givePlayerMoney(player,money)
				exports.GTWtopbar:dm("You have received: "..tostring(math.floor(money)).."$ from your turfs!", player, 0, 255, 0)
			end
		end
	end
end
-- Fight to get money
setTimer(payForTurfs, payout_time_interval*1000, 0)

-- Gets all members in team
function getGroupMembers(player)
	local teamMembers = {}
	for w,gangmember in ipairs(getElementsByType("player")) do
		if isElement(player) then
			if getElementData(gangmember,"Group") == getElementData(player,"Group") then
				table.insert(teamMembers,gangmember)
			end
		end
	end
	return teamMembers
end

-- Group notice by player
function groupMessage(text,player,r,g,b)
	local gangmems = getGroupMembers(player)
	for w,mem in ipairs(gangmems) do
		if mem ~= player then
			exports.GTWtopbar:dm(text, mem, r, g, b)
		end
	end
end

-- Get the members in a specified group
function getMembersInGroup(group)
	local teamMembers = {}
	for w,gangmember in ipairs(getElementsByType("player")) do
		if getElementData(gangmember,"Group") == group then
			table.insert(teamMembers,gangmember)
		end
	end
	return teamMembers
end

-- Group notice by group
function groupMessageFromGroup(text,group,r,g,b)
	local gangmems = getMembersInGroup(group)
	for w,mem in ipairs(gangmems) do
		if mem ~= player then
			exports.GTWtopbar:dm(text, mem, r, g, b)
		end
	end
end

-- count the players in a given turf and compare their groups
function countPlayersInTurf(turf)
	local owner = getElementData(turf, "owner")
	local ownC,enemyC,enemyGC = 0,0,0
	for w,gangmember in ipairs(getElementsByType("player")) do
		local px,py,pz = getElementPosition(gangmember)
		if not getElementData(turf,"sizex") or not getElementData(turf,"sizey") or not
			getElementData(turf,"posx") or not getElementData(turf,"posy") then return end
		local posX = getElementData(turf,"posx")
		local posY = getElementData(turf,"posy")
		local sizeX = getElementData(turf,"sizex")
		local sizeY = getElementData(turf,"sizey")
		local lastEnemyGroupName = ""
		if getElementData(gangmember,"Group") and getElementData(gangmember,"Group") == owner
			and px > posX and px < (posX + sizeX) and py > posY and py < (posY + sizeY) then
			ownC=ownC+1
		elseif getElementData(gangmember,"Group") and px > posX and px < (posX + sizeX)
			and py > posY and py < (posY + sizeY) then
			enemyC=enemyC+1
			if lastEnemyGroupName ~= getElementData(gangmember,"Group") then
				lastEnemyGroupName = getElementData(gangmember,"Group")
				enemyGC=enemyGC+1
			end
		end
	end
	return ownC,enemyC,enemyGC
end

-- Whenever a player enter a turf
function onTurfEnter(hitElement)
	if hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
		getElementData(hitElement, "Group") and
		getElementData(hitElement, "Group") ~= "None" and
		(getPlayerTeam(hitElement) == getTeamFromName(team_criminals) or
		getPlayerTeam(hitElement) == getTeamFromName(team_gangsters)) and
		not getElementData(hitElement,"isInTurf") then
		local owner = getElementData(source, "owner")
		local ownC,enemyC,enemyGC = countPlayersInTurf(source)
		outputConsole("Own: "..tostring(ownC)..", Enemies: "..tostring(enemyC), hitElement)
		if getPedOccupiedVehicle(hitElement) then
			exports.GTWtopbar:dm("TURFS: This turf belongs to: "..owner, hitElement, 255, 200, 0)
			return
		end
		local area = getElementData(source, "area")
		setElementData(hitElement, "area", source)
    		if (getPlayerTeam(hitElement) == getTeamFromName(team_criminals) or getPlayerTeam(hitElement) == getTeamFromName(team_gangsters)) then
    			setElementData(hitElement,"isInTurf",true)
			setElementData(hitElement, "GTWturf.posx", getElementData(source,"posx"))
			setElementData(hitElement, "GTWturf.posy", getElementData(source,"posy"))
			setElementData(hitElement, "GTWturf.theTurf", source)
			setElementData(hitElement, "GTWturf.area", area)
			local group = getElementData(hitElement, "Group")
			local colCuboid = source
			local time_to_capture = math.round((tonumber(getElementData(source, "sizex")) or 0) * (tonumber(getElementData(source, "sizey")) or 0) * time_reduce_factor, 3)
			exports.GTWtopbar:dm("TURFS: This turf belongs to: "..owner, hitElement, 0, 255, 0)
			if group == owner then
				-- This is your own turf
				setElementData(hitElement, "isInFriendlyTurf", true)
			elseif ownC == 0 and enemyGC < 2 then
				-- Start a turf war
				setRadarAreaFlashing(area, true)
				setElementData(source, "currAttacker", group)
				local px,py,pz = getElementPosition(hitElement)
				local currturf = getZoneName(px,py,pz)
				exports.GTWtopbar:dm("TURFS: This turf belongs to: "..owner.." hold it for "..
					tostring(math.floor(time_to_capture)).." seconds to capture it", hitElement, 0, 255, 0)
				setElementData(hitElement, "captureTime", "Time before "..group..
					" capture the turf: "..tostring(math.floor(time_to_capture)).." seconds")
				setTimer(groupMessageFromGroup, 1000, 1, group.." is attacking your turf at: "..currturf..
					" go there and defend your property!", owner, 255, 0, 0)
				-- Status group message
				setTimer(groupMessage, 1000, 1, "TURFS: Your gang is attacking a turf at: "..currturf..", ("..
					tostring(ownC+enemyGC).." members is involved)", hitElement, 255, 200, 0)
				if not isTimer(capturing[source]) then
					-- Start a timer that calls the capturing function
					local player_turfer = hitElement
					local theTurf = source
					capturing[source] = setTimer(function()
						setElementData(colCuboid, "owner", group)
						setElementData(area, "owner", group)
						local gangmems = getMembersInGroup(group)
						for w,mem in ipairs(gangmems) do
							if getElementData(mem,"isInTurf") then
								local c_money = getElementData(theTurf, "payment") or 0
								if c_money > 1000 then c_money = 1000 end
								givePlayerMoney(mem, c_money)
								-- Increase stats by 1
								local playeraccount = getPlayerAccount(mem)
								local turfs_taken = getAccountData(playeraccount, "GTWdata_stats_turf_count") or 0
								setAccountData(playeraccount, "GTWdata_stats_turf_count", turfs_taken + 1)
							end
						end
						local r,g,b = exports.GTWgroups:getGroupTurfColor(group)
						if not r or not g or not b then
							r,g,b = 255,255,255
						end
						setRadarAreaColor(area, r, g, b, turf_alpha)
						setRadarAreaFlashing(area, false)
						setElementData(theTurf, "currAttacker", nil)
						dbExec(db, "UPDATE turfs SET owner=?, red=?, green=?, blue=? WHERE X=? AND Y=?", group, r, g, b,
							tonumber(getElementData(colCuboid,"posx")), tonumber(getElementData(colCuboid,"posy")))
					end, time_to_capture*1000, 1)
				end
			end
			if not isTimer(time_syncer[hitElement]) and isTimer(capturing[source]) then
				-- Start a timer that shows the time left to capture
				local timer_to_check = capturing[source]
				local this_turf = source
				local player_time_req = hitElement
				local current_attacker = getElementData(source, "currAttacker")
				time_syncer[hitElement] = setTimer(function()
					local i1,i2,i3 = 0,0,0
					if isTimer(timer_to_check) then
						i1,i2,i3 = getTimerDetails(timer_to_check)
					end
					if isElement(player_time_req) and i1 and math.floor(i1/1000) >= 0 and isTimer(timer_to_check) and current_attacker then
						setElementData(player_time_req, "captureTime", "Time before "..current_attacker.." capture the turf: "..tostring(math.floor(i1/1000)+1).." seconds")
					elseif isElement(player_time_req) and i1 and math.floor(i1/1000) <= 0 and current_attacker then
						setElementData(player_time_req, "captureTime", "none")
					end
				end, 1000,(time_to_capture))
			end
    		elseif getElementData(hitElement, "Group") == "None" and getPlayerTeam(hitElement) == getTeamFromName(team_criminals) then
			exports.GTWtopbar:dm("Only gang members can capture turfs, (see F6)", hitElement, 255, 0, 0)
		end
	elseif not getElementData(hitElement, "Group") and getElementType(hitElement) == "player" and
		getPlayerTeam(hitElement) == getTeamFromName(team_criminals) then
		exports.GTWtopbar:dm("Only gang members can capture turfs, (see F6)", hitElement, 255, 0, 0)
	end
end

-- Whenever a player leaves a turf
function onTurfLeave(leaveElement)
	if leaveElement and isElement(leaveElement) and getElementType(leaveElement) == "player" then
		resetTurfData(leaveElement)
	elseif leaveElement and isElement(leaveElement) and getElementType(leaveElement) == "vehicle" and getVehicleOccupants(leaveElement) then
		for k,v in ipairs(getVehicleOccupants(leaveElement)) do
			resetTurfData(v)
		end
	end
end

-- Same as above but takes a player element only as argument
function resetTurfData(leaveElement)
	if leaveElement and isElement(leaveElement) and getElementType(leaveElement) == "player" and getElementData(leaveElement, "Group") and
		getElementData(leaveElement, "Group") ~= "None" and(getPlayerTeam(leaveElement) == getTeamFromName(team_criminals) or
			getPlayerTeam(leaveElement) == getTeamFromName(team_gangsters)) then
		-- Count players in turf
		local owner = getElementData(source, "owner")
		local ownC,enemyC,enemyGC = countPlayersInTurf(source)
		outputConsole("Own: "..tostring(ownC)..", Enemies: "..tostring(enemyC), leaveElement)

		-- Leave a turf
		local area = getElementData(source, "area")
		local group = getElementData(leaveElement, "Group")
		setElementData(leaveElement, "area", nil)
		if ownC > 0 and group == owner then
			exports.GTWtopbar:dm("TURFS: Go back and help your gang members! ("..tostring(ownC).." members left in war)", leaveElement, 255, 0, 0)
		elseif ownC == 0 and group == owner and enemyC > 0 then
			exports.GTWtopbar:dm("TURFS: Go back and defend your turf!", leaveElement, 255, 0, 0)
		elseif enemyC == 0 then
			local px,py,pz = getElementPosition(leaveElement)
			local currturf = getZoneName(px,py,pz)
			groupMessage("TURFS: Gang war was interrupted at: "..currturf..", due to lack of members!", leaveElement, 255, 0, 0)
			-- Stop the turf war globally
			setRadarAreaFlashing(area, false)
			if isTimer(capturing[source]) then
				killTimer(capturing[source])
			end
		end
		-- Stops the turf war for a single player
		setElementData(leaveElement,"isInTurf",false)
		setElementData(leaveElement, "isInFriendlyTurf", false)
		if isTimer(time_syncer[leaveElement]) then
			killTimer(time_syncer[leaveElement])
		end
	end
end

-- Interrupt provoking
function quitPlayer(quitType)
	if getElementData(source, "area") then
		local colshape = getElementData(source, "area")
		local area = getElementData(colshape, "area")
		local group = getElementData(source, "Group")
		setElementData(source, "area", nil)
		local ownC,enemyC,enemyGC = countPlayersInTurf(colshape)
		if ownC == 0 or enemyC == 0 then
			setRadarAreaFlashing(area, false)
			if isTimer(capturing[colshape]) then
				killTimer(capturing[colshape])
			end
		end
		if isTimer(time_syncer[source]) then
			killTimer(time_syncer[source])
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), quitPlayer)

-- Sync and update group colors with the group system
function changeTurfColor(plr, cmd, r, g, b)
	local r, g, b = tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255
	local group = getElementData(plr,"Group")
	if(not group) then return end
	if(not exports.GTWgroups:checkGroupAccess(plr, 13)) then return end
	dbExec(db, "UPDATE turfs SET red=?, green=?, blue=? WHERE owner=?", r, g, b, group)
	for w,area in ipairs(getElementsByType("radararea")) do
		if getElementData(area,"owner") and getElementData(area,"owner") == group then
			setRadarAreaColor(area, r, g, b, turf_alpha)
		end
	end
end
addCommandHandler("turfcolor", changeTurfColor)

function addTurf(x,y,z,sizeX,sizeY,red,green,blue,owner)
	-- Load all turfs
	if not owner then
		owner = "None"
	end
	local colCuboid = createColCuboid(x, y, z-30, sizeX, sizeY, z+30)
	local radArea = createRadarArea(x, y, sizeX, sizeY, red, green, blue, 135)
	addEventHandler("onColShapeHit", colCuboid, onTurfEnter)
	addEventHandler("onColShapeLeave", colCuboid, onTurfLeave)
	setElementData(colCuboid, "owner", owner)
	setElementData(radArea, "owner", owner)
	setElementData(colCuboid, "posx", x)
	setElementData(colCuboid, "posy", y)
	setElementData(colCuboid, "sizex", sizeX)
	setElementData(colCuboid, "sizey", sizeY)
	setElementData(colCuboid, "area", radArea)
	setElementData(colCuboid, "payment", math.floor((sizeX*sizeY)/20))
end

-- Initialize and load turfs from database on startup
function loadTurfs(query)
	local result = dbPoll(query, 0)
	if result then
    		for _, row in ipairs(result) do
            		addTurf(row["X"], row["Y"], row["Z"], row["sizeX"], row["sizeY"], row["red"], row["green"], row["blue"], row["owner"])
    		end
	end
end

-- Whenever a player dies inside a turf
function player_Wasted(ammo, attacker, weapon, bodypart)
	if isElement(source) and isElement(attacker) and getElementType(attacker) == "player" then
		if(getPlayerTeam(source) == getTeamFromName(team_criminals) or getPlayerTeam(source) == getTeamFromName(team_gangsters)) and
			(getPlayerTeam(attacker) == getTeamFromName(team_criminals) or getPlayerTeam(attacker) == getTeamFromName(team_gangsters)) and
			getElementData(source, "Group") ~= getElementData(attacker, "Group") and
			not isTimer(cooldown[attacker]) and getElementData(source,"isInTurf") then
			local victim_money = getPlayerMoney(source)
			if victim_money > money_pickpocket_max then
				victim_money = money_pickpocket_max
			elseif victim_money < money_pickpocket_min then
				victim_money = money_pickpocket_min
			end
			local money = math.floor(victim_money*(math.random(10,25)/25))

			-- Advantages for the killer
			takePlayerMoney(source, math.floor(money))
			givePlayerMoney(attacker, math.floor(money))

			-- Move victim to gangsters team if inside turf
			local gangsterTeam = getTeamFromName(team_gangsters)
			setPlayerTeam(source,gangsterTeam)
			setPlayerNametagColor(source,180,0,180)

			-- Health(armor)
			local armor = 0
			if getPedArmor(attacker) <(100-armor_max) then
				armor = math.random(armor_min,armor_max)
				setPedArmor(attacker, getPedArmor(attacker)+armor)
			end

			-- Status message
			local gangmems = getGroupMembers(source)
			local px,py,pz = getElementPosition(source)
			local currturf = getZoneName(px,py,pz)
			for w,mem in ipairs(gangmems) do
				exports.GTWtopbar:dm("TURFS: One of your members died in the turf at: "..currturf.."!", mem, 255, 0, 0)
			end

			-- Special notice for the killer
			exports.GTWtopbar:dm("TURFS: You stole: "..tostring(math.floor(money)).." from "..getPlayerName(source), attacker, 0, 255, 0)

			-- Status for the winner gang
			gangmems = getGroupMembers(attacker)
			px,py,pz = getElementPosition(source)
			currturf = getZoneName(px,py,pz)
			for w,mem in ipairs(gangmems) do
				exports.GTWtopbar:dm("TURFS: Your gang killed an enemy at: "..currturf.."!", mem, 0, 255, 0)
			end

			-- Status
			outputChatBox("#007700(GangInfo) #bbbbbbMoney: #eeeeee+"..tostring(money)..", #bbbbbbArmor:#eeeeee +"..
				tostring(armor)..", #bbbbbbStats: #eeeeee+"..tostring(stats), attacker, 0, 255, 0, true)
			cooldown[attacker] = setTimer(function() end, 15000, 1)

			setElementData(source, "isInTurf", false)
			setElementData(source, "isInFriendlyTurf", false)
		end
	end
end
addEventHandler("onPlayerWasted", root, player_Wasted)

function increaseStats(totalAmmo, attacker, weapon, bodypart, stealth)
    -- Weapon stats 2015-01-04 Stat's increase on any kill
	if not attacker or not weapon or not isElement(attacker) or getElementType(attacker) ~= "player" or attacker == source then return end
	local stat_key = 69
	if weapon == 23 then stat_key = 70 end
	if weapon == 24 then stat_key = 71 end
	if weapon == 25 then stat_key = 72 end
	if weapon == 26 then stat_key = 73 end
	if weapon == 27 then stat_key = 74 end
	if weapon == 28 then stat_key = 75 end
	if weapon == 29 then stat_key = 76 end
	if weapon == 30 then stat_key = 77 end
	if weapon == 31 then stat_key = 78 end
	if weapon == 34 then stat_key = 79 end
	local stats = math.random(weapon_stats_min, weapon_stats_max)
	if (getPedStat(attacker, stat_key) or 0) == 1000 then return end
	if (getPedStat(attacker, stat_key) or 0)+stats > 1000 then stats = (1000-getPedStat(attacker, stat_key)) end
	setPedStat(attacker, stat_key, (getPedStat(attacker, stat_key) or 0)+stats)
	setTimer(killerMessage, 123, 1, weapon, attacker, stat_key)
end
addEventHandler("onPedWasted", root, increaseStats)
addEventHandler("onPlayerWasted", root, increaseStats)

function killerMessage(weapon, attacker, stat_key)
	exports.GTWtopbar:dm("STATS: Killer weapon: "..getWeaponNameFromID(weapon)..", Current value: "..
		tostring(getPedStat(attacker, stat_key) or 0), attacker, 255, 100, 0)
end

-- Claim a turf(Admin)
function claimTurf(player, cmd, sx, sy)
	local acc = getPlayerAccount(player)
	if not getElementData(player, "GTWturf.area") then return end
	if not getElementData(player, "GTWturf.theTurf") then return end
	if isObjectInACLGroup("user."..getAccountName(acc), aclGetGroup("Admin")) then
		local group = getElementData(player, "Group")
		local r,g,b = exports.GTWgroups:getGroupTurfColor(group)
		if not r or not g or not b then
			r,g,b = 255,255,255
		end
		setRadarAreaColor(getElementData(player, "GTWturf.area"), r, g, b, turf_alpha)
		setRadarAreaFlashing(getElementData(player, "GTWturf.area"), false)
		setElementData(getElementData(player, "GTWturf.theTurf"), "currAttacker", nil)
		setElementData(getElementData(player, "GTWturf.theTurf"), "owner", group)
		setElementData(getElementData(player, "GTWturf.area"), "owner", group)
		dbExec(db, "UPDATE turfs SET owner=?, red=?, green=?, blue=? WHERE X=? AND Y=?", group, r, g, b,
			tonumber(getElementData(player, "GTWturf.posx")), tonumber(getElementData(player, "GTWturf.posy")))
		exports.GTWtopbar:dm("TURFS: this area was claimed successfully", player, 0, 255, 0)
	end
end
addCommandHandler("claimturf", claimTurf)

-- Adds a new turf(Admin)
function createTurf(player, cmd, sx, sy)
	local acc = getPlayerAccount(player)
	if isObjectInACLGroup("user."..getAccountName(acc), aclGetGroup("Admin")) then
		if not sx then sx = math.random(50,250) end
		if not sy then sy = math.random(50,250) end
		local x,y,z = getElementPosition(player)
		dbExec(db, "INSERT INTO turfs VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)", math.floor(x), math.floor(y), math.floor(z), math.floor(sx), math.floor(sy), 255, 255, 255, "None")
		addTurf(x,y,z,sx,sy,255,255,255,"None")
		exports.GTWtopbar:dm("TURFS: A new turf was added successfully", player, 0, 255, 0)
	end
end
addCommandHandler("addturf", createTurf)

-- Delete a turf where the remover stands in it's
-- bottom left corner and execute this command(Admin)
function deleteturf(player, cmd)
	local acc = getPlayerAccount(player)
	if isObjectInACLGroup("user."..getAccountName(acc), aclGetGroup("Admin")) then
		local x,y,z = getElementPosition(player)
		dbExec(db, "DELETE FROM turfs WHERE X>? AND X<? AND Y>? AND Y<?", math.floor(x)-15, math.floor(x)+15, math.floor(y)-15, math.floor(y)+15)
		local counter = 0
		for w,area in pairs(getElementsByType("radararea")) do
			local ax,ay,az = getElementPosition(area)
			if ax >(x-5) and ax <(x+5) and ay >(y-5) and ay <(y+5) then
				destroyElement(area)
				counter = counter + 1
			end
		end
		for w,colshape in pairs(getElementsByType("colshape")) do
			local ax,ay,az = getElementPosition(colshape)
			if ax >(x-5) and ax <(x+5) and ay >(y-5) and ay <(y+5) and getElementData(colshape, "owner") then
				destroyElement(colshape)
			end
		end
		if counter > 0 then
			exports.GTWtopbar:dm("TURFS: Turf was removed from database successfully", player, 0, 255, 0)
		else
			exports.GTWtopbar:dm("TURFS: No turfs was found within this range", player, 255, 0, 0)
		end
	end
end
addCommandHandler("deleteturf", deleteturf)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
