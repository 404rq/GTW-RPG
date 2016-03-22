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

function setTDensity()
	exports.npc_traffic:setTrafficDensity(0.02)
	exports.npc_traffic:setTrafficDensity("peds", 0.06)
	exports.npc_traffic:setTrafficDensity("boats", 0.04)
	exports.npc_traffic:setTrafficDensity("planes", 0.04)
end
setTimer(setTDensity, 1000, 30)
