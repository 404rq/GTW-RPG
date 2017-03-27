
--[[

    Mod Shop 
    
    Author:     50p
    
    Version:    1.4.2

]]
local screenWidth, screenHeight = guiGetScreenSize( )

local g_root = getRootElement( )
local g_resRoot = getResourceRootElement( getThisResource( ) )
g_Me = getLocalPlayer();

local shopGUI = { buttons = { } }
local upgradeGUI = { }
local upgWidth = 230
local shopWidth = 170
local movingSpeed = 10 -- 10 px per frame

local hideSubToo = false
local hideMain = false
local mainWindowIsMoving = false
local shoNewSub = false

local moddingVeh = nil
local currUpgrades = nil
local currColors = { }
local tempColors = { }
local shopEnteredName = nil

local colorSet = { }
local paintjobSet = false
local upgradeChanged = { }
local newUpgrades = { }



addEvent( "onClientPlayerEnterModShop", true )
addEventHandler( "onClientPlayerEnterModShop", g_root, 
    function( vehicle, money, shopname )
        if getLocalPlayer() == source then
            moddingVeh = vehicle
            hideAllButtonsInMainWnd()
            showUpgradeButtons()
            upgradeChanged = { }
            newUpgrades = { }
            outputChatBox( "#FFFF00Welcome to #00FF00".. shopname .." #FFFF00mod shop!", 0,0,0, true )
            
            emptyShoppingCart( )
            guiSetText( shoppingCostLbl, "0" )
            
            shopEnteredName = shopname
            
            currColors = { getVehicleColor( vehicle ) }
			--outputDebugString( "Colors when you entered shop: ".. tostring( currColors[ 1 ] ) ..",  "..tostring( currColors[ 2 ] ) )
            tempColors[ 1 ],tempColors[ 2 ] = currColors[ 1 ], currColors[ 2 ]
            currUpgrades = getVehicleUpgrades( vehicle )
            
            for k, id in ipairs( currUpgrades ) do
                upgradeChanged[ getVehicleUpgradeSlotName( id ) ] = false
            end
            
            paintjob = getVehiclePaintjob( vehicle )
            
            showCursor( true )
            hideAllButtonsInMainWnd( )
            showUpgradeButtons( )
            
            guiSetText( shopGUI.wnd, shopname )
            guiSetVisible( cartWnd, true )
            addEventHandler( "onClientRender", g_root, showShopWindow )

            --toggleCameraFixedMode( true )
            addEventHandler( "onClientRender", g_root, rotateCameraAroundPlayer )
            return
        end
    end
)


