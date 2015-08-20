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

-- Global data
fisher_timer = nil
fish_market_time = math.random(10000,30000)

-- Fish data
fish_last_pos = {{ }}
fish_data = {
	-- name, money
	[1]={ "an Aligatorfish", 16 },
	[2]={ "a Asian carp", 7 },
	[3]={ "a Bandfish", 11 },
	[4]={ "a Blue shark", 23 },
	[5]={ "a Salmon", 45 },
	[6]={ "a Norwegian Salmon", 67 },
	[7]={ "a Pike", 23 },
	[8]={ "a Perch", 24 },
	[9]={ "a Black fish", 8 },
	[10]={ "a Goldfish", 21 },
	[11]={ "a Cat fish", 12 },
	[12]={ "a Cow shark", 23 },
	[13]={ "a Crestfish", 26 },
	[14]={ "a Plaize", 14 },
	[15]={ "a Coolie loach", 32 },
	[16]={ "a Swedish Surströmming", 25 },
	[17]={ "a Cobbler", 34 },
	[18]={ "a Coffinfish", 17 },
	[19]={ "a Dwarf gourami", 30 },
	[20]={ "a Elver", 7 },
	[21]={ "a Elephantnose fish", 23 },
	[22]={ "a bag of weed", 156 },
	[23]={ "a Eucla cod", 19 },
	[24]={ "a Electric Eel", 23 },
	[25]={ "a Emperior", 14 },
	[26]={ "a Escolar", 14 },
	[27]={ "a Elephant fish", 57 },
	[28]={ "an anchor", 3 },
	[29]={ "a Fire Goby", 29 },
	[30]={ "a Four-eyed fish", 43 },
	[31]={ "a Football fish", 31 },
	[32]={ "a Frog fish", 4 },
	[33]={ "a Frog", 75 },
	[34]={ "a fish that has already been eaten", 1 },
	[35]={ "a Frilled shark", 24 },
	[36]={ "a French angel fish", 28 },
	[37]={ "a Ground shark", 39 },
	[38]={ "a Guppy", 4 },
	[39]={ "a Gunnel", 21 },
	[40]={ "a Goose fish", 33 },
	[41]={ "a Golden throuth", 33 },
	[42]={ "a bag of money", 42 },
	[43]={ "a Ice fish", 21 },
	[44]={ "a Horse fish", 22 },
	[45]={ "a Hoki", 65 },
	[46]={ "a Harelip sucker", 30 },
	[47]={ "a Hairtail", 20 },
	[48]={ "a Inconnu", 13 },
	[49]={ "a Jewelfish", 91 },
	[50]={ "a Knife fish", 34 },
	[51]={ "a Ide", 17 },
	[52]={ "a Killfish", 55 },
	[53]={ "a Koi", 15 },
	[54]={ "a Kokanee", 37 },
	[55]={ "a piece of the lost city Atlantis", 99 },
	[56]={ "a Japanese eel", 32 },
	[57]={ "a IKEA chair", 42 },
	[58]={ "a Lake chub", 27 },
	[59]={ "a Luderick", 33 },
	[60]={ "a Louvar", 21 },
	[61]={ "a Longfin", 22 },
	[62]={ "a Labyrinth fish", 11 },
	[63]={ "a clam", 13 },
	[64]={ "a broken clam", 2 },
	[65]={ "a Long-finned pike", 28 },
	[66]={ "something you didn't liked and threw back", 0 },
	[67]={ "Lyretail", 33 },
	[68]={ "a crab", 16 },
	[69]={ "a Murray cod", 6 },
	[70]={ "a Mud minnow", 8 },
	[71]={ "a Mrigal", 3 },
	[72]={ "a rock with the text \"Billy was here\"", 14 },
	[73]={ "a Mud cat fish", 7 },
	[74]={ "a Mullet", 5 },
	[75]={ "the book \"nicke curious and the shark\"", 7 },
	[76]={ "a shark", 1 },
	[77]={ "a Milk fish", 9 },
	[78]={ "the bottle of vodka you lost the last time you where here", 0 },
	[79]={ "Mahseer", 12 },
	[80]={ "a Monkfish", 25 },
	[81]={ "a human hand", 3 },
	[82]={ "a Nurse shark", 32 },
	[83]={ "an eel", 3 },
	[84]={ "a piraya", 7 },
	[85]={ "a North american darter", 21 },
	[86]={ "a Nibble fish", 22 },
	[87]={ "a Noodlefish", 18 },
	[88]={ "a North american freshwater catfish", 36 },
	[89]={ "a Oregon chub", 28 },
	[90]={ "a Opah", 27 },
	[91]={ "a Pink salmon", 123 },
	[92]={ "a Porgy", 14 },
	[93]={ "a Ponyfish", 18 },
	[94]={ "a Oscar fish", 11 },
	[95]={ "a Powen", 10 },
	[96]={ "a Pacific cod", 20 },
	[97]={ "a Pilot fish", 21 },
	[98]={ "a Pygmy sunfish", 17 },
	[99]={ "a Prickly shark", 32 },
	[100]={ "a River shark", 23 },
}

-- Handle fishing
function fishing_get()
	local fishers = getElementsByType( "player" )
	for k,fisher in pairs(fishers) do
		if getPedContactElement( fisher ) and isElement( getPedContactElement( fisher )) and
			getElementType( getPedContactElement( fisher )) == "vehicle" and
			getVehicleType( getPedContactElement( fisher )) == "Boat" and
			getPlayerTeam( fisher ) == getTeamFromName( "Civilians" ) and
			getElementData( fisher, "Occupation" ) == "Fisher" then
			-- Verify position
			if not fish_last_pos[fisher] then
				fish_last_pos[fisher] = { }
				fish_last_pos[fisher][1],fish_last_pos[fisher][2],fish_last_pos[fisher][3] = 0,0,0
			end
			local x,y,z = getElementPosition( fisher )
			local dist = getDistanceBetweenPoints3D( x,y,z, fish_last_pos[fisher][1],fish_last_pos[fisher][2],fish_last_pos[fisher][3] )
			fish_last_pos[fisher][1],fish_last_pos[fisher][2],fish_last_pos[fisher][3] = x,y,z

			-- Check distance before payment
			if dist > 0.1 then
				-- This player is a fisher
				local ID = math.random(#fish_data)
				exports.GTWtopbar:dm( "You found "..fish_data[ID][1]..", worth "..fish_data[ID][2].."$", fisher, 0, 255, 0 )
				givePlayerMoney( fisher, fish_data[ID][2] )
			end
		end
	end
end

-- Generates a new time
function new_timer()
	if isTimer( fisher_timer ) then
		killTimer( fisher_timer )
	end
	fish_market = math.random(10000,30000)
	fisher_timer = setTimer( fishing_get, fish_market, 0 )
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

function fish_market( player )
	if fish_market_time < 14000 then
		outputChatBox( "The fish population is excellent now, hurry up, go fishing!", player, 200, 200, 200 )
	elseif fish_market_time < 18000 then
		outputChatBox( "The fish are biting good now", player, 200, 200, 200 )
	elseif fish_market_time < 24000 then
		outputChatBox( "Fish market could have been worse but you might have some luck!", player, 200, 200, 200 )
	else
		outputChatBox( "You need a lot of fishing luck if you think you can get anything right now", player, 200, 200, 200 )
	end
end
addCommandHandler( "fishmarket", fish_market )

-- Set global timers
fisher_timer = setTimer( fishing_get, fish_market_time, 0 )
setTimer( new_timer, 3600000, 0 )
