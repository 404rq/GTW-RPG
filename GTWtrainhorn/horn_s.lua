--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.6
	Status:			Stable release
********************************************************************************
]]--

-- Bink keys to control the horn
function bindTrainHorn( thePlayer, seat, jacked )
    if getVehicleType(source) == "Train" and getElementType(thePlayer) == "player" then
    	bindKey( thePlayer, "H", "down", toggleTrainHorn )
    end
end
addEventHandler ( "onVehicleEnter", root, bindTrainHorn ) 

-- Toggle the horn sound
function toggleTrainHorn(thePlayer, cmd)
	if getPedOccupiedVehicle(thePlayer) and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Train" then
		triggerClientEvent( root, "GTWtrainhorn.toggle", thePlayer, getPedOccupiedVehicle(thePlayer) )
	end
end

-- Trigger the horn sound
function triggerTrainHorn(theTrain)
	if theTrain and isElement(theTrain) then
		triggerClientEvent( root, "GTWtrainhorn.toggle", theTrain, theTrain)
	end
end