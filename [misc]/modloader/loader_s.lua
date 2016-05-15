mods = {}
meta = xmlLoadFile ( "meta.xml" )
local vehicleMods = {}
local weaponMods = {}
local skinMods = {}

addEventHandler ( "onResourceStart", resourceRoot, function ( )
    setTimer ( function ( )
        if getResourceName ( resource ) == "modloader" then
            outputDebugString ( "It seems you use the default resource name for ModLoader." )
            outputDebugString ( "It's reccomanded to change the name to something unique." )
            outputDebugString ( "Please read the readme for more information." )
        end
        
        local reload = false
        
        for index,node in pairs ( xmlNodeGetChildren ( meta ) ) do
            if xmlNodeGetName ( node ) == "file" then
                mods[xmlNodeGetAttribute(node,"src")] = node
            end
        end  
        
        --------------------------------------------------
        
        function checkMod ( modDir, model )
            local txd = modDir.."/"..model..".txd"
            local dff = modDir.."/"..model..".dff"
            if fileExists ( txd ) then
                if not mods[txd] then 
                    addMod ( model, txd, modDir )
                else
                    loadMod ( modDir, model )
                end
            end
            if fileExists ( dff ) then
                if not mods[dff] then 
                    addMod ( model, dff, modDir )
                else
                    loadMod ( modDir, model )
                end
            end
        end

        function addMod ( model, path, modType )
            reload = true
            local newChild = xmlCreateChild ( meta, "file" )
            xmlNodeSetAttribute ( newChild, "src", path )
            outputDebugString ( "Added file entry for "..modType..": "..model.." - "..path )
        end

        function loadMod ( modDir, model )
            local tab,data
            
            if     modDir == "vehicles" then tab = vehicleMods; data = validVehicleModels
            elseif modDir == "weapons"  then tab = weaponMods; data = validWeaponModels
            elseif modDir == "skins"    then tab = skinMods; data = validPedModels end
            
            tab[model] = data[model]
        end
        
        --------------------------------------------------
        
        -- Vehicles
        for vehicle,_ in pairs ( validVehicleModels ) do
            checkMod ( "vehicles", vehicle )
        end
        
        -- Weapons
        for weapon,_ in pairs ( validWeaponModels ) do
            checkMod ( "weapons", weapon )
        end
        
        -- Peds
        for ped,_ in pairs ( validPedModels ) do
            checkMod ( "skins", ped )
        end
        
        if reload then
            xmlSaveFile ( meta )
            xmlUnloadFile ( meta )
            
            outputDebugString ( "New mods saved. Restarting resource.." )
            restartResource ( resource )
            
            return true
        end
        
        for modelName,modelID in pairs ( validVehicleModels ) do
            if fileExists ( "vehicles/"..modelName..".hnd" ) then
                local file = fileOpen ( "vehicles/"..modelName..".hnd", true )
                local str = ""
                
                while not fileIsEOF ( file ) do
                    str = str..fileRead ( file, 100 )
                end
                
                fileClose ( file )
                
                local vIdentifierFound = false
                local item = 2
                
                for value in string.gmatch ( str, "[^%s]+" ) do
                    if not vIdentifierFound and tonumber ( value ) then
                        vIdentifierFound = true
                    end
                    
                    if vIdentifierFound then
                        local property = handlingProperties[item]
                        if property then
                            setHandling ( modelID, property, value )
                        end
                        
                        item = item+1
                    end
                end
            end
        end
        
        return true
    end, 100, 1 )
    
    return true
end )



addEventHandler ( "onResourceStop", resourceRoot, function ( )
    xmlSaveFile ( meta )
    xmlUnloadFile ( meta )
end )



_restartResource = restartResource
function restartResource ( )
    if hasObjectPermissionTo ( resource, "function.restartResource", true ) then
        xmlSaveFile ( meta )
        xmlUnloadFile ( meta )
        
        setTimer ( function ( )
            _restartResource ( resource )
        end, 1000, 1 )
        
        return true
    end
    
    outputDebugString ( "ModLoader has no permission to restart the resource! Instead, do it manually or add this resource to the ACL." )
    return false
end



addEvent ( "requestReplacements", true )
addEventHandler ( "requestReplacements", root, function ( )
    outputDebugString ( "modloader server: Player "..getPlayerName(source).." requested replacing" )
    triggerClientEvent ( source, "replaceModels", source, vehicleMods, weaponMods, skinMods )
end )