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

--[[
	BELOW INFORMATION ARE PROPERTY OF GRAND THEFT WALRUS RPG,
	IT'S SHARED HERE JUST TO SHOW THE LAYOUT STRUCTURE OF THE
	TABLE AND SHOULD NOT BE USED DIRECTLY IN OTHER SERVERS.

	ALSO NOTE THAT THIS IS JUST THE JOB INFORMATION TO ASSIGN
	TO A PLAYER AND NOT THE ACTUAL JOB FUNCTIONALITY. JOB
	TEMPLATES INCLUDED IN THIS PROJECT MAY BE USED IN THEIR
	CURRENT SHAPE, THIS INCLUDES FARMER AND FISHER.
]]--

work_items = {
	-- Index: Name, Team, MaxWl, Description, Skins (Table)
	["Bus Driver"]={ "Civilians", 1, [[
As a busdriver you need to get a bus or coach
to start your route, you can use your own or
rent one from the nearby vehicle spawn marker.

You will get paid around $70/stop multiplied
by your current level, (see F5 to find out
about your level). You will also gain $5/minute
for every passenger you pickup.

Weapons:
- Desert eagle (5x)
- Baseball bat
	]], { -1, 60, 171, 172, 194, 253, 255 },
	{ "default", "Chinese casual dressed man", "White well dressed man", "White well dressed girl (blonde)", "White well dressed girl (brunette)", "Black man with uniform", "White man with mustache" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {24, 35, 500, "Desert eagle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the bus driver job!, get a bus or coach to start your work"},
	["Train Driver"]={ "Civilians", 0, [[
Drive your train around the tracks, slow down
to below 5km/h to stop at the station and get
paid, do not drive to fast (64km/h in the city
or 100km/h country side), or you may derail and
get fired within a second.

Get a Streak or Freight train from the nearby
spawner, Streak is a passenger train and Freight
a freight train obviously. The amount of cars
can be chosed, more cars make your train slower
but you earn more money, a maximum limit are set
and depends on your rank.

You will get paid around $250/station multiplied
by your current level, (see F5 to find out about
your level). You will also gain $20/minute for
every passenger you pickup.

Weapons:
- Desert eagle (3x)
- Baseball bat
	]], { -1, 60, 171, 172, 194, 253, 255 },
	{ "default", "Chinese casual dressed man", "White well dressed man", "White well dressed girl (blonde)", "White well dressed girl (brunette)", "Black man with uniform", "White man with mustache" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {24, 21, 300, "Desert eagle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the train driver job!, get a streak or freight to start your work"},
	["Taxi Driver"]={ "Civilians", 2, [[
In this job you need a taxi, cabbie or limousine.
Get it from a nearby spawner or use your own
vehicle. Pickup up and drop of passengers at
given destination.

You will get paid up to $500/job within the same
city and up to $1100/job for cross city deliveries.
You will also gain $30/minute for every passenger
you pickup.

Weapons:
- Pistol (4x)
- Knife
	]], { -1, 9, 14, 41, 44, 60, 72 },
	{ "default", "Casual African girl", "Casual african man", "Casual latino girl", "Casual latino man", "Chinese casual dressed man", "White casual dressed man" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {22, 68, 200, "Pistol"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the taxi driver job!, get a taxi or cabbie to start your work"},
	["Trucker"]={ "Civilians", 1, [[
Rent or use your own truck or semi truck, in this
job you will deliver cargo around San Andreas.
Experienced truckers can choose a mission with
two trailers attached.

You will get paid up to $1800/job multiplied by your
current level, (see F5 to find out about your level).
Your payment depends on distance, your rank and the
weigth of your cargo.

Weapons:
- Desert eagle (2x)
- Baseball bat
	]], { -1, 31, 112, 133, 172, 194, 198, 202 },
	{ "default", "White country girl", "Russian trucker", "Trucker with red hat", "White well dressed girl (blonde)", "White well dressed girl (brunette)", "Trucker girl", "Beer trucker" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {24, 14, 200, "Desert eagle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the trucker job!, get a truck to start your work"},
	["Pilot"]={ "Civilians", 0, [[
Rent or use your own airplane or helicopter, in
this job you will fly passengers or cargo around
San Andreas. Large aircraft are limited to
experienced pilots.

You will get paid up to $1500/job
You will also gain $80/minute for every passenger
you pickup.

Weapons:
- Pistol (3x)
- Nightstick
	]], { -1, 61, 71 },
	{ "default", "Pilot (official)", "Security guard" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {22, 51, 200, "Pistol"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the pilot job!, get a plane or helicopter to start your work"},
	["Mechanic"]={ "Civilians", 4, [[
Respond to calls and repair players broken
vehicles or refuel vehicles that has been
running out of fuel.

You will get up to $750/repair and $500/refuel
(You can use a weapon to threat your customers
to pay more if you want, note that you may get
wanted for that).

Weapons:
- AK-47 (4x)
- Baseball bat
	]], { 50, 268, 305, 309 },
	{ "Mechanic (official)", "Dwaine", "Jethro", "Janitor" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {30, 30, 700, "AK-47"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the mechanic job!, press X and click on a damaged vehicle to fix or refuel"},
	["Fisher"]={ "Civilians", 5, [[
You need to own a boat to perform this job, get
a boat, take the job then start fishing, easy
huh. You may use your shotgun to keep other
fishers away but remember to keep an eye of
nearby law units as it's illegal ;)

You will get up to $100/fish
Your payment may be better or worse depending
on how often the fish bites, this changes over
time and you can see the current status by doing
/fishmarket at any time.

Weapons:
- Shotgun (x20 bullets)
- Golf club
	]], { -1 },
	{ "default" },
	--[[WeaponID, amount, price, name]]
	{{2, 1, 60, "Golf club"}, {25, 20, 1400, "Shotgun"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the fisher job!, enter a boat and wait to start catching fish"},
	["Farmer"]={ "Civilians", 5, [[
You need a tractor and a harvester to do this job
either your own or barrow one from your friend.
Use the tractor to plant seeds anywhere on the map,
let it grow and then you can use a harvester to
make balls out of the plants, pick up the balls to
get paid.

Note that other farmers may steal your plants so
pick a good spot and don't plant to much unless you
have full control over your fields, you can kill
thiefs with just 25% of the wanted level if you
use a country rifle.

You will get up to $600/plant - ($100 for the seed)
This is all about timing, if youre not fast enough
your crops may rotten, other players may steal your
bales etc.. smart planning is the key of success.

Weapons:
- Country rifle (x30 bullets)
- Desert eagle (x7)
- Baseball bat
	]], { -1, 157, 158, 159, 160, 161, 162 },
	{ "default", "Hillbilly girl", "Farmer man", "Hillbilly boy", "Farmer man (old)", "Farmer (official)", "Hillbilly (probably inbred)" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {24, 49, 700, "Desert eagle"}, {33, 30, 3200, "Country rifle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the farmer job!, get a tractor and press N to buy and plant seeds"},
	["Tram Driver"]={ "Civilians", 1, [[
Drive your tram around the tracks in San Fierro,
slow down to below 5km/h to stop at the station
and get paid, do not drive to fast (64km/h) or
you may derail and get fired within a second.

Get a tram from nearby spawner or use your own
then drive your route.

You will get paid around $130/station multiplied
by your current level, (see F5 to find out about
your level). You will also gain $15/minute for
every passenger you pickup.

Weapons:
- Desert eagle (4x)
- Baseball bat
	]], { -1, 60, 171, 172, 194, 253, 255 },
	{ "default", "Chinese casual dressed man", "White well dressed man", "White well dressed girl (blonde)", "White well dressed girl (brunette)", "Black man with uniform", "White man with mustache" },
	--[[WeaponID, amount, price, name]]
	{{5, 1, 40, "Baseball bat"}, {24, 28, 400, "Desert eagle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the tram driver job!, get a tram to start your work"},
	["Fireman"]={ "Emergency service", 0, [[
Wait for a fire to start, (whenever a vehicle
explode) then go these as fast as you can to put
the fire out. You can use your firetruck's water
canon or a fire extinguesher (better payment).

You will get paid up to $3000/job, (require you
to work hard all the time). You can make more by
helping the police if you for example block the
suspect with your water canon etc.

Weapons:
- Fire extingusher
	]], { 277, 278, 279 },
	{ "LSFD worker", "LVFD worker", "SFFD worker" },
	--[[WeaponID, amount, price, name]]
	{{42, 5000, 300, "Fire extinguesher"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the fireman job!, look for any reported vehicle fire then go to that location"},
	["Paramedic"]={ "Emergency service", 0, [[
Find hurted players and heal them with your spray
can, you can also let them enter your ambulance to
let them hel, (requires you to be inside).

You will get paid up to $500/heal. Thankful players
may give you a bonus reward to thank you.

Weapons:
- Spray can
	]], { 274, 275, 276 },
	{ "Black doctor", "Latino doctor", "White doctor" },
	--[[WeaponID, amount, price, name]]
	{{41, 500, 200, "Healing spray"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the paramedic job!, heal players with your spray or take them to the hospital in your ambulance"},
	["Iron miner"]={ "Civilians", 3, [[
Go down to the quarry outside Las Venturas and dig
for minerals, rocks containing minerasl are seen by
a semi invisible marker, walk up to it and wait for
digging then you get minerals. Sell your minerals
at the nerby factory when your pocket are full.

You will get paid up to $4000/fully loaded truck.

Weapons:
- Desert eagle (x5)
- Baseball bat
	]], { -1, 27, 153, 260 },
	{ "default", "White iron miner", "The foreman", "Black iron miner" },
	--[[WeaponID, amount, price, name]]
	{{6, 1, 60, "Shovel"}, {24, 35, 500, "Desert eagle"}},
	--[[Message for new players when applying for the job]]
	"Welcome to the iron miner job!, press N to deploy dynamite, take cover and then mine by walking up to the rocks"},
	["Police Officer"]={ "Government", 0, [[
Type /wanted to find out who's wanted, then hunt the
wanted people down and arrest them, the higher wanted
level the more payment, alive suspects are worth more
so avoid killing unless you have to.

Prison guard
A side mission for the police job is to become a
prison guard, to to the prison at bayside marina
and kill anyone trying to escape or anyone trying
to help someone to escape. You get paid per kill.

Weapons:
- Tazer (silenced) (x8)
- Teargas (x10)
- Nightstick
	]], { 280, 281, 282, 283, 288, 284 },
	{ "Los Santos police", "San Fierro police", "Las Venturas police", "Highway patrol (Bone county)", "Highway patrol (Red county)", "Traffic officer" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {23, 150, 200, "Tazer"}, {29, 30, 400, "MP5 (driveby)"}, {31, 50, 650, "M4 (heavy)"}, {17, 1, 100, "Teargas"}, {46, 1, 300, "Parachute"}},
	--[[Message for new players when applying for the job]]
	"Welcome to police job!, Hit wanted players with your nightstick to arrest"},
	["SAPD Officer"]={ "Government", 0, [[
Type /wanted to find out who's wanted, then hunt the
wanted people down and arrest them, the higher wanted
level the more payment, alive suspects are worth more
so avoid killing unless you have to.

Prison guard
A side mission for the police job is to become a
prison guard, to to the prison at bayside marina
and kill anyone trying to escape or anyone trying
to help someone to escape. You get paid per kill.

Weapons:
- Tazer (silenced) (x8)
- Teargas (x10)
- Nightstick
	]], { 283, 288 },
	{ "Highway patrol (Bone county)", "Highway patrol (Red county)" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {23, 150, 200, "Tazer"}, {29, 30, 400, "MP5 (driveby)"}, {31, 50, 650, "M4 (heavy)"}, {17, 1, 100, "Teargas"}, {46, 1, 300, "Parachute"}},
	--[[Message for new players when applying for the job]]
	"Welcome to police job!, Hit wanted players with your nightstick to arrest"},
	["FBI agent"]={ "Government", 0, [[
Type /wanted to find out who's wanted, then hunt the
wanted people down and arrest them, the higher wanted
level the more payment, alive suspects are worth more
so avoid killing unless you have to.

Prison guard
A side mission for the police job is to become a
prison guard, to to the prison at bayside marina
and kill anyone trying to escape or anyone trying
to help someone to escape. You get paid per kill.

Weapons:
- Tazer (silenced) (x8)
- Teargas (x10)
- Nightstick
	]], { 165, 166, 286, 295 },
	{ "Agent Jay", "Agent Kay", "FBI officer", "Mike" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {23, 150, 200, "Tazer"}, {29, 30, 400, "MP5 (driveby)"}, {31, 50, 650, "M4 (heavy)"}, {17, 1, 100, "Teargas"}, {46, 1, 300, "Parachute"}},
	--[[Message for new players when applying for the job]]
	"Welcome to police job!, Hit wanted players with your nightstick to arrest"},
	["SWAT Officer"]={ "Government", 0, [[
Type /wanted to find out who's wanted, then hunt the
wanted people down and arrest them, the higher wanted
level the more payment, alive suspects are worth more
so avoid killing unless you have to.

Prison guard
A side mission for the police job is to become a
prison guard, to to the prison at bayside marina
and kill anyone trying to escape or anyone trying
to help someone to escape. You get paid per kill.

Weapons:
- Tazer (silenced) (x8)
- Teargas (x10)
- Nightstick
	]], { 285 },
	{ "SWAT officer" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {23, 150, 200, "Tazer"}, {29, 30, 400, "MP5 (driveby)"}, {31, 50, 650, "M4 (heavy)"}, {17, 1, 100, "Teargas"}, {46, 1, 300, "Parachute"}},
	--[[Message for new players when applying for the job]]
	"Welcome to police job!, Hit wanted players with your nightstick to arrest"},
	["Armed Forces"]={ "Government", 0, [[
Type /wanted to find out who's wanted, then hunt the
wanted people down and arrest them, the higher wanted
level the more payment, alive suspects are worth more
so avoid killing unless you have to.

Prison guard
A side mission for the police job is to become a
prison guard, to to the prison at bayside marina
and kill anyone trying to escape or anyone trying
to help someone to escape. You get paid per kill.

Weapons:
- Tazer (silenced) (x8)
- Teargas (x10)
- Nightstick
	]], { 287 },
	{ "Soldier" },
	--[[WeaponID, amount, price, name]]
	{{3, 1, 0, "Nightstick"}, {23, 150, 200, "Tazer"}, {29, 30, 400, "MP5 (driveby)"}, {31, 50, 650, "M4 (heavy)"}, {17, 1, 100, "Teargas"}, {46, 1, 300, "Parachute"}},
	--[[Message for new players when applying for the job]]
	"Welcome to police job!, Hit wanted players with your nightstick to arrest"}
}

-- Restrict jobs to specific groups
restricted_jobs = {
	["FBI agent"]="FBI",
	["SWAT Officer"]="SWAT",
	["SAPD Officer"]="SAPD",
	["Armed Forces"]="ArmedForces"
}

markers = { }
