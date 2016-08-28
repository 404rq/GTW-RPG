function initTrafficGenerator()
	traffic_density = {peds = 0.01,cars = 0.01,boats = 0.01,planes = 0.01}

	population = {peds = {},cars = {},boats = {},planes = {}}
	element_timers = {}

	players = {}
	for plnum,player in ipairs(getElementsByType("player")) do
		players[player] = true
	end
	addEventHandler("onPlayerJoin",root,addPlayerOnJoin)
	addEventHandler("onPlayerQuit",root,removePlayerOnQuit)

	square_subtable_count = {}

	setTimer(updateTraffic, 1000, 0)
end

function addPlayerOnJoin()
	players[source] = true
	bindKey(source, "F", "down", hijackVehicle)
end

function removePlayerOnQuit()
	players[source] = nil
end

function updateTraffic()
	server_coldata = getResourceFromName("server_coldata")
	npc_hlc = getResourceFromName("npc_hlc")

	colcheck = get("npchlc_traffic.check_collisions")
	colcheck = colcheck == "all" and root or colcheck == "local" and resourceRoot or nil

	updateSquarePopulations()
	generateTraffic()
	removeEmptySquares()
end

function updateSquarePopulations()
	if square_population then
		for dim,square_dim in pairs(square_population) do
			for y,square_row in pairs(square_dim) do
				for x,square in pairs(square_row) do
					square.count = {peds =  0,cars =  0,boats =  0,planes =  0}
					square.list  = {peds = {},cars = {},boats = {},planes = {}}
					square.gen_mode  = "despawn"
				end
			end
		end
	end

	countPopulationInSquares("peds")
	countPopulationInSquares("cars")
	countPopulationInSquares("boats")
	countPopulationInSquares("planes")

	for player,exists in pairs(players) do
		local x,y = getElementPosition(player)
		local dim = getElementDimension(player)
		x,y = math.floor(x/SQUARE_SIZE),math.floor(y/SQUARE_SIZE)

		for sy = y-4,y+4 do for sx = x-4,x+4 do
			local square = getPopulationSquare(sx,sy,dim)
			if not square then
				square = createPopulationSquare(sx,sy,dim,"spawn")
			else
				if x-3 <= sx and sx <= x+3 and y-3 <= sy and sy <= y+3 then
					square.gen_mode = "nospawn"
				else
					square.gen_mode = "spawn"
				end
			end
		end end
	end

	if colcheck then call(server_coldata,"generateColData",colcheck) end
end

function removeEmptySquares()
	if square_population then
		for dim,square_dim in pairs(square_population) do
			for y,square_row in pairs(square_dim) do
				for x,square in pairs(square_row) do
					if
						square.gen_mode == "despawn" and
						square.count.peds == 0 and
						square.count.cars == 0 and
						square.count.boats == 0 and
						square.count.planes == 0
					then
						destroyPopulationSquare(x,y,dim)
					end
				end
			end
		end
	end
end

function countPopulationInSquares(trtype)
	for element,exists in pairs(population[trtype]) do
		if getElementType(element) ~= "ped" or not isPedInVehicle(element) then
			local x,y = getElementPosition(element)
			local dim = getElementDimension(element)
			x,y = math.floor(x/SQUARE_SIZE),math.floor(y/SQUARE_SIZE)

			for sy = y-2,y+2 do for sx = x-2,x+2 do
				local square = getPopulationSquare(sx,sy,dim)
				if sx == x and sy == y then
					if not square then square = createPopulationSquare(sx,sy,dim,"despawn") end
					square.list[trtype][element] = true
				end
				if square then square.count[trtype] = square.count[trtype]+1 end
			end end
		end
	end
end

