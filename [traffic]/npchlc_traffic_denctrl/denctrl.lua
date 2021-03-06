function changeDensity(player,cmdname,trtype,density)
	local accName = getAccountName ( getPlayerAccount ( player ))
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" )) then
		if not trtype and not density then
			outputChatBox("Syntax: /density [type] new_density",player)
			return
		end
		if exports.npc_traffic:setTrafficDensity(trtype,density) then
			if density then
				local prevden = exports.npc_traffic:getTrafficDensity(trtype)
				outputChatBox(trtype.." traffic density changed from "..prevden.." to "..density)
			else
				outputChatBox("all traffic density changed to "..trtype, player, 255, 255, 255)
			end
		end
	end
end
addCommandHandler("density",changeDensity)

--[[ Keep density updated based on time per day ]]--
function updateDensity()
	local multiplier = 1
	local h,m = getTime()
	if h < 4 then multiplier = 0.4
	elseif h < 5 then multiplier = 0.7
	elseif h < 6 then multiplier = 1.2
	elseif h < 7 then multiplier = 4
	elseif h < 9 then multiplier = 7
	elseif h < 10 then multiplier = 3
	elseif h < 11 then multiplier = 4
	elseif h < 12 then multiplier = 6
	elseif h < 13 then multiplier = 8
	elseif h < 15 then multiplier = 5
	elseif h < 18 then multiplier = 9
	elseif h < 19 then multiplier = 7
	elseif h < 20 then multiplier = 4
	elseif h < 21 then multiplier = 2
	elseif h < 22 then multiplier = 0.8
	elseif h < 24 then multiplier = 0.4 end

	exports.npc_traffic:setTrafficDensity(0.002*multiplier)
	exports.npc_traffic:setTrafficDensity("peds", 0.03*multiplier)
	exports.npc_traffic:setTrafficDensity("boats", 0.01*multiplier)
	exports.npc_traffic:setTrafficDensity("planes", 0.01*multiplier)
end
setTimer(updateDensity, 10000, 0)
