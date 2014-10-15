--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

-- Private members
players = {}
lastMsg = {}

-- Public transportation
passengerBlips = { }
driversBlips = { }

-- Send SMS to another user
function sendSMS( to, message )
	message = pregReplace( message, "\n", " ", 2 )
	if string.len(message) > 1 and lastMsg[client] ~= message and not isPlayerMuted( client ) then
		if string.len(message) < 128 then
    		outputChatBox( "(SMS) "..getPlayerName(client).." -> "..getPlayerName(to)..": "..RGBToHex( 230, 230, 230 )..message, client, 200, 200, 200, true )
	    	outputChatBox( "(SMS) "..getPlayerName(client)..": "..RGBToHex( 230, 230, 230 )..message, to, 200, 200, 200, true )
	    else
	    	outputChatBox( "(SMS) From: "..getPlayerName(client).." "..RGBToHex( 230, 230, 230 ).."Press B to open your phone and view it", to, 200, 200, 200, true )
	    end
	    triggerClientEvent( to, "onSMSReceive", to, message, getPlayerName(client))
	    triggerClientEvent( client, "onSMSReceive", client, message, getPlayerName(client))
	    exports.GTWtopbar:dm( "SMS: You may now use /re to quick reply to your most recent connection", from, 0, 255, 0 )
	    players[client] = to
	    players[to] = client
	    lastMsg[client] = message
	    
	    -- Server logs added 2014-02-11
	    outputServerLog( "SMS: "..getPlayerName(client).." -> "..getPlayerName(to)..": "..message )
	elseif string.len(message) < 2 then
		exports.GTWtopbar:dm( "You can't send empty messages", client, 255, 0, 0 )
	elseif lastMsg[client] == message then
		exports.GTWtopbar:dm( "Do not repeat yourself!", client, 255, 0, 0 )
	elseif isPlayerMuted( client ) then
		exports.GTWtopbar:dm( "You can't send sms while being muted", client, 255, 0, 0 )
	end
end
addEvent( "onSendSMS", true )
addEventHandler( "onSendSMS", root, sendSMS )

-- Reply to SMS
function reply( from, commandName, ... )
	local arg = {...}
	local message = table.concat( arg, " " )
    if string.len(message) > 1 and lastMsg[from] ~= message and not isPlayerMuted( from ) and isElement( players[from] ) then
    	if string.len(message) < 128 then
    		outputChatBox( "(SMS) "..getPlayerName(from).." -> "..getPlayerName(players[from])..": "..RGBToHex( 230, 230, 230 )..message, from, 200, 200, 200, true )
	    	outputChatBox( "(SMS) "..getPlayerName(from)..": "..RGBToHex( 230, 230, 230 )..message, players[from], 200, 200, 200, true )
	    end
	    triggerClientEvent( players[from], "onSMSReceive", players[from], message, getPlayerName(from))
	    triggerClientEvent( from, "onSMSReceive", from, message, getPlayerName(from))
	    lastMsg[from] = message
	    
	    -- Server logs added 2014-02-11
	    outputServerLog( "SMS: "..getPlayerName(from).." -> "..getPlayerName(players[from])..": "..message )
	elseif string.len(message) < 2 then
		exports.GTWtopbar:dm( "You can't send empty messages", from, 255, 0, 0 )
	elseif isPlayerMuted( from ) then
		exports.GTWtopbar:dm( "You can't send sms while being muted", from, 255, 0, 0 )
	elseif lastMsg[from] == message then
		exports.GTWtopbar:dm( "Do not repeat yourself!", client, 255, 0, 0 )
	else
    	exports.GTWtopbar:dm( "The person you want to SMS is not available now", from, 255, 0, 0)
	end
end
addCommandHandler( "re", reply )

-- Open phone
function doAnimStart( )
	if not getPedOccupiedVehicle( client ) then
    	setPedAnimation( client, "ped", "phone_in", -1, false )
    end
end
addEvent( "onPhoneOpen", true )
addEventHandler( "onPhoneOpen", root, doAnimStart )

-- Close phone
function doAnimEnd( )
	if not getPedOccupiedVehicle( client ) then
    	setPedAnimation( client, "ped", "phone_out", -1, false )
    	setTimer( phoneOut, 2000, 1, client )
    end