addEventHandler( "onClientResourceStart", g_resRoot, function( )
        loadItems( )

        local buttonHeight = 23
        local btns = 3
        
        cartWnd = guiCreateWindow( 5, screenHeight - 320, 120, 150, "Cart", false )
            guiWindowSetSizable( cartWnd, false )
            guiCreateStaticImage( 10, 20, 100, 100, "cart.png", false, cartWnd)
            guiCreateButton( 10, 121, 110, 19, "", false, cartWnd )
        costsLbl = guiCreateLabel( 10, 121, 110, 20, " Costs:  $", false, cartWnd )
        shoppingCostLbl = guiCreateLabel( 10, 122, 95, 20, "0", false, cartWnd )
            guiSetFont( shoppingCostLbl, "default-bold-small" )
            guiLabelSetHorizontalAlign( shoppingCostLbl, "right" )
            guiLabelSetColor( shoppingCostLbl, 0, 255, 0 )
        guiSetVisible( cartWnd, false )
        
        shopGUI.wnd = guiCreateWindow( screenWidth + 2, screenHeight / 2 - 200, shopWidth, 430, "", false );
        guiWindowSetSizable( shopGUI.wnd, false )
        guiWindowSetMovable( shopGUI.wnd, false )
        guiSetAlpha( shopGUI.wnd, 0 )
        
        colorsWnd = guiCreateWindow( screenWidth / 2 - 230, screenHeight / 2 - 270, 460, 540, "", false )
        guiWindowSetSizable( colorsWnd, false )
        guiSetVisible( colorsWnd, false )
        guiSetText( colorsWnd, "Select your vehicle color" )
        colorGrid_img = guiCreateStaticImage( 10, 23, 440, 480, "vehiclecolors.png", false, colorsWnd )
        bothSame_img = guiCreateStaticImage( 0, 0, 9, 9, "colorselect.png", false, colorGrid_img )
        color1_img = guiCreateStaticImage( 0, 0, 9, 9, "color1.png", false, colorGrid_img )
        color2_img = guiCreateStaticImage( 0, 0, 9, 9, "color2.png", false, colorGrid_img )
        okBtn = guiCreateButton( 10, 512, 100, 25, "OK", false, colorsWnd )
        resetBtn = guiCreateButton( 115, 512, 100, 25, "Reset", false, colorsWnd )
        cancelBtn = guiCreateButton( 220, 512, 100, 25, "Cancel", false, colorsWnd )

        shopGUI.buttons = { }

        shopGUI.buttons[ "Color" ] = guiCreateButton( 10, 28, shopWidth, 18, "Color", false, shopGUI.wnd )

        shopGUI.buttons[ "Paintjob" ] = guiCreateButton( 10, 51, shopWidth, 18, "Paintjob", false, shopGUI.wnd )
        
        shopGUI.buttons[ "Exit" ] = guiCreateButton( 10, buttonHeight * btns + 8, shopWidth, buttonHeight - 5, "Exit", false, shopGUI.wnd )
        
        for i = 1, 17 do
            local upName = getVehicleUpgradeSlotName( i-1 )
            -- slot 11 is "Unknown"
            if not shopGUI.buttons[ i ] and i ~= 12 then
                shopGUI.buttons[ i ] = guiCreateButton( 10, buttonHeight * btns + 5, 230, buttonHeight - 5, upName, false, shopGUI.wnd )
                guiSetVisible( shopGUI.buttons[ i ], false )
                btns = btns + 1
            end
        end


        upgradeGUI.wnd = guiCreateWindow( screenWidth - 215, screenHeight / 2 - 150, upgWidth, 30, "", false )
        guiWindowSetSizable( upgradeGUI.wnd, false )
        guiWindowSetMovable( upgradeGUI.wnd, false )
        guiSetText( upgradeGUI.wnd, "" )
        guiSetVisible( upgradeGUI.wnd, false )
        guiMoveToBack( upgradeGUI.wnd )
        guiSetPosition( upgradeGUI.wnd, guiGetPosition( shopGUI.wnd, false ), false )

        upgradeGUI.gridList = { }
        upgradeGUI.gridList.grd = guiCreateGridList( 10, 23, upgWidth, 200, false, upgradeGUI.wnd )
            guiGridListSetSortingEnabled( upgradeGUI.gridList.grd, false )
            guiGridListAddColumn( upgradeGUI.gridList.grd, "Part name", 0.6 )
            guiGridListAddColumn( upgradeGUI.gridList.grd, "Price", 0.25 )
            guiGridListSetSelectionMode( upgradeGUI.gridList.grd, 0 )


        addEventHandler( "onClientGUIClick", shopGUI.buttons[ "Color" ], colorButtonClicked, false )

        addEventHandler( "onClientGUIClick", colorGrid_img,
            function( btn, state, x, y )
                colorGridClicked( btn, x, y )
            end, false
        )

        addEventHandler( "onClientGUIClick", getResourceRootElement( ),
            function( btn )
                colorWndButtonClicked( btn )
            end
        )

        addEventHandler( "onClientGUIClick", shopGUI.buttons[ "Exit" ], 
            function( btn )
                exitButtonClicked( btn )
            end, false
        )
        
        addEventHandler( "onClientGUIDoubleClick", upgradeGUI.gridList.grd, 
            function( btn )
                gridListClicked( btn )
            end, false
        )

    end
)

function colorButtonClicked( btn )
    if btn == "left" then
        local colors = { getVehicleColor( moddingVeh ) }
        setColorSelection( colors[ 1 ], 1 )
        setColorSelection( colors[ 2 ], 2 )
        guiSetVisible( colorsWnd, true )
        local rem = guiSetEnabled( shopGUI.buttons[ "Color" ], false )
    elseif btn == "hide" then
        guiSetEnabled( shopGUI.buttons[ "Color" ], true )
        for i=1, 2 do
            tempColors[ i ] = currColors[ i ]
        end
        setVehicleColor( moddingVeh, currColors[ 1 ], currColors[ 2 ], 0, 0 )
        guiSetVisible( colorsWnd, false )
        guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
    end
end


function colorWndButtonClicked( btn )
    if btn == "left" then
        if ( ( source == okBtn or source == cancelBtn or source == resetBtn ) and getElementParent( source ) == colorsWnd ) then
            if source == okBtn then
                guiSetEnabled( shopGUI.buttons[ "Color" ], true )
                guiSetVisible( colorsWnd, false )
            elseif source == cancelBtn then
                guiSetEnabled( shopGUI.buttons[ "Color" ], true )
                setVehicleColor( moddingVeh, unpack( currColors ) )
                tempColors[ 1 ], tempColors[ 2 ] = currColors[ 1 ], currColors[ 2 ]
                guiSetVisible( colorsWnd, false )
                setColorSelection( currColors[ 1 ], 1 )
                setColorSelection( currColors[ 2 ], 2 )
                colorSet[ 1 ], colorSet[ 2 ] = false, false
            else
                setColorSelection( currColors[ 1 ], 1 )
                setColorSelection( currColors[ 2 ], 2 )
                tempColors[ 1 ], tempColors[ 2 ] = currColors[ 1 ], currColors[ 2 ]
                setVehicleColor( moddingVeh, unpack( currColors ) )
                colorSet[ 1 ], colorSet[ 2 ] = false, false
            end
        end
    end
