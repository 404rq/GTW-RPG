--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

-- Markers
marker	 		= {}
respawnTimers 	= {}

-- Global data
train 			= {{ }} 
pilot 			= {{ }}
trainDirection	= { }
syncTimer 		= { }
cooldown 		= { }
markercooldown 	= { }
turncooldown	= { }
globcooldown 	= nil
globaldist 		= false
horncooldown	= { }

-- Add all the markers
function addMarkers ( res )
	for k=1, #markers do
    	marker[k] = createMarker ( markers[k][1], markers[k][2], markers[k][3]-4, "cylinder", 25, 0, 0, 0, 255 )
    	if setDebugMode == 0 then
    		setElementAlpha( marker[k], 0 )
    	elseif setDebugMode == 1 or setDebugMode == 2 then
    		setElementAlpha( marker[k], 40 )
    	end
    	addEventHandler( "onMarkerHit", marker[k], makeTrain )
    	addEventHandler( "onMarkerLeave", marker[k], markerLeave )
    end
    
    -- Debug mode 2
    for w=1, #spawnPoints do
    	if setDebugMode == 2 then
    		createMarker( spawnPoints[w][1], spawnPoints[w][2], spawnPoints[w][3]-4, "cylinder", 15, 255, 255, 255, 40 )
    	end
    end
end
addEventHandler( "onResourceStart", getResourceRootElement( ), addMarkers )

-- Kill respawn timer when a player leave a spawn marker
function markerLeave( leaveElement, matchingDimension )
	if isTimer( respawnTimers[leaveElement] ) then
		killTimer( respawnTimers[leaveElement] )
	end
end

-- Return ID of nearest train
function findNearestTrain ( thePlayer )
	if isElement( thePlayer ) and getElementType ( thePlayer ) == "player" then
    	local nearest = nil
	    local min = 999999
	    local max = 30
	    local counter = 1
	    for key,val in pairs( spawnPoints ) do
	        local xx,yy,zz=getElementPosition( thePlayer )
	        local x1=val[1] 
	        local y1=val[2]
	        local z1=val[3]
	        local dist = getDistanceBetweenPoints2D(xx,yy,x1,y1)
	
	        if dist<min and dist>max then
	          	nearest = val
	          	min = dist
	          	counter = key
	        end
	    end
	    return counter
    end
    return false
end

-- Returns the id of the nearest train station
function findNearestTrainStation( loctrain )
	if isElement( loctrain ) then
	    local min = 1200
	    local counter = 0
	    local markType = "station"
	    for w=1, #trainLocations do
	        local xx,yy,zz=getElementPosition( loctrain )
	        local x1=trainLocations[w][1] 
	        local y1=trainLocations[w][2] 
	        local z1=trainLocations[w][3] 
	        markType=trainLocations[w][5] 
	        local dist = getDistanceBetweenPoints2D(xx,yy,x1,y1)
	
	        if dist < min then
	          	min = dist
	          	counter = w
	        end
	    end
	    return counter,markType
    end
    return false
end

-- Return distance to nearest train or 9999
function findNearestTrainActive( player )
	if isElement( player ) then
	    local minDist = 9999
	    local px,py,pz=getElementPosition( player )
	    for i,locomotive in pairs( train ) do
	    	if isElement( locomotive[1] ) then
	        	local lx,ly,lz=getElementPosition( locomotive[1] )
		        local dist = getDistanceBetweenPoints3D( lx,ly,lz, px,py,pz )
		        if dist<minDist then
		          	minDist = dist
		        end
		    end
	    end
	    return minDist
    end
    return 0
end

function getNearbyTrain(thePlayer)
	if isElement(thePlayer) then
		local dist = 9999
		local px,py,pz = getElementPosition(thePlayer)
		for id, trainVeh in ipairs(getElementsByType("vehicle")) do
			if getVehicleType(trainVeh) == "Train" then
				local tx,ty,tz = getElementPosition(trainVeh)
				if dist > getDistanceBetweenPoints3D(px,py,pz, tx,ty,tz) then
					dist = getDistanceBetweenPoints3D(px,py,pz, tx,ty,tz)
				end
			end
		end
		return dist
	end
	return 9999
