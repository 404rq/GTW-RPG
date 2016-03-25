local playerMoney = getPlayerMoney ( localPlayer )
local messages =  { }
local sx, sy = guiGetScreenSize ( )

addEventHandler ( "onClientRender", root, function ( )
	local tick = getTickCount ( )
	if ( playerMoney ~= getPlayerMoney ( localPlayer ) ) then
		local pM = getPlayerMoney ( localPlayer ) 
		local diff = 0
		if ( pM > playerMoney ) then
			diff = pM - playerMoney
			table.insert(messages, {diff, true, tick + 5000, 180 } )
			triggerServerEvent("dxmoneylogs.logPayment", root, "BANK: "..getPlayerName(localPlayer)..", received: $"..convertNumber(diff))
		else
			diff = playerMoney - pM
			table.insert(messages, {diff, false, tick + 5000, 180 } )
			triggerServerEvent("dxmoneylogs.logPayment", root, "BANK: "..getPlayerName(localPlayer)..", paid: $"..convertNumber(diff))
		end
		playerMoney = pM
		setElementData(localPlayer, "Money", "$"..convertNumber(playerMoney))
	end
	
	if ( #messages > 7 ) then
		table.remove ( messages, 1 )
	end
	
	for index, data in ipairs ( messages ) do
		local v1 = data[1]
		local v2 = data[2]
		local v3 = data[3]
		local v4 = data[4]
		dxDrawRectangle ( sx/2 - 110, (sy-20)-(index*25), 200, 20, tocolor ( 0, 0, 0, v4 ) )
		
		if ( v2 ) then
			dxDrawText ( "+ $"..convertNumber ( v1 ), sx/2 - 100, (sy-18)-(index*25), 50, 20, tocolor ( 0, 255, 0, v4+75 ), 1, 'default-bold' )
		else
			dxDrawText ( "- $"..convertNumber ( v1 ), sx/2 - 100, (sy-18)-(index*25), 50, 20, tocolor ( 255, 0, 0, v4+75 ), 1, 'default-bold' )
		end
		
		if ( tick >= v3 ) then
			messages[index][4] = v4-2
			if ( v4 <= 25 ) then
				table.remove ( messages, index )
			end
		end
	end
end )

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