end


function exitButtonClicked( btn )
    if btn == "left" then
        if guiGetVisible( colorsWnd ) then
            colorButtonClicked( "hide" )
        end
        local upgrades = getVehicleUpgrades( moddingVeh )
        if not table.same( upgrades, currUpgrades ) or not table.same( tempColors, currColors ) or paintjob ~= getVehiclePaintjob( moddingVeh ) then 
            upgrades = leaveNewUpgrades( upgrades, currUpgrades )
            local newClrs = { unpack( currColors ) }
            if not table.same( tempColors, currColors ) then
                for i=1, 2 do
                    if tempColors[ i ] ~= currColors[ i ] then
                        newClrs[ i ] = tempColors[ i ]
                    end
                end
            end
            triggerServerEvent( "modShop_playerLeaveModShop", getLocalPlayer(), moddingVeh, getShoppingCosts(), upgrades, newClrs, getVehiclePaintjob( moddingVeh ), shopEnteredName ) 
        else
            hideMain = true
            showNewSub = false
            showCursor( false )
            btnPressed = nil
            toggleCameraFixedMode( false )
            addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
            triggerServerEvent( "modShop_unfreezVehicle", moddingVeh )
            removeEventHandler( "onClientRender", g_root, rotateCameraAroundPlayer )
        end
   end
end


function gridListClicked( btn )
    if btn == 'left' and guiGridListGetSelectedItem( upgradeGUI.gridList.grd ) ~= -1 then
        local row = guiGridListGetSelectedItem( source )
        if btnPressed == shopGUI.buttons[ "Paintjob" ] then
            if row ~= paintjob and not paintjobSet then
                if row ~= getVehiclePaintjob( moddingVeh ) then
                    paintjobSet = true
                    setVehiclePaintjob( moddingVeh, row )
                    addItemToCart( "paintjob", tonumber( row ) )
                end
            elseif row == getVehiclePaintjob( moddingVeh ) and paintjobSet then
                paintjobSet = false
                setVehiclePaintjob( moddingVeh, 3 )
                removeItemFromCart( "paintjob" )
                setVehicleColor( moddingVeh, tempColors[ 1 ], tempColors[ 2 ], currColors[ 3 ], currColors[ 4 ] )
            else
                replaceItemInCart( "paintjob", row )
                setVehiclePaintjob( moddingVeh, row )
            end
            guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
            return
        end
        local upgrades = getVehicleUpgrades( moddingVeh )
        local modid = upgradeGUI.gridList[ "upgID_"..row ]
        local price = tonumber( upgradeGUI.gridList[ "price_"..row ] )
        if currUpgrades then
            for k,id in ipairs( currUpgrades ) do
                if id == modid then
                    local slotname = getVehicleUpgradeSlotName( id )
                    if not isItemInCart( modid ) and not newUpgrades[ slotname ] then 
                        if upgradeChanged[ slotname ] == false then
                            upgradeChanged[ slotname ] = 1
                            guiGridListSetSelectedItem( upgradeGUI.gridList.grd, 0, 0 )
                            guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
                            return
                        elseif upgradeChanged[ slotname ] == 1 then
                            upgradeChanged[ slotname ] = false
                            addVehicleUpgrade( moddingVeh, modid )
                            return
                        end
                    elseif isItemInCart( newUpgrades[ slotname ] ) and newUpgrades[ slotname ] then
                        addVehicleUpgrade( moddingVeh, modid )
                        removeItemFromCart( newUpgrades[ slotname ] )
                        guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
                        upgradeChanged[ slotname ] = false
                        newUpgrades[ slotname ] = false
                        return
                    end
                    return
                end
            end
        end
        for k,v in ipairs( upgrades ) do
            local slotname = getVehicleUpgradeSlotName( v )
            if v == modid then
                guiGridListSetSelectedItem( upgradeGUI.gridList.grd, 0, 0 )
                local rem = removeVehicleUpgrade( moddingVeh, tonumber( modid ) )
                removeItemFromCart( modid )
                guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
                return
            elseif guiGetText( upgradeGUI.wnd ) == slotname then
                upgradeChanged[ slotname ] = true
                newUpgrades[ slotname ] = modid
                addVehicleUpgrade( moddingVeh, modid )
                if not replaceItemInCart( modid, price ) then
                    addItemToCart( modid, price )
                end
                guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
                return
            end
        end
        newUpgrades[ getVehicleUpgradeSlotName( modid ) ] = tonumber( modid )
        addItemToCart( tonumber( modid ), tonumber( price ) )
        guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
        addVehicleUpgrade( moddingVeh, modid )
    end