function createPopulationSquare(x,y,dim,genmode)
	if not square_population then
		square_population = {}
		square_subtable_count[square_population] = 0
	end
	local square_dim = square_population[dim]
	if not square_dim then
		square_dim = {}
		square_subtable_count[square_dim] = 0
		square_population[dim] = square_dim
		square_subtable_count[square_population] = square_subtable_count[square_population]+1
	end
	local square_row = square_dim[y]
	if not square_row then
		square_row = {}
		square_subtable_count[square_row] = 0
		square_dim[y] = square_row
		square_subtable_count[square_dim] = square_subtable_count[square_dim]+1
	end
	local square = square_row[x]
	if not square then
		square = {}
		square_subtable_count[square] = 0
		square_row[x] = square
		square_subtable_count[square_row] = square_subtable_count[square_row]+1
	end
	square.count = {peds =  0,cars =  0,boats =  0,planes =  0}
	square.list  = {peds = {},cars = {},boats = {},planes = {}}
	square.gen_mode = genmode
	return square
end

function destroyPopulationSquare(x,y,dim)
	if not square_population then return end
	local square_dim = square_population[dim]
	if not square_dim then return end
	local square_row = square_dim[y]
	if not square_row then return end
	local square = square_row[x]
	if not square then return end

	square_subtable_count[square] = nil
	square_row[x] = nil
	square_subtable_count[square_row] = square_subtable_count[square_row]-1
	if square_subtable_count[square_row] ~= 0 then return end
	square_subtable_count[square_row] = nil
	square_dim[y] = nil
	square_subtable_count[square_dim] = square_subtable_count[square_dim]-1
	if square_subtable_count[square_dim] ~= 0 then return end
	square_subtable_count[square_dim] = nil
	square_population[dim] = nil
	square_subtable_count[square_population] = square_subtable_count[square_population]-1
	if square_subtable_count[square_population] ~= 0 then return end
	square_subtable_count[square_population] = nil
	square_population = nil
end

function getPopulationSquare(x,y,dim)
	if not square_population then return end
	local square_dim = square_population[dim]
	if not square_dim then return end
	local square_row = square_dim[y]
	if not square_row then return end
	return square_row[x]
end

function generateTraffic()
	if not square_population then return end
	for dim,square_dim in pairs(square_population) do
		for y,square_row in pairs(square_dim) do
			for x,square in pairs(square_row) do
				local genmode = square.gen_mode
				if genmode == "spawn" then
					spawnTrafficInSquare(x,y,dim,"peds")
					spawnTrafficInSquare(x,y,dim,"cars")
					spawnTrafficInSquare(x,y,dim,"boats")
					spawnTrafficInSquare(x,y,dim,"planes")
				elseif genmode == "despawn" then
					despawnTrafficInSquare(x,y,dim,"peds")
					despawnTrafficInSquare(x,y,dim,"cars")
					despawnTrafficInSquare(x,y,dim,"boats")
					despawnTrafficInSquare(x,y,dim,"planes")
				end
			end
		end
	end
end

skins = {0,7,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,43,44,46,47,48,49,50,53,54,55,56,57,58,59,60,61,66,67,68,69,70,71,72,73,76,77,78,79,82,83,84,88,89,91,93,94,95,96,98,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,141,142,143,147,148,150,151,153,157,158,159,160,161,162,170,173,174,175,181,182,183,184,185,186,187,188,196,197,198,199,200,201,202,206,210,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,231,232,233,234,235,236,239,240,241,242,247,248,250,253,254,255,258,259,260,261,262,263}
vehicles = {602,496,401,518,527,589,419,533,526,474,545,517,410,600,436,580,439,549,491,445,507,585,587,466,492,546,551,516,467,426,547,409,550,566,540,421,529,581,509,481,462,521,463,510,461,448,468,586,485,552,431,438,437,574,420,525,408,499,609,498,578,573,455,514,414,456,459,422,482,418,582,413,440,543,478,554,536,575,534,567,535,576,412,402,542,603,475,424,483,500,471,429,541,415,480,562,565,411,559,561,560,506,451,558,555,477,579,400,404,489,479,442,458}
skincount,vehiclecount = #skins,#vehicles

