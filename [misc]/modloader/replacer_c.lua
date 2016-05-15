local allowCollisions = false -- Change this to true if you want to enable custom collisions! Please note that his might be unstable on some clients though!
local maxVehicles = 10 -- This represents the maximum amount of vehicles to be replaced again for it's custom collision. More vehicles means more lagg, less vehicles means more time.





----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function loadMod ( modDir, file, model )
    local txdFile = modDir.."/"..file..".txd"
    local dffFile = modDir.."/"..file..".dff"
    
    if fileExists ( txdFile ) then
        outputConsole ( "Replaced TXD for vehicle "..file.." on ID "..tostring(model) )
        local txd = engineLoadTXD ( txdFile )
        engineImportTXD ( txd, model )
    end
    
    if fileExists ( dffFile ) then
        outputConsole ( "Replaced DFF for vehicle "..file.." on ID "..tostring(model) )
        local dff = engineLoadDFF ( dffFile, model )
        engineReplaceModel ( dff, model )
    end
end



function replaceVehicleCollisions ( replacedVehicles )
    local totalReplaces = table.size ( replacedVehicles )
    local models = {}
    local vehicles = {}
    local num = 1
    
    
    
    for file,model in pairs ( replacedVehicles ) do
        table.insert ( models, {file,model} )
    end
    
    
    
    function replace ( vehicle, file, model )
        local txd = engineLoadTXD ( "vehicles/"..file..".txd" )
        engineImportTXD ( txd, model )
        
        local dff = engineLoadDFF ( "vehicles/"..file..".dff", model )
        local success = engineReplaceModel ( dff, model )
        
        outputDebugString ( "Replaced Collision DFF: "..tostring(success) )
        
        destroyElement ( vehicle )
    end
    
    
    
    setTimer ( function ( )
        local posX, posY, posZ = getElementPosition ( localPlayer )
        local rotZ = math.rad ( -getPedRotation ( localPlayer ) )
        posX = posX + ( math.sin ( rotZ ) * 10 )
        posY = posY + ( math.cos ( rotZ ) * 10 )
        
        local vehicle = createVehicle ( models[num][2], posX, posY, posZ )
        setElementCollisionsEnabled ( vehicle, false )
        setVehicleDamageProof ( vehicle, true )
        setElementAlpha ( vehicle, 0 )
        setVehicleGravity ( vehicle, 0, 0, 0 )
        table.insert ( vehicles, vehicle )
        
        setTimer ( replace, 3000, 1, vehicle, models[num][1], models[num][2] )
        
        num = num+1
    end, 30*maxVehicles, totalReplaces )
    
    return true
end



function table.size ( tab )
    local length = 0
    
    for _ in pairs ( tab ) do
        length = length + 1
    end
    
    return length
end



addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
    setTimer ( function ( )
        outputDebugString ( "modloader client: Finished downloading, requesting server for mods." )
        triggerServerEvent ( "requestReplacements", localPlayer )
    end, 1000, 1 )
end )



addEvent ( "replaceModels", true )
addEventHandler ( "replaceModels", root, function ( replacedVehicles, replacedWeapons, replacedSkins )
    outputDebugString ( "modloader client: Replacing mods! #vehicles:"..tostring(table.size(replacedVehicles)).." | #weapons:"..tostring(table.size(replacedWeapons)).." | #skins:"..tostring(table.size(replacedSkins)) )
    
    local totalVehicles = table.size ( replacedVehicles )
    local scannedVehicles = 0
    
    -- Vehicles
    for modelName,modelID in pairs ( replacedVehicles ) do
        scannedVehicles = scannedVehicles + 1
        
        loadMod ( "vehicles", modelName, modelID )
        
        if allowCollisions and scannedVehicles == totalVehicles then
            replaceVehicleCollisions ( replacedVehicles )
        end
    end

    -- Weapons
    for modelName,modelID in pairs ( replacedWeapons ) do
        loadMod ( "weapons", modelName, modelID )
    end
    
    -- Peds
    for modelName,modelID in pairs ( replacedSkins ) do
        loadMod ( "skins", modelName, modelID )
    end
end )