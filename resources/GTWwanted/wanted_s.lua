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

wanted_data = {{ }}
reduce_timers = { }

--[[ Reduce a players wanted level ]]--
function reduce_wl(plr, first_time)
	-- Check if everything is represented
	first_time = first_time or false
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	
	-- Check that everything is properly set
	verify_table_data(plr)

	-- Check if it's time to interrupt
	if non_violent(plr) then return end
	
	-- Last check before we proceed to reduce
	if not wanted_data[plr] or not wanted_data[plr]["wanted_level"] or not 
		wanted_data[plr]["wanted_level"] > 0 or wanted_data[plr]["violent"] then return end
		
	-- Reduce wantedlevel by 0.1 stars
	if not first_time then
		wanted_data[plr]["wanted_level"] = wanted_data[plr]["wanted_level"] - 0.1
	end
	
	-- Update graphical wanted level
	if wanted_data[plr]["wanted_level"] > 0 and wanted_data[plr]["wanted_level"] <= 1 then
		setPlayerWantedLevel(plr, 1)
	elseif wanted_data[plr]["wanted_level"] > 1 and wanted_data[plr]["wanted_level"] <= 6 then
		setPlayerWantedLevel(plr, math.floor(wanted_data[plr]["wanted_level"]))
	elseif wanted_data[plr]["wanted_level"] > 6 then
		setPlayerWantedLevel(plr, 6)
	end
end

--[[ Round numeric values ]]--
function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end

