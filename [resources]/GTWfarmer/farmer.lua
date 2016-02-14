--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Object ids: 822 plant, 1454 bale
-- Globals
plants_age 		= { }
player_plants 		= { }
plants_pos		= {{{ }}}
seed_moey 		= 300

-- Finds the nearest plant
function find_nearest(player)
	local x,y,z = getElementPosition(player)
	local dist = 16
	if not plants_pos[player] then
		plants_pos[player] = { }
	end
	for w=1, #plants_pos[player] do
		if plants_pos[player][w][1] and plants_pos[player][w][2] and plants_pos[player][w][3] then
			local lx,ly,lz = plants_pos[player][w][1],plants_pos[player][w][2],plants_pos[player][w][3]
			if dist > getDistanceBetweenPoints3D( x,y,z, lx,ly,lz ) then
				dist = getDistanceBetweenPoints3D( x,y,z, lx,ly,lz )
			end
		end
	end
	return dist or 16
end

-- Plant the seed
function plantSeed( player )
	if getPlayerTeam(player) == getTeamFromName("Civilians") and getElementData(player, "Occupation") == "Farmer" and
		getPlayerMoney(player) > seed_moey and getPedOccupiedVehicle(player) and getElementModel( getPedOccupiedVehicle( player )) == 531
		and player_plants[player] < 200 then
		-- Plant the seed
		local x,y,z = getElementPosition(player)
		if not plants_pos then
			plants_pos = { }
		end
		if find_nearest(player) > 15 then
			takePlayerMoney(player, seed_moey)
			local plant = createObject( 822, x, y, z-1 )
			local plantCol = createColSphere( x, y, z-2, 5 )
			local blip = createBlip( x, y, z, 0, 1, 255, 0, 0, 150, 0, 100, player )
			setObjectScale( plant, 0.005 )
			if not plants_pos[player] then
				plants_pos[player] = { }
			end
			if not plants_pos[player][player_plants[player]] then
				plants_pos[player][player_plants[player]] = { }
			end

			-- Make the plant grow up
			plants_age[plant] = 0;
			local currentPlantsCounter = player_plants[player]
			plants_pos[player][currentPlantsCounter][1] = x
			plants_pos[player][currentPlantsCounter][2] = y
			plants_pos[player][currentPlantsCounter][3] = z

			local time_to_grow = math.random(285, 320)
			setTimer( function()
				setObjectScale( plant, getObjectScale(plant)+0.005 )
				plants_age[plant] = plants_age[plant] + 1
			end, 4000, time_to_grow )

			-- Status message
			exports.GTWtopbar:dm( "Farmer: Your seed has been planted, make sure it's safe from intruders!", player, 0, 255, 0 )
			player_plants[player] = player_plants[player] + 1;

			-- Show status
			setTimer( function()
				if isElement(blip) then
					setBlipColor( blip, 0, 255, 0, 100 )
				end
			end, time_to_grow*4000, 1 )

			-- Clean up
			setTimer( function()
				if isElement(plant) then
					destroyElement(plant)
					destroyElement(plantCol)
					destroyElement(blip)
					plants_age[plant] = nil
					plants_pos[player][currentPlantsCounter][1] = nil
					plants_pos[player][currentPlantsCounter][2] = nil
					plants_pos[player][currentPlantsCounter][3] = nil

					-- Status message
					if isElement(player) then
						exports.GTWtopbar:dm( "Farmer: Your plant rotted and was destroyed", player, 255, 200, 0 )
					end
				end
			end, 7200000, 1 )

			addEventHandler( "onColShapeHit", plantCol,
    		function ( hitElement, matchingdimension )
        		if hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
        			getPedOccupiedVehicle(hitElement) and getElementModel( getPedOccupiedVehicle( hitElement )) == 532 and
					plants_age[plant] and plants_age[plant] > time_to_grow - 1 then

				-- Clear and makes a bale
        			plants_age[plant] = nil
        			setElementModel(plant, 1454)
        			setBlipColor( blip, 255, 200, 0, 100 )
        			setElementCollisionsEnabled( plant, false )
        			local px,py,pz = getElementPosition(plant)
        			setElementPosition(plant, px,py,pz+1.1)

        			-- Status message
				exports.GTWtopbar:dm( "Farmer: One of your plants has been harvested", player, 255, 200, 0 )
        		elseif hitElement and isElement(hitElement) and getElementType(hitElement) == "player" and
        			not getPedOccupiedVehicle(hitElement) and getElementModel(plant) == 1454 then
        			-- Pay for the bale
        			givePlayerMoney(hitElement,math.random(900,1100))

        			-- Increase stats by 1/plant
				local playeraccount = getPlayerAccount( hitElement )
				local farmer_plants = getAccountData( playeraccount, "GTWdata_stats_plants_harvested" ) or 0
				setAccountData( playeraccount, "GTWdata_stats_plants_harvested", farmer_plants + 1 )

        			-- Status message
				exports.GTWtopbar:dm( "Farmer: One of your plants has been sold", player, 255, 200, 0 )
				player_plants[player] = player_plants[player] - 1
        			if isElement(plant) then
					destroyElement(plant)
					destroyElement(plantCol)
					destroyElement(blip)
					plants_pos[player][currentPlantsCounter][1] = nil
					plants_pos[player][currentPlantsCounter][2] = nil
					plants_pos[player][currentPlantsCounter][3] = nil
					plants_age[plant] = nil
				end
        		end
    		end)
    	else
    		exports.GTWtopbar:dm( "Farmer: You can't plant your seed too close to eachothers", player, 255, 0, 0 )
    	end
    elseif player_plants[player] and player_plants[player] > 199 then
    	exports.GTWtopbar:dm( "Farmer: You can't plant more seed right now, let your current plants be ready first", player, 255, 0, 0 )
	end
end
addCommandHandler( "plant", plantSeed )

for w,pl in pairs(getElementsByType("player")) do
	bindKey( pl, "n", "down", "plant" )
	player_plants[pl] = 0
end
addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
addEventHandler("onPlayerLogin", root, function()
    bindKey( source, "n", "down", "plant" )
    player_plants[source] = 0
end)

function enterVehicle( thePlayer, seat, jacked )
    if getElementModel(source) == 531 and getElementData(thePlayer, "Occupation") == "Farmer" then
		exports.GTWtopbar:dm( "Farmer: Press n to plant your seed", thePlayer, 255, 200, 0 )
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), enterVehicle )
