
addEvent( "onVehicleMod" )

modShops = {  }

modShops[ 1 ] = { }
--modShops[ 1 ].colShape = createColTube( -2723.7060, 217.2689, 4.0, 200, 1000 )
modShops[ 1 ].veh = false
modShops[ 1 ].marker = createMarker( -2723.7060, 217.2689, 2.6133, "cylinder", 3, 255, 0, 0, 100 )
modShops[ 1 ].name = "Wheel Arch Angles"
--createBlipAttachedTo( modShops[ 1 ].colShape, 27 )
createBlipAttachedTo( modShops[ 1 ].marker, 27, 2, 0,0,0,255, 0, 180 );

modShops[ 2 ] = { }
--modShops[ 2 ].colShape = createColTube( 1990.6890, 2056.8046, 10.5, 200, 1000 )
modShops[ 2 ].veh = false
modShops[ 2 ].marker = createMarker( 1990.6890, 2056.8046, 9.3844, "cylinder", 3, 255, 0, 0, 100 )
modShops[ 2 ].name = "TransFender"
createBlipAttachedTo( modShops[ 2 ].marker, 27, 2, 0,0,0,255, 0, 180 );

modShops[ 3 ] = { }
--modShops[ 3 ].colShape = createColTube( 2499.6159, -1779.8135, 13.3, 200, 1000 )
modShops[ 3 ].veh = false
modShops[ 3 ].marker = createMarker( 2499.6159, -1779.8135, 12.8, "cylinder", 3, 255, 0, 0, 100 )
modShops[ 3 ].name = "Loco Low Co."
--createBlipAttachedTo( modShops[ 3 ].marker, 27, 2, 0,0,0,255, 0, 150 )
createBlipAttachedTo( modShops[ 3 ].marker, 27, 2, 0,0,0,255, 0, 180 );


local TIME_IN_MODSHOP = 3 -- 3 minutes

local moddedVehicles = { }
local timers = { }
local timersClient = { }


addEventHandler( "onPlayerQuit", getRootElement( ),
    function( )
        local veh = getPedOccupiedVehicle( source )
        if veh then
            local driver = getVehicleController( veh )
            if driver == source then
                if getVehicleModShop( veh ) then
                    unfreezeVehicleInModShop( veh )
                end
            end
        end
    end
)


addEventHandler( "onResourceStop", getResourceRootElement( getThisResource( ) ),
    function( )
        for k,veh in pairs( getElementsByType( "vehicle" ) ) do
            if moddedVehicles[ k ] then
                for i, modid in pairs( getVehicleUpgrades( veh ) ) do
                    removeVehicleUpgrade( veh, modid )
                    setVehiclePaintjob( veh, 3 )
                end
            end
            if isVehicleInModShop( veh ) then unfreezeVehicleInModShop( veh ) end
        end
    end, false
)



addEventHandler( "onMarkerHit", getResourceRootElement( getThisResource( ) ),
    function( player, dimension )
        if dimension and getElementType( player ) == "player" then
            local vehicle = getPedOccupiedVehicle( player )
            if vehicle then
                local driver = getVehicleController( vehicle )
                if driver == player and not getVehicleInModShop( source ) then
                    for k,v in ipairs( modShops ) do
                        if modShops[ k ].marker == source and getElementType( vehicle ) == "vehicle" then
                            timers[ vehicle ] = setTimer( unfreezeVehicleInModShop, 60000 * TIME_IN_MODSHOP, 1, vehicle )
                            timersClient[ vehicle ] = setTimer( triggerClientEvent, 60000 * TIME_IN_MODSHOP - 200, 1, driver, "modShop_clientResetVehicleUpgrades", driver )
                            setModShopBusy( source, vehicle )
                            freezVehicleInModShop( vehicle, modShops[ k ].marker )
                            triggerClientEvent( driver, "onClientPlayerEnterModShop", player, vehicle, getPlayerMoney( player ), modShops[ k ].name )
                        end
                    end
                end
            end
        end
    end
)

addEvent( "modShop_playerLeaveModShop", true )
addEventHandler( "modShop_playerLeaveModShop", getRootElement( ),
    function( vehicle, itemsCost, upgrades, colors, paintjob, shopName )
        local pMoney = getPlayerMoney( source )
        if pMoney >= itemsCost then
            modTheVehicle( vehicle, upgrades, colors, paintjob, shopName )
            takePlayerMoney( source, itemsCost )
            triggerClientEvent( source, "modShop_moddingConfirmed", source )
        else
            outputChatBox( "#FF0000Inufficient founds! #00FF00Your pocket shows $"..tostring( getPlayerMoney( source ) )..".#FFFFFF Uninstall some upgrades.", source, 0,0,0,true)
        end
    end
)