--[[ Set violent time to nil to indicate a player is non violent ]]--
function non_violent(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	
	-- Check that everything is properly set
	verify_table_data(plr)
	
	-- Check if it's time to go unwanted
	if wanted_data[plr]["wanted_level"] <= 0 and reduce_timers[plr] and isTimer(reduce_timers[plr]) then
		killTimer(reduce_timers[plr])
		setPlayerWantedLevel(plr, 0)
		wanted_data[plr]["wanted_level"] = nil
		return true
	end
end

--[[ Initialize default values if not set ]]--
function verify_table_data(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	if not wanted_data[plr] then wanted_data[plr] = { } end
	if not wanted_data[plr]["wanted_level"] then wanted_data[plr]["wanted_level"] = 0 end
	if not wanted_data[plr]["violent"] then wanted_data[plr]["violent"] = 0 end
end

--[[ Set player wanted level ]]--
function setWl(plr, level, violent_time)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" or not level then return end
	
	-- Set default value to violent time if not present
	if not violent_time then violent_time = 0 end
	
	-- Start reduce timer if not running
	if not reduce_timers[plr] then
		reduce_timers[plr] = setTimer(reduce_wl, 10000, 0, plr)
	end
	
	-- Update graphical part
	reduce_wl(plr, true)
	
	-- Check that all values are present to prevent errors
	verify_table_data(plr)
	
	-- Update wanted level
	wanted_data[plr]["wanted_level"] = level
	wanted_data[plr]["violent"] = violent_time
end

--[[ Get player wanted level ]]--
function getWl(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" or not level then return end
	
	-- Check that all values are present to prevent errors
	verify_table_data(plr)
	
	-- Clean default values array
	local alt = {
		["wanted_level"]=0, 
		["violent"]=0
	}
	
	-- Return all player wanted level data
	return (wanted_data[plr]["wanted_level"] or 0), (wanted_data[plr]["violent"] or 0)
end

--[[ Check if a player is on the law side ]]--
function is_law_unit(plr)
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" or not level then return end
	local law_teams = { 
		"Government",
		"Staff"
	}
	if getPlayerTeam(plr) and law_teams[getTeamName(getPlayerTeam( plr ))] then
		return true
	else
		return false
	end
end

--[[ Crime of damage other players ]]--
function crime_death(attacker, attackerweapon, bodypart, loss)
	if is_law_unit(attacker) then return end
	local wl,viol = getWl(attacker)
	setWl(attacker, (wl or 0)+1, (viol or 0)+4)
end
addEventHandler( "onPlayerDamage", root, crime_death )

function show_wl(plr)
	local x,y = getWl(plr)
	outputChatBox("WL: "..(x or 0)..", Violent: "..(y or 0), plr)
end
addCommandHandler("wl", show_wl)

-- OLD SHIT --

-- Global members
--[[wlCountdown = {}
violent = {}
sdTimer = {}
cooldown = {}
finecooldown = {}
traincooldown = {}
carcooldown = {}
lastSuspect = {}
lastLocation = {}
trackSyncer = {}

-- Global times
violentTime = 15000 	-- 30 seconds
lowerWLTime = 10000 	-- 20 seconds

function lowerWL( thePlayer )
	if isElement( thePlayer ) and getElementType( thePlayer ) == "player" and getPlayerTeam(thePlayer) then
		local cops = getElementsByType( "player" )
		local copIsNearby = false
		local dist = 3500		
		for theKey,cop in ipairs(cops) do 
			if getPlayerTeam( cop ) and lawTeams[getTeamName(getPlayerTeam( cop ))] and cop ~= thePlayer and not getElementData( cop, "admin" ) then
				cx,cy,cz = getElementPosition( cop )
				px,py,pz = getElementPosition( thePlayer )
	   			dist = getDistanceBetweenPoints3D ( cx, cy, cz, px, py, pz )
	   			setElementData( thePlayer, "distToCop", dist )
	   		end
	   	end
	   	if not isElement( thePlayer ) then
	   		killTimer( wlCountdown[thePlayer] )
	   	end
		if isTimer( wlCountdown[thePlayer] ) and tonumber( getElementData( thePlayer, "Wanted" ) or 0) > 0 and 
			not isTimer( violent[thePlayer] ) then
			local minSpeed = (( dist/20000)-0.02)
			local wl = tonumber(getElementData( thePlayer, "Wanted" ) or 0) - minSpeed
			if wl > 0 then
				setElementData( thePlayer, "Wanted", round( wl, 2 ))
				-- Sync wanted level
				setPlayerWantedAC( thePlayer, 0 )
			else
				setElementData( thePlayer, "Wanted", 0.0 )
				setPlayerWantedLevel( thePlayer, 0 )
				killTimer( wlCountdown[thePlayer] )
			end
		end
	end
end

-- Display a list of all wanted players in the server and number of stars
function show_wanted_players( player )
	local cox,coy,coz = getElementPosition( player )
	local counter = 0	
	for theKey,thePlayer in ipairs(getElementsByType("player")) do 
   		local level = getPlayerWantedLevel( thePlayer )
   		local cx,cy,cz = getElementPosition( thePlayer )
   		local location = getZoneName( getElementPosition( thePlayer ))
   		local city = getZoneName( cx,cy,cz, true )
   		local isViolent = "No"
   		if isTimer( violent[thePlayer] ) then
   			isViolent = "Yes"
   		end
   		if ( level > 0 and getElementData( thePlayer, "Jailed" ) ~= "Yes" and 
   			not getElementData( thePlayer, "arrested" )) then 
      		outputChatBox( "#BBBBBB"..getPlayerName(thePlayer).." #EEEEEEwas last seen at: #BBBBBB" .. 
      			location.." ("..city..")", player, 
      			150, 150, 150, true) 
      			outputChatBox( "#EEEEEEWanted: #BBBBBB"..getElementData(thePlayer,"Wanted")..
      			"#EEEEEE, Dist: #BBBBBB"..tostring( math.floor( getDistanceBetweenPoints3D( cx,cy,cz, cox,coy,coz ))).."m", player, 
      			150, 150, 150, true )
      		counter = counter +1;
   		end 
	end
	
	if counter == 0 then
		outputChatBox( "#BBBBBB(Police) #EEEEEENo wanted players was found, please try again later", player, 150, 150, 150, true )
	end
end
addCommandHandler("wanted", show_wanted_players)
addCommandHandler("wanteds", show_wanted_players)
addCommandHandler("criminals", show_wanted_players)
addCommandHandler("policecomputer", show_wanted_players)

-- Distance to cop
function distanceToCop( player )
	local copIsNearby = false
	local dist = 99999		
	for w,cop in ipairs(getElementsByType("player")) do 
		if getPlayerTeam(cop) and lawTeams[getTeamName(getPlayerTeam( cop ))] and getPlayerTeam(cop) ~= getTeamFromName("Staff") then
			cx,cy,cz = getElementPosition( cop )
			px,py,pz = getElementPosition( player )
			if getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz ) < dist and cop ~= player then
				dist = getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz )
			end
			setElementData( player, "distToCop", dist )
		end
	end
	return dist
end

-- Find nearest cop
function nearestCop( player )
	local copIsNearby = false
	local dist = 99999	
	local nearCop = nil	
	for w,cop in ipairs(getElementsByType("player")) do 
		if getPlayerTeam(cop) and lawTeams[getTeamName(getPlayerTeam( cop ))] then
			cx,cy,cz = getElementPosition( cop )
			px,py,pz = getElementPosition( player )
			if getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz ) < dist then
				dist = getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz )
				nearCop = cop
			end
			setElementData( player, "distToCop", dist )
		end
	end
	return nearCop
end

-- Update violent info
function updateViolence()
	for w,crim in ipairs(getElementsByType("player")) do 
		local i1,i2,i3 = 0,0,0
	   	if isTimer( violent[crim] ) then
	   		i1,i2,i3 = getTimerDetails( violent[crim] )
	   	end
	   	if i1 > 0 then
	   		setElementData( crim, "violent_seconds", math.floor(i1/1000))
	   	end
   	end
end
setTimer(updateViolence,1000,0)

-- Distance to nearest crim
function distanceToCrim( player )
	local crimIsNearby = false
	local dist = 99999	
	for w,crim in ipairs(getElementsByType("player")) do 
		if getPlayerWantedLevel(crim) > 0 and crim ~= player and 
			getElementInterior(crim) == getElementInterior(player) and  
			getElementDimension(crim) == getElementDimension(player) and 
			not lawTeams[getTeamName(getPlayerTeam(crim))] then
			cx,cy,cz = getElementPosition( crim )
			px,py,pz = getElementPosition( player )
			if getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz ) < dist and 
				getElementData( crim, "Jailed" ) ~= "Yes" and 
				not getElementData( crim, "arrested" ) then
				dist = getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz )
			end
			if dist > 180 then
				setElementData( player, "distToCrim", dist )
			end
		end
	end
	return dist
