function sendAdvertise( player, command, ... )
	if (isGuestAccount( getPlayerAccount( player ) ) ) then
		return
	end
	local m = getPlayerMoney( player )
	if (m < settings['Money Required for advertisement']) then
		local money = tostring( settings['Money Required for advertisement'] - m )
		return outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFFYou need $"..money.." more.", player, 255, 0, 0, true)
	end
	local message = table.concat({ ... }, " ")
	if message == "" then
		return outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFFYou did not type a message.", player, 255, 0, 0, true)
	end
	takePlayerMoney( player, settings[ 'Money Required for advertisement' ] )
	outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFF500$ was deducted for the advert!", player, 255, 0, 0, true)
	outputChatBox("#FFFF00[ADVERT-SYSTEM] "..getPlayerName( player )..": #FFFFFF"..message, root, 255, 0, 0, true)
end
addCommandHandler( "ad", sendAdvertise )
addCommandHandler( "advertise", sendAdvertise )
addCommandHandler( "advert", sendAdvertise )