end

-- Initialize the train and attach the carriages
function makeTrain( hitElement, matchingDimension, id )
	-- Make sure the player is the hitelement
	if train[hitElement] and train[hitElement][1] then return end
	if isElement( hitElement ) and getElementType( hitElement ) == "vehicle" and getVehicleType( hitElement ) ~= "Train" then
		hitElement = getVehicleOccupant( hitElement )
	end
	if isElement( hitElement ) and getElementType( hitElement ) == "player" and 
		getPedOccupiedVehicle( hitElement ) then
		if getPlayerPing( hitElement ) > maxSyncerPing then
			return
		end
		tmpveh = getPedOccupiedVehicle( hitElement )
	else
		tmpveh = 400
	end
	-- Justify direction
	trainDirection[hitElement] = true
	local numberOfActiveTrains = #train or 0
	if numberOfActiveTrains > 0 then
		trainDirection[hitElement] = globaldist
	else
		trainDirection[hitElement] = not globaldist
	end
	-- Break if other trains are nearby
	if getNearbyTrain(hitElement) < 1500 then return end
	if ( not isTimer( globcooldown ) and not isTimer( markercooldown[source] ) and 
		getVehicleType( tmpveh ) and getVehicleType( tmpveh ) ~= "Train" and 
		numberOfActiveTrains < maxNumberOfTrains and findNearestTrainActive(hitElement) > 1100 ) then
		-- Initialize
		if not train[hitElement] then
			train[hitElement] = {}
		end
		if not pilot[hitElement] then
			pilot[hitElement] = {}
		end
		
		-- Check for already existing trains
		if not isElement( train[hitElement][1] ) then
			-- Cleanup
			cleanUp( hitElement )
			
			-- Spawn the train
			local spawner = findNearestTrain( hitElement )
			if spawner then
				local maxAttach = maxAttachedTrailers
				local numberOfWagonsInTrain = math.random(minAttachedTrailers,maxAttach)
				if spawnPoints[spawner][5] == "tram" then
					maxAttach = 3
					numberOfWagonsInTrain = math.random(1,maxAttach)
				end
				local locomotiveID = 537
				local isChainOfEngines = false
				if math.random(1,20) > 15 then
					isChainOfEngines = true
				end
				for i=1,numberOfWagonsInTrain do
					if i == 1 then
						-- First locomotive
						if math.random(1,10) < 8 then
							locomotiveID = 538
						end
						if spawnPoints[spawner][5] == "tram" then
							locomotiveID = 449
						end
						train[hitElement][i] = createVehicle(locomotiveID, spawnPoints[spawner][1], spawnPoints[spawner][2], spawnPoints[spawner][3]) 
						setTimer( setVehicleOverrideLights, 50, 1, train[hitElement][i], 0 )
						setTrainDerailable( train[hitElement][1], false )
					else
						-- Flat freight trailers
						local vehID = 590
						if math.random(1,10) < 4 and allowBoxTrailers then
							vehID = 569
						end
						if locomotiveID == 538 then
							vehID = 570
						end
						if i == 2 and math.random(1,10) < 6 and allowDoubleEngines and numberOfWagonsInTrain > 4 and locomotiveID == 537 then
							vehID = 537
						end
						if isChainOfEngines then
							vehID = locomotiveID
						end
						if spawnPoints[spawner][5] == "tram" then
							vehID = 449
						end
						local x,y,z = getElementPosition( train[hitElement][1] )
						train[hitElement][i] = createVehicle(vehID, x, y, z )
						if spawnPoints[spawner][5] == "tram" then
							setVehicleColor( train[hitElement][i], 135, 135, 135, 255, 255, 255 )
						end
						setTimer( setVehicleOverrideLights, 50, 1, train[hitElement][i], 1 )
						setTrainDerailable( train[hitElement][i], false )
						
						-- MTA 1.4 attach using C++ algoritm rather than lua
						attachTrailerToVehicle(train[hitElement][i-1], train[hitElement][i])
					end
					setTrainDirection( train[hitElement][i], trainDirection[hitElement] )
					setElementSyncer( train[hitElement][i], hitElement )
					setElementData( train[hitElement][i], "syncer", hitElement)
					
					-- Adds a blip to each carriage (DEBUG only)
				    createBlipAttachedTo( train[hitElement][i], 0, 1, 255, 200, 0, 255, 0, 180 )
				    setVehicleColor( train[hitElement][i], 0, 0, 0, 0, 0, 0)
				end
				 -- Adds a ped to every trailer
				for j=1,numberOfWagonsInTrain do
					-- Create a ped for every wagon to control it
					pilot[hitElement][j] = createPed(194, 1, 1, 1)
						
					-- Make the ped invisible for 
					-- the look and feel of the train
					--setElementAlpha( pilot[hitElement][j], 0 )
						
					-- Wrap the peds into the train
				    warpPedIntoVehicle( pilot[hitElement][j], train[hitElement][j])
				end
				
				-- Play the horn
				setTimer(useHorn, math.random(500, 5000), 1, train[hitElement][1])
				
				-- Starting the syncer
				local time = math.random(1200, 1800)*1000
				syncTimer[hitElement] = setTimer( sync, 200, 0, hitElement, maxSpeed, numberOfWagonsInTrain )
				setTimer( cleanUp, time, 1, hitElement )
				cooldown[hitElement] = setTimer ( function() end, 60000, 1 ) -- The minimum time a train can exist
				
				-- Debuginfo
				--outputServerLog("[TRAIN] Train ("..numberOfWagonsInTrain..") was created at: "..getZoneName(spawnPoints[spawner][1],
					--spawnPoints[spawner][2], spawnPoints[spawner][3])..", by: "..getPlayerName(hitElement))
				
				-- Anti spam to save performance
				globcooldown = setTimer( function() end, timeToNextTrain*1000, 1 )
				getNewInterval()
				globaldist = trainDirection[hitElement]
				if isTimer( respawnTimers[hitElement] ) then
					killTimer( respawnTimers[hitElement] )
				end
				respawnTimers[hitElement] = setTimer( makeTrain, timeNextTrainInterval*1000, 0, hitElement, matchingDimension, id )
			end
		end
	else
		if isElement( source ) and not markercooldown[source] then
			markercooldown[source] = setTimer( function() end, 30000, 1 )
		end
	end