end

-- Direction to crim
function directionToCrim( player )
	local crimIsNearby = false
	local dir = "North"
	local dist = 9999	
	for w,crim in ipairs(getElementsByType("player")) do 
		if getPlayerWantedLevel(crim) > 0 and crim ~= player then
			cx,cy,cz = getElementPosition( crim )
			px,py,pz = getElementPosition( player )
			if getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz ) < dist and 
				getElementData( crim, "Jailed" ) ~= "Yes" and 
				not getElementData( crim, "arrested" ) then
				dist = getDistanceBetweenPoints3D( cx, cy, cz, px, py, pz )
				if py > cy-10 then
					dir = "South"
				elseif py < cy+10 then
					dir = "North"
				end
				if px > cx-10 then
					dir = dir.."West"
				elseif px < cx+10 then
					dir = dir.."East"
				end
			end
		end
	end
	return dir
end

-- Use the fine command to remove your wanted level (staff only)
function remove_wanted_level(player)
	local wl = getElementData( player, "Wanted" )
	local fine = wl*100
	if fine < 500 and not isTimer( finecooldown[player] ) and not getElementData( player, "arrested" ) and 
		getPlayerMoney( player ) > fine and not isTimer( violent[player] ) and
		( distanceToCop( player ) > 179 or (getPlayerTeam(player) and lawTeams[getTeamName(getPlayerTeam( player ))])) then
		setPlayerWantedLevel( player, 0 )
		setElementData( player, "Wanted", 0.0 ) 
		exports.GTWtopbar:dm( "You have payed a fine to remove your wanted level!", player, 0, 255, 0 )
		takePlayerMoney( player, fine )
		finecooldown[player] = setTimer( function() end, 60000, 1 )
	elseif getPlayerMoney( player ) < fine then
		exports.GTWtopbar:dm( "You don't have enough money to pay a fine!", player, 255, 0, 0 )
	elseif isTimer( finecooldown[player] ) then
		exports.GTWtopbar:dm( "You have just payed a fine, be patient!", player, 255, 0, 0 )
	elseif fine > 499 then
		exports.GTWtopbar:dm( "Your wanted level is too high, stay away from the law to reduce your wanted level!", player, 255, 0, 0 )
	elseif isTimer( violent[player] ) then
		exports.GTWtopbar:dm( "You where recently violent and can't use this command now!", player, 255, 0, 0 )
	elseif distanceToCop( player ) < 180 then
		exports.GTWtopbar:dm( "You can't pay a fine when a cop is nearby! ("..tostring(math.floor(180 - distanceToCop( player ))).."m to safety)", player, 255, 0, 0 )
	elseif wl == 0 then
		exports.GTWtopbar:dm( "You are clean!", player, 0, 255, 0 )
	else
		exports.GTWtopbar:dm( "An unknown error occurred while trying to pay a fine!", player, 255, 0, 0 )
	end
	
	-- Sync wanted level
	setPlayerWantedAC( player, 0 )
end
addCommandHandler("fine", remove_wanted_level)
addCommandHandler("payfine", remove_wanted_level)
addCommandHandler("surrender", remove_wanted_level)
addCommandHandler("giveup", remove_wanted_level)

