--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

--[[ All help related text is in this file ]]--
list = {
	{ "General", 0 },
	{ "Server rules", 1, [[
********************************************************************
Rules in English
********************************************************************

#1 Do not spawn kill other players. (Applies around hospitals)
#2 Drive on the right side of the road. Do not block other 
    players, do not crash into other players unless you have 
    a reason to do so, e.g in a police chase or to revenge.
#3 Do not use any kind of hack or exploit bugs. GTW-RPG is an 
    open source game mode which we claim to be stable and of 
    high quality, it's therefore important to let us know about 
    any bug you may find. Bug reports are rewardable, exploits 
    are punishable.
#4 Do not advertise, feel free to talk about anything as long 
    you're not advertising it. If you don't get the difference 
    here's an example: Talking: xBox vs PS3... Advertising: 
    buy xBox here...
#5 Do not obstruct or interrupt role play situations. It's not 
    appropriate to show up with a minigun and kill a group of 
    players standing together chatting for instance, do not use 
    more violence than the situation require.
#6 Do not spam the chats, repeating nonsense on purpose will lead 
    to a mute, note that this mute are global and applies to many 
    other servers running GTW-RPG resources as well.
#7 Do NOT try this in gmae: apply for staff, suggest new features,
    complaint on other players or staff, ask about stuff you'll 
    find information about in the list to the left. This is not 
    punishable but you may not get the response you expected.
#8 Do not actively troll, provoke, annoy or insult other players. 
    Instead, solve your conflicts here:
    Report: http://forum.albonius.com/complaints-and-reports/complaints-rules-and-guidelines-357/
    Appeal: http://forum.albonius.com/complaints-and-reports/complaints-appeal-your-punishment-356/

Thank you for complying with our rules.

********************************************************************
Last edit:	2015-01-28
********************************************************************]] },
	{ "About GTW Games", 1, [[
********************************************************************
About GTW Games
********************************************************************

Welcome to GTW RPG 2.2-beta, a server in the GTW Games organization.

GTW Games is an independent organization running multiple 
game servers in many different online games such as Multi
Theft Auto, Minecraft, Conuter strike and Call of Duty.

We beleive in democracy and freedom of speech and because 
of that wi have a very small amount of rules in our servers,
you are free to do whatever you want as long you have fun 
and doesn't harm our servers in any way by exploiting bugs 
for example. More information will be found on our webpage.

********************************************************************
General information:
********************************************************************

Game mode:            
    Grand Theft Walrus | games.albonius.com
Website:     
    http://games.albonius.com
Location:                    
    Karlstad - Sweden
Languages:               
    English in global chats
Owners:                         
    Grand Theft Walrus community
Admins:                
    MrBrutus & The_Walrus @ GTW Games

********************************************************************
Last edit:	2015-01-28
********************************************************************
]] },
	{ "Accounts", 1, [[
********************************************************************
About user accounts
********************************************************************

If you want your progress to be saved you need to register a 
user account, this can be done when you are joining the server 
via a easy to use GUI or by commands. During register you can 
also give a reward to a friend of your who invited you, if 
that person is a player here. Simple enter the account name 
of that player and he'll get rewarded, you can also make money 
yourself by inviting more people to the server.

How to change password:
  * Press F8 to open your console, then enter:
  
  chgmypass <oldpass> <newpass>
  
How to change nick name:
  * Press F8 to open your console, then enter:
  
  nick <new-nick>
  
Note that these commands are built in and works on any server.
]]},
	{ "Staff guidelines", 1, [[
********************************************************************
Staff guidelines (only relevant to server staff)
********************************************************************

You can enter the staff mode at any time you would like to do 
your staff duty by using the command /gostaff (or /gostafff 
for female skin). This mode makes you invincible and are 
strictly forbidden to use during game play.

Staff panel are located at F7 and are used at your own risk,
we do not make refunds in case it has bugs which makes you 
lose anything when it's used the wrong way or overused.

Abusing the staff panel will lead to a kick without warning, 
with abusing means using it to gain advantages over other 
players or by giving another player free weapons or tools.

NOTE: For previous staff, you do not need to apply again, 
just send a PM to MrBrutus in the forum with your account 
name to get added again, this is a security check to prevent 
old staff account names from being exploited.

NOTE2: Use built in features in the first case, vehicles must 
be spawned using /gv, otherwise it's your responibly to clean 
up since vehicles from the staff panel won't be removed 
automatically and may cause lag if overused.

NOTE3: Warp using staff panel may still cause you to loose your 
weapons so use /setpos x y z for safely warps anywhere on the 
map or warp to player. Never warp a player to you, alwasy warp 
to the player if you are gonna warp.

NOTE4: [GTW] Tags are not required, when youre in the staff 
team "Government" you're a staff, otherwise youre a regular player 
with some extra basic advantages.

NOTE5: Vehicles spawned from /gv are only for transportation of 
staff members, the rental cost are free and they are therefore 
strictly forbidden to use while working, exceptions are if youre 
testing a bug or can prove that youre doing it as a staff.
]]},
	{ "How to prevent FPS lag", 1, [[
:: Improve FPS and reduce lag ::
A collection of commands to increase your FPS and lower your ping 
at a cost of a little bit lower graphics, try and see what's best 
for you.

/reflect    # Toggle reflection on vehicles
/detail     # Toggle details shader that makes everything look more elegant.
/water      # Toggle water shader

You can't change the weather as it's based on location, the weather 
won't make you lag which you can see on your FPS meter at top right
on your screen, the roads may get slippery when it rains tho and 
acceleration may be slower when you drive.
]]},
	{ "FAQ", 1, [[
********************************************************************
Frequently asked questions
********************************************************************

Q: What is GTW Games?
A: GTW Games is an independent non profit organization hosted by 
   A.corp since 2013, read more on our website:
   http://games.albonius.com.
   
Q: What does AC and GTW stands for?
A: GTW - Grand Theft Walrus, our current name
   AC - Artic community, our previous name.
   
Q: What kind of server is this?
A: This is our RPG server which has support for multiple gamemodes
   you choose by yourself how you want to play, we have CnR events
   which also includes a stealth based law and criminal system. 
   Gangwars with turfs and a whole bunch of roleplay features that 
   makes everything more realistic, you may use /me and /do for 
   roleplay but we do support more than that, call it ARPG - 
   (Action role play game).
   
Q: How can I become staff?
A: By writing a small application in our forum: 
   http://forum.albonius.com and wait for enough people to vote 
   for you.
   
Q: What's your uptime?
A: 99.7% in our first year, we're a self hosted community without 
   charges and servers at many locations, our game mode is also 
   open source just like the associated data, that means our 
   server will always be available, even if GTW dies. 
   
Q: How do I donate?
A: Visit our website: http://games.albonius.com and choose an 
   option to the right, you can use either PayPal or ZayPay SMS 
   donations currently.
   
Q: My question wasn't answered here, what should I do?
A: Ask your question here: 
   http://forum.albonius.com/questions-and-concerns/
]]},
	{ "Vehicles", 0 },
	{ "Vehicle rental", 1, [[
The smaller square blips on your radar indicates a place where 
you can rent a vehicle, either for work or casual driving. The
color shows the difference, white means casual driving and 
anyone will be able to rent a vehicle there, these are often 
located nearby gas stations and busy areas in general like 
hospitals, police departments etc..

Other colors like yellow, light blue or gray indicates job 
vehicles, that means you must be employed in the required job 
in order to use them, those markers are always located close 
to the job site itself so you can't miss them.

The rental cost works like a pledge, you pay a relatively 
expensive price to rent the car but don't worry, if the car 
is in good shape when you return it you'll get most of the 
money back. The most expensive vehicles are trains and large 
aircraft which may get as high as 1000$, as long you drive 
carefully it's a cheap price.]] },
	{ "Vehicle shops", 1, [[
Of course a better option than crappy rental vehicles is to 
buy your own vehicle, there are plenty of vehicle shops 
areound the map often marked with a car, bike, boat, airplane 
or train icon. All available vehicles can be bought and managed 
in the vehicle GUI which is appears when you press 'F2'

Owned vehicles are personal and can be shown/hidden as you wish
You can have multiple vehicles visible at the same time in case 
you want to let a friend drive one of your vehicles, you don't 
have to worry about blownup vehicles either, they're just broken 
until you pay for a recovery or call a mechanic to fix them which 
is 80% cheaper than recovery.]] },
	{ "Vehicle commands", 1, [[
Here's a list of the available commands related to vehicles:
-- Gearbox:
/drive     # Switch to the 'drive' gear witch saves fuel but makes 
             your car slower
/sport     # Default vehicle handling, this is a blanaced option
/race      # Switch to the 'race' gear which consumes a lot of fuel 
             but let's you accelerate really fast, this will have 
             more effect on expensive sports cars used for streat 
             races for example.
           
/gearup    # Next gear above current
/geardown  # Previous gear below current
/nextgear  # Toggle next gear, goes back to the first gear when the 
             end of the list is reached.
 
-- Door control 
/cd\[0-6\] # Close all vehicle doors or an individual door from inside
/od\[0-6\] # Opens all vehicle doors or an individual door from inside

-- Turn indicators
/warn      # Toggle hazard lights
/lleft     # Toogle turn indicator to left
/lright    # Toggle turn indicator to right

-- Misc
/engine    # Start/stop the vehicle engine
/lock      # Lock/unlock the doors of your vehicle
/emlight   # Toggle emergency lights, works on Police vehicles, 
             Firetrucks, and ambulances, a great way to get 
             attention in emergency situations when you need 
             a clear road.

-- Rental vehicles
/djv 
or 
/rrv       # Returns a rental vehicle

-- Keybinds
Key: 'C'   # Toggle crusing control
Key: 'L'   # Toggle headlights
Key: 'H'   # Horn and will also be able to toggle emergency lights
]] },
	{ "Civilians", 0 },
	{ "Bus driver", 1, [[********************************************************************
Bus driver:
********************************************************************
 You can become a busdriver at Unity station in Los Santos or 
 at pier 69 in San Fierro, after taking this job you will gain 
 access to the yellow marker nearby which is a vehicle spawner
 in where you can get a bus or a coach as jobvehicle.
 
 After entering your bus you'll have to select a route, it's 
 recomended to pick one nearby so you don't have to drive too 
 long to the first stop, you will be paid every time you hit 
 a busstop and money will be removed if your vus are damaged.
 
 Other players can call for you by using the command /bus, you 
 will then be able to see them marked with a blip on your map.
 Transporting other players is also a great way to make money 
 in this job. You may also buy your own bus to use in this job.]] },
	{ "Farmer", 1, [[********************************************************************
Farmer:
********************************************************************
As a farmer you need to buy a tractor and a combine harvester, 
it's also recomended to buy a house country side (not required 
thougth) to get some land. When you have that stuff ready enter
your tractor and plant with the command /plant or press the 'N'
key. Each plant cost you some money and take up to an hour to 
grow. 

Luckily you don't have to wait all that time, meanwhile 
you can do other stuff, even leave the server if you wish, 
just remember to come back and harvest them with your combine 
harvester within three hours or they will rotten, be aware of 
other farmers as well since they may steal your plants.

Farmers can legally kill other farmers if they are a threat, 
you may also work together with other farmers as a team. 
After harvesting a plant, all you gotta do it so step out and 
pick it up, the profit in this job is extremly high so it's 
probably our most well payed job. Also the most risky one.

You can become a farmer at "the farm", south side of San Fierro
]] },
	{ "Fisher", 1, [[********************************************************************
Fisher:
********************************************************************
All you need in this job is a boat, your own or travel with a 
rich friend, any boat work and all you gotta do is to be on 
the boat, (not AFK thought). Use the /fishmarket command to 
find out the status of the fish, this indicates how often the 
fish will bite and how much money you might make by fishing.

This job is located in Los santos near the lighthouse and in 
San Fierro on the west side near city hall and the bank.
]] },
	{ "Mechanic", 1, [[********************************************************************
Mechanic:
********************************************************************
This job is found near larger workshops whith pay'n'sprays and 
mod shops in all three cities, as a mechanic you'll find and help
people with their broken or damaged cars or by selling them fuel
if they ran out of it.

To repair a car press X to show the cursor, then click on the 
vehilce you want to repair, a menu will show up, select Repair 
or Refuel, a refule increase the fuel by 10 hits and you're 
getting paid. Note that you won't get paid for reparing or 
refuling your own cars, you'll just get a cheaper price.

This is probably the most appriciated job, people will thank 
you and maybe even tip you if youre doing a good job.]] },
	{ "Pilot", 1, [[********************************************************************
Pilot:
********************************************************************
You can become a pilot at any of the three major airports in 
San Andreas, as a pilot you'll fly passengers and/or cargo 
between the airports and some other places. You may use your 
own aircraft as well and you can always make some extra cash 
by picking up and transport other players around the map.

Anyone can call for a pilot using the command /pilot, you will 
see those players marked on the map with a green man blip.]] },
	{ "Taxi", 1, [[********************************************************************
Taxi:
********************************************************************
Does it have to be explained? You'll find this job near the 
airports as well as the pilot job, anyone can call a taxi 
by the command /taxi, your job is to transport them fast 
and professional to the destination they wish to go to.

There are peds assigned for you in case none of the online 
players want a taxi either so don't worry about being out 
of money or work.]] },
	{ "Train driver", 1, [[********************************************************************
Train driver:
********************************************************************
GTW Games are known for the trains so don't think you can sit 
back and just press the 'W' button in this job, there are a 
lot of stuff to think of, for instance slowing down near sharp 
turns, railway switches and train stations. A derailment is one 
of the most serious crimes you can commit. 

Just like in other jobs in the public transportation section
you'll getting payed for stopping at the train station and by 
picking up passengers or stuff they want to transport like cars
for instance. The /train command let's then notice you that 
they are waiting for your train. 

Train driver is located at the major train stations in each city.]] },
	{ "Tram driver", 1, [[********************************************************************
Tram driver:
********************************************************************
See train driver, the main difference are slower top speed, avoid
collisions with other vehicles and shorter distance betwen the 
stops. This job is located in San Fierro only, just south about 
the china town neighbourhood]] },
	{ "Trucker", 1, [[********************************************************************
Trucker:
********************************************************************
Transport cargo around San Andreas or inside your current city. 
Deliver fuel to the local gas stations etc. This is a job where 
ranks will make difference, you start at the bottom by driving 
smaller trucks and will then work your way up to the larger trucks 
like Tanker, Roadtrain and Linerunner, at really high ranks you 
will receive missions with two trailers attached at the same time 
and get double payment.

This job is found in Ocean docks (Los Santos), west Los Santos 
gasstation and in San Fierro easter basin, the pier near the 
airport. Damaged cargo will reduce your payment so drive carefully 
or loose your money. Except for farmer this is one of the most well 
paid jobs you can find, if you know how to drive a large and heavy 
truck of course.]] },
	{ "Government", 0 },
	{ "Police", 1, [[
There are plenty of law squads within the 
government, for instance ArmedForces, FBI, SAPD, SWAT and of course 
the regular police officers, traffic officers, detectives etc..

All of these does pretty much the same stuff but some has special 
priviledges, for example traffic offiers has speeding cameras and 
access to stingers and barriers to setup road blocks, they'll also 
have fast cars for high speed car chases. ArmedForces deal with 
the most wanted criminals uing tanks, hunters and hydras, SWAT 
takes care of robberies and SAPD and FBI handles federal crimes.]] },
	{ "Police chief", 1, [[
Police chiefs make sure any player that work in the law enforcement 
follow the law, it's a job with lot's of freedom and great 
responsiblity and that's why we have police chiefs. You must 
prove that you are trusted enough to handle this job, to do 
so, write and post your application here:

http://forum.albonius.com/law-board/police-chief-center-topic/

Commands: (admin):
/addpc <name>     -- Adds a police chief
/removepc <name>  -- If you screw it up and needs to be kicked

Commands: (police chiefs)
/banfromlaw <name>
/revokebanfromlaw <name>

(name means the nick name of the affected player.]] },
	{ "Police (codes)", 1, [[
10-4   	Roger that
10-10  	Off duty
10-14  	Provide Escort
10-15  	Prisoner in custody
10-23  	Stand by
10-29  	Check For Wanted (person, Vehicle Or Object)
10-97  	Arrived At Scene              
10-98  	Assignment Completed

11-10  	Take A Report
11-24  	Abandoned Vehicle
11-25  	Traffic Hazard
11-41  	Ambulance Required
11-66  	Defective Traffic Signals
11-78  	Paramedics Dispatched
11-79  	Accident- Ambulance Rolling
11-98  	Officer Requires Help, Emergency]]},
	{ "How to arrest", 1, [[
All law units get's a free nightstick, this is used to arrest a 
wanted player, simply hit the suspect once to arrest him. After 
the arrest you'll take him to jail which is inside all police 
departments, all the way to the cellblocks where you walk up to 
the cell to deliver the suspect. ((Yes you can also choose which 
cell)).

At the larger police departments there is a light ammu nation 
shop where law units can buy useful equiptment like silenced 
pistol (tazer which will freeze the suspect for a while), 
teargas, M4 and MP5 which are common useful guns in the law 
section as well as body armor and much more.

If a suspect is obviously violent you can do a kill arrest, by 
that you will simply shoot the suspect in place to get paid. 
The payment is lower than a regular arrest so try avoid this.]] },
	{ "How do I know who's wanted?", 1, [[
There are many ways, the command /wanted output's a list of wanted 
players names and their current wanted level

Another way is regular patrolling, a wanted player will probably 
act suspicious by trying to escape when he see's you or somethnig 
like that, if not you can stop him anyway just to check, to do so, 
simply press X to show the cursor and click on the suspect, a menu 
will open in where you select "Check if wanted", you will then find 
out if the player is wanted or not.

A third way is to check for a text at the bottom of your screen 
saying somethnig about distance, that means a suspect is nearby
and you'll getting an approximate distance telling you roughly
where the suspect is hiding. You'll have to look a lot so a 
helicopter is required as well as temwork between law uints.]] },
	{ "Law chat", 1, [[
All government units has access to the emergency chat /e <text>,
keep other law units updated with your current status, call for 
backup etc, this chat is also useful if you need firemen or medics,
the teamchat will only be visible to other players in the Government 
team. 

Be creative, firemen can be useful against riots and medics are 
useful if violent criminals attack you.]] },
	{ "Server staff", 1, [[
Server staff is also a part of the goverment team, there are three 
ranks currently, Admin, Super moderator and Moderator, the staff 
duty is mainly about keeping an eye of the game play and help new 
players, anyone can apply to join the staff team here: 
http://games.albonius.com/index.php?topic=3.0

If a staff is abusing his power we kindly ask you to report him here:
http://games.albonius.com/index.php?topic=357.0]] },
	{ "Developers", 1, [[
Developers is also a part of the government team, GTW Games is based
on open source which means that anyone are free to contribute, or use
the code under the MIT licence, official developers are people that 
applied to become official.]] },
	{ "Criminals", 0 },
	{ "The basics", 1, [[
Sooner or later youre life get's fucked up and you'll stand there 
without money, being a criminal is the final option to make money 
quick if you can hide from the law. You can easy become a criminmal 
at any time by either comitting a serious crime or by pressing 'F5' 
and click 'Go Criminal', the command /criminal is another option.]] },
	{ "Store robberies", 1, [[
There are around 100 shops around San Andreas which you can rob at 
any time for quick money, any clothes shop, ammu nation, fast food 
restaurant or general store can be robbed by aiming a weapon at the 
face of the salesman behind the desk. 

You will then be noticed by a text on your screen telling you how 
much time you must stay to get the money, during this time you can't 
leave the store or getting arrested. If you do the robbery is 
interrupted.

Robberies are mostly depending on the amount of cash in the store, 
a higher wanted level means more cash but it's still hard to know 
how much you can get. One thing is for sure, it's often worth it.]] },
	{ "Hijacking missions", 1, [[
Hijacking vehicles is a relatively well paid mission, at least 
when many other criminals figthing about the same car, the flag 
icon indicates where you can find a hijack car. Simply enter it 
and deliver it to the given destination.]] },
	{ "Mystery bags", 1, [[
Mystery bags can contain a random amount of money, armor and 
weapons, as a criminal you can hunt for these bags which are 
marked with a question mark.]] },
	{ "Turfs", 1, [[
Turfs is also a pretty good way to earn money, you just need 
to be a member of a gang if you want to turf, if youre not 
you can create a gang by pressing 'F6' enter a name and click 
'Create'.

Go criminal by using the command /criminal then you'll enter 
any turf to provoke it, after provoking it you must hold it 
and defend it from others that might be interested in it, 
especially the current owner. Turfs will pay out to entire 
gangs with a couple of hours delay and you'll earn some money 
after capturing it as well. 

There are turfs spread out over the entire map so try to focus 
on one specific area if possible to make it easier to defend 
them from other gangs.]] },
	{ "Gangsters", 1, [[
Any criminal that get's shot inside a turf becomes a gangster, 
gangsters will not gain wanted level from killing other gangsters
which is a huge advantage since the law units has an easy time 
arresting people that is practicating in a turf war. Allthought 
you don't want to get killed since you'll lose your weapons.]] },
	{ "Reduce wanted level", 1, [[
Your wanted level will start to reduce after you commit a crime
if there isn't any cops nearby and the crime wasn't too serious.
Serious crimes makes you violent, you'll see a count down timer 
in your hud telling you for how long you'll be violent, when that 
time reaches zero your wanted level will reduce.

Stay away from cops and other government units is the best way to 
reduce, you can do so by either buy a house and hide inside or by 
traveling out contry side and hide somewhere where there isn't 
many other players around.

You can also pay a fine by doing /fine or /surrender, this is often 
pretty expensive and you'll may loose all the money you erned from 
the crime, this is also useless when a law unit is nearby.]] },
	{ "Bribery", 1, [[
You can bribe corrupt cops at your own risk, note that you may 
getting scammed if you do but theoretically you can bribe.

First talk to the cop who arrested you to see if he's interested,
if he accept use the /give <player_nick> <amount> command to send 
the money or visit any bank or atm, the cop will then use the 
/release command to release you. You will still be wanted so be 
careful.]] },
	{ "Shops", 0 },
	{ "Fast food restaurants", 1, [[
If you want to regain health but are far away from a hospital or 
just wanna get fat we have 32 fast food restaurants for you, All 
Clucki'n Bells, Burger shots and Well stack Pizza C.o are open 
for you 24/7. Welcome.

Are you lazy? Try the new drive thru outside most burger shots.]] },
	{ "Ammu nation", 1, [[
Protect yourself with a gun, the patriotic way. Ammu nation is the 
best place to buy cheap weapons with 11 shops around the map, there 
is also two special shops where you can buy the heavy stuff such as 
Heat seeking rockets, bombs and grenades.]] },
	{ "Skin and clothes shops", 1, [[
Six different chains and 17 shops allover the map, in case you want 
to change your skin or jsut get a new look.]] },
	{ "Gas stations", 1, [[
Buy fuel for your vehicles here.]] },
	{ "Pay'n'spray", 1, [[
Are your car damaged? Then come in and we repair it for you for a 
fair price, way cheaper than calling for a mechanic.]] },
	{ "Mod shops", 1, [[
Want to mod your car? We have all the equiptment you need, 
hydralics, nitrus, new colors, spoilers and other nice stuff.]] },
	{ "Vending machines", 1, [[
If you see a vending machine walk up to it and press 'Enter' to buy 
snacks and regain health.]] },
	{ "Hardware shops", 1, [[
If you ever need a baseball bad, golf club, knife or other tools we 
have them here.]] },
	{ "Misc features", 0 },
	{ "Command list", 1, [[
:: Animations ::
Key 'F10'   -- Opens a GUI with all available animations
/cpr        -- Do CPR on another player
/deal1      -- If you want to look like a drugdealer
/deal2
/deal3
/fatidle    -- Look like a fat person
/handsup    -- Handsup to follow the orders from a 
               law officer and prevent getting shot
/lean       -- Lean towards a wall or a car
/lookaround -- Look around in place
/mourn      -- Look sad (if someone dies maybe)
/sit        -- Sit down on anything you want to sit on
/smoke      -- Smoke a cigarette
/tired      -- Look tired
/wave       -- Wave to another player
* All animations can be interupted by walking forward at any time

:: General (keys) ::
F1               -- Toggle help
F2               -- Show the vehicle GUI where you 
                    can manage your own vehicles.
F3 | /stats      -- Show the stats window
F4               -- (nearby vehicle) open the vehicle trunk
F5               -- Show the job management GUI, current job 
                    stats and quick buttons to end your work 
                    or become a criminal.
/endwork
/criminal        -- (See job management GUI)
F6               -- Open group system, create a group/gang 
                    and invite people, useful for turfning 
                    or if you just want to chat privately.
F7 (admin)       -- The admin panel (staff only)
F8               -- Show the console
F10              -- All available animations.
F11              -- The map over San Andreas
F12              -- Take a screenshot
B                -- Show your phone

:: Bank ::
/give <player_nick> <amount>      -- Transfer money to another 
                                     player pocket to pocket
                                     
:: Police ::
/e <message>       -- Say something in law chat
/wanted            -- Shows a list of all wanted players
/release           -- Release a suspect you are holding

:: Criminals ::
/fine              -- Attempts to pay a fine to get rid 
                      of your wanted level. Warning! it's 
                      expensive and may fail.
/give              -- (See bank, may be used for bribery 
                      at own risk)
                      
:: Public transportation ::
/taxi              -- Call for a taxi
/bus               -- Let the busdrivers know youre waiting
/pilot             -- Call for a pilot in helicopter
/train             -- Let the train drivers know youre waiting
/tram              -- Let the tramdrivers know youre waiting

:: Staff ::
/gv                -- Spawn a vehicle
/setpos x y z      -- Move anywhere on the map
/mute <player_nick> <time_in_minutes> <reason>
/jail <player_nick> <time_in_minutes> <reason>
/ban <player_nick> <time_in_minutes> <reason>
]]},
	{ "House system", 1, [[
Buy a house as a place to relax, a place to hide from the law, hide 
your money and weapons or as a base for your gang. The posibilities 
are infinite. Houses are available in a wide price range allover the 
map, starting from just 500$ for a shed countryside up to 1'000'000$
for a luxury manson in north Los Santos or downtown San Fierro and 
everything between.

You may also rent your house as a landlord or rent from someone else,
all this will be configured in the house GUI which is simple to 
understand, type: /househelp for more info or ask anyone else.]] },
	{ "AC Phone", 1, [[
Press 'B' to open your nokia phone which you may use to listen to 
radio, send SMS to other players or to call for services. ]] },
	{ "Trains", 1, [[
Avoid driving your car on the railroads, you may getting hit by a 
train, you may also see trams in San Fierro so be careful while driving 
there as well, they won't stop for you, trains and trams is also a great 
way to travel around the map for free.]] },
	{ "Business system", 1, [[
There are a lot of business properties to invest in around the map, a 
business start's to generate money after about two weeks, after that 
time it has produced as much money as you payed for buying it. Busniess 
are available in all price classes but may be hard to find thought.]] },
	{ "Bank system", 1, [[
Safe your money by putting them into the bank, ATM's and banks are all 
useful to deposit, withdraw or send money to other players. ATM's and
banks are marked with a dollar sign on the map.]] },
	{ "Hospitals", 1, [[
There are many hospitals around the map, you can regain health at nay 
hospital quick and for a fair price, you will also respawn at nearest 
hospital if you die. Hospitals are safe zones and it's strictly forbidden 
to kill or damage people or vehicles near a hospital.]] },
}