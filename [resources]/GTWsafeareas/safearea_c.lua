--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

has_been_warned = nil
rocket_launchers = {
        {"jail", -3008.18,2442.19,25.47},
	{"jail", -3110.78,2354.36,28.37},
	{"jail", -3110.51,2254.5,28.37},
	{"jail", -3054.41,2204.34,25.47},
	{"jail", -2984.04,2235.65,28.37},
	{"jail", -2979.02,2042.44,22.58},
	{"jail", -2983.1,2285.03,10},
	{"jail", -2983.3,2362.6,30},
	{"jail", -3054.7,2304.1,40},
        {"jail", -2885.6,2299.8,162},
        {"a51",16,1718,30},
        {"a51",237,1696,30},
        {"a51",354,2028,30},
        {"a51",188,2081,30},
}
allowed_government_teams = {
	["Staff"]=true,
	["Government"]=true,
	["Emergency service"]=true
}

function protectPrison()
	for k,v in pairs(getElementsByType("player")) do
		local x,y,z = getElementPosition(v)
		local nx,ny,nz = 0,0,0
		local old_dist = 999
		for i,rl in pairs(rocket_launchers) do
			local dist = getDistanceBetweenPoints3D(rl[2],rl[3],rl[4], x,y,z)
			if dist < 180 and (not getPlayerTeam(v) or
				not allowed_government_teams[getTeamName(getPlayerTeam(v))]) and rl[1] == "jail" and
				(isElementInWater(v) or getPedOccupiedVehicle(v) or z > 20) and not getElementData(v, "arrested") then
				if old_dist > dist then
					old_dist = dist
					nx,ny,nz = rl[2],rl[3],rl[4]
				end
                                -- Make sure none of the occupants are allowed to be there
                                if getPedOccupiedVehicle(v) then
                                        local occupants = getVehicleOccupants(getPedOccupiedVehicle(v))
                                        for i,occu in pairs(occupants) do
                                                if getPlayerTeam(occu) and allowed_government_teams[
                                                        getTeamName(getPlayerTeam(occu))] then
                                                        -- Theres a law enforcer in this vehicle, don't shoot
                                                        nx,ny,nz = 0,0,0
                                                end
                                        end
                                end
			end
			if has_been_warned and dist < 150 and z > 40 and (not getPlayerTeam(v) or
				not allowed_government_teams[getTeamName(getPlayerTeam(v))]) and rl[1] == "a51" then
				if old_dist > dist then
					old_dist = dist
					nx,ny,nz = rl[2],rl[3],rl[4]
				end
			elseif not has_been_warned  and dist < 150 and z > 40 and (not getPlayerTeam(v) or
				not allowed_government_teams[getTeamName(getPlayerTeam(v))]) and rl[1] == "a51" then
				has_been_warned = true
				setTimer(reset_warning, 300000, 1)
				exports.GTWtopbar:dm("This is a restricted area, leave or get shot!", 255, 100, 0)
			end
		end

		-- Fire if there is a nearest rocket
		if nx == 0 or ny == 0 or nz == 0 then return end
		createProjectile(v, 20, nx,ny,nz, 1, v)
	end
end
function reset_warning()
	has_been_warned = nil
end
setTimer(protectPrison, 30000, 0)
