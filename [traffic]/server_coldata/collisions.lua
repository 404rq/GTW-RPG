COLSQUARE_SIZE = 4
colsquares = {}
element_x,element_y = {},{}
element_box = {}

box_x,box_y,box_xx,box_xy,box_yx,box_yy,box_z1,box_z2 = {},{},{},{},{},{},{},{}
box_model,box_cx,box_cy = {},{},{}

last_box = 1

function loadCollisionData()
	bb_x1,bb_y1,bb_z1,bb_x2,bb_y2,bb_z2 = {},{},{},{},{},{}
	bs_r = {}
	local coldata_file = xmlLoadFile("coldata.xml")
	local colbox_nodes = xmlNodeGetChildren(coldata_file)
	for colbox_num,colbox_node in ipairs(colbox_nodes) do
		local coldata = xmlNodeGetAttributes(colbox_node)
		local model = tonumber(coldata.model)
		local x1,y1,z1 = tonumber(coldata.x1),tonumber(coldata.y1),tonumber(coldata.z1)
		local x2,y2,z2 = tonumber(coldata.x2),tonumber(coldata.y2),tonumber(coldata.z2)
		bb_x1[model],bb_y1[model],bb_z1[model] = x1,y1,z1
		bb_x2[model],bb_y2[model],bb_z2[model] = x2,y2,z2
		x2,y2 = x2-x1,y2-y1
		bs_r[model] = math.sqrt(x2*x2+y2*y2)
	end
	bbox_part = {x1 = bb_x1,y1 = bb_y1,z1 = bb_z1,x2 = bb_x2,y2 = bb_y2,z2 = bb_z2}
	clearColData()
end
addEventHandler("onResourceStart",resourceRoot,loadCollisionData)

function generateColData(startelement)
	if startelement == nil then
		startelement = root
	end
	if not isElement(startelement) then
		--outputDebugString("Invalid element argument",2)
		return false
	end

	local updateElementColData = updateElementColData
	clearColData()
	local elements
	elements = getElementsByType("ped",startelement)
	for elnum,element in ipairs(elements) do
		if not isPedInVehicle(element) then
			updateElementColData(element)
		end
	end
	elements = getElementsByType("player",startelement)
	for elnum,element in ipairs(elements) do
		if not isPedInVehicle(element) then
			updateElementColData(element)
		end
	end
	elements = getElementsByType("vehicle",startelement)
	for elnum,element in ipairs(elements) do
		updateElementColData(element)
	end

	return true
end

function clearColData()
	colsquares = {}
	element_x,element_y,element_dim = {},{},{}
	element_box = {}

	box_x,box_y,box_xx,box_xy,box_yx,box_yy,box_z1,box_z2 = {},{},{},{},{},{},{},{}
	box_model,box_cx,box_cy = {},{},{}
	return true
end

function createColSquare(x,y,dim)
	local colsquare_dim = colsquares[dim]
	if not colsquare_dim then
		colsquare_dim = {}
		colsquares[dim] = colsquare_dim
	end
	local colsquare_row = colsquare_dim[y]
	if not colsquare_row then
		colsquare_row = {}
		colsquare_dim[y] = colsquare_row
	end
	local colsquare = colsquare_row[x]
	if not colsquare then
		colsquare = {}
		colsquare_row[x] = colsquare
	end
	return colsquare
end

function getColSquare(x,y,dim)
	local colsquare_dim = colsquares[dim]
	if not colsquare_dim then return end
	local colsquare_row = colsquare_dim[y]
	if not colsquare_row then return end
	return colsquare_row[x]
end

function createModelIntersectionBox(model,x,y,z,r)
	if not bs_r[model] then
		--outputDebugString("Invalid model argument",2)
		return false
	end
	x = tonumber(x)
	if not x then
		--outputDebugString("Invalid x coordinate argument",2)
		return false
	end
	y = tonumber(y)
	if not y then
		--outputDebugString("Invalid y coordinate argument",2)
		return false
	end
	z = tonumber(z)
	if not z then
		--outputDebugString("Invalid z coordinate argument",2)
		return false
	end
	r = tonumber(r)
	if not r then
		--outputDebugString("Invalid rotation argument",2)
		return false
	end

	local x1,y1,z1,x2,y2,z2 = bb_x1[model],bb_y1[model],bb_z1[model],bb_x2[model],bb_y2[model],bb_z2[model]
	r = math.rad(-r)
	local yx,yy = math.sin(r),math.cos(r)
	local xx,xy = yy,-yx
	local dx,dy,dz = x2-x1,y2-y1,z2-z1

	last_box = last_box+1
	box_x[last_box],box_y[last_box] = x+xx*x1+yx*y1,y+xy*x1+yy*y1
	box_xx[last_box],box_xy[last_box] = xx*dx,xy*dx
	box_yx[last_box],box_yy[last_box] = yx*dy,yy*dy
	box_z1[last_box],box_z2[last_box] = z+z1,z+z2
	box_model[last_box],box_cx[last_box],box_cy[last_box] = model,x,y
	return last_box