end


function colorGridClicked( btn, x, y )
    local gridX, gridY = guiGetPosition( colorGrid_img, false )
    local gridWidth, gridHeight = guiGetSize( colorGrid_img, false )
    local wndX, wndY = guiGetPosition( colorsWnd, false )
    local X = x - wndX - gridX
    local Y = y - wndY - gridY
    X = X/gridWidth
    Y = Y/gridHeight
    local indexX = math.floor( X / (1/11) )
    local indexY = math.floor( Y / (1/12) )
    local color = indexY * 11 + indexX
    if color > 126 then return end
    if btn == "left" then 
        local colors = { getVehicleColor( moddingVeh ) }
        colors[ 1 ] = color
        setVehicleColor( moddingVeh, unpack( colors ) )
        tempColors[ 1 ] = color
        setColorSelection( color, 1 )
    elseif btn == "right" then
        local colors = { getVehicleColor( moddingVeh ) }
        colors[ 2 ] = color
        setVehicleColor( moddingVeh, unpack( colors ) )
        setColorSelection( color, 2 )
        tempColors[ 2 ] = color
    elseif btn == "middle" then
        local colors = { getVehicleColor( moddingVeh ) }
        colors[ 1 ], colors[ 2 ] = color, color
        setVehicleColor( moddingVeh, unpack( colors ) )
        setColorSelection( color, "both" )
        tempColors[ 1 ], tempColors[ 2 ] = color, color
    end
    guiSetText( shoppingCostLbl, tostring( getShoppingCosts( ) ) )
end




function showUpgradeButtons( )
    guiSetSize( shopGUI.wnd, shopWidth, 500, false )
    local upgrades = getVehicleCompatibleUpgrades( moddingVeh )
    local alreadySet = { }
    local buttonHeight = 23
    local btns = 2
    if isVehicleRacer( moddingVeh ) or isVehicleLowrider( moddingVeh ) then
        guiSetVisible( shopGUI.buttons[ "Paintjob" ], true )
        btns = 3
    end
    for i = 1, 17 do
        for k, v in ipairs( upgrades ) do
            if i ~= 12 and alreadySet[ i ] ~= true and getVehicleUpgradeSlotName( v ) == guiGetText( shopGUI.buttons[ i ] ) then 
                guiSetVisible( shopGUI.buttons[ i ], true )
                guiSetPosition( shopGUI.buttons[ i ], 10, buttonHeight * btns + 5, false )
                alreadySet[ i ] = true
                btns = btns + 1
            end
        end
    end
    guiSetPosition( shopGUI.buttons[ "Exit" ], 10, 23 * btns + 15, false ) 
    guiSetSize( shopGUI.wnd, shopWidth, buttonHeight * btns + 45, false )
end


function hideAllButtonsInMainWnd( )
    for i = 1, 17 do
        guiSetVisible( shopGUI.buttons[ i ], false )
    end
    guiSetVisible( shopGUI.buttons[ "Paintjob" ], false )
end


function performAction( button )
    if button == "left" then

        local buttonName = guiGetText( source )
        
        if source == shopGUI.buttons[ "Color" ] and btnPressed ~= source then
            showNewSub = false
            addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
            btnPressed = source
            return
        elseif source == shopGUI.buttons[ "Paintjob" ] then
            if btnPressed ~= source then
                showPaintjobSub( )
            else
                showNewSub = false
                removeEventHandler( "onClientGUIClick", getResourceRootElement( getThisResource( ) ), performAction )
                addEventHandler( "onClientRender", g_root, contractSubWindow )
            end
            return
        end
        
        for i = 1, 17 do
            if buttonName == guiGetText( shopGUI.buttons[ i ] ) then
                if not hideSubToo and btnPressed ~= shopGUI.buttons[ i ] then
                    if guiGetVisible( colorsWnd ) then
                        guiSetVisible( colorsWnd, false )
                        colorButtonClicked( "hide" )
                    end
                    showSpecificSlotWindow( i - 1 )
                    btnPressed = shopGUI.buttons[ i ]
                    removeEventHandler( "onClientGUIClick", getResourceRootElement( ), performAction )
                    return
                elseif guiGetText( shopGUI.buttons[ i ] ) == guiGetText( upgradeGUI.wnd ) then
                    removeEventHandler( "onClientGUIClick", getResourceRootElement( ), performAction )
                    addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
                    btnPressed = shopGUI.buttons[ i ]
                    return
                elseif source ~= upgradeGUI.wnd and source ~= shopGUI.wnd then
                    showNewSub = true
                    showSpecificSlotWindow( guiGetText( source ) )
                    removeEventHandler( "onClientGUIClick", getResourceRootElement( ), performAction )
                    btnPressed = shopGUI.buttons[ i ]
                    return
                end
            end
        end
    end
