SQUARE_SIZE = 25

function initTrafficMap()
	square_id = {}
	square_conns = {}
	square_cpos1 = {}
	square_cpos2 = {}
	square_cdens = {}
	square_ttden = {}
end

function addConnToTrafficMap(connid)
	local n1,n2,nb = conn_n1[connid],conn_n2[connid],conn_nb[connid]
	local x1,y1 = node_x[n1],node_y[n1]
	local x2,y2 = node_x[n2],node_y[n2]
	local density = conn_density[connid]
	do
		local lanes = conn_lanes.left[connid]+conn_lanes.right[connid]
		density = density*(lanes == 0 and 1 or lanes)
	end

	local SQUARE_SIZE = SQUARE_SIZE
	local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
	local addConnToSquare = addConnToSquare
	local math_min,math_max = math.min,math.max
	local math_floor,math_ceil = math.floor,math.ceil
	local math_abs,math_huge = math.abs,math.huge

	if nb then
		local bx,by = node_x[nb],node_y[nb]
		local mxx,mxy,myx,myy = x1-bx,y1-by,x2-bx,y2-by

		local det_inv = 1/(mxy*myx-mxx*myy)
		local ixx,ixy =  myy*det_inv, myx*det_inv
		local iyx,iyy = -mxy*det_inv,-mxx*det_inv

		local minx_alg = math_floor((bx+math_min(mxx,myx,mxx+myx)            )/SQUARE_SIZE)*SQUARE_SIZE
		local maxx_alg = math_floor((bx+math_max(mxx,myx,mxx+myx)+SQUARE_SIZE)/SQUARE_SIZE)*SQUARE_SIZE
		local miny_alg = math_floor((by+math_min(mxy,myy,mxy+myy)            )/SQUARE_SIZE)*SQUARE_SIZE
		local maxy_alg = math_floor((by+math_max(mxy,myy,mxy+myy)+SQUARE_SIZE)/SQUARE_SIZE)*SQUARE_SIZE

		local pos_list = {0,math.pi*0.5}

		for x = minx_alg,maxx_alg,SQUARE_SIZE do
			local pos1,pos2 = getArcAndLineCrossPos(x-bx,0-by,x-bx,SQUARE_SIZE-by,ixx,ixy,iyx,iyy)
			if pos1 and not pos_list[pos1] then table.insert(pos_list,pos1) pos_list[pos1] = true end
			if pos2 and not pos_list[pos2] then table.insert(pos_list,pos2) pos_list[pos2] = true end
		end
		for y = miny_alg,maxy_alg,SQUARE_SIZE do
			local pos1,pos2 = getArcAndLineCrossPos(0-bx,y-by,SQUARE_SIZE-bx,y-by,ixx,ixy,iyx,iyy)
			pos1,pos2 = pos1 and math.pi*0.5-pos1,pos2 and math.pi*0.5-pos2
			if pos1 and not pos_list[pos1] then table.insert(pos_list,pos1) pos_list[pos1] = true end
			if pos2 and not pos_list[pos2] then table.insert(pos_list,pos2) pos_list[pos2] = true end
		end

		table.sort(pos_list)
		for posnum = 1,#pos_list-1 do
			local pos1,pos2 = pos_list[posnum],pos_list[posnum+1]
			local posavg = (pos1+pos2)*0.5
			local possin,poscos = math.sin(posavg),math.cos(posavg)
			local sqx,sqy = bx+mxx*possin+myx*poscos,by+mxy*possin+myy*poscos
			sqx = math_floor(sqx/SQUARE_SIZE)
			sqy = math_floor(sqy/SQUARE_SIZE)

			local square = getSquare(sqx,sqy) or createSquare(sqx,sqy)
			local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*0.5*(pos2-pos1)*density
			addConnToSquare(square,connid,pos1,pos2,len)
		end
	else
		local miny = math_min(y1,y2)
		local maxy = math_max(y1,y2)
		local miny_alg = math_floor(miny/SQUARE_SIZE)
		local maxy_alg = math_floor(maxy/SQUARE_SIZE)
		for sqy = miny_alg,maxy_alg do
			local y = sqy*SQUARE_SIZE
			local row_y1 = math_min(maxy,math_max(miny,y))
			local row_y2 = math_min(maxy,math_max(miny,y+SQUARE_SIZE))
			local row_pos1 = (row_y1-y1)/(y2-y1)
			local row_pos2 = (row_y2-y1)/(y2-y1)
			if row_pos1 ~= row_pos1 or math_abs(row_pos1) == math_huge then
				row_pos1,row_pos2 = 0,1
			end
			local row_x1 = x1*(1-row_pos1)+x2*row_pos1
			local row_x2 = x1*(1-row_pos2)+x2*row_pos2

			local minx = math_min(row_x1,row_x2)
			local maxx = math_max(row_x1,row_x2)
			local minx_alg = math_floor(minx/SQUARE_SIZE)
			local maxx_alg = math_floor(maxx/SQUARE_SIZE)
			for sqx = minx_alg,maxx_alg do
				local x = sqx*SQUARE_SIZE
				local sqr_x1 = math_min(maxx,math_max(minx,x))
				local sqr_x2 = math_min(maxx,math_max(minx,x+SQUARE_SIZE))
				local sqr_pos1 = (sqr_x1-row_x1)/(row_x2-row_x1)
				local sqr_pos2 = (sqr_x2-row_x1)/(row_x2-row_x1)
				if sqr_pos1 ~= sqr_pos1 or math_abs(sqr_pos1) == math_huge then
					sqr_pos1,sqr_pos2 = 0,1
				end
				local sqr_y1 = row_y1*(1-sqr_pos1)+row_y2*sqr_pos1
				local sqr_y2 = row_y1*(1-sqr_pos2)+row_y2*sqr_pos2

				local square = getSquare(sqx,sqy) or createSquare(sqx,sqy)
				local pos1 = row_pos1+(row_pos2-row_pos1)*sqr_pos1
				local pos2 = row_pos1+(row_pos2-row_pos1)*sqr_pos2
				local len = getDistanceBetweenPoints2D(sqr_x1,sqr_y1,sqr_x2,sqr_y2)*density
				addConnToSquare(square,connid,pos1,pos2,len)
			end
		end
	end