end

function getElementIntersectionBox(element)
	if not isElement(element) then
		--outputDebugString("Invalid element argument",2)
		return false
	end

	local box = element_box[element]
	if box_model[box] then return box end
	local model = getElementModel(element)
	if not model or not bs_r[model] then
		--outputDebugString("Invalid element model",2)
		return false
	end

	local x,y,z = getElementPosition(element)
	local rx,ry,rz = getElementRotation(element)
	box = createModelIntersectionBox(model,x,y,z,rz)
	element_box[element] = box
	element_x[element],element_y[element] = x,y
	return box
end

function updateElementColData(element)
	if not isElement(element) then
		--outputDebugString("Invalid element argument",2)
		return false
	end

	local model = getElementModel(element)
	local radius = bs_r[model]
	if not radius then
		--outputDebugString("Invalid element model",2)
		return false
	end

	local COLSQUARE_SIZE = COLSQUARE_SIZE
	local math_floor,math_ceil = math.floor,math.ceil
	local createColSquare = createColSquare
	local dim = getElementDimension(element)
	if element_box[element] then
		local getColSquare = getColSquare
		local x,y,dim = element_x[element],element_y[element],element_dim[element]
		local x1,y1,x2,y2 = x-radius,y-radius,x+radius,y+radius
		x1,y1 = math_floor(x1/COLSQUARE_SIZE),math_floor(y1/COLSQUARE_SIZE)
		x2,y2 = math_ceil (x2/COLSQUARE_SIZE),math_ceil (y2/COLSQUARE_SIZE)
		for sy = y1,y2 do
			for sx = x1,x2 do
				local square = getColSquare(sx,sy,dim)
				if square then square[element] = nil end
			end
		end
	end
	local x,y,z = getElementPosition(element)
	local rx,ry,rz = getElementRotation(element)
	local dim = getElementDimension(element)
	local box = createModelIntersectionBox(model,x,y,z,rz)
	local x1,y1,x2,y2 = x-radius,y-radius,x+radius,y+radius
	x1,y1 = math_floor(x1/COLSQUARE_SIZE),math_floor(y1/COLSQUARE_SIZE)
	x2,y2 = math_ceil (x2/COLSQUARE_SIZE),math_ceil (y2/COLSQUARE_SIZE)
	for sy = y1,y2 do
		for sx = x1,x2 do
			createColSquare(sx,sy,dim)[element] = box
		end
	end
	element_x[element],element_y[element] = x,y
	element_box[element] = box
	return true
end

function doesModelBoxIntersect(box1,dim,boxexcl)
	if not box1 or not box_model[box1] then
		--outputDebugString("Invalid box argument",2)
		return false
	end
	dim = tonumber(dim)
	if not dim then
		--outputDebugString("Invalid dimension argument",2)
		return false
	end
	if boxexcl and not box_model[boxexcl] then
		--outputDebugString("Invalid ignored box argument",2)
		return false
	end

	local COLSQUARE_SIZE = COLSQUARE_SIZE
	local getColSquare = getColSquare
	local doModelBoxesIntersect = doModelBoxesIntersect
	local math_floor,math_ceil = math.floor,math.ceil
	local pairs = pairs
	local radius,x,y = bs_r[box_model[box1]],box_cx[box1],box_cy[box1]
	local x1,y1,x2,y2 = x-radius,y-radius,x+radius,y+radius
	x1,y1 = math_floor(x1/COLSQUARE_SIZE),math_floor(y1/COLSQUARE_SIZE)
	x2,y2 = math_ceil (x2/COLSQUARE_SIZE),math_ceil (y2/COLSQUARE_SIZE)
	for sy = y1,y2 do
		for sx = x1,x2 do
			local square = getColSquare(sx,sy,dim)
			if square then
				for element,box2 in pairs(square) do
					if doModelBoxesIntersect(box1,box2) and box1 ~= box2 and box2 ~= boxexcl then
						return true
					end
				end
			end
		end
	end
	return false
end