-- Show your own current wanted level as a float
function show_wanted_level(player)
	if getElementData( player, "Wanted") == 0 then
		outputChatBox( "#EEEEEEWanted:#009900 0.00 #EEEEEEViolent: #BBBBBBno", player, 0, 150, 0, true )
	else
		local i1,i2,i3 = 0,0,0
   		if isTimer( violent[player] ) then
   			i1,i2,i3 = getTimerDetails( violent[player] )
   		end
   		local violentTime = tostring(math.floor(i1/1000)).." #EEEEEEseconds left"
   		if math.floor(i1/1000) == 0 then
   			violentTime = "none"
   		end
   		outputChatBox( "#EEEEEEWanted: #BBBBBB" .. 
		round( tonumber( getElementData( player, "Wanted")), 2 ).." #EEEEEEViolent: #BBBBBB"..violentTime, player, 0, 150, 0, true )
	end
end
addCommandHandler("wl", show_wanted_level)
addCommandHandler("mywl", show_wanted_level)
addCommandHandler("mywantedlevel", show_wanted_level)

-- Return remaining violent time in seconds
function getViolentTime(player)
	local i1,i2,i3 = 0,0,0
   	if isTimer( violent[player] ) then
   		i1,i2,i3 = getTimerDetails( violent[player] )
   	end
   	return math.floor(i1/1000)
end

-- Raise the wanted level on player damage depending on damage made 
function playerDamage ( attacker, weapon, bodypart, loss ) 
	-- Make shore that an attacker exist as well as the source and that the attacker is a player
	if isElement ( attacker ) and getElementType ( attacker ) == "player" and isElement ( source ) then
		local isCop = false
		if isElement ( attacker ) and getPlayerTeam ( attacker ) then
			-- Check so cops and staff don't get wanted
			if ( lawTeams[getTeamName(getPlayerTeam( attacker ))] or 
				( tonumber( getElementData( source, "Wanted" ) or 0) > 0 and 
				tonumber( getElementData( attacker, "Wanted" )) < 1 ) and
				isTimer( violent[source] )) then
				isCop = true
			end
		end
		-- If the victim is admin, kill the attacker
		if getPlayerTeam( source ) == getTeamFromName( "Staff" ) then
			killPed( attacker )
		end
		-- Make shore that attacker is not the source (suicide) 
		-- and that the attacker isn't a cop
		if attacker ~= source and ( not isCop ) and getPlayerTeam( source ) ~= getTeamFromName( "Staff" ) then 
			-- Raise the wanted level
			if not getElementData( source, "DM" ) then
				if ( not lawTeams[getTeamName(getPlayerTeam( attacker ))] or not isTimer( violent[source] )) then
					setElementData( attacker, "DM", source )
					if isTimer( sdTimer[attacker] ) then
						killTimer( sdTimer[attacker] )
					end
					sdTimer[attacker] = setTimer( disableSelfDefence, 60000, 1, attacker )
					if not isTimer( wlCountdown[attacker] ) then
						wlCountdown[attacker] = setTimer( lowerWL, lowerWLTime, 0, attacker )
						violent[attacker] = setTimer( function() end, violentTime, 1 )
						
						-- Wanted points for criminals
						local playeraccount = getPlayerAccount( attacker )
						local wantedPoints = getAccountData( playeraccount, "acorp_stats_wanted_points" ) or 0
						setAccountData( playeraccount, "acorp_stats_wanted_points", wantedPoints + 3 )
					end
				end
			end
			cooldown[source] = setTimer(function() end, 7000, 1)
			
			-- Sync wanted level
			setPlayerWantedAC( attacker, 10 )
		end
	end
end
addEventHandler( "onPlayerDamage", getRootElement(), playerDamage )

function checkSpeeding( )
	-- Get the target
	local target = getPedTarget( client )
	speedx, speedy, speedz = getElementVelocity( target )
	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	kmh = actualspeed * 180
	
	-- Perform a check
	if isElement( target ) then
		local speeder = getVehicleOccupants(target)[0]
		if not isTimer( cooldown[speeder] ) and getPlayerTeam( speeder ) ~= getTeamFromName( "Staff" ) then
			-- Tell the speeder
			local wl = round((kmh*1.3/400),2)
			exports.GTWtopbar:dm( "You committed the crime of speeding "..tostring(wl).." stars", speeder, 255, 0, 0 )
			
			-- Pay the cop
			local money = math.floor(kmh*1.3)
			exports.GTWtopbar:dm(	"You have catched: "..getPlayerName(speeder).." for speeding and earned: "..tostring(money).."$", client, 0, 255, 0 )
			givePlayerMoney( client, money )
			
			-- Wanted points for criminals
			local playeraccount = getPlayerAccount( speeder )
			local wantedPoints = getAccountData( playeraccount, "acorp_stats_wanted_points" ) or 0
			setAccountData( playeraccount, "acorp_stats_wanted_points", wantedPoints + 1 )
			
			-- Sync wanted level
			setElementData( speeder, "Wanted", tonumber( getElementData( speeder, "Wanted" )) + wl )
			setPlayerWantedAC( speeder, 0 )
			if not isTimer( wlCountdown[speeder] ) then
				wlCountdown[speeder] = setTimer( lowerWL, lowerWLTime, 0, speeder )
			end
			cooldown[source] = setTimer(function() end, 8000, 1)
		end
	end
