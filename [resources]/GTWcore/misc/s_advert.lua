--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Anubhav

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

function send_advertise(plr, cmd, ...)
	if (isGuestAccount( getplrAccount( plr ) ) ) then
		return
	end
	local m = getplrMoney( plr )
	if (m < 500) then
		local money = tostring(500 - m)
		return outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFFYou need $"..money.." more.", plr, 255, 0, 0, true)
	end
	local msg = table.concat({ ... }, " ")
	if msg == "" then
		return outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFFYou did not type a msg.", plr, 255, 0, 0, true)
	end
	takeplrMoney( plr, settings[ 'Money Required for advertisement' ] )
	outputChatBox("#FFFF00[ADVERT-SYSTEM] #FFFFFF500$ was deducted for the advert!", plr, 255, 0, 0, true)
	outputChatBox("#FFFF00[ADVERT-SYSTEM] "..getplrName( plr )..": #FFFFFF"..msg, root, 255, 0, 0, true)
end
addcmdHandler("ad", send_advertise)
addcmdHandler("advertise", send_advertise)
addcmdHandler("advert", send_advertise)
