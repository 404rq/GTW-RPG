--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

members_in_turf = {{ }}									-- Counts the amount of players in each group in each turf
capturing 		= { }									-- Boolean to check whenever someone is trying to capture a specific turf 
cooldown 		= { }									-- Cooldown timer to prevent spam kills for stats farming
time_syncer 	= { }									-- Timers to update the client status text with information about how much time is left to capture a turf
db 				= dbConnect("sqlite", "/turfs.db")		-- Database connection (SQLLite), mysql is supported as well, see syntax for dbConnect here:
														-- https://wiki.multitheftauto.com/wiki/DbConnect
payout_time_interval		= 600						-- Time interval between payments for owned turfs (seconds).
turf_payments_max			= 500						-- Maximum payments for 1 single turf during payouts. Multiplyed by turfs count divided by gangmembers count  
turf_payments_min			= 490						-- Minimum payments for 1 single turf during payouts. (See above)
lowest_amount_to_display 	= 50						-- Specify the lowest amount of money which is worth to notice the players about during payouts.

team_criminals				= "Criminals"				-- Specify teams that are allowed to turf
team_gangsters				= "Gangsters"				-- (See above)

money_pickpocket_max		= 500						-- Specify how much (or less) money the gangmembers will pickpocket from their enemies during a kill inside a turf 
money_pickpocket_min		= 50						-- (See above)
armor_max					= 35						-- The maximum amount of armor the killer will get after killing an enemy
armor_min					= 25						-- The minimum amount of armor the killer will get after killing an enemy
weapon_stats_max			= 35						-- The maximum amount of stats for the current weapon the killer will gain after killing an enemy
weapon_stats_min			= 25						-- The minimum amount of stats for the current weapon the killer will gain after killing an enemy
turf_capture_payment_max 	= 900						-- Maximum payment for capturing a turf
turf_capture_payment_min	= 800						-- Minimum payment for capturing a turf
time_to_capture				= 180 						-- Time before a gang captures a turf (seconds)