end
addEvent( "onSpeeding", true )
addEventHandler( "onSpeeding", root, checkSpeeding )

function setClientWL( wl, violentmult, text, vehrelated )
	-- Get element velocity (car crimes like speeding or crashes)
	speedx, speedy, speedz = getElementVelocity ( client )
	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	kmh = actualspeed * 180
	
	-- Decrease health
	local veh = getPedOccupiedVehicle( client )
	if isElement( veh ) and vehrelated then
		local occupants = getVehicleOccupants( veh )
		if occupants then
			 for seat, occupant in pairs( occupants ) do 
			 	if isElement( occupant ) then
			 		local result = getVehicleHandling ( veh )
 					massDiv = (tonumber ( result["mass"] )/300)
 					if massDiv < 0.1 then
 						massDiv = 0.1
 					end
					if getElementHealth( occupant ) > ((wl*80)/massDiv) then
						setElementHealth( occupant, getElementHealth( occupant ) - ((wl*80)/massDiv))
					else
						setElementHealth ( occupant, 0 )
					end
				end
			end
		end
	end
	
	-- Reduce wl if vehicle related
	if vehrelated then
		wl = (wl/3)
	end
	
	-- Not in vehicle or in vehicle with a speed higher than 30km/h
	if ( not getPedOccupiedVehicle ( client ) or ( getPedOccupiedVehicle ( client ) and kmh > 30 )) and 
		not getElementData(client, "admin") and wl > 0.01 and (distanceToCop( client ) < 180 or wl > 0.5) then
		setElementData ( client, "Wanted", round( 
			tonumber( getElementData( client, "Wanted" )) + wl, 2 ))
			
		if text and text ~= "" and ( not isTimer(cooldownmsg) or not vehrelated ) then
			exports.GTWtopbar:dm( text, client, 255, 0, 0 )
			if vehrelated then
				cooldownmsg = setTimer( function() end, 120000, 1)
			end
		end
		
		-- Wanted points for criminals
		local playeraccount = getPlayerAccount( client )
		local wantedPoints = getAccountData( playeraccount, "acorp_stats_wanted_points" ) or 0
		setAccountData( playeraccount, "acorp_stats_wanted_points", wantedPoints + math.floor((wl*10)+1) )
		
		-- Sync wanted level
	    if not isTimer( wlCountdown[client] ) then
			wlCountdown[client] = setTimer( lowerWL, lowerWLTime, 0, client )
		end
		-- Make player count's as violent
		setPlayerWantedAC( client, (violentmult or 0) )
	end
end
addEvent( "setClientWL", true )
addEventHandler( "setClientWL", root, setClientWL, wl )

