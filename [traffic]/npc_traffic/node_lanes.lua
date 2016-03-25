function calculateNodeLaneCounts()
	for connid,n1 in ipairs(conn_n1) do
		local n2 = conn_n2[connid]
		local nb = conn_nb[connid]
		local ll,rl = conn_lanes.left[connid],conn_lanes.right[connid]

		local ll1,rl1 = node_lanes.left[n1],node_lanes.right[n1]
		local ll2,rl2 = node_lanes.left[n2],node_lanes.right[n2]

		if areDirectionsMatching(n1,nb or n1,n2) then
			if ll ~= 0 then ll1 = ll1 and math.min(ll,ll1) or ll end
			if rl ~= 0 then rl1 = rl1 and math.min(rl,rl1) or rl end
		else
			if rl ~= 0 then ll1 = ll1 and math.min(rl,ll1) or rl end
			if ll ~= 0 then rl1 = rl1 and math.min(ll,rl1) or ll end
		end
		if areDirectionsMatching(n2,n1,nb or n2) then
			if ll ~= 0 then ll2 = ll2 and math.min(ll,ll2) or ll end
			if rl ~= 0 then rl2 = rl2 and math.min(rl,rl2) or rl end
		else
			if rl ~= 0 then ll2 = ll2 and math.min(rl,ll2) or rl end
			if ll ~= 0 then rl2 = rl2 and math.min(ll,rl2) or ll end
		end

		node_lanes.left[n1],node_lanes.right[n1] = ll1,rl1
		node_lanes.left[n2],node_lanes.right[n2] = ll2,rl2

		checkThreadYieldTime()
	end

	for nodeid in ipairs(node_z) do
		if not node_lanes.left[nodeid] then node_lanes.left[nodeid] = 0 end
		if not node_lanes.right[nodeid] then node_lanes.right[nodeid] = 0 end

		checkThreadYieldTime()
	end
end

function getNodeConnLanePos(nodeid,connid,lane,dest)
	if lane == 0 then return node_x[nodeid],node_y[nodeid],node_z[nodeid] end
	local n1,n2,nb = conn_n1[connid],conn_n2[connid],conn_nb[connid]
	local dirs_match
	if dest then
		if nodeid ~= n1 then
			if not nb then
				dirs_match = areDirectionsMatching(nodeid,n1,n2)
			else
				dirs_match = areDirectionsMatching(nodeid,n1,nb)
			end
		else
			if not nb then
				dirs_match = areDirectionsMatching(nodeid,n2,n1)
			else
				dirs_match = areDirectionsMatching(nodeid,n2,nb)
			end
		end
	else
		if nodeid == n1 then
			if not nb then
				dirs_match = areDirectionsMatching(nodeid,n1,n2)
			else
				dirs_match = areDirectionsMatching(nodeid,nb,n2)
			end
		else
			if not nb then
				dirs_match = areDirectionsMatching(nodeid,n2,n1)
			else
				dirs_match = areDirectionsMatching(nodeid,nb,n1)
			end
		end
	end
	if dirs_match then
		return getNodeLanePos(nodeid,"right",lane)
	else
		return getNodeLanePos(nodeid,"left",lane)
	end
end

function getNodeLanePos(nodeid,side,lane)
	local x,y,z = node_x[nodeid],node_y[nodeid],node_z[nodeid]
	if lane == 0 then return x,y,z end
	local rx,ry = node_rx[nodeid],node_ry[nodeid]
	local ll,rl = node_lanes.left[nodeid],node_lanes.right[nodeid]
	lane = math.min(lane,side == "left" and ll or rl)*2-1
	local lanepos = -(rl-ll)+(side == "left" and -lane or lane)
	return x+rx*lanepos,y+ry*lanepos,z
end

function areDirectionsMatching(n,n1,n2)
	local rx,ry = node_rx[n],node_ry[n]
	local cx,cy = node_x[n2]-node_x[n1],node_y[n2]-node_y[n1]
	local nfx,nfy = -ry,rx
	return cx*nfx+cy*nfy > 0
end