end


addEvent( "modShop_insufficiantFounds", true )
addEventHandler( "modShop_insufficiantFounds", g_root,
    function( )
        outputChatBox( "Insufficient founds.", 255, 255, 0 )
    end
)


addEvent( "modShop_moddingConfirmed", true )
addEventHandler( "modShop_moddingConfirmed", g_root,
    function( )
        if guiGetVisible( colorsWnd ) then
            guiSetVisible( colorsWnd, false )
        end
        paintjobSet = false
        colorSet[ 1 ], colorSet[ 2 ] = false, false
        guiSetVisible( cartWnd, false )
        guiSetAlpha( shopGUI.wnd, 0.8 )
        hideMain = true
        showNewSub = false
        showCursor( false )

        --toggleCameraFixedMode( false )
        setCameraTarget( g_Me );
        addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
        removeEventHandler( "onClientRender", getRootElement(), rotateCameraAroundPlayer )
    end
)


function showSpecificSlotWindow( slotid )
    local slotname = getVehicleUpgradeSlotName( slotid )
    if type( slotid ) == 'string' then
        slotname = slotid
    end
    local upgrades = getVehicleCompatibleUpgrades( moddingVeh )
    if not hideSubToo then
        guiSetText( upgradeGUI.wnd, slotname )
        showNewSub = false 
    else
        addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
    end
    layoutButtons( slotname )
end


function layoutButtons( slotname )
    if not hideSubToo then
        local headerHeight = 23
        local rowHeight = 15
        local footerHeight = 10

        local upgrades = getVehicleCompatibleUpgrades( moddingVeh )
        guiSetSize( upgradeGUI.wnd, upgWidth, 600, false )
        guiGridListClear( upgradeGUI.gridList.grd )
        for k,v in pairs( upgradeGUI.gridList ) do
            if upgradeGUI.gridList[ k ] ~= upgradeGUI.gridList.grd then
                upgradeGUI.gridList[ k ] = nil
            end
        end
        guiSetSize( upgradeGUI.gridList.grd, upgWidth, 500, false )
        for k,v in ipairs( upgrades ) do
            if slotname == getVehicleUpgradeSlotName( v ) then
                local row = guiGridListAddRow( upgradeGUI.gridList.grd )
                local price = getItemPrice( v )
                guiGridListSetItemText( upgradeGUI.gridList.grd, row, 1, getItemName( v ), false, false )
                upgradeGUI.gridList[ "upgID_"..tostring( row ) ] = v
                guiGridListSetItemText( upgradeGUI.gridList.grd, row, 2, "$ "..tostring( price ), false, false )
                upgradeGUI.gridList[ "price_"..tostring( row ) ] = price
            end
        end
        local rows = guiGridListGetRowCount( upgradeGUI.gridList.grd )
        guiSetSize( upgradeGUI.wnd, upgWidth, rowHeight * rows + headerHeight + footerHeight + 40, false )
        guiSetSize( upgradeGUI.gridList.grd, upgWidth, (rowHeight * rows) + headerHeight + footerHeight, false )
        guiSetSize( upgradeGUI.wnd, upgWidth, 0, false )
        guiSetPosition( upgradeGUI.wnd, guiGetPosition( shopGUI.wnd, false ), false )
        guiSetVisible( upgradeGUI.wnd, true )
        addEventHandler( "onClientRender", getRootElement(), flyIn_window )
    end
end


function setProperRowSelected( )
    for k,v in ipairs( getVehicleUpgrades( moddingVeh ) ) do
        if getVehicleUpgradeSlotName( v ) == guiGetText( btnPressed ) then
            for i = 0, guiGridListGetRowCount( upgradeGUI.gridList.grd ) do
                if upgradeGUI.gridList[ "upgID_"..i ] == v then
                    guiGridListSetSelectedItem( upgradeGUI.gridList.grd, i, 2 )
                    break
                end
                i = i + 1
            end
        end
    end
end


