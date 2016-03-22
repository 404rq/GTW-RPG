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

--[[ Convert between rank key to display name (TODO: convert into table) ]]--
function get_player_rank(player, occupation)
	local acc = getPlayerAccount(player)
	if not acc then return end
	local statValue = ""
	if occupation == "Train Driver" then
		statValue = "GTWdata_stats_train_stops"
	elseif occupation == "Tram Driver" then
		statValue = "GTWdata_stats_tram_stops"
	elseif occupation == "Bus Driver" then
		statValue = "GTWdata_stats_bus_stops"
	elseif occupation == "Taxi Driver" then
		statValue = "GTWdata_stats_taxi_stops"
	elseif occupation == "Pilot" then
		statValue = "GTWdata_stats_pilot_progress"
	elseif occupation == "Criminal" then
		statValue = "GTWdata_stats_wanted_points"
	elseif occupation == "Gangster" then
		statValue = "GTWdata_stats_turf_count"
	elseif occupation == "Farmer" then
		statValue = "GTWdata_stats_plants_harvested"
	elseif occupation == "Trucker" then
		statValue = "GTWdata_stats_trucker_deliveries"
	elseif occupation == "Mechanic" then
		statValue = "GTWdata_stats_repaired_cars"
	elseif occupation == "Police officer" then
		statValue = "GTWdata_stats_police_arrests"
	elseif occupation == "SAPD officer" then
		statValue = "GTWdata_stats_police_arrests"
	elseif occupation == "SWAT officer" then
		statValue = "GTWdata_stats_police_arrests"
	elseif occupation == "FBI officer" then
		statValue = "GTWdata_stats_police_arrests"
	elseif occupation == "ArmedForces" then
		statValue = "GTWdata_stats_police_arrests"
	elseif occupation == "Fireman" then
		statValue = "GTWdata_stats_fireman_fires"
	elseif occupation == "Paramedic" then
		statValue = "GTWdata_stats_medic_heals"
	end
	local rank,nextRank,statNumReq,statNum,statLevel = "","",0,0,0
	if statValue then
		statNum = tonumber(getAccountData(acc, statValue) or 0)
		if level_list[occupation] then
			for w=1, #level_list[occupation] do
				if statNum >= level_list[occupation][w] then
					statLevel = w
					rank = rank_list[occupation][w]
					if rank_list[occupation][w+1] then
						nextRank = rank_list[occupation][w+1]
						statNumReq = level_list[occupation][w+1]
					else
						nextRank = "None";
						statNumReq = level_list[occupation][w] or 0
					end
				end
			end
		end
	end
	return rank,nextRank,statNum,statNumReq,statLevel
end

--[[ Get rank key from occupation key ]]--
function get_rank(occupation)
	local rank,nextRank,statNum,statNumReq,statLevel = get_player_rank(client, occupation)
	triggerClientEvent( client, "onRankReceive", client, rank, nextRank, statNum, statNumReq, statLevel )
end
addEvent( "onAskForPlayerRank", true )
addEventHandler( "onAskForPlayerRank", root, get_rank)

-- List of levels
level_list = {
	["Bus Driver"]={ 0, 25, 50, 90, 150, 240, 360, 480, 600, 800, 1100 },
	["Criminal"]={ 0, 200, 500, 1000, 2000, 5000, 12000, 25000, 55000, 140000, 350000, 2000000, 10000000 },	
	["Farmer"]={ 0, 500, 1200, 2000, 3000, 4500, 7000, 10000, 20000, 40000, 100000 },
	["Mechanic"]={ 0, 7, 18, 40, 60, 90, 140, 200, 280, 400, 500 },
	["Pilot"]={ 0, 20, 50, 90, 150, 220, 290, 400, 530, 680, 900 },	
	["Train Driver"]={ 0, 15, 35, 70, 120, 180, 250, 360, 480, 600, 800 },
	["Tram Driver"]={ 0, 20, 50, 90, 150, 220, 300, 400, 550, 700, 1000 },
	["Taxi Driver"]={ 0, 20, 50, 90, 150, 220, 290, 400, 530, 680, 900 },
	["Trucker"]={ 0, 7, 20, 40, 65, 100, 170, 300, 500, 750, 1100 },
	["Unemployed"]={ 0 },
	
	-- Emergency services
	["Fireman"]={ 0, 50, 150, 300, 500, 800, 1300, 2000, 3000 },
	["Paramedic"]={ 0, 5, 11, 20, 34, 50, 70, 100, 150, 220, 400 },
	
	-- LAW jobs
	["Police officer"]={ 0, 5, 10, 20, 40, 80, 160, 320, 640, 1280, 2480 },
	["SAPD officer"]={ 0, 5, 10, 20, 40, 80, 160, 320, 640, 1280, 2480 },
	["FBI officer"]={ 0, 5, 10, 20, 40, 80, 160, 320, 640, 1280, 2480 },
	["SWAT officer"]={ 0, 5, 10, 20, 40, 80, 160, 320, 640, 1280, 2480 },
	["ArmedForces"]={ 0, 5, 10, 20, 40, 80, 160, 320, 640, 1280, 2480 },
}

