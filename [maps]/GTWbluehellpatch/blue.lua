--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		(Pro)Hunter

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

for i,v in ipairs({
    {3095,2522.3999,-1273.19995,32.9,0,270,359.75,1,0,0, true},
}) do
    local obj = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    setObjectScale(obj, v[8])
    setElementDimension(obj, v[9])
    setElementInterior(obj, v[10])
    setElementDoubleSided(obj, v[11])
end