function setColorSelection( colorID, slot )
	local xIndex = math.fmod(colorID, 11)
	local yIndex = math.floor(colorID/11)
	local x = xIndex/11 + (1/11)/2 - (9/440)/2
	local y = yIndex/12 + (1/12)/2 - (9/480)/2
    if type( slot ) ~= "string" then
    	guiSetPosition( _G[ "color"..slot.."_img" ], x, y, true )
        guiSetVisible( color1_img, true )
        guiSetVisible( color2_img, true )
        guiSetVisible( bothSame_img, false )
        if colorID ~= currColors[ slot ] and not colorSet[ slot ] then
            colorSet[ slot ] = true
            riseCartValue( 150 )
        elseif colorID == currColors[ slot ] and colorSet[ slot ] then
            colorSet[ slot ] = false
            decreaseCartValue( 150 )
        end
    elseif slot == "both" then
        guiSetVisible( bothSame_img, true )
        guiSetPosition( bothSame_img, x, y, true )
        guiSetVisible( color1_img, false )
        guiSetVisible( color2_img, false )
    end
    guiSetText( shoppingCostLbl, tostring( getShoppingCosts() ) )
end


--[[

        ANIMATING WINDOWS

]]

function hideShopWindow( )
    local fadingOut = 0.023
    local currAlpha = guiGetAlpha( shopGUI.wnd )
    local x,y = guiGetPosition( shopGUI.wnd, false )
    local subX, subY = guiGetPosition( upgradeGUI.wnd, false )
    if subX and guiGetAlpha( upgradeGUI.wnd ) > 0.1 and x < screenWidth and currAlpha > ( currAlpha - fadingOut )then
        mainWindowIsMoving = true
        guiSetPosition( shopGUI.wnd, x + movingSpeed, y, false )
        guiSetAlpha( shopGUI.wnd, currAlpha - fadingOut )
        if subX < x - 30 and subX < screenWidth and hideSubToo then
            addEventHandler( "onClientRender", getRootElement(), dragSubWindow )
            hideSubToo = false
        end
    elseif x < screenWidth and currAlpha > ( currAlpha - fadingOut ) then
        guiSetPosition( shopGUI.wnd, x + movingSpeed, y, false )
        guiSetAlpha( shopGUI.wnd, currAlpha - fadingOut )
    else
        mainWindowIsMoving = false 
        hideMain = false
        removeEventHandler( "onClientGUIClick", getResourceRootElement( getThisResource( ) ), performAction )
        removeEventHandler( "onClientRender", getRootElement(), hideShopWindow )
    end
end


function showShopWindow( name )
    local fadingIn = 0.023
    local currAlpha = guiGetAlpha( shopGUI.wnd )
    local x,y = guiGetPosition( shopGUI.wnd, false )
    if x > screenWidth - shopWidth and currAlpha < currAlpha + fadingIn then
        mainWindowIsMoving = true
        guiSetPosition( shopGUI.wnd, x - movingSpeed, y, false )
        guiSetAlpha( shopGUI.wnd, currAlpha + fadingIn )
    else
        mainWindowIsMoving = false
        guiSetPosition( shopGUI.wnd, screenWidth - shopWidth, y, false )
        guiSetAlpha( shopGUI.wnd, 0.8 )
        removeEventHandler( "onClientRender", getRootElement(), showShopWindow )
        addEventHandler( "onClientGUIClick", getResourceRootElement( getThisResource( ) ), performAction )
    end
end


function showPaintjobSub( )
    showNewSub = "paintjob"
    removeEventHandler( "onClientGUIClick", getResourceRootElement( getThisResource( ) ), performAction )
    addEventHandler( "onClientRender", getRootElement(), contractSubWindow )
end


function flyIn_window(  )
    local x, y = guiGetPosition( upgradeGUI.wnd, false )
    local shopX, shopY = guiGetPosition( shopGUI.wnd, false )
    local btnX, btnY = guiGetPosition( btnPressed, false )
    local shopWidth, _ = guiGetSize( shopGUI.wnd, false )
    local currAlpha = guiGetAlpha( upgradeGUI.wnd )
    if ( x > screenWidth - upgWidth - shopWidth ) and currAlpha < currAlpha + .024 then
        guiSetAlpha( upgradeGUI.wnd, currAlpha + .02 )
        guiSetPosition( upgradeGUI.wnd, x - movingSpeed, btnY+shopY, false )
    else
        hideSubToo = true 
        guiSetAlpha( upgradeGUI.wnd, 0.8 )
        guiSetPosition( upgradeGUI.wnd, screenWidth - shopWidth - upgWidth, btnY+shopY, false )
        removeEventHandler( "onClientRender", getRootElement(), flyIn_window )
        if btnPressed == shopGUI.buttons[ "Paintjob" ] and getVehiclePaintjob( moddingVeh ) ~= 255 then
            guiGridListSetSelectedItem( upgradeGUI.gridList.grd, getVehiclePaintjob( moddingVeh ), 1 )
        else
            setProperRowSelected( )
        end
        addEventHandler( "onClientRender", getRootElement(), extendSubWindow )
    end
end