function setPlayerWantedAC( thePlayer, viol )
	if isElement( thePlayer ) and getElementType( thePlayer ) == "player" and viol then
		-- Set number of stars depending on wanted level 
		if tonumber( getElementData( thePlayer, "Wanted")) > 0 and tonumber( 
			getElementData( thePlayer, "Wanted")) <= 1 then
		   	setPlayerWantedLevel( thePlayer, 1 )
		elseif tonumber( getElementData( thePlayer, "Wanted")) > 1 and tonumber( 
			getElementData( thePlayer, "Wanted")) < 6 then
		   	setPlayerWantedLevel( thePlayer, math.floor( tonumber( 
		   	getElementData( thePlayer, "Wanted" ))))
		elseif tonumber( getElementData( thePlayer, "Wanted")) >= 6 then
		   	setPlayerWantedLevel( thePlayer, 6 )
		end
		if tonumber( getElementData( thePlayer, "Wanted" )) >= 2 and getPlayerTeam( thePlayer ) ~= getTeamFromName( "Criminals" ) then
			-- Turn into criminal if more than 2 stars and not a gangster already
			if getPlayerTeam(thePlayer) ~= getTeamFromName("Gangsters") then
				local team = getTeamFromName ( "Criminals" )
				setElementData( thePlayer, "Occupation", "Criminal", true ) 
				setPlayerNametagColor ( thePlayer, 200, 0, 0 )
				local skinID = exports.GTWclothes:getBoughtSkin ( thePlayer ) or 0
				fadeCamera( thePlayer, false, 1600, 255, 255, 255 )
				setTimer( setElementModel, 2000, 1, thePlayer, skinID )
				setTimer( setPlayerTeam, 2000, 1, thePlayer, team )
				setTimer( fadeCamera, 2400, 1, thePlayer, true, 1600, 255, 255, 255 )
				setElementData( thePlayer, "admin", false)
				exports.GTWtopbar:dm( "You are now a criminal!", thePlayer, 0, 255, 0 )
			
				-- Always consider as violent when becoming a criminal 2014-02-11
				violent[thePlayer] = setTimer( function() end, 600000, 1 )
			end
		end
		if not isTimer( wlCountdown[thePlayer] ) then
			wlCountdown[thePlayer] = setTimer( lowerWL, lowerWLTime, 0, thePlayer )
		end
		if not viol then
			viol = 0
		end
		if isTimer( violent[thePlayer] ) then
			local i1,i2,i3 = getTimerDetails( violent[thePlayer] )
			if math.floor(violentTime*viol) > i1 then
				killTimer( violent[thePlayer] )
				if math.floor(violentTime*viol) > 50 then
					violent[thePlayer] = setTimer( function() end, math.floor(violentTime*viol), 1 )
				end
			end
		elseif math.floor(violentTime*viol) > 50 then
			violent[thePlayer] = setTimer( function() end, math.floor(violentTime*viol), 1 )
		end
	end
end

function disableSelfDefence( thePlayer )
	if isElement( thePlayer ) then
		setElementData( thePlayer, "DM", false )
		killTimer( sdTimer[thePlayer] )
	end
