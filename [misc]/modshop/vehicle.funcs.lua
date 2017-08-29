
vehicleUpgrades = { names = { }, prices = { } }

lowriders = { [536]=true, [575]=true, [534]=true, [567]=true, [535]=true, [576]=true, [412]=true }
racers = { [562]=true, [565]=true, [559]=true, [561]=true, [560]=true, [558]=true }


_getVehicleCompatibleUpgrades = getVehicleCompatibleUpgrades
function getVehicleCompatibleUpgrades( veh )
    local upgrs = _getVehicleCompatibleUpgrades( veh )
    local upgrades = { }
    for k,v in ipairs( upgrs ) do
        if not ( v == 1004 or v == 1005 or v == 1013 or v == 1024 or v == 1023 or v == 1031 or v == 1040 or v == 1041 or v == 1099 or v == 1143 or v == 1145 or v == 1030 or v == 1120 or v == 1121 ) then
            table.insert( upgrades, v )
        end
    end
    return upgrades
end


function isVehicleLowrider( vehicle )
    local id = getElementModel( vehicle )
    return lowriders[ id ]
end

function isVehicleRacer( vehicle )
    local id = getElementModel( vehicle )
    return racers[ id ]
end


function loadItems( )
    local file_root = xmlLoadFile( "moditems.xml" )
    local sub_node = xmlFindChild( file_root, "item", 0 )
    local i = 1
    while sub_node do
        vehicleUpgrades.names[ i ] = xmlNodeGetAttribute( sub_node, "name" )
        vehicleUpgrades.prices[ i ] = xmlNodeGetAttribute( sub_node, "price" )
        sub_node = xmlFindChild( file_root, "item", i )
        i = i + 1
    end
end


function getItemPrice( itemid )
    if not itemid then return false end
    if itemid < 1000 or itemid > 1193 then 
        return false
    elseif type( itemid ) ~= 'number' then
        return false
    end
    return vehicleUpgrades.prices[ itemid - 999 ]
end

function getItemName( itemid )
    if not itemid then return false end
    if itemid > 1193 or itemid < 1000 then 
        return false 
    elseif type( itemid ) ~= 'number' then
        return false
    end
    return vehicleUpgrades.names[ itemid - 999 ]
end

function getItemIDFromName( itemname )
    if not itemname then 
        return false
    elseif type( itemname ) ~= 'string' then 
        return false 
    end
    for k,v in ipairs( vehicleUpgrades.names ) do
        if v == itemname then
            return k + 999
        end
    end
    return false
end