function flyOut_window(  )
    local x, y = guiGetPosition( upgradeGUI.wnd, false )
    local shopX, shopY = guiGetPosition( shopGUI.wnd, false )
    local shopWidth, _ = guiGetSize( shopGUI.wnd, false )
    local currAlpha = guiGetAlpha( upgradeGUI.wnd )
    if ( x <= screenWidth - shopWidth ) and currAlpha - .021 > 0.0 then
        guiSetAlpha( upgradeGUI.wnd, currAlpha - .04 )
        guiSetPosition( upgradeGUI.wnd, x + movingSpeed, y, false )
    else
        hideSubToo = false 
        guiSetVisible( upgradeGUI.wnd, false )
        guiSetAlpha( upgradeGUI.wnd, 0.0 )
        guiSetPosition( upgradeGUI.wnd, shopX, shopY, false )
        removeEventHandler( "onClientRender", getRootElement(), flyOut_window )
        if hideMain then
            addEventHandler( "onClientRender", g_root, hideShopWindow )
        elseif type( showNewSub ) == "string" and showNewSub == "paintjob" then
            
            btnPressed = shopGUI.buttons[ "Paintjob" ]
            local headerHeight = 23
            local rowHeight = 15
            local footerHeight = 10
            guiSetSize( upgradeGUI.wnd, upgWidth, 600, false )
            guiSetSize( upgradeGUI.gridList.grd, upgWidth, 500, false )
            guiSetText( upgradeGUI.wnd, "Paintjob" )
            guiGridListClear( upgradeGUI.gridList.grd )
            for k,v in pairs( upgradeGUI.gridList ) do
                if upgradeGUI.gridList[ k ] ~= upgradeGUI.gridList.grd then
                    upgradeGUI.gridList[ k ] = nil
                end
            end
            if getVehicleID( moddingVeh ) ~= 575 then
                for i = 0, 2 do
                    local row = guiGridListAddRow( upgradeGUI.gridList.grd )
                    guiGridListSetItemText( upgradeGUI.gridList.grd, row, 1, "Paintjob "..tostring(i+1), false, false )
                    guiGridListSetItemText( upgradeGUI.gridList.grd, row, 2, "$ 500", false, false )
                end
            else
                for i = 0, 1 do
                    local row = guiGridListAddRow( upgradeGUI.gridList.grd )
                    guiGridListSetItemText( upgradeGUI.gridList.grd, row, 1, "Paintjob "..tostring(i+1), false, false )
                    guiGridListSetItemText( upgradeGUI.gridList.grd, row, 2, "$ 500", false, false )
                end
            end
            local rows = guiGridListGetRowCount( upgradeGUI.gridList.grd )
            guiSetSize( upgradeGUI.gridList.grd, upgWidth, (rowHeight * rows) + headerHeight + footerHeight, false )
            guiSetSize( upgradeGUI.wnd, upgWidth, 0, false )
            guiSetVisible( upgradeGUI.wnd, true )
            addEventHandler( "onClientRender", getRootElement(), flyIn_window )
            
        elseif showNewSub then
            showSpecificSlotWindow( guiGetText( btnPressed ) )
        elseif guiGetVisible( colorsWnd ) or btnPressed == shopGUI.buttons[ "Paintjob" ] then
            if btnPressed == shopGUI.buttons[ "Paintjob" ] then
                addEventHandler( "onClientGUIClick", g_resRoot, performAction )
                btnPressed = nil
            end
            return
        else
            addEventHandler( "onClientGUIClick", g_resRoot, performAction )
        end
    end
end


function extendSubWindow( )
    local btns 
    local headerHeight = 23
    local rowHeight = 15
    local footerHeight = 10
    if btnPressed == shopGUI.buttons[ "Paintjob" ] then
        if getVehicleID( moddingVeh ) ~= 575 then
            btns = 4 
        else
            btns = 3
        end
    elseif btnPressed ~= shopGUI.buttons[ "Color" ] then 
        btns = getBtnsInWindow( )
    end
    local width, height = guiGetSize( upgradeGUI.wnd, false )
    local x, y = guiGetPosition( upgradeGUI.wnd, false )
    if height < ( btns * rowHeight + headerHeight + footerHeight ) then
        guiSetSize( upgradeGUI.wnd, width, height + movingSpeed, false )
        if height > screenHeight - y then
            guiSetPosition( upgradeGUI.wnd, x, (screenHeight - height), false )
        end
    else
        guiSetSize( upgradeGUI.wnd, width, btns * rowHeight + headerHeight + footerHeight + 25, false )
        removeEventHandler( "onClientRender", getRootElement(), extendSubWindow )
        if not showNewSub or btnPressed == shopGUI.buttons[ "Paintjob" ] then
            addEventHandler( "onClientGUIClick", g_resRoot, performAction )
        end
    end
end


