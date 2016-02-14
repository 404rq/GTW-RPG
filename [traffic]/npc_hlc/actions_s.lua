function makeNPCWalkToPos(npc,x,y,z,maxtime)
	local px,py,pz = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local dx,dy,dz = x-px,y-py,z-pz
	local dist = getDistanceBetweenPoints3D(0,0,0,dx,dy,dz)
	dx,dy,dz = dx/dist,dy/dist,dz/dist
	local maxtime_unm = maxtime
	if dist < walk_dist then
		maxtime = maxtime*dist/walk_dist
		walk_dist = dist
	end
	local model = getElementModel(npc)
	x,y,z = px+dx*walk_dist,py+dy*walk_dist,pz+dz*walk_dist
	local rot = -math.deg(math.atan2(dx,dy))

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x,y,z,rot)
		local boxprev = call(server_coldata,"getElementIntersectionBox",npc)
		move = not call(server_coldata"doesModelBoxIntersect",box,getElementDimension(npc),boxprev)
	end
	if move then
		setElementPosition(npc,x,y,z,false)
		setPedRotation(npc,rot)
		if check_cols then call(server_coldata,"updateElementColData",npc) end
		return maxtime
	else
		setElementPosition(npc,px,py,pz)
		setPedRotation(npc,getPedRotation(npc))
		return maxtime_unm
	end
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getPercentageInLine(x_this,y_this,x1,y1,x2,y2)
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+walk_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
	else
		x_next = x1*p1_next+x2*p2_next
		y_next = y1*p1_next+y2*p2_next
		z_next = z1*p1_next+z2*p2_next
	end
	local model = getElementModel(npc)
	local rot = -math.deg(math.atan2(x2-x1,y2-y1))

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x_next,y_next,z_next,rot)
		local boxprev = call(server_coldata,"getElementIntersectionBox",npc)
		move = not call(server_coldata,"doesModelBoxIntersect",box,getElementDimension(npc),boxprev)
	end
	if move then
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,rot)
		if check_cols then call(server_coldata,"updateElementColData",npc) end
		return maxtime
	else
		setElementPosition(npc,x_this,y_this,z_this)
		setPedRotation(npc,getPedRotation(npc))
		return maxtime_unm
	end
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getAngleInBend(x_this,y_this,x0,y0,x1,y1,x2,y2)/math.pi*2
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+walk_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next,a_next
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
		a_next = -math.deg(math.atan2(x0-x1,y0-y1))
	else
		x_next,y_next = getPosFromBend(p2_next*math.pi*0.5,x0,y0,x1,y1,x2,y2)
		z_next = z1*p1_next+z2*p2_next
		local x_next_front,y_next_front = getPosFromBend(p2_next*math.pi*0.5+0.01,x0,y0,x1,y1,x2,y2)
		a_next = -math.deg(math.atan2(x_next_front-x_next,y_next_front-y_next))
	end
	local model = getElementModel(npc)

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x_next,y_next,z_next,a_next)
		local boxprev = call(server_coldata,"getElementIntersectionBox",npc)
		move = not call(server_coldata,"doesModelBoxIntersect",box,getElementDimension(npc),boxprev)
	end
	if move then
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,a_next)
		if check_cols then call(server_coldata,"updateElementColData",npc) end
		return maxtime
	else
		setElementPosition(npc,x_this,y_this,z_this)
		setPedRotation(npc,getPedRotation(npc))
		return maxtime_unm
	end
end