end
-- Handle wasted players wanted level
function player_Wasted( ammo, attacker, weapon, bodypart )
	if attacker and isElement ( attacker ) and getElementType(attacker) == "player" and not getElementData( attacker, "SD" ) and attacker ~= source then
		-- onPlayerDamage won't catch all kills but a timer is used
		-- to make shore that this won´t trigger twice.
		if getPlayerTeam(attacker) and getElementType(attacker) == "player" then
			if ( lawTeams[getTeamName(getPlayerTeam( attacker ))] or getElementData(attacker,"Occupation") == "Farmer" ) and not isTimer( violent[source] ) and getPlayerWantedLevel( source ) < 3 then		-- Violent cops
				-- 2014-02-11 Cops will now get wanted for killing non violent players
				setElementData ( attacker, "Wanted", round( 
				getElementData( attacker, "Wanted" ) + 0.6, 2 ))
				
				-- Inform user about crime
				exports.GTWtopbar:dm( "You committed the crime of murder 0.6 stars", attacker, 255, 0, 0 )
				
				-- Sync wanted level
				setPlayerWantedAC( attacker, 1 )
			    if not isTimer( wlCountdown[attacker] ) then
					wlCountdown[attacker] = setTimer( lowerWL, lowerWLTime, 0, attacker )
				end
			elseif not lawTeams[getTeamName(getPlayerTeam( attacker ))] then
				-- Set data
				if getPlayerTeam( source ) == getTeamFromName( "Gangsters" ) then
					-- Anyone can kill a gangster without getting wanted, including gangsters who kill other gangsters
				elseif getPlayerTeam( source ) == getTeamFromName( "Criminals" ) then
					setElementData ( attacker, "Wanted", round( 
						getElementData( attacker, "Wanted" ) + 0.7, 2 ))
					-- Inform user about crime
					exports.GTWtopbar:dm( "You committed the crime of murder 0.7 stars", attacker, 255, 0, 0 )
				else
					setElementData ( attacker, "Wanted", round( 
						getElementData( attacker, "Wanted" ) + 2.2, 2 ))
					-- Inform user about crime
					exports.GTWtopbar:dm( "You committed the crime of murder 2.2 stars", attacker, 255, 0, 0 )
				end

				-- Turn into criminal
				if getPlayerTeam(attacker) ~= getTeamFromName("Gangsters") and attacker ~= source then
					local team = getTeamFromName ( "Criminals" )
					setElementData( attacker, "Occupation", "Criminal", true ) 
					setPlayerNametagColor ( attacker, 200, 0, 0 )
					local skinID = exports.GTWclothes:getBoughtSkin ( attacker ) or 0
					setTimer( setElementModel, 2000, 1, attacker, skinID )
					setTimer( setPlayerTeam, 2000, 1, attacker, team )
				
					-- Sync wanted level
					setPlayerWantedAC( attacker, 10 )
				end
			end
		end
	end
	
	-- Increase kills by 1
	if attacker and isElement(attacker) and getElementType(attacker) == "player" then
        local playeraccount = getPlayerAccount( attacker )
		local kills = getAccountData( playeraccount, "acorp_stats_kills" ) or 0
		setAccountData( playeraccount, "acorp_stats_kills", kills + 1 )
		
		-- Wanted points for criminals
		local wantedPoints = getAccountData( playeraccount, "acorp_stats_wanted_points" ) or 0
		setAccountData( playeraccount, "acorp_stats_wanted_points", wantedPoints + 10 )
	end
	-- Increase stats by 1
	if attacker and isElement(attacker) and getElementType(attacker) == "player" and 
		getPlayerTeam(attacker) and lawTeams[getTeamName(getPlayerTeam(attacker))] then
        local playeraccount = getPlayerAccount( attacker )
		local arrests = getAccountData( playeraccount, "acorp_stats_police_arrests_kill" ) or 0
		setAccountData( playeraccount, "acorp_stats_police_arrests_kill", arrests + 1 )
	end

	-- Get the wanted level as int
	local wl = tonumber(getElementData( source, "Wanted"))
	local suicide = false
	if not attacker then
		suicide = true
		if distanceToCop( source ) < 180 then
			attacker = nearestCop( source )
		else
			attacker = nil
		end
	end
	if attacker and isElement( attacker ) and getElementType( attacker ) ~= "player" then
		suicide = true
	end

	if getElementData( source, "arrestedPlayer" ) then
		local prisoner = getElementData( source, "arrestedPlayer" )
		setElementData( prisoner, "arrested", false )
		setElementData( source, "arrestedPlayer", nil )
		exports.GTWtopbar:dm( "You have been released!", prisoner, 0, 255, 0 )
		exports.GTWtopbar:dm( "You lost the suspect!", source, 255, 0, 0 )
		setElementFrozen( prisoner, false )
	end
	
	-- Move player to jail if kill arrested
	if wl and wl > 0 and isElement(attacker) and getElementType( attacker ) == "player" and 
		lawTeams[getTeamName(getPlayerTeam( attacker ))] and getPlayerWantedLevel( source ) > 0 and
		isTimer( violent[source] ) then
		setTimer( Jail, 11000, 1, source, attacker )
		if suicide then
			givePlayerMoney( attacker, math.floor( wl*55 ))
		end
		if not suicide and attacker then
			exports.GTWtopbar:dm( "You kill arrested "..getPlayerName(source).."!", attacker, 0, 255, 0 )
		elseif attacker then
			exports.GTWtopbar:dm( "You arrested a suicider!", attacker, 0, 255, 0 )
		end
		exports.GTWtopbar:dm( "You have been kill arrested by the cop: "..getPlayerName(attacker).."!", source, 255, 0, 0 )
			
		-- Remove jail markers
        for k=1, #marker do
       		if marker[k] then
	      		if isElement( marker[k][source] ) then
	    			destroyElement( marker[k][source] )
	    		end
	    	end
		end
		for j=1, #blips	do
			if blipList[j] then
				if isElement( blipList[j][source] ) then
	    			destroyElement( blipList[j][source] )
	    		end
	    	end
		end
	end
	if isTimer( prisonerSyncTimers[source] ) then
		killTimer( prisonerSyncTimers[source] )
	end

	if isElement( attacker ) and getElementType( attacker ) == "player" then
		playerDamage ( attacker, weapon, bodypart ) 
		if getElementType( attacker ) == "player" then
			-- if victim is clean
			if not getElementData( source, "DM" ) then
				setElementData( attacker, "DM", source )
				setElementData( source, "DM", false )
				outputServerLog( "DTF: "..getPlayerName(attacker).."["..getPlayerWantedLevel(attacker)..
					"]["..getTeamName(getPlayerTeam(attacker)).."] killed: "..getPlayerName(source)..
					"["..getPlayerWantedLevel(source).."]["..getTeamName(getPlayerTeam(source)).."] DM" )
				if isTimer( sdTimer[attacker] ) then
					killTimer( sdTimer[attacker] )
				end
				sdTimer[attacker] = setTimer( disableSelfDefence, 300000, 1, attacker )
			else
				outputServerLog( "DTF: "..getPlayerName(attacker).."["..getPlayerWantedLevel(attacker)..
					"]["..getTeamName(getPlayerTeam(attacker)).."] killed: "..getPlayerName(source)..
					"["..getPlayerWantedLevel(source).."]["..getTeamName(getPlayerTeam(source)).."] SD" )
				-- 2014-02-20 self defence act is completed
				setElementData( attacker, "DM", false )
				setElementData( source, "DM", false )
			end
		else
			outputServerLog( "DTF: "..getPlayerName(source).." died for unknown reason" )
		end
		
		-- Send alarm call to all the cops		
		for theKey,cop in pairs(getElementsByType("player")) do 
			if getPlayerTeam( cop ) and lawTeams[getTeamName(getPlayerTeam( cop ))] then
				cx,cy,cz = getElementPosition( attacker )
				if getElementData( attacker, "DM" ) then
					outputChatBox( "#BBBBBB(911): #EEEEEEA murder has been committed at: "..getZoneName( cx, cy, cz ), cop, 255, 255, 255, true )
				else
					outputChatBox( "#BBBBBB(911): #EEEEEE10-32A at: "..getZoneName( cx, cy, cz )..", injured players has been seen", cop, 255, 255, 255, true )
				end
	   		end
	   	end
		
		local theTeam = getPlayerTeam ( attacker )
		
		-- Get the wanted level as int
		local wl = tonumber(getElementData( source, "Wanted"))
		if wl > 0 and wl < 1 then
			wl = 1
		elseif wl >= 1 then
			wl = math.ceil(getElementData( source, "Wanted"))
		end 
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), player_Wasted )



