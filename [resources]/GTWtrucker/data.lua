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

-- List of vehicles that are considered to be a truck
truck_vehicles = {
	[403] = true,
        [414] = true,
        [443] = true,
	[455] = true,
        [456] = true,
        [498] = true,
        [499] = true,
        [514] = true,
        [515] = true,
        [524] = true,
        [573] = true,
        [578] = true
}

-- List over all truck routes
truck_routes = {
        -- Name of route to display in list
        ["[State] Solarin industries, San Fierro -> Unity station, Los Santos"] = {
                -- x, y, z, rot
                [1]={ -1826.548828125, 92.197265625, 15.706624031067, 179.73626708984 },
                [2]={ 1776.501953125, -1922.0869140625, 13.947728157043, 178.59338378906 },
        },
        ["[State] Solarin industries, San Fierro -> Temple gas station, Los Santos"] = {
                -- x, y, z, rot
                [1]={ -1820.525390625, 52.9150390625, 15.714419364929, 359.78021240234 },
                [2]={ 986.205078125, -923.6923828125, 42.65958404541, 5.3186950683594 },
        },
        ["[State] S Ocean docks, Los Santos -> Solarin industries, San Fierro"] = {
                -- x, y, z, rot
                [1]={ 2687.4560546875, -2394.435546875, 14.226403236389, 89.098907470703 },
                [2]={ -1820.525390625, 52.9150390625, 15.714419364929, 359.78021240234 },
        },
        ["[State] N Ocean docks, Los Santos - > Clucki'n Bell Angel pine"] = {
                -- x, y, z, rot
                [1]={ 2473.2021484375, -2094.078125, 14.141147613525, 269.1428527832 },
                [2]={ -2155.953125, -2468.0693359375, 31.187726974487, 233.53846740723 },
        },
        ["[State] N Ocean docks, Los Santos - > Whetstone gas station -> Angel Pine gas station"] = {
                -- x, y, z, rot
                [1]={ 2473.2021484375, -2094.078125, 14.141147613525, 269.1428527832 },
                [2]={ -1618.599609375, -2719.3974609375, 49.103012084961, 52.175811767578 },
                [3]={ -2264.0986328125, -2557.5849609375, 32.674327850342, 149.31869506836 },
        },
        ["[State] Fallen Tree, Red county -> Power tools paradise, Angel pine"] = {
                -- x, y, z, rot
                [1]={ -489.08203125, -521.052734375, 26.108619689941, 0.30767822265625 },
                [2]={ -2193.4853515625, -2437.396484375, 31.556900024414, 51.648345947266 },
        },
        ["[Local] San Fierro Docks -> Easter Basin gas station"] = {
                -- x, y, z, rot
                [1]={ -1745.1455078125, 68.29296875, 4.4865007400513, 359.9560546875 },
                [2]={ -1689.3369140625, 412.5673828125, 7.7712354660034, 135.9560546875 },
        },
        ["[Local] Willowfield, Los Santos -> S Ocean docks, Los Santos"] = {
                -- x, y, z, rot
                [1]={ 2032.7880859375, -1940.099609375, 13.917248725891, 269.84616088867 },
                [2]={ 2687.4560546875, -2394.435546875, 14.226403236389, 89.098907470703 },
        },
        ["[Local] S Ocean docks, Los Santos - > Willowfield Ammu nation, Los Santos"] = {
                -- x, y, z, rot
                [1]={ 2687.4560546875, -2394.435546875, 14.226403236389, 89.098907470703 },
                [2]={ 2370.763671875, -2010.501953125, 14.149662017822, 90.593414306641 },
        },


}
