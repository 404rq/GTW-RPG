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

-- Money earnings ~$2500/rob 6 robberies/hour max $15´000/hour

ped = { }
peds = {
	-- Clothes shops
	--x, y, z, dimension, interior, rotation, skinID, nameOfStore
	[1]={ 161, -81, 1001.8046875, 3, 18, 180, 93, "Zip clothes shop" },
	[2]={ 161, -81, 1001.8046875, 2, 18, 180, 226, "Zip clothes shop" },
	[3]={ 161, -81, 1001.8046875, 1, 18, 180, 93, "Zip clothes shop" },
	[4]={ 161, -81, 1001.8046875, 0, 18, 180, 192, "Zip clothes shop" },

	[5]={ 204.7978515625, -7.896484375, 1001.2109375, 2, 5, 270, 233, "Victim" },
	[6]={ 204.7978515625, -7.896484375, 1001.2109375, 1, 5, 270, 93, "Victim" },
	[7]={ 204.7978515625, -7.896484375, 1001.2109375, 0, 5, 270, 93, "Victim" },

	[8]={ 203.4, -41.7, 1001.8046875, 2, 1, 180, 192, "Sub Urban" },
	[9]={ 203.4, -41.7, 1001.8046875, 1, 1, 180, 93, "Sub Urban (Hashbury)" },
	[10]={ 203.4, -41.7, 1001.8046875, 0, 1, 180, 93, "Sub Urban" },

	[11]={ 204.2080078125, -157.8193359375, 1000.5234375, 0, 14, 180, 226, "DidierSachs (Rodeo)" },

	[12]={ 206.3759765625, -127.5380859375, 1003.5078125, 1, 3, 180, 233, "Pro Laps" },
	[13]={ 206.3759765625, -127.5380859375, 1003.5078125, 0, 3, 180, 192, "Pro Laps (Rodeo)" },

	[14]={ 206.3349609375, -98.703125, 1005.2578125, 3, 15, 180, 192, "Binco clothes shop" },
	[15]={ 206.3349609375, -98.703125, 1005.2578125, 2, 15, 180, 233, "Binco clothes shop" },
	[16]={ 206.3349609375, -98.703125, 1005.2578125, 1, 15, 180, 192, "Binco clothes shop" },
	[17]={ 206.3349609375, -98.703125, 1005.2578125, 0, 15, 180, 233, "Binco clothes shop (Ganton)" },

	-- Banks
	[18]={ 356.2509765625, 168.93359375, 1008.3763427734, 0, 3, 270, 192, "Bank of Las Venturas" },
	[19]={ 356.126953125, 165.9638671875, 1008.3766479492, 0, 3, 270, 233, "Bank of Las Venturas" },
	[20]={ 356.259765625, 185.7578125, 1008.3762817383, 0, 3, 270, 93, "Bank of Las Venturas" },
	[21]={ 356.0908203125, 179.4306640625, 1008.3767089844, 0, 3, 270, 226, "Bank of Las Venturas" },

	[22]={ 356.2509765625, 168.93359375, 1008.3763427734, 1, 3, 270, 192, "Bank of Los Santos" },
	[23]={ 356.126953125, 165.9638671875, 1008.3766479492, 1, 3, 270, 226, "Bank of Los Santos" },
	[24]={ 356.259765625, 185.7578125, 1008.3762817383, 1, 3, 270, 93, "Bank of Los Santos" },
	[25]={ 356.0908203125, 179.4306640625, 1008.3767089844, 1, 3, 270, 233, "Bank of Los Santos" },

	[26]={ 356.2509765625, 168.93359375, 1008.3763427734, 2, 3, 270, 192, "Bank of San Fierro" },
	[27]={ 356.126953125, 165.9638671875, 1008.3766479492, 2, 3, 270, 226, "Bank of San Fierro" },
	[28]={ 356.259765625, 185.7578125, 1008.3762817383, 2, 3, 270, 223, "Bank of San Fierro" },
	[29]={ 356.0908203125, 179.4306640625, 1008.3767089844, 2, 3, 270, 93, "Bank of San Fierro" },
}

-- Trigger respawn each 12 hour
cancelTimers = {}
function loadPeds()
	respawn_all_peds()
	setTimer(respawn_all_peds, 60*60*12*1000, 0)
end
addEventHandler("onResourceStart", resourceRoot, loadPeds)

-- Respawn all peds
function respawn_all_peds()
	for k=1, #peds do
		-- Destroy element if it exist
		if isElement(ped[k]) then destroyElement(ped[k]) end

		-- Create the ped
    	ped[k] = createPed( peds[k][7], peds[k][1], peds[k][2], peds[k][3] )
		setElementDimension( ped[k], peds[k][4] )
		setElementInterior( ped[k], peds[k][5] )
		setPedRotation( ped[k], peds[k][6] )
		setElementData( ped[k], "robLoc", peds[k][8] )
	end
