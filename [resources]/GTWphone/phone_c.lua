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

-- Define data members
local sound = nil
local volume = 50
bindKey( "B", "down", "phone" )

-- Local bools
local isRadioOn = false

-- Radio list
radio = {
	{ "", " Top Europe stations", 0 },
	{ "http://mp3stream7.apasf.apa.at:8000/listen.pls", "ORF Ö3", 1 },
	{ "http://onair-ha1.krone.at/kronehit-hp.mp3.m3u", "Kronehit Digital", 1 },
	{ "http://onair-ha1.krone.at/kronehit1058.mp3.m3u", "Kronehit 105,8", 1 },
	{ "http://onair-ha1.krone.at/kronehit-fresh.mp3.m3u", "Kronehit Fresh", 1 },
	{ "http://onair-ha1.krone.at/kronehit-charts.mp3.m3u", "Kronehit Charts", 1 },
	{ "http://www.listenlive.eu/vrtmnm-mid.m3u", "VRT MNM", 1 },
	{ "http://icecast-qmusic.cdp.triple-it.nl/Qmusic_be_live_96.mp3.m3u", "Q-Music", 1 },
	{ "http://shoutcast01.edpnet.net:10150/listen.pls", "City Music", 1 },
	{ "http://94.23.48.124:8000/listen.pls", "Hit FM", 1 },
	{ "http://broadcast.infomaniak.net/nrjbe-high.mp3.m3u", "NRJ Belgium", 1 },
	{ "http://broadcast.infomaniak.net/funradiobe-low.aac.m3u", "Fun Radio", 1 },
	{ "http://www.listenlive.eu/contactfr.m3u", "Radio Contact", 1 },
	{ "http://62.204.158.5:8081/live.m3u", "Radio 999", 1 },
	{ "http://193.108.24.21:8000/fresh.m3u", "Radio Fresh", 1 },
	{ "http://icecast3.play.cz/evropa2-128.mp3.m3u", "Evropa 2", 1 },
	{ "http://www.listenlive.eu/thevoice_dk.m3u", "The Voice Copenhagen", 1 },
	{ "http://stream.power.ee/PHR.m3u", "PowerHit Radio Estonia", 1 },
	{ "http://ice.stream.frequence3.net/frequence3-128.mp3.m3u", "Fréquence3", 1 },
	{ "http://www.m2radio.fr/pls/m2hit.m3u", "M2 HIT", 1 },
	{ "http://www.listenlive.eu/nrj_fr.m3u", "NRJ Paris", 1 },
	{ "http://www.listenlive.eu/nrj_hits.m3u", "NRJ Hits Paris", 1 },
	{ "http://www.hit104.com/listen.pls", "HIT104", 1 },
	{ "http://31.14.40.241:6184/listen.pls", "FM104 Ireland", 1 },
	{ "http://stream.europeanhitradio.com:8000/ehr64.m3u", "European Hit Radio", 1 },
	
	{ "", " Local radio", 0 },
	{ "http://194.16.21.227/mix_gbg_se_mp3.m3u", "[Sweden] Mix megapol", 1 },
	{ "http://194.16.21.227/nrj_se_mp3.m3u", "[Sweden] NRJ Sweden", 1 },
	{ "http://stream-ice.mtgradio.com:8080/stat_rix_fm.m3u", "[Sweden] Rix FM", 1 },
	{ "http://lyd.nrk.no/nrk_radio_klassisk_aac_h.m3u", "[Norway] NRK classical", 1 },
	{ "http://lyd.nrk.no/nrk_radio_alltid_nyheter_aac_h.m3u", "[Norway] NRK news", 1 },
	{ "http://live-icy.gss.dr.dk:8000/A/A21L.mp3.m3u", "[Denmark] DR Mix", 1 },
	{ "http://live-icy.gss.dr.dk:8000/A/A04L.mp3.m3u", "[Denmark] DR classical", 1 },
	{ "http://live.motgift.nu:8000/stream", "[Sweden] Motgift Mix/Talk", 1 },
	
	{ "", " 181.fm stations", 0 },
	{ "http://www.181.fm/winamp.pls?station=181-power&style=mp3&description=Power%20181%20(Top%2040)&file=181-power.pls", "Power 181", 1 },
	{ "http://relay.181.fm:8068", "Old School Rap", 1 },
	
	{ "", " Rap and Hiphop", 0 },
	{ "http://188.117.44.132:8000/stream.m3u", "[Finland] Basso radio", 1 },
	{ "http://mp3-live.dasding.de/dasdingraka02_m.m3u", "[Germany] DasDing Sprechstunde", 1 },
	{ "http://www.antenne.de/webradio/channels/black-beatz.m3u", "[Germany] Antenne Bayern Black Beatz", 1 },
	{ "http://91.121.223.159:8000/move.m3u", "Move FM", 1 },
	{ "http://broadcast.infomaniak.ch/onlyrai-high.mp3.m3u", "Urban hit", 1 },
	{ "http://lyd.nrk.no/nrk_radio_p3_national_rap_show_aac_h.m3u", "[Norway] Rap/Hiphop", 1 },
	
	{ "", " Rock", 0 },
	{ "http://www.skyrock.fm/stream.php/yourplayer_64.pls", "Skyrock", 1 },
	{ "http://stream-ice.mtgradio.com:8080/stat_bandit.m3u", "[Sweden] Bandit rock", 1 },
	{ "http://195.55.74.212/cope/rockfm.mp3?GKID=b803794ee76d11e4b84e00163ea2c744&fspref=aHR0cDovL3BsYXllci5yb2NrZm0uZm0v", "[Spain] RockFM", 1 },
	{ "http://mp3channels.webradio.antenne.de/rockantenne", "[Germany] ROCK ANTENNE", 1 },
	{ "http://mp3channels.webradio.antenne.de/heavy-metal", "[Germany] ROCK ANTENNE - Heavy Metal", 1 },
	{ "http://mp3channels.webradio.antenne.de/classic-perlen", "[Germany] ROCK ANTENNE - Classic Perlen", 1 },
	{ "http://mp3channels.webradio.antenne.de/deutschrock", "[Germany] ROCK ANTENNE - Deutschrock", 1 },
	{ "http://mp3channels.webradio.antenne.de/soft-rock", "[Germany] ROCK ANTENNE - Soft Rock", 1 },
	{ "http://mp3channels.webradio.antenne.de/alternative", "[Germany] ROCK ANTENNE - Alternative", 1 },
	{ "http://mp3channels.webradio.antenne.de/young-stars", "[Germany] ROCK ANTENNE - Young Stars", 1 },
	{ "http://mp3channels.webradio.antenne.de/rockantennelocal01", "[Germany] ROCK ANTENNE - Erding Freising Ebersberg", 1 },
	
	{ "", " Jazz", 0 },
	{ "http://lyd.nrk.no/nrk_radio_jazz_aac_h.m3u", "[Norway] NRK Jazz", 1 },
	{ "http://sj128.hnux.com/listen.pls", "Smooth Jazz", 1 },
	
	{ "", " Techno", 0 },
	{ "http://tunein.t4e.dj/hard/dsl/mp3", "Techno4ever Hard stream", 1 },
	{ "http://tunein.t4e.dj/club/dsl/mp3", "Techno4ever Clup stream", 1 },
	
	{ "", " Mixed stations", 0 },
	{ "http://www.radiogold.de/listen.pls", "Radio Gold (Germany)", 1 },
	{ "http://217.151.151.91/live4.m3u", "Radio regenbogen (Germany)", 1 },
}

