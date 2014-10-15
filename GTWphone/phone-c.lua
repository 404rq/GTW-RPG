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

-- Define data members
sound = nil
volume = 80
bindKey( "B", "down", "phone" )

-- Local bools
local isRadioOn = false

-- Radio list
radio = {
	{ "", " Swedish radio", 0 },
	{ "http://stream-ice.mtgradio.com:8080/stat_bandit.m3u", "Bandit rock", 1 },
	{ "http://www.listenlive.eu/rockklassiker.m3u", "Classical Rock", 1 },
	{ "http://sverigesradio.se/topsy/direkt/2576-hi-aac.pls", "Malmö (Hiphop/RnB)", 1 },
	{ "http://www.listenlive.eu/mixmegapol.m3u", "Mix megapol", 1 },
	{ "http://www.listenlive.eu/nrj_se.m3u", "NRJ Sweden", 1 },
	{ "http://scb2.fantis.se:8080/listen.pls", "Pirate rock", 1 },
	{ "http://stream-ice.mtgradio.com:8080/stat_rix_fm.m3u", "Rix FM", 1 },	
	{ "http://www.listenlive.eu/thevoice_se.m3u", "The voice", 1 },
	{ "", " Rap and Hiphop", 0 },
	{ "http://shoutcast.unitedradio.it:1113/listen.pls", "105 Hip hop", 1 },
	{ "http://www.jam.fm/streams/black-n-dance/jamfm.m3u", "Jam FM", 1 },
	{ "http://91.121.223.159:8000/move.m3u", "Move FM", 1 },
	{ "http://relay.181.fm:8068", "Old School Rap", 1 },
	{ "http://www.skyrock.fm/stream.php/yourplayer_64.pls", "Skyrock", 1 },
	{ "http://50.22.212.196:8132", "Underground radio", 1 },
	{ "http://broadcast.infomaniak.ch/onlyrai-high.mp3.m3u", "Urban hit", 1 },
	{ "", " Jazz", 0 },
	{ "http://sj128.hnux.com/listen.pls", "Smooth Jazz", 1 },
	{ "", " Techno", 0 },
	{ "http://tunein.t4e.dj/hard/dsl/mp3", "Techno4ever Hard stream", 1 },
	{ "http://tunein.t4e.dj/club/dsl/mp3", "Techno4ever Clup stream", 1 },
	{ "", " Digitally imported", 0 },
	{ "http://listen.di.fm/public3/clubdubstep.pls?a5e45b0f69e2910bde3edcd4", "Digitally Imported Big Room House", 1 },
	{ "http://listen.di.fm/public3/club.pls?a5e45b0f69e2910bde3edcd4", "Digitally Imported Club Dubstep", 1 },
	{ "http://listen.di.fm/public3/electro.pls?a5e45b0f69e2910bde3edcd4", "Digitally Imported Club Sounds", 1 },
	{ "http://listen.di.fm/public3/electro.pls?a5e45b0f69e2910bde3edcd4", "Digitally Imported Electro House", 1 },
	{ "http://listen.di.fm/public3/djmixes.pls?a5e45b0f69e2910bde3edcd4", "Digitally Imported DJ mixes", 1 },
	{ "", " Mixed stations", 0 },
	{ "http://www.181.fm/winamp.pls?station=181-power&style=mp3&description=Power%20181%20(Top%2040)&file=181-power.pls", "Power 181", 1 },
	{ "http://46.165.204.52:38231/listen.pls", "Power69", 1 },
	{ "http://www.radiogold.de/listen.pls", "Radio Gold (Germany)", 1 },
	{ "http://217.151.151.91/live4.m3u", "Radio regenbogen (Germany)", 1 },
	{ "http://95.154.202.117:12130/listen.pls", "Ownbyurs11's radio", 1 },
}

service = {
	"(911) Police",
	"(911) Ambulance",
	"(911) Fire Department",
	"Mechanic",
	"Taxi",
	"Pilot",
	"Bus Driver",
	"Fast food delivery",
}

-- Create window
x,y = guiGetScreenSize() 
--phoneGui = guiCreateWindow ( x - 244, y - 500, 244, 500, "", false )
img = guiCreateStaticImage((x/2)-150, (y/2)-300, 300, 600, "lumia920.png", false, nil )

-- Tab panel for apps
tabPanel = guiCreateTabPanel ( 10, 50, 280, 500, false, img )
tabRadio = guiCreateTab( "Radio", tabPanel )
tabPlayers = guiCreateTab( "SMS", tabPanel ) 
tabPhone = guiCreateTab( "Phone", tabPanel ) 