function contractSubWindow( )
    local btns = getBtnsInWindow( )
    local width, height = guiGetSize( upgradeGUI.wnd, false )
    local x, y = guiGetPosition( upgradeGUI.wnd, false )
    if height > 49 then
        guiSetSize( upgradeGUI.wnd, width, height - movingSpeed, false )
        if height > screenHeight - y then
            guiSetPosition( upgradeGUI.wnd, x, (screenHeight - height), false )
        end
    else
        guiSetSize( upgradeGUI.wnd, width, 23, false )
        removeEventHandler( "onClientRender", g_root, contractSubWindow )
        guiMoveToBack( upgradeGUI.wnd )
        addEventHandler( "onClientRender", g_root, flyOut_window )
        if not showNewSub and btnPressed ~= shopGUI.buttons[ "Color" ] and btnPressed ~= shopGUI.buttons[ "Paintjob" ] then
            btnPressed = nil
        end
    end
end


function dragSubWindow( )
    local x, y = guiGetPosition( upgradeGUI.wnd, false )
    local shopX, shopY = guiGetPosition( shopGUI.wnd, false )
    local _, shopHeight = guiGetSize( shopGUI.wnd, false )
    local currAlpha = guiGetAlpha( upgradeGUI.wnd )
    if mainWindowIsMoving then
        guiSetAlpha( upgradeGUI.wnd, currAlpha - 0.024 )
        guiSetPosition( upgradeGUI.wnd, x + movingSpeed, y, false )
    elseif ( ( x ~= shopX ) or ( x < shopX ) ) and currAlpha < currAlpha + .024 then
        guiSetAlpha( upgradeGUI.wnd, currAlpha - 0.024 )
        guiSetPosition( upgradeGUI.wnd, x + movingSpeed, y, false )
    else
        guiSetAlpha( upgradeGUI.wnd, 0.8 )
        guiSetPosition( upgradeGUI.wnd, x, shopHeight + shopY, false )
        removeEventHandler( "onClientRender", getRootElement(), dragSubWindow )
        addEventHandler( "onClientGUIClick", getResourceRootElement( getThisResource( ) ), performAction )
        showNewSub = false
    end
end



--[[

        MISC. FUNCTIONS
        
]]


function getBtnsInWindow( )
    local slotname = guiGetText( btnPressed )
    local upgrades = getVehicleCompatibleUpgrades( moddingVeh )
    local btns = 1
    for k,v in ipairs( upgrades ) do
        if slotname == getVehicleUpgradeSlotName( v ) then
            btns = btns + 1
        end
    end
    return btns
end


function table.same( t1, t2 )
    local size = table.getsize( t1 )
    local size2 = table.getsize( t2 )
    if size == size2 then
        for i = 1, size do
            if t1[ i ] ~= t2[ i ] then return false end
        end
    else 
        return false
    end
    return true
end


function table.getsize( t )
    local tsize = 0
    for k, v in pairs( t ) do
        tsize = tsize + 1
    end
    return tsize
end


function leaveNewUpgrades( newtable, oldtable )
    local leftUpgrades = { }
    for k, v in ipairs( newtable ) do
        if newtable[ k ] ~= oldtable[ k ] then 
            table.insert( leftUpgrades, newtable[ k ] ) 
        end
    end
    return leftUpgrades
end


local facing = 0
function rotateCameraAroundPlayer( )
    local x, y, z = getElementPosition( getLocalPlayer() )
    if isPedInVehicle( getLocalPlayer( ) ) then
        x, y, z = getElementPosition( moddingVeh )
    else
        fixedCamera( false )
        removeEventHandler( "onClientRender", getResourceRootElement( ), rotateCameraAroundPlayer )
    end
    local camX = x + math.cos( facing / math.pi * 180 ) * 5
    local camY = y + math.sin( facing / math.pi * 180 ) * 5
    
    --setCameraPosition( camX, camY, z+1 )
    --setCameraLookAt( x, y, z )
    --use for dp3:
    setCameraMatrix( camX, camY, z+1, x, y, z )
    facing = facing + 0.0002
end


addEvent( "modShop_clientResetVehicleUpgrades", true )
function resetVehicleUpgradesToPrevious( )
    triggerEvent( "modShop_moddingConfirmed", getLocalPlayer( ) )
    for i = 0, 16 do
        local modid = getVehicleUpgradeOnSlot( moddingVeh, i )
        if modid then
            removeVehicleUpgrade( moddingVeh, modid )
        end
    end
    for k,v in pairs( currUpgrades ) do
        addVehicleUpgrade( moddingVeh, v )
    end
    setVehicleColor( moddingVeh, unpack( currColors ) )
    if paintjob ~= 255 then
        setVehiclePaintjob( moddingVeh, paintjob )
    end
end
addEventHandler( "modShop_clientResetVehicleUpgrades", getRootElement( ), resetVehicleUpgradesToPrevious )