end

-- Robbery time
function CounterTime( crim )
	if isElement( crim ) then
		local time = getTickCount( )
		setElementData( crim, "robTime2", time )
	end
end

-- Define law
lawTeams = {
	[getTeamFromName("Government")] = true,
	[getTeamFromName("Emergency service")] = true
}
-- Antispam timer
robTimer = {{ }}

-- Do the rob
function robStore( target )
	if getElementType( target ) == "ped" and ((robTimer[target] and not isTimer(robTimer[target][client])) or not robTimer[target]) then
		-- Robbery in progress
		setElementData( client, "rob", true )
		local money = math.random( 2450, 2500 )
		local robtime = math.random(30000, 90000)

		-- Allow count down timer
		setElementData( client, "robTime", robtime+getTickCount( ))
		setElementData( client, "robTime2", getTickCount( ))
		setTimer( CounterTime, 1000, (math.floor(robtime)/1000), client )

		-- When the robbery is finished
	    setTimer( payForRob, robtime, 1, client, money )
	    setTimer( robStatus, robtime, 1, client, target )
	    cancelTimers[client] = setTimer( cancelRob, (math.floor(robtime)/100), 100, client, target )

	    -- Set the wanted level 4 stars and 15 minutes violent
		exports.GTWwanted:setWl(client, 4, 500, "You committed the crime of robbery")
		setPedAnimation( target, "shop", "shp_rob_givecash", -1, false, false, false )

		-- Send alarm call to all the cops
		local robLoc = getElementData( target, "robLoc" )
		if not robLoc then
			robLoc = "Unknown store"
		end
		if getElementData( client, "lastLoc" ) then
			robLoc = robLoc.." ("..getElementData( client, "lastLoc" )..")"
		end
		exports.GTWtopbar:dm( "You have robbed "..robLoc..", stay inside!", client, 255, 200, 0 )
		local cops = getElementsByType( "player" )
		for theKey,cop in ipairs(cops) do
			if lawTeams[getPlayerTeam(cop)] then
				outputChatBox( "#0000BB(911): #EEEEEERobbery in progress at: "..robLoc, cop, 255, 255, 255, true )
				exports.GTWtopbar:dm( "Robbery in progress at: "..robLoc, cop, 255, 0, 0 )
			end
		end

		-- Set cooldown timer for store to 30 minutes
		if not robTimer[target] then robTimer[target] = { } end
		robTimer[target][client] = setTimer(function() end, 1800000, 1 )
	elseif robTimer[target] and robTimer[target][client] and isTimer(robTimer[target][client]) then
		exports.GTWtopbar:dm( "Get the hell out of here, this shop was recently robbed!", client, 255, 0, 0 )
	end
end
addEvent( "onRob", true )
addEventHandler( "onRob", root, robStore )

function payForRob( crim, amount )
	if isElement( crim ) then
		if getElementData( crim, "rob" ) then
			givePlayerMoney( crim, amount )

			-- Increase stats by 1
			local playeraccount = getPlayerAccount( crim )
			local robs = getAccountData( playeraccount, "GTWdata_stats_rob_count" ) or 0
			setAccountData( playeraccount, "GTWdata_stats_rob_count", robs + 1 )

			-- Wanted points for criminals
			local wantedPoints = getAccountData( playeraccount, "GTWdata_stats_wanted_points" ) or 0
			setAccountData( playeraccount, "GTWdata_stats_wanted_points", wantedPoints + 40)
		end
	end
end

function robStatus( crim, target, money )
	if isElement( crim ) then
		if getElementData( crim, "rob" ) then
			exports.GTWtopbar:dm( "Rob successfully, now escape before the cops arrive!", crim, 0, 255, 0 )
	    end
	    if isElement( target ) and isElement( crim ) then
			setPedAnimation( target, nil, nil )
			setElementData( crim, "rob", false )
		end
	end
end

-- Check if the rob should be interrupted
function cancelRob( crim, target )
	if isElement( crim ) then
		if getElementInterior( crim ) == 0 or getElementData( crim, "arrested" ) or getElementData( crim, "Jailed" ) == "Yes" then
			setElementData( crim, "rob", false )
			exports.GTWtopbar:dm( "Robbery failed because you left the store!", crim, 255, 0, 0 )
			setPedAnimation( target, nil, nil )
			if isTimer( cancelTimers[crim] ) then
				killTimer( cancelTimers[crim] )
			end
		end
	end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

-- Round float values
function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end
