function stopAllNPCActions(npc)
	stopNPCWalkingActions(npc)
	stopNPCWeaponActions(npc)
	stopNPCDrivingActions(npc)

	setPedControlState(npc,"vehicle_fire",false)
	setPedControlState(npc,"vehicle_secondary_fire",false)
	setPedControlState(npc,"steer_forward",false)
	setPedControlState(npc,"steer_back",false)
	setPedControlState(npc,"horn",false)
	setPedControlState(npc,"handbrake",false)
end

function stopNPCWalkingActions(npc)
	setPedControlState(npc,"forwards",false)
	setPedControlState(npc,"sprint",false)
	setPedControlState(npc,"walk",false)
end

function stopNPCWeaponActions(npc)
	setPedControlState(npc,"aim_weapon",false)
	setPedControlState(npc,"fire",false)
end

function stopNPCDrivingActions(npc)
	local car = getPedOccupiedVehicle(npc)
	if not car then return end
	local m = getElementMatrix(car)
	local vx,vy,vz = getElementVelocity(car)
	vy = vx*m[2][1]+vy*m[2][2]+vz*m[2][3]
	setPedControlState(npc,"accelerate",vy < -0.01)
	setPedControlState(npc,"brake_reverse",vy > 0.01)
	setPedControlState(npc,"vehicle_left",false)
	setPedControlState(npc,"vehicle_right",false)
end

function makeNPCWalkToPos(npc,x,y)
	local px,py = getElementPosition(npc)
	setPedCameraRotation(npc,math.deg(math.atan2(x-px,y-py)))
	setPedControlState(npc,"forwards",true)
	local speed = getNPCWalkSpeed(npc)
	setPedControlState(npc,"walk",speed == "walk")
	setPedControlState(npc,"sprint",
		speed == "sprint" or
		speed == "sprintfast" and not getPedControlState(npc,"sprint")
	)
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local x,y,z = getElementPosition(npc)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty = p1*x1+p2*x2,p1*y1+p2*y2
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/math.pi*2+off/len
	local destx,desty = getPosFromBend(p2*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCShootAtPos(npc,x,y,z)
	local sx,sy,sz = getElementPosition(npc)
	x,y,z = x-sx,y-sy,z-sz
	local yx,yy,yz = 0,0,1
	local xx,xy,xz = yy*z-yz*y,yz*x-yx*z,yx*y-yy*x
	yx,yy,yz = y*xz-z*xy,z*xx-x*xz,x*xy-y*xx
	local inacc = 1-getNPCWeaponAccuracy(npc)
	local ticks = getTickCount()
	local xmult = inacc*math.sin(ticks*0.01 )*1000/math.sqrt(xx*xx+xy*xy+xz*xz)
	local ymult = inacc*math.cos(ticks*0.011)*1000/math.sqrt(yx*yx+yy*yy+yz*yz)
	local mult = 1000/math.sqrt(x*x+y*y+z*z)
	xx,xy,xz = xx*xmult,xy*xmult,xz*xmult
	yx,yy,yz = yx*ymult,yy*ymult,yz*ymult
	x,y,z = x*mult,y*mult,z*mult
	
	setPedAimTarget(npc,sx+xx+yx+x,sy+xy+yy+y,sz+xz+yz+z)
	if isPedInVehicle(npc) then
		setPedControlState(npc,"vehicle_fire",not getPedControlState(npc,"vehicle_fire"))
	else
		setPedControlState(npc,"aim_weapon",true)
		setPedControlState(npc,"fire",not getPedControlState(npc,"fire"))
	end
end

function makeNPCShootAtElement(npc,target)
	local x,y,z = getElementPosition(target)
	local vx,vy,vz = getElementVelocity(target)
	local tgtype = getElementType(target)
	if tgtype == "ped" or tgtype == "player" then
		x,y,z = getPedBonePosition(target,3)
		local vehicle = getPedOccupiedVehicle(target)
		if vehicle then
			vx,vy,vz = getElementVelocity(vehicle)
		end
	end
	vx,vy,vz = vx*6,vy*6,vz*6
	makeNPCShootAtPos(npc,x+vx,y+vy,z+vz)
end

function makeNPCDriveToPos(npc,x,y,z)
	local car = getPedOccupiedVehicle(npc)
	local m = getElementMatrix(car)
	x,y,z = x-m[4][1],y-m[4][2],z-m[4][3]
	local rx,ry,rz =
		x*m[1][1]+y*m[1][2]+z*m[1][3],
		x*m[2][1]+y*m[2][2]+z*m[2][3],
		x*m[3][1]+y*m[3][2]+z*m[3][3]
	if ry <= 0 then
		setPedControlState(npc,"vehicle_left",rx < 0)
		setPedControlState(npc,"vehicle_right",rx >= 0)
	else
		local secondpart = getTickCount()%100
		setPedControlState(npc,"vehicle_left",rx*500/ry < -secondpart)
		setPedControlState(npc,"vehicle_right",rx*500/ry > secondpart)
	end
	local vx,vy,vz = getElementVelocity(car)
	local vrx,vry,vrz =
		vx*m[1][1]+vy*m[1][2]+vz*m[1][3],
		vx*m[2][1]+vy*m[2][2]+vz*m[2][3],
		vx*m[3][1]+vy*m[3][2]+vz*m[3][3]
	local speed
	do
		local x1,y1,z1,x2,y2,z2 = getElementBoundingBox(car)
		z1 = z1+1
		local vx,vy,vz = m[4][1]+m[3][1]*z1,m[4][2]+m[3][2]*z1,m[4][3]+m[3][3]*z1
		local mult = (y2+6)/math.sqrt(x*x+y*y+z*z)
		local dx,dy,dz = x*mult,y*mult,z*mult
		if not isLineOfSightClear(vx,vy,vz,vx+dx,vy+dy,vz+dz,false,true,true,false,true,false,false,car) then
			speed = 0
		else
			speed = getNPCDriveSpeed(npc)*math.sin(math.pi*0.5-math.atan(math.abs(rx/ry))*0.75)
		end
	end
	setPedControlState(npc,"accelerate",vry < speed)
	setPedControlState(npc,"brake_reverse",vry > speed*1.1)
end

function makeNPCDriveAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local car = getPedOccupiedVehicle(npc)
	local x,y,z = getElementPosition(car)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty,destz = p1*x1+p2*x2,p1*y1+p2*y2,p1*z1+p2*z2
	makeNPCDriveToPos(npc,destx,desty,destz)
end

function makeNPCDriveAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off)
	local car = getPedOccupiedVehicle(npc)
	local x,y,z = getElementPosition(car)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/math.pi*2
	p2 = math.max(0,math.min(1,p2))
	p2 = p2+off/len
	local destx,desty = getPosFromBend(p2*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	local destz = (1-p2)*z1+p2*z2
	makeNPCDriveToPos(npc,destx,desty,destz)
end