end

function useHorn(theTrain)
	exports.GTWtrainhorn:triggerTrainHorn(theTrain)
end

-- Keep train and carriages speed synced
function sync( thePlayer, trainSpeed, numberOfWagons )
	if isElement( thePlayer ) and isElement( train[thePlayer][1] ) and train[thePlayer][math.floor((numberOfWagons)/2)] then
		-- Justify the train speed
		local stationID = 0
		local typeOfMarker = "station"
		stationID,typeOfMarker = findNearestTrainStation( train[thePlayer][1] )
		if not stationID then cleanUp(thePlayer) return end
		local px,py,pz = getElementPosition( train[thePlayer][1] )
		local lx,ly,lz = getElementPosition( train[thePlayer][1] )
		local mmx,mmy,mmz = getElementPosition( train[thePlayer][math.floor((numberOfWagons)/2)] )
		local distToStation = getDistanceBetweenPoints3D( mmx,mmy,mmz, trainLocations[stationID][1],trainLocations[stationID][2],trainLocations[stationID][3] ) or 0
		local ldistToStation = getDistanceBetweenPoints3D( lx,ly,lz, trainLocations[stationID][1],trainLocations[stationID][2],trainLocations[stationID][3] ) or 0
		local dist = getDistanceBetweenPoints3D( mmx,mmy,mmz, px,py,pz )
		trainSpeed = (trainSpeed*(distToStation/accelerationConst)*3)
		if getElementModel( train[thePlayer][1] ) == 449 then
			trainSpeed = (trainSpeed*(distToStation/accelerationConst)*7)
		end
		if distToStation > 30 and distToStation < 400 then
			if math.random(10) < 3 and not isTimer(horncooldown[thePlayer]) then
				useHorn(train[thePlayer][1])
				if math.random(10) < 3 then
					setTimer(useHorn, 6000, 1, train[thePlayer][1])
				end
				horncooldown[thePlayer] = setTimer(function() end, 15000, 1)
			end
		end
		if trainSpeed > maxSpeed then
			trainSpeed = maxSpeed
		elseif trainSpeed < minSpeed then
			trainSpeed = minSpeed
		end
		if getElementModel( train[thePlayer][1] ) == 449 and trainSpeed > (maxSpeed/1.4) then
			trainSpeed = (maxSpeed/1.4)
		end
		--[[if distToStation < accelerationConst and trainLocations[stationID][5] == "slow" then
			if trainSpeed < (maxSpeed/2.5) then
				trainSpeed = (maxSpeed/2.5)
			end
		end]]--
		if not trainDirection[thePlayer] then
			trainSpeed = -trainSpeed
		end
		if distToStation < 0.5 and not isTimer(stationHoldTimer[thePlayer]) and not isTimer(stationLeaveTimer[thePlayer]) and trainLocations[stationID][5] == "station" then
			setTrainSpeed( train[thePlayer][1], 0.0 )
			setVehicleEngineState( train[thePlayer][1], false )
			local time = 1000*math.random(5,10)
			stationHoldTimer[thePlayer] = setTimer( function() end, time , 1 )
			-- Compensation to allow the train to leave
			stationLeaveTimer[thePlayer] = setTimer( function() end, time+15000 , 1 )
		end
		
		if not isTimer(stationHoldTimer[thePlayer]) then
			-- Set the speed
			setVehicleEngineState( train[thePlayer][1], true )
			setTrainSpeed( train[thePlayer][1], trainSpeed )	
		end
		if distToStation < 4 and trainLocations[stationID][5] == "block" then
			setTrainSpeed( train[thePlayer][1], 0.0 )
			setVehicleEngineState( train[thePlayer][1], false )
			stationLeaveTimer[thePlayer] = setTimer( function() end, 30000, 1 )
			if isTimer( syncTimer[thePlayer] ) then
				killTimer( syncTimer[thePlayer] )
			end
		end
		if dist > cleanUpDistance then
			cleanUp(thePlayer)
		end
	end