end
addEvent( "onPhoneClose", true )
addEventHandler( "onPhoneClose", root, doAnimEnd )

function phoneOut( player )
	if isElement( player ) then
		setPedAnimation( player, false )
	end
end

-- Make phone call
cooldown = {}
function sendCall( rec )
	local counter = 0
	if rec == "(911) Police" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Police" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			for playerKey, playerValue in ipairs( players ) do
				if getPlayerTeam( playerValue ) == getTeamFromName( "Police" ) then
					exports.GTWtopbar:dm( getPlayerName(client).." need police assistance at: "..getZoneName(getElementPosition(client)), playerValue, 0, 0, 255 )
				else
					exports.GTWtopbar:dm( getPlayerName(client).." has called the police from: "..getZoneName(getElementPosition(client)), playerValue, 0, 0, 255 )
				end
				counter = counter + 1
			end
		end
    elseif rec == "(911) Ambulance" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Emergency service" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			for playerKey, playerValue in ipairs( players ) do
				if getPlayerTeam( playerValue ) == getTeamFromName( "Emergency service" ) then
					exports.GTWtopbar:dm( getPlayerName(client).." need medics to back him up at: "..getZoneName(getElementPosition(client)), playerValue, 255, 0, 0 )
				else
					exports.GTWtopbar:dm( getPlayerName(client).." require a paramedic at: "..getZoneName(getElementPosition(client)), playerValue, 255, 0, 0 )
				end
				counter = counter + 1
			end
		end
	elseif rec == "(911) Fire Department" and not isTimer( cooldown[client] ) and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Emergency service" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			for playerKey, playerValue in ipairs( players ) do
				if getPlayerTeam( playerValue ) == getTeamFromName( "Emergency service" ) then
					exports.GTWtopbar:dm( getPlayerName(client).." need more firemen to: "..getZoneName(getElementPosition(client)), playerValue, 255, 0, 0 )
				else
					exports.GTWtopbar:dm( getPlayerName(client).." has reported a fire at: "..getZoneName(getElementPosition(client)), playerValue, 255, 0, 0 )
				end
				counter = counter + 1
			end
		end
	elseif rec == "Mechanic" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Civilians" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			for playerKey, playerValue in ipairs( players ) do
				if getElementData( playerValue, "Occupation" ) == "Mechanic" then
					exports.GTWtopbar:dm( getPlayerName(client).." need a mechanic at: "..getZoneName(getElementPosition(client)), playerValue, 255, 200, 0 )
					counter = counter + 1
				end
			end
		end
	elseif rec == "Taxi" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Civilians" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			notePublicTransport( client, "phone" )
			for playerKey, playerValue in ipairs( players ) do
				if getElementData( playerValue, "Occupation" ) == "Taxi Driver" then
					exports.GTWtopbar:dm( getPlayerName(client).." need a taxi at: "..getZoneName(getElementPosition(client)), playerValue, 255, 200, 0 )
					counter = counter + 1
				end
			end
		end
	elseif rec == "Pilot" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Civilians" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			notePublicTransport( client, "phone" )
			for playerKey, playerValue in ipairs( players ) do
				if getElementData( playerValue, "Occupation" ) == "Pilot" then
					exports.GTWtopbar:dm( getPlayerName(client).." need a pilot at: "..getZoneName(getElementPosition(client)), playerValue, 255, 200, 0 )
					counter = counter + 1
				end
			end
		end
	elseif rec == "Bus Driver" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Civilians" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			notePublicTransport( client, "phone" )
			for playerKey, playerValue in ipairs( players ) do
				if getElementData( playerValue, "Occupation" ) == "Bus Driver" then
					exports.GTWtopbar:dm( getPlayerName(client).." need a bus at: "..getZoneName(getElementPosition(client)), playerValue, 255, 200, 0 )
					counter = counter + 1
				end
			end
		end
	elseif rec == "Fast food delivery" and not isTimer( cooldown[client] ) then
		local theTeam = getTeamFromName( "Civilians" )
		if ( theTeam ) then
			local players = getPlayersInTeam( theTeam )
			for playerKey, playerValue in ipairs( players ) do
				if getElementData( playerValue, "Occupation" ) == "Pizza delivery man" then
					exports.GTWtopbar:dm( getPlayerName(client).." need a fast food delivery at: "..getZoneName(getElementPosition(client)), playerValue, 255, 200, 0 )
					counter = counter + 1
				end
			end
		end
	end
	if isTimer( cooldown[client] ) then
		exports.GTWtopbar:dm( "Due to spam you can't call right now, wait a couple of seconds then try again.", client, 255, 0, 0 )
	else
    	exports.GTWtopbar:dm( "Your call was sent to "..tostring(counter).." service workers.", client, 0, 255, 0 )
    	cooldown[client] = setTimer( function() end, 30000, 1 )
    end