count_needed = 0

function destroyAINPCVehicle(veh)
	if veh and isElement(veh) then
		local occupants = getVehicleOccupants(veh)
		for k, v in pairs(occupants) do
			if isElement(v) then destroyElement(v) end
		end
		destroyElement(veh)
	end
end

function clean_up_angry_bots(angry_bot, angry_blip)
	if isElement(angry_blip) then destroyElement(angry_blip) end
	if isElement(angry_bot) then destroyElement(angry_bot) end
end
function hijackVehicle(plr)
	local px,py,pz = getElementPosition(plr)
	for k,v in pairs(getElementsByType("vehicle")) do
		local b_driver = getVehicleOccupant(v) or v
		local vx,vy,vz = getElementPosition(b_driver)
		if getDistanceBetweenPoints3D(px,py,pz, vx,vy,vz) < 4 and 
			isElement(v) and getElementType(v) == "vehicle" and
			getVehicleOccupant(v) and getElementType(getVehicleOccupant(v)) == "ped" then
			call(npc_hlc, "disableHLCForNPC", getVehicleOccupant(v))
			local px,py,pz = getElementPosition(plr)
			local angry_bot = exports.slothbot:spawnBot(px,py,pz+2, 0, getElementModel(getVehicleOccupant(v)), 0,0, nil, 0, "chasing", plr)
			--exports.slothbot:setBotChase(getVehicleOccupant(v), plr)
			local angry_blip = createBlipAttachedTo(angry_bot, 0, 1, 200, 200, 200, 200, 0, 180 )
			setTimer(clean_up_angry_bots, 300*1000, 1, angry_bot, angry_blip)
			exports.GTWwanted:setWl(plr, 0.3, 10, "You committed the crime of grand theft auto")
			destroyElement(getVehicleOccupant(v)) 
		end
	end
end
for p_index,curr_player in pairs(getElementsByType("player")) do
	bindKey(curr_player, "F", "down", hijackVehicle)
end