end

-- Clean up, remove unused trains and free memory
function cleanUp( trainID )
	if trainID and isElement(trainID) and train[trainID] and train[trainID][1] and not isTimer( cooldown[trainID] ) then
		local hasBeenDestroyed = false
   		for d=1,#train[trainID] do
			if isElement ( train[trainID][d] ) then
				destroyElement ( train[trainID][d] )
				train[trainID][d] = nil
				hasBeenDestroyed = true
			end
			if isElement ( pilot[trainID][d] ) then
				destroyElement ( pilot[trainID][d] )
				pilot[trainID][d] = nil
			end
		end
		train[trainID] = nil
		if isTimer( syncTimer[trainID] ) then
			killTimer( syncTimer[trainID] )
		end
		
		-- Change global direction
		if #train == 0 then
			globaldist = not globaldist
		end
		
		-- Debuginfo
		--setTimer( outputServerLog, 100, 1, "[TRAIN] Train ("..getPlayerName(trainID)..") was destroyed succsessfully" )
	end
end

-- Clean up and remove attached data
function quitPlayer( )
	if train[source] then
		for d=1,#train[source] do
			if isElement ( train[source][d] ) then
				destroyElement ( train[source][d] )
				train[source][d] = nil
				hasBeenDestroyed = true
			end
			if isElement ( pilot[source][d] ) then
				destroyElement ( pilot[source][d] )
				pilot[source][d] = nil
			end
			if isTimer( syncTimer[source] ) then
				killTimer( syncTimer[source] )
			end
		end
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), quitPlayer )