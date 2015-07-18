-- NOTE:
-- Do only edit stuff after this point if you know what you're doing!
-- Editing something wrong may break or bug the entire script!

-- Modshop resource by Dennis aka UniOn

createObject ( 11326, 1994.276, 2041.688, 12.063, 0, 0, 90 )
createObject ( 11326, 2514.873, -1775.783, 14.797, 0, 0, 180 )

-- Table with the positions for the modshop markers
local modshopPositions = {
	{ 1041.744, -1017.104, 31.1 },
	{ -2723.7060, 217.2689, 3.6133 },
	{ 1990.6890, 2056.8046, 9.83 },
	{ 2499.6159, -1779.8135, 12.8 },
	{ 2386.773, 1050.792, 9.82 },
	{ -1786.706, 1215.382, 24.12 },
	{ -1205.187, 39.404, 12.85 },
	{ 2000.45, -2453.623, 12.547 },
	{ 1293.87, 1440.13, 9.82 },
	{ -1935.85, 246.62, 33.46 },
}

-- Some tables we need to store data to let the modshop work proper
local moddingMarkers = {}
local moddingVehicle = {}
local vehicleModding = {}

-- Create the markers when the resource starts
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for i=1,#modshopPositions do
			local aMarker = createMarker( modshopPositions[ i ][ 1 ], modshopPositions[ i ][ 2 ], modshopPositions[ i ][ 3 ], "cylinder", 4.0, 255, 255, 255, 50 )
			createBlip ( modshopPositions[ i ][ 1 ], modshopPositions[ i ][ 2 ], modshopPositions[ i ][ 3 ], 27, 0, 0, 0, 0, 0, 1, 180 )
			addEventHandler( "onMarkerHit", aMarker, onModshopMarkerHit )
		end
		
		-- Open garage doors
		setGarageOpen( 7, true )
		setGarageOpen( 10, true )
		setGarageOpen( 15, true )
		setGarageOpen( 18, true )
		setGarageOpen( 24, true )
		setGarageOpen( 33, true )
		setGarageOpen( 35, true )
	end
)

-- When a vehicle gets destroyed
function onModshopVehicleDestroy ()
	if ( vehicleModding[ source ] ) then
		local thePlayer = getVehicleController( source )
		if ( thePlayer ) and ( moddingVehicle[ thePlayer ] ) then
			resetModdingShop ( thePlayer )
			triggerClientEvent( thePlayer, "onClientStopModdingVehicle", thePlayer )
		end
	end
end

-- Couple events for the destroy function
addEventHandler( "onElementDestroy", root, onModshopVehicleDestroy )
addEventHandler( "onVehicleExplode", root, onModshopVehicleDestroy )

-- Function when the marker got hit
function onModshopMarkerHit ( hitElement, matchingDimension )
	if ( isElement( hitElement ) ) and ( matchingDimension ) and ( getElementType( hitElement ) == "vehicle" ) then
		if ( getVehicleController( hitElement ) ) then
			local thePlayer = getVehicleController( hitElement )
			moddingMarkers[ thePlayer ] = source
			moddingVehicle[ thePlayer ] = hitElement
			vehicleModding[ hitElement] = hitElement
			setElementFrozen( hitElement, true )
			setVehicleDamageProof( moddingVehicle[ thePlayer ], true )
			local x, y, z = getElementPosition( source )
			setElementPosition( hitElement, x, y, z + 1.65 )
			triggerClientEvent( thePlayer, "onClientModdingMarkerHit", thePlayer, hitElement )
			setElementDimension( source, 999 )
		end
	end
end

-- When a player quits while modding
addEventHandler( "onPlayerQuit", root,
	function ()
		if ( moddingMarkers[ source ] ) then
			resetModdingShop ( source )
		end
	end
)

-- When a wants to hijack a player thats modding
addEventHandler( "onVehicleStartExit", root,
	function ( thePlayer, seat )
		local jacked = getVehicleController( source )
		if ( moddingMarkers[ jacked ] ) then
			cancelEvent()
		end
	end
)

-- When a player dies
addEventHandler( "onPlayerWasted", root,
	function ()
		if ( moddingMarkers[ source ] ) then
			resetModdingShop ( source )
			triggerClientEvent( source, "onClientStopModdingVehicle", source )
		end
	end
)

-- When the players leaves a modding marker
addEvent( "onServerModdingShopLeave", true )
addEventHandler( "onServerModdingShopLeave", root,
	function ()
		if ( moddingMarkers[ source ] ) then
			resetModdingShop ( source )
		end
	end
)

-- Function that resets the tables and stuff
function resetModdingShop ( thePlayer )
	setElementDimension( moddingMarkers[ thePlayer ], 0 )
	setElementFrozen( moddingVehicle[ thePlayer ], false )
	setVehicleDamageProof( moddingVehicle[ thePlayer ], false )
	moddingMarkers[ thePlayer ] = nil
	vehicleModding[ moddingVehicle[ thePlayer ] ] = nil
	moddingVehicle[ thePlayer ] = nil
end

-- When the player is done with the modding
addEvent( "onServerFinishCarModding", true )
addEventHandler( "onServerFinishCarModding", root,
	function ( modTable, modPayment, modVehicle, modColors, modPaintjob )
		-- Take the player's money
		takePlayerMoney( source, tonumber( modPayment ) )
		
		-- Add the upgrades serverside
		for _, upgrade in ipairs ( modTable ) do
			addVehicleUpgrade( modVehicle, upgrade )
		end
		
		-- Set the colors and paintjob
		setVehicleColor( modVehicle, modColors[1], modColors[2], modColors[3], modColors[4], modColors[5], modColors[6] )
		setVehicleHeadLightColor( modVehicle, modColors[7], modColors[8], modColors[9] )
		setVehiclePaintjob( modVehicle, modPaintjob )
		
		-- Trigger the event
		triggerEvent( "onVehicleFinishedModding", modVehicle, modTable, modColors, modPaintjob, modPayment )
	end
)

-- Exported function to check if a vehicle is modding
function isVehicleModding( theVehicle )
	if ( theVehicle ) and ( isElement( theVehicle ) ) then
		if ( vehicleModding[ theVehicle ] ) then return true else return false end
	else
		return false
	end
end

-- Exported function to check if a player is modding
function isPlayerModding( thePlayer )
	if ( thePlayer ) and ( isElement( thePlayer ) ) then
		if ( moddingVehicle[ thePlayer ] ) then return true else return false end
	else
		return false
	end
end