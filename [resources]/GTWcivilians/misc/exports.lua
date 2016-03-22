--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

function addWorkItem(key, data)
	-- Clear key first
	if work_items[key] then
		work_items[key] = nil
	end

	-- Update key data
	work_items[key] = data
end

function addMarker(data)
	-- Add marker to table
	table.insert(markers, data)
end

-- JobID, int, dim, x, y, z, JobType
table.insert(markers, { "Bus Driver", 0, 0, 1810.0068359375, -1896.935546875, 13.57953453064, "civilian" })
table.insert(markers, { "Bus Driver", 0, 0, -1671.8857421875, 1301.8271484375, 7.1798057556152, "civilian" })
table.insert(markers, { "Bus Driver", 0, 0, 2280.8623046875, 605.662109375, 10.8203125, "civilians" })
table.insert(markers, { "Train Driver", 0, 0, 1686.314453125, -1968.4482421875, 14.1171875, "civilian" })
table.insert(markers, { "Train Driver", 0, 0, -1968.7646484375, 161.9765625, 27.6875, "civilian" })
table.insert(markers, { "Train Driver", 0, 0, 1430.5107421875, 2620.3896484375, 11.392614364624, "civilian" })
table.insert(markers, { "Taxi Driver", 0, 0, 1682.873046875, -2334.2265625, 13.546875, "civilian" })
table.insert(markers, { "Taxi Driver", 0, 0, -1386.431640625, -347.787109375, 14.1484375, "civilian" })
table.insert(markers, { "Trucker", 0, 0, 2748.546875, -2437.6142578125, 13.64318561554, "civilian" })
table.insert(markers, { "Trucker", 0, 0, -77.9697265625, -1136.0869140625, 1.078125, "civilian" })
table.insert(markers, { "Trucker", 0, 0, -1688.2958984375, -17.8037109375, 3.5546875, "civilian" })
table.insert(markers, { "Pilot", 0, 0, -1546, -442, 6, "civilian" })
table.insert(markers, { "Pilot", 0, 0, 1958, -2182, 13.5, "civilian" })
table.insert(markers, { "Pilot", 0, 0, 1717, 1615.6, 10, "civilian" })
table.insert(markers, { "Mechanic", 0, 0, 1064.818359375, -1029.2861328125, 32.1015625, "civilian" })
table.insert(markers, { "Mechanic", 0, 0, -1916.5166015625, 253.9453125, 41.046875, "civilian" })
table.insert(markers, { "Fisher", 0, 0, -2947.4228515625, 503.61328125, 2.4296875, "civilian" })
table.insert(markers, { "Fisher", 0, 0, 159.3837890625, -1879.3955078125, 3.7734375, "civilian" })
table.insert(markers, { "Farmer", 0, 0, -1059.3037109375, -1205.517578125, 129.21875, "civilian" })
table.insert(markers, { "Farmer", 0, 0, -702.3828125, 945.595703125, 12.373688697815, "civilian" })
table.insert(markers, { "Tram Driver", 0, 0, -2238.806640625, 548.2177734375, 35.171875, "civilian" })
table.insert(markers, { "Fireman", 0, 0, 1745.7177734375, -1459.4775390625, 13.520838737488, "emergency" })
table.insert(markers, { "Fireman", 0, 0, 1745, 2080, 9.8, "emergency" })
table.insert(markers, { "Fireman", 0, 0, -2024, 64, 28.4, "emergency" })
table.insert(markers, { "Paramedic", 0, 0, 2035, -1406.5, 17.3, "emergency" })
table.insert(markers, { "Paramedic", 0, 0, 1177, -1327, 14.1, "emergency" })
table.insert(markers, { "Paramedic", 0, 0, -2644, 630, 14.6, "emergency" })
table.insert(markers, { "Paramedic", 0, 0, 1600, 1818, 10.8, "emergency" })
table.insert(markers, { "Iron miner", 0, 0, 825.583984375, 858.4228515625, 12.20775604248, "civilians" })
table.insert(markers, { "Trucker", 0, 0, 1057.3662109375, 1940.8779296875, 10.8203125, "civilians" })

-- BETA Police job
table.insert(markers, { "Police Officer", 6, 1, 250, 68, 1003.6, "government" })
table.insert(markers, { "Police Officer", 3, 0, 234, 159, 1003, "government" })
table.insert(markers, { "Police Officer", 10, 0, 246, 118, 1003, "government" })

-- Country side police jobs
table.insert(markers, { "Police Officer", 5, 0, 326, 307, 999, "government" })
table.insert(markers, { "Police Officer", 5, 1, 326, 307, 999, "government" })
table.insert(markers, { "Police Officer", 5, 2, 326, 307, 999, "government" })
table.insert(markers, { "Police Officer", 5, 3, 326, 307, 999, "government" })
table.insert(markers, { "Police Officer", 5, 4, 326, 307, 999, "government" })
table.insert(markers, { "Police Officer", 5, 5, 326, 307, 999, "government" })

table.insert(markers, { "SAPD Officer", 6, 2, 250, 68, 1003.6, "government" })
