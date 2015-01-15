--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

-- Allow the train to move when no player can see it (disabled due to lag)
function stream ( veh )
	--setElementStreamable( veh, true )
end
addEvent( "train.onstream", true )
addEventHandler( "train.onstream", resourceRoot, stream )

addEventHandler( "onClientElementStreamOut", getRootElement( ),
function ( )
    if getElementType( source ) == "vehicle" and getVehicleType(source) == "Train" then
        triggerServerEvent("GTWtrain.onClientTrainStreamOut", localPlayer, source)           
    end
end)
