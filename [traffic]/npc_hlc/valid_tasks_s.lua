taskValid = {}

function taskValid.walkToPos(task)
	local x,y,z,dist = task[2],task[3],task[4],task[5]
	return tonumber(x) and tonumber(y) and tonumber(z) and tonumber(dist) and true or false
end

function taskValid.walkAlongLine(task)
	local x1,y1,z1 = task[2],task[3],task[4]
	local x2,y2,z2 = task[5],task[6],task[7]
	local off,enddist = task[8],task[9]
	return
		tonumber(x1) and tonumber(y1) and tonumber(z1) and
		tonumber(x2) and tonumber(y2) and tonumber(z2) and
		tonumber(off) and tonumber(enddist) and true or false
end

function taskValid.walkAroundBend(task)
	local bx,by = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	return
		tonumber(bx) and tonumber(by) and
		tonumber(x1) and tonumber(y1) and tonumber(z1) and
		tonumber(x2) and tonumber(y2) and tonumber(z2) and
		tonumber(off) and tonumber(enddist) and true or false
end

function taskValid.walkFollowElement(task)
	local element,dist = task[2],task[3]
	return isElement(element) and getElementPosition(element) and tonumber(dist) and true or false
end

function taskValid.shootPoint(task)
	local x,y,z = task[2],task[3],task[4]
	return tonumber(x) and tonumber(y) and tonumber(z) and true or false
end

function taskValid.shootElement(task)
	local element = task[2]
	return isElement(element) and getElementPosition(element) and true or false
end

function taskValid.killPed(task)
	local element,shootdist,followdist = task[2],task[3],task[4]
	return
		isElement(element) and getElementType(element) == "ped" and
		tonumber(shootdist) and tonumber(followdist) and true or false
end

taskValid.driveToPos = taskValid.walkToPos
taskValid.driveAlongLine = taskValid.walkAlongLine
taskValid.driveAroundBend = taskValid.walkAroundBend

function taskValid.waitForGreenLight(task)
	local dir = task[2]
	return dir == "NS" or dir == "WE" or dir == "ped"
end

