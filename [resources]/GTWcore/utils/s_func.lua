--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

function display_total_playtime(plr)
	local account_table = getAccounts()
	local total_account_time = 0
	for w,acc in ipairs(account_table) do
		total_account_time = total_account_time +(exports.GTWcore:get_account_data(acc, "GTWdata.playtime") or 0)
	end
	local hour = tostring(math.floor(total_account_time/(1000*60*60)))
	local minute = tostring(math.floor(total_account_time/(1000*60))%60)
	local nMinute = math.floor(total_account_time/(1000*60))%60
	if nMinute < 10 then
	   	minute = "0"..minute
	end
	outputChatBox("Total time: "..tostring(hour).."h, "..tostring(minute).."m, in: "..tostring(#account_table).." accounts", plr, 255, 255, 255)
end
addCommandHandler("accounts-info", display_total_playtime)

--[[ Convert number e.g 100000 -> 100.000 ]]--
function convert_num(number)
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end
