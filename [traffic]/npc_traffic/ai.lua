function initAI()
	ped_nodes = {}
	ped_conns = {}
	ped_thisnode = {}
	ped_lastnode = {}
	ped_lane = {}
	ped_drivespeed = {}
end

function initPedRouteData(ped)
	ped_nodes[ped] = {}
	ped_conns[ped] = {}
	ped_drivespeed[ped] = {}
	addEventHandler("onElementDestroy",ped,uninitPedRouteDataOnDestroy)
	addEventHandler("npc_hlc:onNPCTaskDone",ped,continuePedRoute)
end

function uninitPedRouteDataOnDestroy()
	ped_nodes[source] = nil
	ped_conns[source] = nil
	ped_thisnode[source] = nil
	ped_lastnode[source] = nil
	ped_lane[source] = nil
	ped_drivespeed[source] = nil
end

function continuePedRoute(task)
	if task[1] == "waitForGreenLight" then return end
	local thisnode = ped_thisnode[source]
	local speed = ped_drivespeed[source][thisnode]
	if speed then
		call(npc_hlc,"setNPCDriveSpeed",source,speed/180)
		ped_drivespeed[source][thisnode] = nil
	end
	ped_thisnode[source] = thisnode+1
	addRandomNodeToPedRoute(source)
end

function addNodeToPedRoute(ped,nodeid,nb)
	local n1num = ped_lastnode[ped]
	if not n1num then
		ped_nodes[ped][1] = nodeid
		ped_lastnode[ped] = 1
		return
	end
	local n0num,n2num = n1num-1,n1num+1
	local prevnode = ped_nodes[ped][n1num]
	local connid = node_conns[prevnode][nodeid]
	local lane = ped_lane[ped]
	ped_nodes[ped][n2num] = nodeid
	ped_conns[ped][n2num] = connid

	local n0 = ped_nodes[ped][n0num]
	local speed = conn_maxspeed[connid]
	if n0 and conn_maxspeed[node_conns[n0][n1]] ~= speed then
		ped_drivespeed[ped][n1num-1] = speed
	end

	local x1,y1,z1 = getNodeConnLanePos(prevnode,connid,lane,false)
	local x2,y2,z2 = getNodeConnLanePos(nodeid,connid,lane,true)

	local zoff
	local vehicle = getPedOccupiedVehicle(ped)
	local model = getElementModel(vehicle or ped)
	if vehicle then
		local dx,dy,dz = x2-x1,y2-y1,z2-z1
		dx,dy,dz = dx*dx,dy*dy,dz*dz
		zoff = z_offset[model]*math.sqrt((dx+dy)/(dx+dy+dz))
	else
		zoff = 1
	end

	z1,z2 = z1+zoff,z2+zoff

	local lights
	if nodeid == conn_n1[connid] then
		lights = conn_light1[connid]
	else
		lights = conn_light2[connid]
	end

	if vehicle then
		local off = speed*0.1
		local enddist = lights and call(server_coldata,"getModelBoundingBox",model,"y2")+5 or off
		if nb then
			call(npc_hlc,"addNPCTask",ped,{"driveAroundBend",node_x[nb],node_y[nb],x1,y1,z1,x2,y2,z2,off,enddist})
		else
			call(npc_hlc,"addNPCTask",ped,{"driveAlongLine",x1,y1,z1,x2,y2,z2,off,enddist})
		end
	else
		if nb then
			call(npc_hlc,"addNPCTask",ped,{"walkAroundBend",node_x[nb],node_y[nb],x1,y1,z1,x2,y2,z2,1,1})
		else
			call(npc_hlc,"addNPCTask",ped,{"walkAlongLine",x1,y1,z1,x2,y2,z2,1,1})
		end
	end
	if not ped_thisnode[ped] then ped_thisnode[ped] = 1 end
	ped_lastnode[ped] = n2num

	if lights then
		call(npc_hlc,"addNPCTask",ped,{"waitForGreenLight",lights})
	end
end

function addRandomNodeToPedRoute(ped)
	local n2num = ped_lastnode[ped]
	local n1num,n3num = n2num-1,n2num+1
	local n1,n2 = ped_nodes[ped][n1num],ped_nodes[ped][n2num]
	local possible_turns = {}
	local total_density = 0
	local c12 = node_conns[n1][n2]
	for n3,connid in pairs(node_conns[n2]) do
		local c23 = node_conns[n2][n3]
		if not conn_forbidden[c12][c23] then
			if conn_lanes.left[connid] == 0 and conn_lanes.right[connid] == 0 then
				if n3 ~= n1 then
					local density = conn_density[connid]
					total_density = total_density+density
					table.insert(possible_turns,{n3,connid,density})
				end
			else
				local dirmatch1 = areDirectionsMatching(n2,n1,n2)
				local dirmatch2 = areDirectionsMatching(n2,n2,n3)
				if dirmatch1 == dirmatch2 then
					local density = conn_density[connid]
					total_density = total_density+density
					table.insert(possible_turns,{n3,connid,density})
				end
			end
		end
	end
	local n3,connid
	local possible_count = #possible_turns
	if possible_count == 0 then
		n3,connid = next(node_conns[n2])
	else
		local pos = math.random()*total_density
		local num = 1
		while true do
			num = num%possible_count+1
			local turn = possible_turns[num]
			pos = pos-turn[3]
			if pos <= 0 then
				n3,connid = turn[1],turn[2]
				break
			end
		end
	end
	addNodeToPedRoute(ped,n3,conn_nb[connid])
end

