function getPercentageInLine(x,y,x1,y1,x2,y2)
	if not x then x = 0 end
	if not x1 then x1 = 0 end
	if not x2 then x2 = 0 end
	if not y then y = 0 end
	if not y1 then y1 = 0 end
	if not y2 then y2 = 0 end
	x,y = x-x1,y-y1 or 0,0
	local yx,yy = x2-x1,y2-y1
	return (x*yx+y*yy)/(yx*yx+yy*yy)
end

function getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)
	if not x then x = 0 end
	if not y then y = 0 end
	x,y = x-x0,y-y0
	local yx,yy = x1-x0,y1-y0
	local xx,xy = x2-x0,y2-y0
	local rx = (x*yy-y*yx)/(xx*yy-xy*yx)
	local ry = (x*xy-y*xx)/(yx*xy-yy*xx)
	return math.atan2(rx,ry)
end

function getPosFromBend(ang,x0,y0,x1,y1,x2,y2)
	local yx,yy = x1-x0,y1-y0
	local xx,xy = x2-x0,y2-y0
	local rx,ry = math.sin(ang),math.cos(ang)
	return
		rx*xx+ry*yx+x0,
		rx*xy+ry*yy+y0
end

