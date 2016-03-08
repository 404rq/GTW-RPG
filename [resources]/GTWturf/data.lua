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

members_in_turf 		= {{ }}						-- Counts the amount of players in each group in each turf
capturing 			= { }						-- Boolean to check whenever someone is trying to capture a specific turf
cooldown 			= { }						-- Cooldown timer to prevent spam kills for stats farming
time_syncer 			= { }						-- Timers to update the client status text with information about how much time is left to capture a turf

-- Database connection setup, MySQL or fallback SQLite
local mysql_host    	= exports.GTWcore:getMySQLHost() or nil
local mysql_database 	= exports.GTWcore:getMySQLDatabase() or nil
local mysql_user    	= exports.GTWcore:getMySQLUser() or nil
local mysql_pass    	= exports.GTWcore:getMySQLPass() or nil
db = dbConnect("mysql", "dbname="..mysql_database..";host="..mysql_host, mysql_user, mysql_pass, "autoreconnect=1")
if not db then db = dbConnect("sqlite", "/turfs.db") end

payout_time_interval		= 600						-- Time interval between payments for owned turfs (seconds).
lowest_amount_to_display 	= 50						-- Specify the lowest amount of money which is worth to notice the players about during payouts.

team_criminals			= "Criminals"					-- Specify teams that are allowed to turf
team_gangsters			= "Gangsters"					-- (See above)

money_pickpocket_max		= 500						-- Specify how much (or less) money the gangmembers will pickpocket from their enemies during a kill inside a turf
money_pickpocket_min		= 50						-- (See above)
armor_max			= 35						-- The maximum amount of armor the killer will get after killing an enemy
armor_min			= 25						-- The minimum amount of armor the killer will get after killing an enemy
weapon_stats_max		= 15						-- The maximum amount of stats for the current weapon the killer will gain after killing an enemy
weapon_stats_min		= 5						-- The minimum amount of stats for the current weapon the killer will gain after killing an enemy

time_reduce_factor		= 0.05						-- A value to be multiplied with sizex * sizey of a turf entered to decide how much time it takes to capture it
turf_alpha			= 140						-- The global turf color alpha value
