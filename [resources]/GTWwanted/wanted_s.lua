--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

wanted_data = {
	wanted_level 	= { },
	violent_time	= { },
	reduce_timers 	= { },
	fine_charge		= { },
}

--[[ Load system data ]]--
function load_system( )
	for k,v in pairs(getElementsByType("player")) do
		-- Restore wanted level and reduce timers
		if (tonumber(getElementData(v, "Wanted")) or 0) < 0 then setElementData(v, "Wanted", 0) end
		setWl(v, (tonumber(getElementData(v, "Wanted")) or 0), (tonumber(getElementData(v, "violent_seconds")) or 0))
	end
end
addEventHandler("onResourceStart", resourceRoot, load_system)

-- Possible bug here
--[[function restore_wanted_level(_, pAcc)
    -- Restore wanted level and reduce timers
    if (tonumber(getElementData(source, "Wanted")) or 0) < 0 then setElementData(source, "Wanted", 0) end
	setWl(source, (tonumber(getElementData(source, "Wanted")) or 0), (tonumber(getElementData(source, "violent_seconds")) or 0))
end
addEventHandler("onPlayerLogin", root, restore_wanted_level)]]--

--[[ Make sure the graphical hud and scoreboards are up to date ]]--
function update_graphical(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local wanted_lvl = (wanted_data.wanted_level[plr] or 0)
	
	-- Update graphical wanted level
	setElementData(plr, "Wanted", wanted_lvl)
	if wanted_lvl <= 0 then
		setElementData(plr, "Wanted", nil)
	end
	
	-- Pass violent time to client
	if (wanted_data.violent_time[plr] or 0) > 0 then
		setElementData(plr, "violent_seconds", (wanted_data.violent_time[plr] or nil))
	else
		setElementData(plr, "violent_seconds", nil)
	end
	
	-- Sync the amount of stars seen on screen
	if wanted_lvl > 0 and wanted_lvl <= 1 then
		setPlayerWantedLevel(plr, 1)
	elseif wanted_lvl > 1 and wanted_lvl <= 6 then
		setPlayerWantedLevel(plr, math.floor(wanted_lvl))
	elseif wanted_lvl > 6 then
		setPlayerWantedLevel(plr, 6)
	else
		setPlayerWantedLevel(plr, 0)
	end
end

--[[ Reduce a players wanted level ]]--
function reduce_wl(crim)
	-- Check if everything is represented
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return end

	-- Check if arrested, if so, don't reduce or increase
	local is_arrested = exports.GTWpolice:isArrested(crim)
	if is_arrested then return end
	
	-- Check if jailed, if so, don't reduce or increase
	local is_jailed = exports.GTWjail:isJailed(crim)
	if is_jailed then return end

	-- Check if it's time to interrupt
	if non_violent(crim) then return end
	
	-- Setup default reduce margins
	local wl_reduce,viol_reduce = 0.02,1
	
	-- Justify reducement depending on distance to cop
	local dist = exports.GTWpolice:distanceToCop(crim)
	if dist > 3000 and not is_law_unit(crim) then wl_reduce = 0.04 end
	if dist > 2000 and not is_law_unit(crim) then wl_reduce = 0.03 end
	if dist < 1000 and not is_law_unit(crim) then wl_reduce = 0.01 end
	if dist < 500 and not is_law_unit(crim) then wl_reduce = 0.005 end
	if dist < 180 and not is_law_unit(crim) then wl_reduce = 0 end
	if dist < 90 and not is_law_unit(crim) then wl_reduce = -0.001 end
	
	-- Set the team to criminal
	if getPlayerTeam(crim) and getPlayerTeam(crim) ~= getTeamFromName("Criminals") and wanted_data.wanted_level[crim] > 1 then
		setPlayerTeam(crim, getTeamFromName("Criminals"))
		setPlayerNametagColor(crim, 170, 0, 0)
		setElementData(crim, "Occupation", "Criminal")
		local own_skin = exports.GTWclothes:getBoughtSkin(crim) or getElementModel(crim) or 0
		setElementModel(crim, own_skin)
		exports.GTWtopbar:dm("You are now a criminal due to your wanted level", crim, 255, 100, 0 )
	end
	
	-- Reduce wantedlevel by 0.1 stars
	if wanted_data.violent_time[crim] <= 0 then
		wanted_data.wanted_level[crim] = round(wanted_data.wanted_level[crim] - wl_reduce, 3)
	elseif wanted_data.violent_time[crim] > 0 then
		wanted_data.violent_time[crim] = math.floor(wanted_data.violent_time[crim] - viol_reduce)
	else
		wanted_data.wanted_level[crim] = nil
		wanted_data.violent_time[crim] = nil
	end
	
	-- Update graphical data
	update_graphical(crim)
end

--[[ Round numeric values ]]--
function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end

--[[ Set violent time to nil to indicate a player is non violent ]]--
function non_violent(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	
	-- Check if it's time to go unwanted
	if wanted_data.wanted_level[plr] <= 0 and isTimer(wanted_data.reduce_timers[plr]) then
		killTimer(wanted_data.reduce_timers[plr])
		wanted_data.wanted_level[plr] = nil
		return true
	end
end

--[[ Set player wanted level ]]--
function setWl(plr, level, violent_time, reason, add_to, reduce_health)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" or not level then return end
	if not add_to then add_to = true end
	if not reduce_health then reduce_health = false end
	
	-- Don't set wanted level if crime is comitted in jail
	local is_jailed = exports.GTWjail:isJailed(plr)
	if is_jailed and add_to then return end
	
	if is_law_unit(plr) then level = (level/10) end
	if is_law_unit(plr) then violent_time = (violent_time/10) end
	
	-- If the crime was in a vehicle collision, reduce health
	if reduce_health and getPedOccupiedVehicle(plr) then
		local driver = getVehicleOccupants(getPedOccupiedVehicle(plr))[0]
		for k,v in pairs(getVehicleOccupants(getPedOccupiedVehicle(plr))) do
			local new_health = getElementHealth(v)-(level*50)
			if new_health > 0 then
				setElementHealth(v, new_health)
			else
				killPed(v)
			end
		end
		
		-- Cancel if suspect isn't the driver
		if driver ~= plr then return end
	end	
	
	-- Set default value to violent time if not present
	if not violent_time then violent_time = 0 end
	
	-- Start reduce timer if not running
	if not isTimer(wanted_data.reduce_timers[plr]) then
		wanted_data.reduce_timers[plr] = setTimer(reduce_wl, 1000, 0, plr)
	end

	-- Update wanted level and violent time
	local p_level = (wanted_data.wanted_level[plr] or 0)
	local p_viol_time = (wanted_data.violent_time[plr] or 0)
	if p_level < 0 then p_level = 0 end
	if add_to then
		wanted_data.wanted_level[plr] = p_level + level
		wanted_data.violent_time[plr] = p_viol_time + violent_time
	else
		wanted_data.wanted_level[plr] = level
		wanted_data.violent_time[plr] = violent_time
	end
	
	-- Wanted points for criminals
	local pAcc = getPlayerAccount(plr)
	local wp_stat = getAccountData( pAcc, "acorp_stats_wanted_points" ) or 0
	setAccountData(pAcc, "acorp_stats_wanted_points", wp_stat+level)
	
	-- Display the reason for the player
	if reason and reason ~= "" then
		exports.GTWtopbar:dm(reason.." ("..round(level, 2).." stars)", plr, 200, 0, 0)
	end
	
	-- If argument was 0 (fine)
	if level == 0 and violent_time == 0 then
		if isTimer(wanted_data.reduce_timers[plr]) then
			killTimer(wanted_data.reduce_timers[plr])
		end
		wanted_data.wanted_level[plr] = nil
		wanted_data.violent_time[plr] = nil
	end
	
	-- Update graphical data
	update_graphical(plr)
end

function setServerWantedLevel(wl, violent_time, reason, require_nearby_cop, reduce_health)
	-- A value indicating if the crime require a cop to be nearby
	if require_nearby_cop then
		local dist = exports.GTWpolice:distanceToCop(client)
		if dist > 180 then return end
	end
	
	-- Set the wanted level
	setWl(client, wl, violent_time, reason, true, reduce_health)
end
addEvent("GTWwanted.serverSetWl", true)
addEventHandler("GTWwanted.serverSetWl", root, setServerWantedLevel) 

--[[ Get player wanted level ]]--
function getWl(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return 0,0 end
	
	-- Return all player wanted level data
	return (wanted_data.wanted_level[plr] or 0), (wanted_data.violent_time[plr] or 0)
end

--[[ Check if a player is on the law side ]]--
function is_law_unit(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	local law_teams = { 
		["Government"]=true,
		["Staff"]=true,
	}
	if getPlayerTeam(plr) and law_teams[getTeamName(getPlayerTeam( plr ))] then
		return true
	else
		return false
	end
end

--[[ Crime of damage other players ]]--
function crime_damage(attacker, attackerweapon, bodypart, loss)
	if not attacker or not isElement(attacker) or getElementType(attacker) ~= "player" or attacker == source then return end
	local wl,viol = getWl(source)
	local is_jailed = exports.GTWjail:isJailed(source)
	if is_law_unit(attacker) and (wl > 0 or getElementType(source) == "ped" or is_jailed) then return end
	setWl(attacker, round((loss/150), 2), 5)
end
addEventHandler( "onPlayerDamage", root, crime_damage )

--[[ Crime of killing other players ]]--
function crime_death(totalAmmo, killer, killerWeapon, bodypart, stealth)
	if not killer or not isElement(killer) or getElementType(killer) ~= "player" or killer == source then return end
	local wl,viol = getWl(source)
	local is_jailed = exports.GTWjail:isJailed(source)
    if is_law_unit(killer) and (wl > 0 or is_jailed) then return end
	local add_wl = 1.8
	if getElementType(source) == "ped" then
		add_wl = 1.2   -- Reduced by 0.6 for bots
	end
	setWl(killer, round(add_wl, 2), 50)
end
addEventHandler("onPedWasted", root, crime_death)
addEventHandler("onPlayerWasted", root, crime_death)

function crime_grand_theft_auto_attempt(plr, seat, jacked)
    if not jacked or not isElement(jacked) or getElementType(jacked) ~= "player" or seat > 0  then return end
    if is_law_unit(plr) then return end
    setWl(plr, 0.2, 5, "You committed the crime of grand theft auto (attempt)")
end
addEventHandler("onVehicleStartEnter", root, crime_grand_theft_auto_attempt)
function crime_grand_theft_auto(plr, seat, jacked)
    if not jacked or not isElement(jacked) or getElementType(jacked) ~= "player" or seat > 0 then return end
    if is_law_unit(plr) then return end
    setWl(plr, 0.8, 25, "You committed the crime of grand theft auto")
end
addEventHandler("onVehicleEnter", root, crime_grand_theft_auto)

function reduce_functionality(loss)
    
end
addEventHandler("onVehicleDamage", root, reduce_functionality)

function checkSpeeding( )
	-- Get the target
	local target = getPedTarget( client )
	local speedx, speedy, speedz = getElementVelocity( target )
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	local kmh = actualspeed * 180
	
	-- Perform a check
	if not isElement( target ) then return end
	local speeder = getVehicleOccupants(target)[0]
	if not speeder or (speeder and is_law_unit(speeder)) then return end
			
	-- Tell the speeder
	local n_wl = round((kmh*1.3/400),2)
	setWl(speeder, round(n_wl, 2), 0, "You committed the crime of speeding")
	
	-- Pay the cop for the catch
	local money = math.floor(kmh*1.3)
	exports.GTWtopbar:dm("You have catched: "..getPlayerName(speeder).." for speeding and earned: $"..tostring(money), client, 0, 255, 0 )
	givePlayerMoney(client, money)
end
addEvent("GTWwanted.onSpeeding", true)
addEventHandler("GTWwanted.onSpeeding", root, checkSpeeding)

--[[ Display wanted level (DEBUG) ]]--
function show_wl(plr)
	local x,y = getWl(plr)
	outputChatBox("WL: "..(x or 0)..", Violent: "..(y or 0), plr, 255, 100, 0)
end
addCommandHandler("wl", show_wl)

--[[ Display wanted players ]]--
function show_wanted_players(plr)
	local c = 0
	local cx,cy,cz = getElementPosition(plr)
	for k,v in pairs(getElementsByType("player")) do
		local x,y = getWl(v)
		local px,py,pz = getElementPosition(v)

		local dist = getDistanceBetweenPoints3D(px,py,pz, cx,cy,cz)
		--[[ Color codes:
		* Green: suspect is in jail and harmless
		* Yellow: suspect is arrested and on his way to jail
		* Orange: suspect is wanted but not violent (you must arrest)
		* Red: suspect is violent, kill arrest is allowed]]--
		local is_arrested = exports.GTWpolice:isArrested(v)
		local is_jailed = exports.GTWjail:isJailed(v)
		local location = getElementData(v, "Location") or getZoneName(px,py,pz)
		if is_jailed then
			local endTime = tonumber( getElementData( v, "jailTime" ))
			local currentTime = tonumber( getElementData( v, "jailTime2" ))
			outputChatBox(getPlayerName(v)..": Jailed: "..round((endTime-currentTime)/1000, 2).." seconds left", plr, 0, 200, 0)
			c = c + 1
		elseif is_arrested and x > 0 then
			outputChatBox(getPlayerName(v)..": Wanted level: "..round(x, 2)..", Violent time (s): "..
				round(y, 2)..", Location: "..location.." ("..getZoneName(px,py,pz,true)..") "..math.floor(dist).."m", plr, 255, 200, 0)
			c = c + 1
		elseif x > 0 and y > 0 then
			outputChatBox(getPlayerName(v)..": Wanted level: "..round(x, 2)..", Violent time (s): "..
				round(y, 2)..", Location: "..location.." ("..getZoneName(px,py,pz,true)..") "..math.floor(dist).."m", plr, 200, 0, 0)
			c = c + 1
		elseif x > 0 then
			outputChatBox(getPlayerName(v)..": Wanted level: "..round(x, 2)..", Violent time (s): "..
				round(y, 2)..", Location: "..location.." ("..getZoneName(px,py,pz,true)..") "..math.floor(dist).."m", plr, 255, 100, 0)
			c = c + 1
		end
	end
	if c == 0 then
		outputChatBox("No wanted players was found, try again later", plr, 255, 100, 0)
	end
end
addCommandHandler("wanted", show_wanted_players)
addCommandHandler("wanteds", show_wanted_players)

--[[ Pays a fine $500/star $200/violent second ]]--
function pay_fine(plr, cmd, plr2)
	local wl,viol = getWl(plr)
	local price = math.floor((wl*300)+(viol*100))
	local disttocop = exports.GTWpolice:distanceToCop(plr)
	if cmd == "adminfine" then
		local accName = getAccountName( getPlayerAccount( plr )) 
		if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" )) then
			if plr2 and getPlayerFromName(plr2) then
				setWl(getPlayerFromName(plr2), 0, 0)
				exports.GTWtopbar:dm(getPlayerName(plr).." has removed your wanted level", getPlayerFromName(plr2), 255, 100, 0 )
				exports.GTWtopbar:dm("You have removed "..plr2.."'s wanted level", plr, 255, 100, 0 )
			else
				setWl(plr, 0, 0)
				exports.GTWtopbar:dm("You have removed your wanted level for free", plr, 255, 100, 0 )
			end
			return
		end
	end
	if (tonumber(getElementData(plr, "violent_seconds")) or 0) > 0 then
		exports.GTWtopbar:dm("You are too violent to pay a fine!", plr, 255, 0, 0 )	
		return 
	end
	if wl > 100 then
		exports.GTWtopbar:dm("Your wanted level is to high!", plr, 255, 0, 0 )	
		return 
	end
	if getPlayerMoney(plr) < price then
		exports.GTWtopbar:dm("You can't afford a fine! $"..tostring(price), plr, 255, 0, 0 )	
		return 
	end
	if wl == 0 then
		exports.GTWtopbar:dm("You are clean!", plr, 0, 255, 0 )	
		return 
	end
	if disttocop < 180 then
		exports.GTWtopbar:dm("You can't pay a fine when a law enforcer is nearby, ("..tostring(180-disttocop).."m to safety)", plr, 255, 0, 0 )	
		return 
	end
	wanted_data.fine_charge[plr] = price
	exports.GTWtopbar:dm("You have requested a fine, it will cost you $"..tostring(price)..", type /accept to continue", plr, 255, 100, 0 )
end
addCommandHandler("fine", pay_fine)
addCommandHandler("payfine", pay_fine)
addCommandHandler("surrender", pay_fine)
addCommandHandler("giveup", pay_fine)
addCommandHandler("adminfine", pay_fine)
function accept_fine(plr)
	if not wanted_data.fine_charge[plr] then return end
	takePlayerMoney(plr, wanted_data.fine_charge[plr])
	setWl(plr, 0, 0)
	wanted_data.fine_charge[plr] = nil
	exports.GTWtopbar:dm("You have paid a fine of $"..tostring(price), plr, 0, 255, 0 )
end
addCommandHandler("accept", accept_fine)
addCommandHandler("acceptfine", accept_fine)
addCommandHandler("confirm", accept_fine)