function doModelBoxesIntersect(b1,b2)
	if not b1 or not box_model[b1] then
		--outputDebugString("Invalid box1 argument",2)
		return false
	end
	if not b2 or not box_model[b2] then
		--outputDebugString("Invalid box2 argument",2)
		return false
	end

	if box_z1[b1] > box_z2[b2] or box_z1[b2] > box_z2[b1] then return false end
	local x1,y1,xx1,xy1,yx1,yy1 = box_x[b1],box_y[b1],box_xx[b1],box_xy[b1],box_yx[b1],box_yy[b1]
	local x2,y2,xx2,xy2,yx2,yy2 = box_x[b2],box_y[b2],box_xx[b2],box_xy[b2],box_yx[b2],box_yy[b2]
	do
		local x1,y1,x2,y2 = x1-x2,y1-y2,x2-x1,y2-y1
		local rx1 = (x1*yy2-y1*yx2)/(xx2*yy2-xy2*yx2)
		local ry1 = (x1*xy2-y1*xx2)/(yx2*xy2-yy2*xx2)
		if rx1 >= 0 and rx1 <= 1 and ry1 >= 0 and ry1 <= 1 then return true end
		local rx2 = (x2*yy1-y2*yx1)/(xx1*yy1-xy1*yx1)
		local ry2 = (x2*xy1-y2*xx1)/(yx1*xy1-yy1*xx1)
		if rx2 >= 0 and rx2 <= 1 and ry2 >= 0 and ry2 <= 1 then return true end
	end
	local x1_1,y1_1,x2_1,y2_1,x3_1,y3_1,x4_1,y4_1 = x1,y1,x1+xx1,y1+xy1,x1+xx1+yx1,y1+xy1+yy1,x1+yx1,y1+yy1
	local x1_2,y1_2,x2_2,y2_2,x3_2,y3_2,x4_2,y4_2 = x2,y2,x2+xx2,y2+xy2,x2+xx2+yx2,y2+xy2+yy2,x2+yx2,y2+yy2
	local doLinesIntersect = doLinesIntersect
	return
		doLinesIntersect(x1_1,y1_1,x2_1,y2_1,x1_2,y1_2,x2_2,y2_2) or
		doLinesIntersect(x1_1,y1_1,x2_1,y2_1,x2_2,y2_2,x3_2,y3_2) or
		doLinesIntersect(x1_1,y1_1,x2_1,y2_1,x3_2,y3_2,x4_2,y4_2) or
		doLinesIntersect(x1_1,y1_1,x2_1,y2_1,x4_2,y4_2,x1_2,y1_2) or
		doLinesIntersect(x2_1,y2_1,x3_1,y3_1,x1_2,y1_2,x2_2,y2_2) or
		doLinesIntersect(x2_1,y2_1,x3_1,y3_1,x2_2,y2_2,x3_2,y3_2) or
		doLinesIntersect(x2_1,y2_1,x3_1,y3_1,x3_2,y3_2,x4_2,y4_2) or
		doLinesIntersect(x2_1,y2_1,x3_1,y3_1,x4_2,y4_2,x1_2,y1_2) or
		doLinesIntersect(x3_1,y3_1,x4_1,y4_1,x1_2,y1_2,x2_2,y2_2) or
		doLinesIntersect(x3_1,y3_1,x4_1,y4_1,x2_2,y2_2,x3_2,y3_2) or
		doLinesIntersect(x3_1,y3_1,x4_1,y4_1,x3_2,y3_2,x4_2,y4_2) or
		doLinesIntersect(x3_1,y3_1,x4_1,y4_1,x4_2,y4_2,x1_2,y1_2) or
		doLinesIntersect(x4_1,y4_1,x1_1,y1_1,x1_2,y1_2,x2_2,y2_2) or
		doLinesIntersect(x4_1,y4_1,x1_1,y1_1,x2_2,y2_2,x3_2,y3_2) or
		doLinesIntersect(x4_1,y4_1,x1_1,y1_1,x3_2,y3_2,x4_2,y4_2) or
		doLinesIntersect(x4_1,y4_1,x1_1,y1_1,x4_2,y4_2,x1_2,y1_2)
end

function doLinesIntersect(x1_1,y1_1,x2_1,y2_1,x1_2,y1_2,x2_2,y2_2)
	local yx,yy = x2_1-x1_1,y2_1-y1_1

	local x1,y1 = x1_2-x1_1,y1_2-y1_1
	local x2,y2 = x2_2-x1_1,y2_2-y1_1

	local det = 1/(yy*yy+yx*yx)
	local rx1 = (x1*yy-y1*yx)*det
	local ry1 = (x1*yx+y1*yy)*det
	local rx2 = (x2*yy-y2*yx)*det
	local ry2 = (x2*yx+y2*yy)*det

	if rx1 > 0 and rx2 > 0 or rx1 < 0 and rx2 < 0 then return false end
	local my = ry1-(ry2-ry1)*rx1/(rx2-rx1)
	return my >= 0 and my <= 1
end