--[[function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getPercentageInLine(x_this,y_this,x1,y1,x2,y2)
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+off/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next = p1_next*x1+p2_next*x2,p1_next*y1+p2_next*y2,p1_next*z1+p2_next*z2
	local next_dist = getDistanceBetweenPoints3D(x_this,y_this,z_this,x_next,y_next,z_next)
	if p2_next > 1 then
		local p_next = (1-p2_this)/(p2_next-p2_this)
		local p_this = 1-p_next
		x_next = x_this*p_this+x_next*p_next
		y_next = y_this*p_this+y_next*p_next
		z_next = z_this*p_this+z_next*p_next
		local next_dist = getDistanceBetweenPoints3D(x_this,y_this,z_this,x_next,y_next,z_next)
		if next_dist < walk_dist then
			maxtime = maxtime*next_dist/walk_dist
			setPedRotation(npc,-math.deg(math.atan2(x_next-x_this,y_next-y_this)))
		else
			local distmult = walk_dist/next_dist
			x_next = (x_next-x_this)*distmult+x_this
			y_next = (y_next-y_this)*distmult+y_this
			z_next = (z_next-z_this)*distmult+z_this
		end
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,-math.deg(math.atan2(x_next-x_this,y_next-y_this)))
		return maxtime
	else
		if next_dist < walk_dist then
			local next2_dist = walk_dist-next_dist
			local p2_next2 = p2_next+next2_dist/len
			if p2_next2 > 1 then
				maxtime = maxtime*(walk_dist-(p2_next2-1)*len)/walk_dist
				x_next,y_next,z_next = x2,y2,z2
			else
				local p1_next2 = 1-p2_next2
				x_next = p1_next2*x1+p2_next2*x2
				y_next = p1_next2*y1+p2_next2*y2
				z_next = p1_next2*z1+p2_next2*z2
			end
			setElementPosition(npc,x_next,y_next,z_next,false)
			setPedRotation(npc,-math.deg(math.atan2(x2-x1,y2-y1)))
			return maxtime
		else
			local distmult = walk_dist/next_dist
			x_next = (x_next-x_this)*distmult
			y_next = (y_next-y_this)*distmult
			z_next = (z_next-z_this)*distmult
			setPedRotation(npc,-math.deg(math.atan2(x_next,y_next)))
			x_next,y_next,z_next = x_next+x_this,y_next+y_this,z_next+z_this
			setElementPosition(npc,x_next,y_next,z_next,false)
			return maxtime
		end
	end
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getAngleInBend(x_this,y_this,x0,y0,x1,y1,x2,y2)/math.pi*2
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)*math.pi*0.5
	local p2_next = p2_this+off/len
	local p1_next = 1-p2_next
	local x_next,y_next = getPosFromBend(p2_next*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	local z_next = p1_next*z1+p2_next*z2
	local next_dist = getDistanceBetweenPoints3D(x_this,y_this,z_this,x_next,y_next,z_next)
	if p2_next > 1 then
		local p_next = (1-p2_this)/(p2_next-p2_this)
		local p_this = 1-p_next
		x_next = x_this*p_this+x_next*p_next
		y_next = y_this*p_this+y_next*p_next
		z_next = z_this*p_this+z_next*p_next
		local next_dist = getDistanceBetweenPoints3D(x_this,y_this,z_this,x_next,y_next,z_next)
		if next_dist < walk_dist then
			maxtime = maxtime*next_dist/walk_dist
		else
			local distmult = walk_dist/next_dist
			x_next = (x_next-x_this)*distmult+x_this
			y_next = (y_next-y_this)*distmult+y_this
			z_next = (z_next-z_this)*distmult+z_this
		end
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,-math.deg(math.atan2(x_next-x_this,y_next-y_this)))
		return maxtime
	else
		if next_dist < walk_dist then
			local next2_dist = walk_dist-next_dist
			local p2_next2 = p2_next+next2_dist/len
			if p2_next2 > 1 then
				maxtime = maxtime*(walk_dist-(p2_next2-1)*len)/walk_dist
				x_next,y_next,z_next = x2,y2,z2
			else
				local p1_next2 = 1-p2_next2
				x_next = p1_next2*x1+p2_next2*x2
				y_next = p1_next2*y1+p2_next2*y2
				z_next = p1_next2*z1+p2_next2*z2
			end
			setElementPosition(npc,x_next,y_next,z_next,false)
			setPedRotation(npc,-math.deg(math.atan2(x2-x1,y2-y1)))
			return maxtime
		else
			local distmult = walk_dist/next_dist
			x_next = (x_next-x_this)*distmult
			y_next = (y_next-y_this)*distmult
			z_next = (z_next-z_this)*distmult
			setPedRotation(npc,-math.deg(math.atan2(x_next,y_next)))
			x_next,y_next,z_next = x_next+x_this,y_next+y_this,z_next+z_this
			setElementPosition(npc,x_next,y_next,z_next,false)
			return maxtime
		end
	end
end]]

function makeNPCDriveToPos(npc,x,y,z,maxtime)
	local car = getPedOccupiedVehicle(npc)
	local px,py,pz = getElementPosition(car)
	local speed = getNPCDriveSpeed(npc)
	local drive_dist = speed*50*maxtime*0.001
	local dx,dy,dz = x-px,y-py,z-pz
	local dist = getDistanceBetweenPoints3D(0,0,0,dx,dy,dz)
	dx,dy,dz = dx/dist,dy/dist,dz/dist
	local rx,ry,rz = math.deg(math.asin(dz)),0,-math.deg(math.atan2(dx,dy))
	local vx,vy,vx
	local maxtime_unm = maxtime
	if dist < drive_dist then
		maxtime = maxtime*dist/drive_dist
		drive_dist = dist
		vx,vy,vz = 0,0,0
	else
		vx,vy,vz = dx*speed,dy*speed,dz*speed
	end
	local model = getElementModel(car)
	x,y,z = px+dx*drive_dist,py+dy*drive_dist,pz+dz*drive_dist

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x,y,z,rz)
		local boxprev = call(server_coldata,"getElementIntersectionBox",car)
		move = not call(server_coldata,"doesModelBoxIntersect",box,getElementDimension(car),boxprev)
	end
	if move then
		setElementPosition(car,x,y,z,true)
		setElementRotation(car,rx,ry,rz)
		setElementVelocity(car,vx,vy,vz)
		setVehicleTurnVelocity(car,0,0,0)
		setElementPosition(npc,x,y,z)
		if check_cols then call(server_coldata,"updateElementColData",car) end
		return maxtime
	else
		setElementPosition(car,px,py,pz,true)
		setElementRotation(car,getElementRotation(car))
		setElementVelocity(car,0,0,0)
		setVehicleTurnVelocity(car,0,0,0)
		return maxtime_unm
	end
