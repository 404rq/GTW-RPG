function setPlayerFreecamEnabled(player, x, y, z, itemAttached)
	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, itemAttached)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end

viewElements = {}
function removeCarCamera( thePlayer, seat, jacked )
    setPlayerFreecamDisabled(thePlayer)
    setCameraTarget(thePlayer,thePlayer)
    if isElement(viewElements[thePlayer]) then
    	destroyElement(viewElements[thePlayer])
    end
end
addEventHandler( "onVehicleExit", getRootElement(), removeCarCamera )

function enableFreecam (player)
    if not isPlayerFreecamEnabled(player) and getPedOccupiedVehicle(player) and getVehicleType(getPedOccupiedVehicle(player)) == "Train" then
    	local x, y, z = getElementPosition(player)
    	viewElements[player] = createMarker( x,y,z, "checkpoint", 0.1, 0,0,0,0 )
    	attachElements(viewElements[player], getPedOccupiedVehicle(player), 0, 10, -3)
    	setPlayerFreecamEnabled(player, x, y, z, viewElements[player])
    else
        setPlayerFreecamDisabled(player)
        setCameraTarget(player,player)
    end
end
addCommandHandler("cv", enableFreecam)
