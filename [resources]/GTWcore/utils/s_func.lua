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

function display_total_playtime(plr)
	local accountTable = getAccounts()
	local accTotalTime = 0
	for w,acc in ipairs(accountTable) do
		accTotalTime = accTotalTime +(getAccountData(acc, "GTWdata.playtime") or 0)
	end
	local hour = tostring(math.floor(accTotalTime/(1000*60*60)))
	local minute = tostring(math.floor(accTotalTime/(1000*60))%60)
	local nMinute = math.floor(accTotalTime/(1000*60))%60
	if nMinute < 10 then
	   	minute = "0"..minute
	end
	outputChatBox("Total time: "..tostring(hour).."h, "..tostring(minute).."m, in: "..tostring(#accountTable).." accounts", plr, 255, 255, 255)
end
addCommandHandler("accounts-info", display_total_playtime)

--[[ Convert number e.g 100000 -> 100.000 ]]--
function convertNumber ( number )
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end
