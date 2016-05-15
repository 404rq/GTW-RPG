handlingProperties = { 
    "identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY",
    "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears",
    "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration",
    "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping",
    "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier",
    "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup"
}

function setHandling ( model, property, value )
    if not isHandlingPropertySupported ( property ) then
        return false
    end

    if isHandlingPropertyCorrectable ( property ) then
        value = getCorrectedHandlingValue ( value )
    elseif isHandlingPropertyHexadecimal ( property ) then
        value = tonumber ( "0x" .. value )
    else
        value = tonumber ( value )
        if isHandlingPropertyCenterOfMass ( property ) then
            local com = getModelHandling ( model )["centerOfMass"]
            local axis = property
            property = "centerOfMass"
            if axis == "centerOfMassX" then
                value = { value, com[2], com[3] }
            elseif axis == "centerOfMassY" then
                value = { com[1], value, com[3] }
            elseif axis == "centerOfMassZ" then
                value = { com[1], com[2], value }
            end
        end
    end

    if not setModelHandling ( model, property, value ) then
        outputDebugString ( tostring(property) )
    end

    return true
end

function isHandlingPropertySupported ( property )
    local unsupported = {
        ["ABS"]=true, ["monetary"]=true, 
        ["headLight"]=true, ["tailLight"]=true,
        ["animGroup"]=true
    }
    
    if unsupported[property] then
        return false
    end
    
    return true
end

function isHandlingPropertyCorrectable ( property )
    local props ={ 
        ["driveType"]=true, ["engineType"]=true,
        ["headLight"]=true, ["tailLight"]=true
    }
    
    return props[property] or false
end

function isHandlingPropertyCenterOfMass ( property )
    local props = {
        ["centerOfMassX"]=true, ["centerOfMassY"]=true,
        ["centerOfMassZ"]=true
    }
    
    return props[property] or false
end

function isHandlingPropertyHexadecimal ( property )
    if property == "modelFlags" or property == "handlingFlags" then
        return true 
    end
    
    return false
end

local correctedValues = {
    ["f"] = "fwd",
    ["r"] = "rwd",
    ["4"] = "awd",
    ["p"] = "petrol",
    ["d"] = "diesel",
    ["e"] = "electric",
    ["0"] = "long",
    ["1"] = "small",
    ["3"] = "big",
}

function getCorrectedHandlingValue ( value )
    return correctedValues[string.lower(value)] or "big" -- as 3 cant be converted to 'tall', we use 'big'
end