end
addEvent( "onSendCall", true )
addEventHandler( "onSendCall", root, sendCall )

-- Vehicle enter
function enterVehicle( thePlayer, seat, jacked ) 
    if getElementType( thePlayer ) == "player" then
        -- Public transportation
        if seat > 0 then
        	if getVehicleOccupants( source ) and getVehicleOccupants( source )[0] and isElement( driversBlips[getVehicleOccupants( source )[0]] ) then
		     	destroyElement( driversBlips[getVehicleOccupants( source )[0]] )
		    end
		    local playerList = getElementsByType ( "player" ) 
			for w,player in pairs(playerList) do 
				local ptTeam = getTeamFromName( "Civilians" )
				if not passengerBlips[thePlayer] then
		     		passengerBlips[thePlayer] = {}
		     	end
		     	if isElement( passengerBlips[thePlayer][w] ) then
		     		destroyElement( passengerBlips[thePlayer][w] )
		     	end
		    end
	    end
    end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), enterVehicle )

function notePublicTransport( source, cmd )
	local counter = 0
    local players = getElementsByType ( "player" ) 
	for k,player in pairs(players) do 
		local ptTeam = getTeamFromName( "Civilians" )
		if not passengerBlips[source] then
     		passengerBlips[source] = {}
     	end
     	if isElement( passengerBlips[source][k] ) then
     		destroyElement( passengerBlips[source][k] )
     	end
		if ( ptTeam == getPlayerTeam( player ) and ( getElementData( player, "Occupation" ) == "Taxi Driver" or 
			getElementData( player, "Occupation" ) == "Pilot" or getElementData( player, "Occupation" ) == "Bus Driver" or 
			getElementData( player, "Occupation" ) == "Tram Driver" or getElementData( player, "Occupation" ) == "Train Driver")) and
			not getPedOccupiedVehicle( source ) then 

	  		counter = (counter + 1)
  			local x,y,z = getElementPosition( source )
     		exports.GTWtopbar:dm( getPlayerName( source ).." has called for transportation at: "..getZoneName(x,y,z), player, 0, 255, 0)
     		outputChatBox( getPlayerName( source ).." has called for transportation at: "..getZoneName(x,y,z), player, 0, 150, 0)
     		if isElement( driversBlips[player] ) then
     			destroyElement( driversBlips[player] )
     		end
     		driversBlips[player] = createBlipAttachedTo( player, 60, 2, 0, 0, 0, 255, 10, 999999, source )
     		passengerBlips[source][k] = createBlipAttachedTo( source, 62, 2, 0, 0, 0, 255, 10, 999999, player )
     	elseif getPedOccupiedVehicle( source ) then
     		exports.GTWtopbar:dm( "You can't request public transportation from inside a vehicle", source, 255, 0, 0)
		end 
	end
	if counter > 0 then
		exports.GTWtopbar:dm( "Your message has been sent to "..tostring(counter).." drivers", source, 0, 255, 0)
		outputChatBox( "Your message has been sent to "..tostring(counter).." drivers", source, 0, 150, 0)
	else
		exports.GTWtopbar:dm( "There is no drivers available now, please try again later", source, 255, 0, 0)
	end
end
addCommandHandler( "taxi", notePublicTransport )
addCommandHandler( "pilot", notePublicTransport )
addCommandHandler( "bus", notePublicTransport )
addCommandHandler( "train", notePublicTransport )
addCommandHandler( "tram", notePublicTransport )

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end