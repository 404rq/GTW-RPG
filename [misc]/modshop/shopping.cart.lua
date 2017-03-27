
shoppingCart = { upgrades = { }, prices = { }, value }


function addItemToCart( modid, price )
    if type( modid ) == "string" and modid == "paintjob" then
        --outputDebugString( tostring( price ) )
        addPaintjobToCart( price )
        return true
    elseif type( modid ) == "string" then
        local clr = modid:match( "(%w+)_(%w+)" )
        if clr == "color" then
            riseCartValue( 150 )
            return true
        end
        return false
    end
    if not isItemInCart( modid ) then
        table.insert( shoppingCart.upgrades, modid )
        table.insert( shoppingCart.prices, price )
        riseCartValue( price )
        return true
    end
    return false
end

function riseCartValue( amount )
    shoppingCart.value = shoppingCart.value + amount
end

function decreaseCartValue( amount )
    if shoppingCart.value - amount < 0 then
        shoppingCart.value = 0
    else
        shoppingCart.value = shoppingCart.value - amount
    end
end

function addPaintjobToCart( paintjob )
    shoppingCart.prices[ "paintjob" ] = 500
    shoppingCart.upgrades[ "paintjob" ] = paintjob
    shoppingCart.value = getShoppingCosts( ) + 500
end


function removePaintjobFromCart( )
    shoppingCart.upgrades[ "paintjob" ] = nil
    shoppingCart.prices[ "paintjob" ] = nil
    shoppingCart.value = shoppingCart.value - 500
end


function removeItemFromCart( modid )
    if type( modid ) == "string" and modid == "paintjob" then
        removePaintjobFromCart( )
        return true
    end
    for k,v in ipairs( shoppingCart.upgrades ) do
        if shoppingCart.upgrades[ k ] == modid then
            shoppingCart.value = shoppingCart.value - tonumber( shoppingCart.prices[ k ] )
            shoppingCart.upgrades[ k ] = nil
            shoppingCart.prices[ k ] = nil
            return true
        end
    end
    return false
end


function replaceItemInCart( newmodid, newprice )
    if type( newmodid ) == "string" and newmodid == "paintjob" then
        removePaintjobFromCart( )
        addPaintjobToCart( newprice )
        return true
    end
    for k,v in ipairs( shoppingCart.upgrades ) do
        if getVehicleUpgradeSlotName( v ) == getVehicleUpgradeSlotName( newmodid ) then
            removeItemFromCart( v )
            return addItemToCart( newmodid, newprice )
        end
    end
    return false
end


function isItemInCart( item )
    if type( item ) == 'string' then
        local name, id = item:match( "(%w+)_(%d+)" )
        if name == "color" then
            if shoppingCart.upgrades[ item ] then
                return true
            end
        elseif item == "paintjob" then
            if shoppingCart.upgrades[ item ] then
                return true
            end
        end
        return false
    end
    for k,v in ipairs( shoppingCart.upgrades ) do
        if shoppingCart.upgrades[ k ] == item then 
            return true
        end
    end
    return false
end


function getPaintjobFromCart( )
    return shoppingCart.upgrades[ "paintjob" ]
end


function getItemFromCart( item ) 
    if type( item ) == "string" and item == "paintjob" then
        return getPaintjobFromCart( )
    end
    return false
end


function getItemsFromCart( )
    return shoppingCart.upgrades
end


function getShoppingCosts( )
    return shoppingCart.value
end


function emptyShoppingCart( )
    shoppingCart.upgrades = nil
    shoppingCart.upgrades = { }
    shoppingCart.prices = nil
    shoppingCart.prices = { }
    shoppingCart.value = 0
end


