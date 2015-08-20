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

-- Private members
players = {}
lastMsg = {}

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
function reply_to_sms( plr_from, commandName, ... )
	local arg = {...}
	local message = table.concat( arg, " " )
    if string.len(message) > 1 and lastMsg[plr_from] ~= message and not isPlayerMuted( plr_from ) and isElement( players[plr_from] ) then
    	if string.len(message) < 128 then
    		outputChatBox( "(SMS) "..getPlayerName(plr_from).." -> "..getPlayerName(players[plr_from])..": "..RGBToHex( 230, 230, 230 )..message, plr_from, 200, 200, 200, true )
	    	outputChatBox( "(SMS) "..getPlayerName(plr_from)..": "..RGBToHex( 230, 230, 230 )..message, players[plr_from], 200, 200, 200, true )
	    end
	    triggerClientEvent( players[plr_from], "onSMSReceive", players[plr_from], message, getPlayerName(plr_from))
	    triggerClientEvent( plr_from, "onSMSReceive", plr_from, message, getPlayerName(plr_from))
	    lastMsg[plr_from] = message

	    -- Server logs added 2014-02-11
	    outputServerLog( "SMS: "..getPlayerName(plr_from).." -> "..getPlayerName(players[plr_from])..": "..message )
	elseif string.len(message) < 2 then
		exports.GTWtopbar:dm( "You can't send empty messages", plr_from, 255, 0, 0 )
	elseif isPlayerMuted( plr_from ) then
		exports.GTWtopbar:dm( "You can't send sms while being muted", plr_from, 255, 0, 0 )
	elseif lastMsg[plr_from] == message then
		exports.GTWtopbar:dm( "Do not repeat yourself!", client, 255, 0, 0 )
	else
    	exports.GTWtopbar:dm( "The person you want to SMS is not available now", plr_from, 255, 0, 0)
	end
end
addCommandHandler("re", reply_to_sms)
addCommandHandler("reply", reply_to_sms)

-- Open phone
function animate_open_phone( )
	if not getPedOccupiedVehicle( client ) then
    	setPedAnimation( client, "ped", "phone_in", -1, false )
    end
end
addEvent( "onPhoneOpen", true )
addEventHandler( "onPhoneOpen", root, animate_open_phone )

-- Close phone
function animate_close_phone( )
	if not getPedOccupiedVehicle( client ) then
    	setPedAnimation( client, "ped", "phone_out", -1, false )
    	setTimer( put_phone_in_pocket, 2000, 1, client )
    end
end
addEvent( "onPhoneClose", true )
addEventHandler( "onPhoneClose", root, animate_close_phone )

-- Stop animation
function put_phone_in_pocket( plr )
	if isElement( plr ) then
		setPedAnimation( plr, nil, nil )
	end
end

-- Make phone call
cooldown = {}
function call_service( rec )
	local counter = 0
	local plr_name = getPlayerName(client)
	if rec == "Law enforcement" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Government") then
			local workers = getPlayersInTeam(getTeamFromName("Government"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Government" ) then
					exports.GTWtopbar:dm( plr_name.." need police assistance at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				else
					exports.GTWtopbar:dm( plr_name.." has called the police from: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
    elseif rec == "Ambulance" and not isTimer( cooldown[client] ) then
    	if getTeamFromName("Emergency service") then
			local workers = getPlayersInTeam(getTeamFromName("Emergency service"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Emergency service" ) then
					exports.GTWtopbar:dm( plr_name.." need medics to back him up at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				else
					exports.GTWtopbar:dm( plr_name.." require a paramedic at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	elseif rec == "Fire Department" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Emergency service") then
			local workers = getPlayersInTeam(getTeamFromName("Emergency service"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Emergency service" ) then
					exports.GTWtopbar:dm( plr_name.." need more firemen to: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				else
					exports.GTWtopbar:dm( plr_name.." has reported a fire at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	elseif rec == "Mechanic" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Civilians") then
			local workers = getPlayersInTeam(getTeamFromName("Civilians"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Civilians" ) and getElementData( v, "Occupation" ) == "Mechanic"then
					exports.GTWtopbar:dm( plr_name.." need a mechanic at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	elseif rec == "Taxi" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Civilians") then
			local workers = getPlayersInTeam(getTeamFromName("Civilians"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Civilians" ) and getElementData( v, "Occupation" ) == "Taxi Driver"then
					exports.GTWtopbar:dm( plr_name.." need a taxi at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	elseif rec == "Pilot" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Civilians") then
			local workers = getPlayersInTeam(getTeamFromName("Civilians"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Civilians" ) and getElementData( v, "Occupation" ) == "Pilot"then
					exports.GTWtopbar:dm( plr_name.." need a pilot at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	elseif rec == "Bus Driver" and not isTimer( cooldown[client] ) then
		if getTeamFromName("Civilians") then
			local workers = getPlayersInTeam(getTeamFromName("Civilians"))
			for k, v in pairs(workers) do
				if getPlayerTeam(v) and getPlayerTeam(v) == getTeamFromName( "Civilians" ) and getElementData( v, "Occupation" ) == "Bus Driver"then
					exports.GTWtopbar:dm( plr_name.." need a bus driver at: "..getZoneName(getElementPosition(client)), v, 255, 100, 0 )
				end
				local dest_blip = createBlipAttachedTo( v, 41, 2, 0,0,0, 255, 10, 99999, client)
				setTimer(destroyElement, 60000, 1, dest_blip)
				counter = counter + 1
			end
		end
	end

	-- Check for spam or show the status
	if isTimer( cooldown[client] ) then
		exports.GTWtopbar:dm( "Due to spam you can't call right now, wait a couple of seconds then try again.", client, 255, 0, 0 )
	else
    	exports.GTWtopbar:dm( "Your call was sent to "..tostring(counter).." service workers.", client, 0, 255, 0 )
    	cooldown[client] = setTimer( function() end, 30000, 1 )
    end
end
addEvent( "GTWphone.onSendCall", true )
addEventHandler( "GTWphone.onSendCall", root, call_service )

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

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
