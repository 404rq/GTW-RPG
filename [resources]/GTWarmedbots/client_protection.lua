function cancelPedDamage ( attacker )
	if (getElementType( attacker ) ~= "player") then
		return 
	end
	if ( not getElementData( source, "GTWoutlaws.vBot" )) then
		return
	end
	if (getTeamName( getPlayerTeam( attacker ) ) == "Staff" ) then
		cancelEvent() -- cancel any damage done to peds as staff
	end
end
addEventHandler ( "onClientPedDamage", getRootElement(), cancelPedDamage )
