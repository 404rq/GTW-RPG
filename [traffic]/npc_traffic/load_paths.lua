function loadPaths()
	node_x,node_y,node_z = {},{},{}
	node_rx,node_ry = {},{}
	node_conns = {}
	node_lanes = {left = {},right = {}}
	conn_n1,conn_n2,conn_nb = {},{},{}
	conn_type,conn_light1,conn_light2,conn_maxspeed = {},{},{},{}
	conn_lanes,conn_density = {left = {},right = {}},{}
	conn_lanepos = {left = {},right = {}}
	conn_forbidden = {}

	local starttime = getTickCount()
	local maplist = getPathMapList()
	for mapnum,mapname in ipairs(maplist) do
		local starttime = getTickCount()
		if loadPathMapFile(mapname) then
			outputServerLog("Loaded path map "..mapname.." in "..getTickCount()-starttime.." ms")
		end
	end
	outputServerLog("Loaded all path maps in "..getTickCount()-starttime.." ms")
end

function getPathMapList()
	local maps = {}
	local maplist = xmlLoadFile("paths/maplist.xml")
	if not maplist then
		outputDebugString("Failed to open path maps list: paths/maplist.xml",2)
		return
	end
	local mapnodes = xmlNodeGetChildren(maplist)
	for mapnum,mapnode in ipairs(mapnodes) do
		local filename = xmlNodeGetAttribute(mapnode,"src")
		if filename then
			filename = "paths/maps/"..filename
			if fileExists(filename) then
				table.insert(maps,filename)
			else
				outputDebugString("Map file "..filename.." does not exist",2)
			end
		else
			outputDebugString("Failed to read file path of map "..mapnum,2)
		end
	end
	xmlUnloadFile(maplist)
	return maps
end

function loadPathMapFile(filename)
	local file = fileOpen(filename,true)
	if not file then
		outputDebugString("Failed to open path map file: "..filename,2)
		return
	end
	local header_bytes = fileRead(file,12)
	if #header_bytes ~= 12 then
		outputDebugString("Failed to read the header of path map file: "..filename,2)
		fileClose(file)
		return
	end

	local node_ids,conn_ids = {},{}
	local nodecount,conncount,forbcount = bytesToData("3i",header_bytes)

	for nodenum = 1,nodecount do
		local node_bytes = fileRead(file,16)
		if #node_bytes ~= 16 then
			outputDebugString("Failed to read all nodes from path map file: "..filename,2)
			fileClose(file)
			return
		end
		local new_id = #node_z+1
		node_ids[nodenum] = new_id
		local x,y,z,rx,ry = bytesToData("3i2s",node_bytes)
		node_x[new_id],node_y[new_id],node_z[new_id] = x/1000,y/1000,z/1000
		node_rx[new_id],node_ry[new_id] = rx/1000,ry/1000
		node_conns[new_id] = {}

		checkThreadYieldTime()
	end

	for connnum = 1,conncount do
		local conn_bytes = fileRead(file,20)
		if #conn_bytes ~= 20 then
			outputDebugString("Failed to read all connections from path map file: "..filename,2)
			fileClose(file)
			return
		end
		local new_id = #conn_type+1
		conn_ids[connnum] = new_id
		local n1,n2,nb,trtype,lit,speed,ll,rl,density = bytesToData("3i2ubus2ubus",conn_bytes)
		local lit1,lit2 = lit%4,math.floor(lit/4)
		n1,n2 = node_ids[n1],node_ids[n2]
		conn_n1[new_id],conn_n2[new_id] = n1,n2
		conn_nb[new_id] = nb ~= -1 and node_ids[nb] or nil
		conn_type[new_id] = trtype == 1 and "peds" or trtype == 2 and "cars" or trtype == 3 and "boats" or trtype == 4 and "planes"
		conn_light1[new_id] = lit1 == 1 and "NS" or lit1 == 2 and "WE" or lit1 == 3 and "ped" or nil
		conn_light2[new_id] = lit2 == 1 and "NS" or lit2 == 2 and "WE" or lit2 == 3 and "ped" or nil
		conn_maxspeed[new_id] = speed/10
		conn_lanes.left[new_id],conn_lanes.right[new_id] = ll,rl
		conn_density[new_id] = density/1000
		conn_forbidden[new_id] = {}
		if rl ~= 0 or ll == 0 then node_conns[n1][n2] = new_id end
		if ll ~= 0 or rl == 0 then node_conns[n2][n1] = new_id end

		addConnToTrafficMap(new_id)

		checkThreadYieldTime()
	end

	for forbnum = 1,forbcount do
		local forb_bytes = fileRead(file,8)
		if #forb_bytes ~= 8 then
			outputDebugString("Failed to read all forbidden connection sequences from path map file: "..filename,2)
			fileClose(file)
			return
		end
		local c1,c2 = bytesToData("2i",forb_bytes)
		conn_forbidden[conn_ids[c1]][conn_ids[c2]] = true

		checkThreadYieldTime()
	end

	fileClose(file)
	return true
end