playerList = guiCreateGridList( 0, 0.60, 1, 0.29, true, tabPlayers )
smsTextBox = guiCreateMemo( 0, 0.40, 1, 0.19, "", true, tabPlayers )
smsReceiveTextBox = guiCreateMemo( 0, 0, 1, 0.39, "", true, tabPlayers )
button3 = guiCreateButton( 0, 0.91, 1, 0.08, "Send SMS", true, tabPlayers )
column = guiGridListAddColumn( playerList, "People", 0.85 )
if ( column ) then --If the column has been created, fill it with players
	for id, player in ipairs(getElementsByType("player")) do
		local row = guiGridListAddRow ( playerList )
		guiGridListSetItemText ( playerList, row, column, getPlayerName ( player ), false, false )
	end
end
guiMemoSetReadOnly( smsReceiveTextBox, true )

-- On SMS receive
function onSMSReceive( message, from )
    guiSetText(smsReceiveTextBox,"*** "..from.." -> "..message.."\n"..guiGetText(smsReceiveTextBox))
end
addEvent( "onSMSReceive", true )
addEventHandler( "onSMSReceive", getRootElement(), onSMSReceive )

radioList = guiCreateGridList ( 0.01, 0, 0.98, 0.9, true, tabRadio )
editBox = guiCreateEdit ( 0.67, 0.91, 0.15, 0.08, "80", true, tabRadio )
button5 = guiCreateButton( 0.50, 0.91, 0.17, 0.08, "-", true, tabRadio )
button4 = guiCreateButton( 0.82, 0.91, 0.17, 0.08, "+", true, tabRadio )
column1 = guiGridListAddColumn( radioList, "Radio stations", 0.85 )
button1 = guiCreateButton( 0.01, 0.91, 0.48, 0.08, "Stop", true, tabRadio )
button2 = guiCreateButton( 0.33, 0.92, 0.34, 0.08, "X", true, img )
button6 = guiCreateButton( 0, 0.92, 0.33, 0.08, "<", true, img )
guiSetAlpha( button2, 0 )
guiSetAlpha( button6, 0 )
if ( column ) then --If the column has been created, fill it with players
	for id, station in ipairs(radio) do
		local row = guiGridListAddRow ( radioList )
		if radio[id][3] == 1 then
			guiGridListSetItemText( radioList, row, column1, radio[id][2], false, false )
		else
			guiGridListSetItemText( radioList, row, column1, radio[id][2], true, false )
		end
	end
end

phoneList = guiCreateGridList ( 0, 0, 1, 0.9, true, tabPhone )
column2 = guiGridListAddColumn( phoneList, "Call service", 0.9 )
button7 = guiCreateButton( 0, 0.91, 1, 0.08, "Call service", true, tabPhone )
if ( column2 ) then 
	for id, number in ipairs(service) do
		local row = guiGridListAddRow ( phoneList )
		guiGridListSetItemText ( phoneList, row, column2, service[id], false, false )
	end
end

-- Select radio station
addEventHandler("onClientGUIDoubleClick",radioList,
function()
	local row,col = guiGridListGetSelectedItem( radioList ) 
	if isElement( sound ) then
		destroyElement ( sound )
	end
	if radio[row+1][1] then
   		sound = playSound( radio[row+1][1] ) 
   		isRadioOn = true
   	end
	setSoundVolume( sound, tonumber( guiGetText ( editBox ))/100 )
	
	-- Turn off the car radio
	setRadioChannel ( 0 )
end)

-- Stops the car radio if listening to phone radio
setTimer(function() 
	if isRadioOn and getPedOccupiedVehicle(localPlayer) then
		setRadioChannel ( 0 )
	end
end, 1000, 0)

-- Set the alpha
guiSetVisible( img, false )