function modTheVehicle( vehicle, upgrades, colors, paintjob, shopName )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' and type( upgrades ) == 'table' or getVehiclePaintjob( vehicle ) ~= paintjob then
        local trigger = false
        
		--outputDebugString( "Colors recieved from client: ".. colors[ 1 ] ..", "..tostring( colors[ 2 ] ) )
        local oldColor = { getVehicleColor( vehicle ) }
        local newColor = { 0, 0, 0, 0 }
        local fixVeh = false
        for i = 1, 2 do
            if oldColor[ i ] == colors[ i ] then
                newColor[ i ] = oldColor[ i ]
                colors[ i ] = false
            else 
                newColor[ i ] = colors[ i ]
                trigger = true
                fixVeh = true
            end
        end
        
        if paintjob == 255 or paintjob == getVehiclePaintjob( vehicle ) then 
            paintjob = false 
        else
            setVehiclePaintjob( vehicle, paintjob )
            trigger = true
        end
        
        local vehUpg = { getVehicleUpgrades( vehicle ) }
        local upgs = { }
        for k,v in pairs( upgrades ) do
            for i,j in pairs( vehUpg ) do
                if v ~= j then
                    addVehicleUpgrade( vehicle, v )
                    table.insert( upgs, v )
                    trigger = true
                end
            end
        end
        
        if fixVeh then
            fixVehicle( vehicle )
            setVehicleColor( vehicle, unpack( newColor ) )
			--outputDebugString( "color set: ".. tostring( newColor[ 1 ] ) .."  "..tostring( newColor[ 2 ] ) )
        end
        for _, veh in ipairs( moddedVehicles ) do
            if veh ~= vehicle then
                table.insert( moddedVehicles, veh )
            end
        end
        unfreezeVehicleInModShop( vehicle )
        if trigger then
            triggerEvent( "onVehicleMod", vehicle, upgs, colors, paintjob, shopname )
        end
    end
end


function freezVehicleInModShop( vehicle, marker )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' then
        local mX, mY, mZ = getElementPosition( marker )
        if mX then
            setElementPosition( vehicle, mX, mY, mZ + 1.65 )
            setElementDimension( marker, 1 )
            local _,_, rot = getVehicleRotation( vehicle )
            setVehicleRotation( vehicle, 0, 0, rot )
            setElementFrozen( vehicle, true )
            setVehicleDamageProof( vehicle, true )
            if not isVehicleLocked( vehicle ) then
                setVehicleLocked( vehicle, true )
                setElementData( vehicle, "veh.locked", true )
            end
        end
    end
end


function unfreezeVehicleInModShop( vehicle )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' then
        local shop = getVehicleModShop( vehicle )
        if shop then
            setElementDimension( shop, 0 )
            setModShopBusy( shop, 0, false )
            setElementFrozen( vehicle, false )
            setVehicleDamageProof( vehicle, false )
            if isVehicleLocked( vehicle ) and getElementData( vehicle, "veh.locked" ) == true then
                setVehicleLocked( vehicle, false )
                setElementData( vehicle, "veh.locked", false )
            end
            --outputDebugString( "called" )
            if timers[ vehicle ] then
                killTimer( timers[ vehicle ] )
                killTimer( timersClient[ vehicle ] )
            end
        end
    end
end

addEvent( "modShop_unfreezVehicle", true )
addEventHandler( "modShop_unfreezVehicle", getRootElement( ),
    function( )
        unfreezeVehicleInModShop( source )
    end
)

addEventHandler( "onVehicleRespawn", getRootElement(),
    function( )
        if moddedVehicles[ source ] then
            local upgrades = getVehicleUpgrades( source )
            for k,v in pairs( upgrades ) do
                removeVehicleUpgrade( source, v )
            end
            setVehiclePaintjob( source, 3 )
            moddedVehicles[ source ] = nil
        end
    end
)

addEventHandler( "onVehicleMod", getRootElement( ), function( upgrades, colors, paintjob, shopName )
--[[
    -- this is just to see how onVehicleMod event works
        outputChatBox( "You just modded a vehicle", getVehicleController( source ) )
        for k, v in ipairs( upgrades ) do
            outputChatBox( getVehicleUpgradeSlotName( v ) .." - " .. tostring( v ) )
        end
        local str = "New colors:"
        if type( colors ) == "table" then
            for i=1,#colors do
                str = str.."  "..tostring( colors[ i ] )
            end
            outputChatBox( str )
        end
        outputChatBox( "Paintjob: "..tostring( paintjob ), getVehicleController( source ) )
]]
    end
)

addEventHandler( "onResourceStart", getResourceRootElement( getThisResource() ),
	function( )
		setGarageOpen( 15, true );
	end
)