function spawnTrafficInSquare(x,y,dim,trtype)
	-- Do not spawn to close to any player
	for k,v in pairs(getElementsByType("player")) do
		local px,py,pz = getElementPosition(v)
		local dist = getDistanceBetweenPoints2D(px,py, x,y)

		-- A player is closer to spawn than 50m, don't spawn
		if dist < 50 then return end
	end

	local square_tm_id = square_id[y] and square_id[y][x]
	if not square_tm_id then return end
	local square = square_population and square_population[dim] and square_population[dim][y] and square_population[dim][y][x]
	if not square then return end

	local conns = square_conns[square_tm_id][trtype]
	local cpos1 = square_cpos1[square_tm_id][trtype]
	local cpos2 = square_cpos2[square_tm_id][trtype]
	local cdens = square_cdens[square_tm_id][trtype]
	local ttden = square_ttden[square_tm_id][trtype]
	count_needed = count_needed+math.max(ttden*traffic_density[trtype]-square.count[trtype]/25,0)

	while count_needed >= 1 do
		local sqpos = ttden*math.random()
		local connpos
		local connnum = 1
		while true do
			connpos = cdens[connnum]
			if not connpos then return end
			if sqpos > connpos then
				sqpos = sqpos-connpos
			else
				connpos = sqpos/connpos
				break
			end
			connnum = connnum+1
		end

		local connid = conns[connnum]
		connpos = cpos1[connnum]*(1-connpos)+cpos2[connnum]*connpos
		local n1,n2,nb = conn_n1[connid],conn_n2[connid],conn_nb[connid]
		local ll,rl = conn_lanes.left[connid],conn_lanes.right[connid]
		local lanecount = ll+rl
		if lanecount == 0 and math.random(2) > 1 or lanecount ~= 0 and math.random(lanecount) > rl then
			n1,n2,ll,rl = n2,n1,rl,ll
			connpos = (nb and math.pi*0.5 or 1)-connpos
		end
		lane = rl == 0 and 0 or math.random(rl)
		local x,y,z
		local x1,y1,z1 = getNodeConnLanePos(n1,connid,lane,false)
		local x2,y2,z2 = getNodeConnLanePos(n2,connid,lane,true)
		local dx,dy,dz = x2-x1,y2-y1,z2-z1
		local rx = math.deg(math.atan2(dz,math.sqrt(dx*dx+dy*dy)))
		local rz
		if nb then
			local bx,by,bz = node_x[nb],node_y[nb],(z1+z2)*0.5
			local x1,y1,z1 = x1-bx,y1-by,z1-bz
			local x2,y2,z2 = x2-bx,y2-by,z2-bz
			local possin,poscos = math.sin(connpos),math.cos(connpos)
			x = bx+possin*x1+poscos*x2
			y = by+possin*y1+poscos*y2
			z = bz+possin*z1+poscos*z2
			local tx = -poscos
			local ty = possin
			tx,ty = x1*tx+x2*ty,y1*tx+y2*ty
			rz = -math.deg(math.atan2(tx,ty))
		else
			x = x1*(1-connpos)+x2*connpos
			y = y1*(1-connpos)+y2*connpos
			z = z1*(1-connpos)+z2*connpos
			rz = -math.deg(math.atan2(dx,dy))
		end

		local speed = conn_maxspeed[connid]/180
		local vmult = speed/math.sqrt(dx*dx+dy*dy+dz*dz)
		local vx,vy,vz = dx*vmult,dy*vmult,dz*vmult

		local model = trtype == "peds" and skins[math.random(skincount)] or vehicles[math.random(vehiclecount)]
		local colx,coly,colz = x,y,z+z_offset[model]

		local create = true
		if colcheck then
			local box = call(server_coldata,"createModelIntersectionBox",model,colx,coly,colz,rz)
			create = not call(server_coldata,"doesModelBoxIntersect",box,dim)
		end

		if create and trtype == "peds" then
			local ped = createPed(model,x,y,z+1,rz)
			local walking_styles = {54,55,56,54,55,56,54,55,56,54,55,56,54,55,56,54,55,56,54,55,56,118,119,121,123,124,125,127,129,130,135,138}
			setPedWalkingStyle(ped, walking_styles[math.random(#walking_styles)])
			setElementDimension(ped,dim)
			createBlipAttachedTo(ped, 0, 1, 200, 200, 200, 200, 0, 180 )
			element_timers[ped] = {}
			addEventHandler("onElementDestroy",ped,removePedFromListOnDestroy,false)
			addEventHandler("onPedWasted",ped,removeDeadPed,false)
			population.peds[ped] = true

			if colcheck then call(server_coldata,"updateElementColData",ped) end

			call(npc_hlc,"enableHLCForNPC",ped,"walk",0.99,40/180)
			ped_lane[ped] = lane
			initPedRouteData(ped)
			addNodeToPedRoute(ped,n1)
			addNodeToPedRoute(ped,n2,nb)
			for nodenum = 1,4 do addRandomNodeToPedRoute(ped) end

		elseif create and trtype == "cars" then
			local zoff = z_offset[model]/math.cos(math.rad(rx))
			local car = createVehicle(model,x,y,z+zoff,rx,0,rz)
			setVehicleFuelTankExplodable(car, true)
			--setTimer(destroyAINPCVehicle, 120000, 1, car)
			setElementData(car, "npc", true)
			setElementDimension(car,dim)
			element_timers[car] = {}
			addEventHandler("onElementDestroy",car,removeCarFromListOnDestroy,false)
			addEventHandler("onVehicleExplode",car,removeDestroyedCar,false)
			population.cars[car] = true

			if colcheck then call(server_coldata,"updateElementColData",car) end

			local ped1 = createPed(skins[math.random(skincount)],x,y,z+1)
			createBlipAttachedTo(ped1, 0, 1, 200, 200, 200, 200, 0, 180 )
			warpPedIntoVehicle(ped1,car)
			setElementDimension(ped1,dim)
			element_timers[ped1] = {}
			addEventHandler("onElementDestroy",ped1,removePedFromListOnDestroy,false)
			addEventHandler("onPedWasted",ped1,removeDeadPed,false)
			population.peds[ped1] = true

			local maxpass = getVehicleMaxPassengers(model)

			if maxpass >= 1 and math.random() < 0.5 then
				local ped2 = createPed(skins[math.random(skincount)],x,y,z+1)
				warpPedIntoVehicle(ped2,car,1)
				setElementDimension(ped2,dim)
				element_timers[ped2] = {}
				addEventHandler("onElementDestroy",ped2,removePedFromListOnDestroy,false)
				addEventHandler("onPedWasted",ped2,removeDeadPed,false)
				population.peds[ped2] = true
			end

			if maxpass >= 2 and math.random() < 0.25 then
				local ped3 = createPed(skins[math.random(skincount)],x,y,z+1)
				warpPedIntoVehicle(ped3,car,2)
				setElementDimension(ped3,dim)
				element_timers[ped3] = {}
				addEventHandler("onElementDestroy",ped3,removePedFromListOnDestroy,false)
				addEventHandler("onPedWasted",ped3,removeDeadPed,false)
				population.peds[ped3] = true
			end

			if maxpass >= 3 and math.random() < 0.25 then
				local ped4 = createPed(skins[math.random(skincount)],x,y,z+1)
				warpPedIntoVehicle(ped4,car,3)
				setElementDimension(ped4,dim)
				element_timers[ped4] = {}
				addEventHandler("onElementDestroy",ped4,removePedFromListOnDestroy,false)
				addEventHandler("onPedWasted",ped4,removeDeadPed,false)
				population.peds[ped4] = true
			end

			setElementVelocity(car,vx,vy,vz)

			call(npc_hlc,"enableHLCForNPC",ped1,"walk",0.99,speed)
			ped_lane[ped1] = lane
			initPedRouteData(ped1)
			addNodeToPedRoute(ped1,n1)
			addNodeToPedRoute(ped1,n2,nb)
			for nodenum = 1,4 do addRandomNodeToPedRoute(ped1) end
		end

		square.count[trtype] = square.count[trtype]+1

		count_needed = count_needed-1
	end
end

function removePedFromListOnDestroy()
	if getAttachedElements(source) then
		local attachedElements = getAttachedElements(source)
		for k,v in ipairs(attachedElements) do
      		if getElementType(v) == "blip" then
      			destroyElement(v)
			end
		end
	end
	for timer,exists in pairs(element_timers[source]) do
		killTimer(timer)
	end
	element_timers[source] = nil
	population.peds[source] = nil
end

function removeDeadPed()
	element_timers[source][setTimer(destroyElement,20000,1,source)] = true
end

function removeCarFromListOnDestroy()
	for timer,exists in pairs(element_timers[source]) do
		killTimer(timer)
	end
	element_timers[source] = nil
	population.cars[source] = nil
end

function removeDestroyedCar()
	element_timers[source][setTimer(destroyElement,60000,1,source)] = true
end

function despawnTrafficInSquare(x,y,dim,trtype)
	local square = square_population and square_population[dim] and square_population[dim][y] and square_population[dim][y][x]
	if not square then return end

	if trtype == "peds" then
		for element,exists in pairs(square.list[trtype]) do
			destroyElement(element)
		end
	else
		for element,exists in pairs(square.list[trtype]) do
			local occupants = getVehicleOccupants(element)
			local destroy = true
			for seat,ped in pairs(occupants) do
				if not population.peds[ped] then destroy = false end
			end
			if destroy then
				destroyElement(element)
				for seat,ped in pairs(occupants) do
					destroyElement(ped)
				end
			end
		end
	end
end
