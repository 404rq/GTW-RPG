
function isVehicleInModShop( vehicle )
    for k,v in ipairs( modShops ) do
        if modShops[ k ].veh == vehicle then
            return true
        end
    end
    return false
end

function getVehicleInModShop( marker )
    for k,v in ipairs( modShops ) do
        if modShops[ k ].marker == marker then
            return modShops[ k ].veh
        end
    end
    return false
end

function getVehicleModShop( vehicle )
    for k,v in ipairs( modShops ) do
        if modShops[ k ].veh == vehicle then
            return modShops[ k ].marker
        end
    end
    return false
end

function getVehicleTuner( vehicle )
    if not isVehicleInModShop( vehicle ) then return false end
    return getVehicleController( vehicle )
end

function setModShopBusy( marker, vehicle, busy )
    if busy == true or busy == false then
        for k, v in ipairs( modShops ) do
            if modShops[ k ].marker == marker then
                modShops[ k ].veh = busy
                return true
            end
        end
    end
    for k, v in ipairs( modShops ) do
        if modShops[ k ].marker == marker then
            modShops[ k ].veh = vehicle
            return true
        end
    end
    return false
end



function getItemPrice( itemid )
    if not itemid then return false end
    if itemid > 1193 or itemid < 1000 then 
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