service = {
	"Law enforcement",
	"Ambulance",
	"Fire Department",
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
exports.GTWgui:setDefaultFont(tabRadio, 10)
exports.GTWgui:setDefaultFont(tabPlayers, 10)
exports.GTWgui:setDefaultFont(tabPhone, 10)
exports.GTWgui:setDefaultFont(tabPanel, 10)

playerList = guiCreateGridList( 0, 0.60, 1, 0.29, true, tabPlayers )
smsTextBox = guiCreateMemo( 0, 0.40, 1, 0.19, "", true, tabPlayers )
smsReceiveTextBox = guiCreateMemo( 0, 0, 1, 0.39, "", true, tabPlayers )
btn_send_sms = guiCreateButton( 0, 0.91, 1, 0.08, "Send SMS", true, tabPlayers )
column = guiGridListAddColumn( playerList, "People", 0.85 )
if ( column ) then --If the column has been created, fill it with players
	for id, player in ipairs(getElementsByType("player")) do
		local row = guiGridListAddRow ( playerList )
		guiGridListSetItemText ( playerList, row, column, getPlayerName ( player ), false, false )
	end
end
guiMemoSetReadOnly( smsReceiveTextBox, true )
exports.GTWgui:setDefaultFont(playerList, 10)
exports.GTWgui:setDefaultFont(btn_send_sms, 10)

-- On SMS receive
function onSMSReceive( message, from )
    guiSetText(smsReceiveTextBox,"*** "..from.." -> "..message.."\n"..guiGetText(smsReceiveTextBox))
end
addEvent( "onSMSReceive", true )
addEventHandler( "onSMSReceive", getRootElement(), onSMSReceive )

radioList = guiCreateGridList ( 0.01, 0, 0.98, 0.9, true, tabRadio )
editBox = guiCreateEdit ( 0.67, 0.91, 0.15, 0.08, "40", true, tabRadio )
btn_volume_down = guiCreateButton( 0.50, 0.91, 0.17, 0.08, "-", true, tabRadio )
btn_volume_up = guiCreateButton( 0.82, 0.91, 0.17, 0.08, "+", true, tabRadio )
column1 = guiGridListAddColumn( radioList, "Radio stations", 0.85 )
btn_stop_radio = guiCreateButton( 0.01, 0.91, 0.48, 0.08, "Stop", true, tabRadio )
btn_close = guiCreateButton( 0.33, 0.92, 0.34, 0.08, "X", true, img )
btn_left = guiCreateButton( 0, 0.92, 0.33, 0.08, "<", true, img )
guiSetAlpha( btn_close, 0 )
guiSetAlpha( btn_left, 0 )
exports.GTWgui:setDefaultFont(btn_volume_up, 10)
exports.GTWgui:setDefaultFont(btn_volume_down, 10)
exports.GTWgui:setDefaultFont(btn_stop_radio, 10)
exports.GTWgui:setDefaultFont(editBox, 10)
exports.GTWgui:setDefaultFont(radioList, 10)

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
btn_call_service = guiCreateButton( 0, 0.91, 1, 0.08, "Call service", true, tabPhone )
if ( column2 ) then
	for id, number in ipairs(service) do
		local row = guiGridListAddRow ( phoneList )
		guiGridListSetItemText ( phoneList, row, column2, service[id], false, false )
	end
end
exports.GTWgui:setDefaultFont(phoneList, 10)
exports.GTWgui:setDefaultFont(btn_call_service, 10)

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
	if isElement( sound ) and source == btn_stop_radio then
		setSoundVolume( sound, 0 )
   		destroyElement( sound )
   		isRadioOn = false
   	end
end
addEventHandler( "onClientGUIClick", btn_stop_radio, stopRadio )
-- Close the gui
function exitPhone( )
	if source == btn_left then
   		showCursor ( false )
		guiSetVisible( img, false )
		triggerServerEvent( "onPhoneClose", localPlayer )
		if isTimer( updateTimer[localPlayer] ) then
			killTimer( updateTimer[localPlayer] )
		end
		guiSetInputEnabled( false )
   	end
end
addEventHandler( "onClientGUIClick", btn_left, exitPhone )
-- Home button
function phoneBack( )
	if source == btn_close then
   		showCursor ( false )
		guiSetVisible( img, false )
		triggerServerEvent( "onPhoneClose", localPlayer )
		if isTimer( updateTimer[localPlayer] ) then
			killTimer( updateTimer[localPlayer] )
		end
		guiSetInputEnabled( false )
   	end
end
addEventHandler( "onClientGUIClick", btn_close, phoneBack )
-- Call service
function call_service( )
	if source == btn_call_service then
		local row,col = guiGridListGetSelectedItem( phoneList )
   		local call = guiGridListGetItemText( phoneList, row, col )
   		triggerServerEvent ( "GTWphone.onSendCall", localPlayer, call )
   	end
end
addEventHandler( "onClientGUIClick", btn_call_service, call_service )
-- Volume up
function volUp( )
	if source == btn_volume_up then
		local vol = math.floor(tonumber( guiGetText ( editBox )))
		if vol < 91 then
			vol = vol+10
			guiSetText( editBox, tostring( vol ))
		end
   		setSoundVolume( sound, vol/100 )
   	end
end
addEventHandler( "onClientGUIClick", btn_volume_up, volUp )
-- Volume down
function volDown( )
	if source == btn_volume_down then
		local vol = math.floor(tonumber( guiGetText ( editBox )))
		if vol > 9 then
			vol = vol-10
			guiSetText( editBox, tostring( vol ))
		end
   		setSoundVolume( sound, vol/100 )
   	end
end
addEventHandler( "onClientGUIClick", btn_volume_down, volDown )
-- Send SMS to player
function sendSMS( )
	if source == btn_send_sms then
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
addEventHandler( "onClientGUIClick", btn_send_sms, sendSMS )
