addCommandHandler ( "mdel", function ( player, _, modDir, modName )
    if not hasRights ( player ) then
        return false
    end
    
    if type ( modDir ) ~= "string" or type ( modName ) ~= "string" then
        outputDebugString ( "Please enter valid arguments! use 'mdel [moddir] [modname]'!" )
        return false        
    end
    
    local txd = modDir.."/"..modName..".txd"
    local dff = modDir.."/"..modName..".dff"
    local hnd = modDir.."/"..modName..".hnd"
    
    if fileExists ( txd ) then
        fileDelete ( txd )
        xmlDestroyNode ( mods[txd] )
        outputDebugString ( "Deleted TXD in "..modDir.." for item "..modName )
    end
    
    if fileExists ( dff ) then
        fileDelete ( dff )
        xmlDestroyNode ( mods[dff] )
        outputDebugString ( "Deleted DFF in "..modDir.." for item "..modName )
    end
    
    if fileExists ( hnd ) then
        fileDelete ( hnd )
        outputDebugString ( "Deleted handling in "..modDir.." for item "..modName )
    end
    
    outputDebugString ( "Deleted mod "..modName..". Restarting resource.." )
    restartResource ( )
    
    return true
end )



addCommandHandler ( "mclear", function ( player, _, modDir )
    if not hasRights ( player ) then
        return false
    end
    
    if type ( modDir ) ~= "string" then
        outputDebugString ( "Please enter valid arguments! use 'mclear [moddir]'!" )
        return false        
    end
    
    local tab
    if modDir == "vehicles" then
        tab = validVehicleModels
    elseif modDir == "weapons" then
        tab = validWeaponModels
    elseif modDir == "skins" then
        tab = validPedModels
    else
        outputDebugString ( "Please use a valid mod directory! Valids are: 'vehicles', 'weapons', 'skins'." )
        return false
    end
    
    for modelName,modelID in pairs ( tab ) do
        local txd = modDir.."/"..modelName..".txd"
        local dff = modDir.."/"..modelName..".dff"
        local hnd = modDir.."/"..modelName..".hnd"
        
        if fileExists ( txd ) then
            fileDelete ( txd )
            xmlDestroyNode ( mods[txd] )
            outputDebugString ( "Deleted TXD in "..modDir.." for item "..modelName )
        end
        
        if fileExists ( dff ) then
            fileDelete ( dff )
            xmlDestroyNode ( mods[dff] )
            outputDebugString ( "Deleted DFF in "..modDir.." for item "..modelName )
        end
        
        if fileExists ( hnd ) then
            fileDelete ( hnd )
            outputDebugString ( "Deleted handling in "..modDir.." for item "..modelName )
        end
    end
    
    outputDebugString ( "Cleared mod directory "..modDir..". Restarting resource.." )
    restartResource ( )
    
    return true
end )



function hasRights ( player )
    if getElementType ( player ) == "console" then
        return true
    end
    
    local pAccount = getPlayerAccount ( player ) 
    if isGuestAccount ( pAccount ) then
        return false
    end
    
    if isObjectInACLGroup ( "user."..pAccount, aclGetGroup ( "admin" ) ) then
        return true
    end
    
    return false
end