end

function makeNPCDriveAlongLine(npc,x1,y1,z1,x2,y2,z2,off,maxtime)
	local car = getPedOccupiedVehicle(npc)
	local x_this,y_this,z_this = getElementPosition(car)
	local speed = getNPCDriveSpeed(npc)
	local drive_dist = speed*50*maxtime*0.001
	local p2_this = getPercentageInLine(x_this,y_this,x1,y1,x2,y2)
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+drive_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next
	local dirx,diry,dirz = (x2-x1)/len,(y2-y1)/len,(z2-z1)/len
	local vx,vy,vz
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
		vx,vy,vz = 0,0,0
	else
		x_next = x1*p1_next+x2*p2_next
		y_next = y1*p1_next+y2*p2_next
		z_next = z1*p1_next+z2*p2_next
		vx,vy,vz = dirx*speed,diry*speed,dirz*speed
	end
	local model = getElementModel(car)
	local rx,ry,rz = math.deg(math.asin(dirz)),0,-math.deg(math.atan2(dirx,diry))

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x_next,y_next,z_next,rz)
		local boxprev = call(server_coldata,"getElementIntersectionBox",car)
		move = not call(server_coldata,"doesModelBoxIntersect",box,getElementDimension(car),boxprev)
	end
	if move then
		setElementPosition(car,x_next,y_next,z_next,true)
		setElementRotation(car,rx,ry,rz)
		setElementVelocity(car,vx,vy,vz)
		setVehicleTurnVelocity(car,0,0,0)
		setElementPosition(npc,x_next,y_next,z_next)
		if check_cols then call(server_coldata,"updateElementColData",car) end
		return maxtime
	else
		setElementPosition(car,x_this,y_this,z_this,true)
		setElementRotation(car,getElementRotation(car))
		setElementVelocity(car,0,0,0)
		setVehicleTurnVelocity(car,0,0,0)
		return maxtime_unm
	end
end

function makeNPCDriveAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off,maxtime)
	local car = getPedOccupiedVehicle(npc)
	local x_this,y_this,z_this = getElementPosition(car)
	local speed = getNPCDriveSpeed(npc)
	local drive_dist = speed*50*maxtime*0.001
	local p2_this = getAngleInBend(x_this,y_this,x0,y0,x1,y1,x2,y2)/math.pi*2
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+drive_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next
	local dirx,diry,dirz,vx,vy,vz
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
		dirx,diry,dirz = x1-x0,y1-y0,z1-z2
		local dirlen = 1/getDistanceBetweenPoints3D(0,0,0,dirx,diry,dirz)
		dirx,diry,dirz = dirx*dirlen,diry*dirlen,dirz*dirlen
		vx,vy,vz = 0,0,0
	else
		x_next,y_next = getPosFromBend(p2_next*math.pi*0.5,x0,y0,x1,y1,x2,y2)
		z_next = z1*p1_next+z2*p2_next
		local x_next_front,y_next_front = getPosFromBend(p2_next*math.pi*0.5+0.01,x0,y0,x1,y1,x2,y2)
		local z_next_front = z1*(p1_next-0.01)+z2*(p2_next+0.01)

		dirx,diry,dirz = x_next_front-x_next,y_next_front-y_next,z_next_front-z_next
		local dirlen = 1/getDistanceBetweenPoints3D(0,0,0,dirx,diry,dirz)
		dirx,diry,dirz = dirx*dirlen,diry*dirlen,dirz*dirlen
		vx,vy,vz = dirx*speed,diry*speed,dirz*speed
	end
	local model = getElementModel(car)
	local rx,ry,rz = math.deg(math.asin(dirz)),0,-math.deg(math.atan2(dirx,diry))

	local move = true
	if check_cols then
		local box = call(server_coldata,"createModelIntersectionBox",model,x_next,y_next,z_next,rz)
		local boxprev = call(server_coldata,"getElementIntersectionBox",car)
		move = not call(server_coldata,"doesModelBoxIntersect",box,getElementDimension(car),boxprev)
	end
	if move then
		setElementPosition(car,x_next,y_next,z_next,true)
		setElementRotation(car,rx,ry,rz)
		setElementVelocity(car,vx,vy,vz)
		setVehicleTurnVelocity(car,0,0,0)
		setElementPosition(npc,x_next,y_next,z_next)
		if check_cols then call(server_coldata,"updateElementColData",car) end
		return maxtime
	else
		setElementPosition(car,x_this,y_this,z_this,true)
		setElementRotation(car,getElementRotation(car))
		setElementVelocity(car,0,0,0)
		setVehicleTurnVelocity(car,0,0,0)
		return maxtime_unm
	end
end