-- starting WL countdown
function onCurrentResourceStart(theResource)
	local players = getElementsByType( "player" )
   	for theKey,p in pairs(players) do 
   		if isTimer( sdTimer[p] ) then
			killTimer( sdTimer[p] )
		end
		if getPlayerWantedLevel( p ) > 0 then
			if not isTimer( wlCountdown[p] ) then
				wlCountdown[p] = setTimer( lowerWL, lowerWLTime, 0, p )
			end
	   	end
	   	
	   	-- Release all criminals
	   	if getElementData( p, "Jailed" ) == "Yes" then
	   		releaseFromJail( p, math.random(#releasePoints))
	   	end
	   	
	   	-- Index array
	   	for k=1, #marker do
			marker[k] = {}
			blipList[k] = {}
		end
	   	
	   	-- Reset data variables
	   	setElementData( p, "DM", false )
	   	setElementData( p, "Wanted", 0 )
	   	setElementData( p, "Jailed", "" )
	   	setElementData( p, "arrestedPlayer", false )
	   	setElementData( p, "arrested", false )
	   	
	   	-- Sync wanted level
		setPlayerWantedAC( p, 0 )
	   	
	   	-- Release and reenable controls
	   	setPedAnimation( p, nil, nil )
		toggleControl( p, "jump", true )
        toggleControl( p, "sprint", true )
        toggleControl( p, "crouch", true )
        toggleControl( p, "fire", true )
        toggleControl( p, "aim_weapon", true )
        toggleControl( p, "enter_exit", true )
        toggleControl( p, "enter_passenger", true )
        
        -- Start tracker
        if isTimer( trackSyncer[p] ) then
        	killTimer( trackSyncer[p] )
        end
        trackSyncer[p] = setTimer( syncTracker, 100, 0, p )
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), onCurrentResourceStart)

-- Fix from 2014-02-12 to prevent reconnecting reset of violent time
function setViolentStatus( thePlayer )
	if isElement( thePlayer ) and getPlayerWantedLevel( thePlayer ) > 0 then
		violent[thePlayer] = setTimer( function() end, violentTime, 1 )
	end
end

function syncTracker( cop ) 
	local dist = distanceToCrim( cop )
	if dist < 3100 and dist > 180 then
		setElementData( cop, "distToCrim", tostring(math.floor(dist)).."m, "..directionToCrim(cop))
	elseif dist >= 3100 then
		setElementData( cop, "distToCrim", "?" )
	elseif dist <= 180 then
		setElementData( cop, "distToCrim", "very close" )
	end
end

addEventHandler("onPlayerLogin", getRootElement(),
function()
    setTimer( setViolentStatus, 300, 1, source )
    if isTimer( trackSyncer[source] ) then
        killTimer( trackSyncer[source] )
    end
    trackSyncer[source] = setTimer( syncTracker, 100, 0, source )
    wlCountdown[source] = setTimer( lowerWL, lowerWLTime, 0, source )
end)

function playerQuit( quitType )
	if isTimer( trackSyncer[source] ) then
        killTimer( trackSyncer[source] )
    end
end
addEventHandler ( "onPlayerQuit", getRootElement(), playerQuit )]]--