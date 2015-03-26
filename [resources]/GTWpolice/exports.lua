--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

-- Distance to cop
function distanceToCop(crim)
	local copIsNearby = false
	local dist = 99999		
	for w,cop in ipairs(getElementsByType("player")) do 
		if getPlayerTeam(cop) and lawTeams[getTeamName(getPlayerTeam(cop))] and getPlayerTeam(cop) ~= getTeamFromName("Staff") then
			cx,cy,cz = getElementPosition(cop)
			px,py,pz = getElementPosition(crim)
			if getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz) < dist and cop ~= crim then
				dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			end
			setElementData(crim, "distToCop", dist)
		end
	end
	return dist
end

-- Find nearest cop
function nearestCop(player)
	local copIsNearby = false
	local dist = 99999	
	local nearCop = nil	
	for w,cop in ipairs(getElementsByType("player")) do 
		if getPlayerTeam(cop) and lawTeams[getTeamName(getPlayerTeam(cop))] then
			cx,cy,cz = getElementPosition(cop)
			px,py,pz = getElementPosition(player)
			if getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz) < dist then
				dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
				nearCop = cop
			end
			setElementData(player, "distToCop", dist)
		end
	end
	return nearCop
end

-- Distance to nearest crim
function distanceToCrim(player)
	if not player or not isElement(player) then return end
	local crimIsNearby = false
	local dist = 99999	
	for w,crim in ipairs(getElementsByType("player")) do 
		if getPlayerWantedLevel(crim) > 0 and crim ~= player and 
			getElementInterior(crim) == getElementInterior(player) and  
			getElementDimension(crim) == getElementDimension(player) and 
			not lawTeams[getTeamName(getPlayerTeam(crim))] then
			cx,cy,cz = getElementPosition(crim)
			px,py,pz = getElementPosition(player)
			if getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz) < dist and 
				getElementData(crim, "Jailed") ~= "Yes" and 
				not police_data.is_arrested[crim] then
				dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			end
			if dist > 90 then
				setElementData(player, "distToCrim", dist)
			end
		end
	end
	return dist
end

-- Direction to crim
function directionToCrim(player)
	local crimIsNearby = false
	local dir = "North"
	local dist = 9999	
	for w,crim in ipairs(getElementsByType("player")) do 
		if getPlayerWantedLevel(crim) > 0 and crim ~= player then
			cx,cy,cz = getElementPosition(crim)
			px,py,pz = getElementPosition(player)
			if getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz) < dist and 
				getElementData(crim, "Jailed") ~= "Yes" and 
				not police_data.is_arrested[crim] then
				dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
				if py > cy-1 then
					dir = "South"
				elseif py < cy+1 then
					dir = "North"
				end
				if px > cx-1 then
					dir = dir.."West"
				elseif px < cx+1 then
					dir = dir.."East"
				end
				if pz > cz-1 then
					dir = dir.." (below)"
				elseif pz < cz+1 then
					dir = dir.." (above)"
				end
			end
		end
	end
	return dir
end

function isArrested(crim)
	if not crim or not isElement(crim) or getElementType(crim) ~= "player" then return end
	return police_data.is_arrested[crim] or false
end