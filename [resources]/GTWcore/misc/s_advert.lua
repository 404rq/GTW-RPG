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

local ad_price = 200;
function send_advertise(plr, cmd, ...)
	if (isGuestAccount(getPlayerAccount(plr))) then
		return
	end
	local m = getPlayerMoney(plr)
	if (m < ad_price) then
		local money = tostring(ad_price - m)
		return exports.GTWtopbar:dm("You need $"..money.." more", plr, 255,0,0, true)
	end
	local msg = table.concat({ ... }, " ")
	if msg == "" then
		return exports.GTWtopbar:dm("You did not type a msg", plr, 255,0,0, true)
	end
	takePlayerMoney(plr, ad_price)
	exports.GTWtopbar:dm("$"..ad_price.." was deducted for the advert", plr, 255,100,0, true)
	outputChatBox("#FFFF00[AD] "..getPlayerName(plr)..": #FFFFFF"..msg, root, 255,0,0, true)
end
addCommandHandler("ad", send_advertise)
addCommandHandler("advertise", send_advertise)
addCommandHandler("advert", send_advertise)