-- List of ranks corrensponding to levels above
rank_list = {
	["Bus Driver"]={ "New driver", "Ticket salesman", "Announcer", "Master announcer", "Regular driver", "Professional driver", "Expert driver", "King of the road", "Chief of San Fierro bus company", "Chief of Las Venturas bus company", "Chief of Los Santos bus company", "Head chief of bus company" },
	["Criminal"]={ "Small thief", "Pick pocketer", "Car thief", "Local store robber", "Bank robber", "Professional thief", "Gang banger", "Murder", "Hitman", "Mafia member", "Local mafia boss", "Godfather", "Grand Theft Walrus" },
	["Farmer"]={ "Cowboy", "Tractor operator", "Harvester operator", "Small farmer", "Medium farmer", "Large farmer", "Industrial farmer", "Chief of the farm", "Farm owner" },
	["Mechanic"]={ "Junior assistant", "Assistant", "New mechanic", "Regular mechanic", "Proffessional mechanic", "Expert mechanic", "Assistant manager", "Manager", "Chief manager", "God of broken cars" },
	["Pilot"]={ "Beginner", "Second pilot", "Small aircraft pilot", "Medium aircraft pilot", "Large aircraft pilot", "Flight engineer", "Flight instructor", "Flight superintendent", "King of the air" },
	["Train Driver"]={ "Student driver", "Boilerman", "Master boilerman", "Conductor", "Master conductor", "Railroad Engineer", "Locomotive Engineer", "Locomotive Superintendent", "Mechanical Engineer", "Chief Mechanical Engineer", "God of trains" },
	["Tram Driver"]={ "Trial driver", "Cleaner", "Master cleaner", "Conductor", "Master conductor", "Engineer", "Locomotive Engineer", "Locomotive Superintendent", "Mechanical Engineer", "Chief Mechanical Engineer", "God of tram" },
	["Taxi Driver"]={ "Practice driver", "Taxi driver", "Cabbie driver", "Regular driver", "Professional driver", "Expert driver", "King of the taxi league", "Chief of taxi company", "God of taxi" },
	["Trucker"]={ "New driver", "Delivery man", "Light load trucker", "Medium load trucker", "Heavy load trucker", "Special transporter", "Professional driver", "Expert driver", "Epic professional driver", "Chief of transport", "God of transport" },
	["Unemployed"]={ "Unemployed" },
	
	-- Emergency services
	["Fireman"]={ "Assistant fireman", "Extinguesher supplier", "Trial fireman", "Regular fireman", "Fire truck driver", "Expert fireman", "Fire engineer", "Master fire engineer", "Chief of firestation", "God of fires" },
	["Paramedic"]={ "Junior assistant medic", "Assistant medic", "New medic", "Regular medic", "Professional medic", "Proffesional healer", "Expert healer", "God of hospital", "Jesus christ" },
	
	-- LAW jobs
	["Police officer"]={ "Office assistant", "Office worker", "Trial officer", "Patrolling officer", "Radio car unit", "Traffic officer", "Highway patrol", "Alpha unit", "Special tactics team", "God of law" },
	["SAPD officer"]={ "Office assistant", "Office worker", "Trial officer", "Patrolling officer", "Radio car unit", "Traffic officer", "Highway patrol", "Alpha unit", "Special tactics team", "God of law" },
	["FBI officer"]={ "Office assistant", "Office worker", "Trial officer", "Patrolling officer", "Radio car unit", "Traffic officer", "Highway patrol", "Alpha unit", "Special tactics team", "God of law" },
	["SWAT officer"]={ "Office assistant", "Office worker", "Trial officer", "Patrolling officer", "Radio car unit", "Traffic officer", "Highway patrol", "Alpha unit", "Special tactics team", "God of law" },
	["ArmedForces"]={ "Office assistant", "Office worker", "Trial officer", "Patrolling officer", "Radio car unit", "Traffic officer", "Highway patrol", "Alpha unit", "Special tactics team", "God of law" },
}