end

function getArcAndLineCrossPos(x1,y1,x2,y2,ixx,ixy,iyx,iyy)
	local rx  = x1*ixx+y1*ixy
	local ry  = x1*iyx+y1*iyy
	local ryx = x2*ixx+y2*ixy-rx
	local ryy = x2*iyx+y2*iyy-ry

	local rmult = 1/math.sqrt(ryx*ryx+ryy*ryy)
	ryx,ryy = ryx*rmult,ryy*rmult
	local nry = (0-rx)*ryx+(0-ry)*ryy

	local nx = rx+ryx*nry
	local ny = ry+ryy*nry
	local ndist = math.sqrt(nx*nx+ny*ny)
	local adddist = math.sqrt(1-ndist*ndist)

	local nx1,ny1 = nx+ryx*adddist,ny+ryy*adddist
	local nx2,ny2 = nx-ryx*adddist,ny-ryy*adddist

	local pos1 = nx1 >= 0 and ny1 >= 0 and math.asin(ny1)
	local pos2 = nx2 >= 0 and ny2 >= 0 and math.asin(ny2)

	return pos1 or pos2 or nil,pos1 and pos2 or nil
end

function createSquare(x,y)
	local row = square_id[y]
	if not row then
		row = {}
		square_id[y] = row
	end
	local sqid = row[x]
	if not sqid then
		sqid = #square_conns+1
		row[x] = sqid
		square_conns[sqid] = {peds = {},cars = {},boats = {},planes = {}}
		square_cpos1[sqid] = {peds = {},cars = {},boats = {},planes = {}}
		square_cpos2[sqid] = {peds = {},cars = {},boats = {},planes = {}}
		square_cdens[sqid] = {peds = {},cars = {},boats = {},planes = {}}
		square_ttden[sqid] = {peds =  0,cars =  0,boats =  0,planes =  0}
		return sqid
	end
end

function getSquare(x,y)
	local row = square_id[y]
	if not row then return end
	local sqid = row[x]
	if not sqid then return end
	return sqid
end

function addConnToSquare(square,conn,pos1,pos2,len)
	local conntype = conn_type[conn]
	local connnum = #square_conns[square][conntype]+1
	square_conns[square][conntype][connnum] = conn
	square_cpos1[square][conntype][connnum] = pos1
	square_cpos2[square][conntype][connnum] = pos2
	square_cdens[square][conntype][connnum] = len
	square_ttden[square][conntype] = square_ttden[square][conntype]+len
end