-- Show/hide the phone
updateTimer = { }
function togglePhone( source )
	-- Show the phone
	if not guiGetVisible( img ) then
		showCursor ( true )
		guiSetVisible( img, true )
		triggerServerEvent ( "onPhoneOpen", localPlayer )
		
		-- Update player list
		if ( column ) then
			-- Save selected item
			local row,col = guiGridListGetSelectedItem( playerList )
			guiGridListClear ( playerList )
			for id, player in ipairs(getElementsByType("player")) do
				local row = guiGridListAddRow ( playerList )
				guiGridListSetItemText ( playerList, row, column, getPlayerName ( player ), false, false )
			end
			-- Correct after refresh
			guiGridListSetSelectedItem( playerList, row, col )
		end
		updateTimer[localPlayer] = setTimer( function() 
			-- Update player list
			if ( column ) then
				-- Save selected item
				local row,col = guiGridListGetSelectedItem( playerList )
				guiGridListClear ( playerList )
				for id, player in ipairs(getElementsByType("player")) do
					local row = guiGridListAddRow ( playerList )
					guiGridListSetItemText ( playerList, row, column, getPlayerName ( player ), false, false )
				end
				-- Correct after refresh
				guiGridListSetSelectedItem( playerList, row, col )
			end
		end, 5000, 0 )
	else
		showCursor ( false )
		guiSetVisible( img, false )
		triggerServerEvent( "onPhoneClose", localPlayer )
		if isTimer( updateTimer[localPlayer] ) then
			killTimer( updateTimer[localPlayer] )
		end
		guiSetInputEnabled( false )
	end
end 
addCommandHandler( "phone", togglePhone, source )

-- On editor focus
function disableInput( )
	if source == smsTextBox then
		guiSetInputEnabled( true )
   	end
end
addEventHandler( "onClientGUIClick", smsTextBox, disableInput )
-- Stop the radio
function stopRadio( )
	if isElement( sound ) and source == button1 then
		setSoundVolume( sound, 0 )
   		destroyElement( sound )
   		isRadioOn = false
   	end
end
addEventHandler( "onClientGUIClick", button1, stopRadio )
-- Close the gui
function exitPhone( )
	if source == button6 then
   		showCursor ( false )
		guiSetVisible( img, false )
		triggerServerEvent( "onPhoneClose", localPlayer )
		if isTimer( updateTimer[localPlayer] ) then
			killTimer( updateTimer[localPlayer] )
		end
		guiSetInputEnabled( false )
   	end
end
addEventHandler( "onClientGUIClick", button6, exitPhone )
-- Home button
function phoneBack( )
	if source == button2 then
   		showCursor ( false )
		guiSetVisible( img, false )
		triggerServerEvent( "onPhoneClose", localPlayer )
		if isTimer( updateTimer[localPlayer] ) then
			killTimer( updateTimer[localPlayer] )
		end
		guiSetInputEnabled( false )
   	end
end
addEventHandler( "onClientGUIClick", button2, phoneBack )
-- Call service
function callService( )
	if source == button7 then
		local row,col = guiGridListGetSelectedItem( phoneList )
   		local call = guiGridListGetItemText( phoneList, row, col )
   		triggerServerEvent ( "onSendCall", localPlayer, call )
   	end
end
addEventHandler( "onClientGUIClick", button7, callService )
-- Volume up
function volUp( )
	if source == button4 then
		local vol = math.floor(tonumber( guiGetText ( editBox )))
		if vol < 91 then
			vol = vol+10
			guiSetText( editBox, tostring( vol ))
		end
   		setSoundVolume( sound, vol/100 )
   	end
end
addEventHandler( "onClientGUIClick", button4, volUp )
-- Volume down
function volDown( )
	if source == button5 then
		local vol = math.floor(tonumber( guiGetText ( editBox )))
		if vol > 9 then
			vol = vol-10
			guiSetText( editBox, tostring( vol ))
		end
   		setSoundVolume( sound, vol/100 )
   	end
end
addEventHandler( "onClientGUIClick", button5, volDown )
-- Send SMS to player
function sendSMS( )
	if source == button3 then
   		local row,col = guiGridListGetSelectedItem( playerList )
   		local rec = guiGridListGetItemText(playerList, row, col )
   		local recPlayer = getPlayerFromName( rec )
		if isElement( recPlayer ) and getElementType( recPlayer ) == "player" then	
			if recPlayer ~= localPlayer and string.len(guiGetText( smsTextBox )) < 1024 then
    			triggerServerEvent ( "onSendSMS", localPlayer, getPlayerFromName( rec ), guiGetText( smsTextBox ))
    			guiSetText( smsTextBox, "" )
				guiSetInputEnabled( false )    			
    		else
    			exports.GTWtopbar:dm( "Phone: You can't SMS yourself!", 255, 0, 0)
    		end
    	elseif string.len(guiGetText( smsTextBox )) > 1023 then
    		exports.GTWtopbar:dm( "Phone: Sorry but your message is to long!", 255, 0, 0)
    	else
    		exports.GTWtopbar:dm( "Phone: The person you want to SMS is not available now ("..rec..")", 255, 0, 0)
    	end
   	end
end
addEventHandler( "onClientGUIClick", button3, sendSMS )
fileDelete("phone-c.lua")