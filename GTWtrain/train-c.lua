--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

-- Allow the train to move when no player can see it
function stream ( veh )
	setElementStreamable( veh, true )
end
addEvent( "train.onstream", true )
addEventHandler( "train.onstream", getRootElement(), stream )

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
        if getElementType( source ) == "vehicle" and getVehicleType(source) == "Train" then
            triggerServerEvent( "train_onClientStreamOut", localPlayer, getElementData( source, "syncer" ))           
        end
    end
);
