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

str_updates = [['''Wednesday 19, August 2015 (GTWcore v-2.4-beta r-7766)'''
* Fixed broken radio links in phone
* Using a local file for updates instead of the old online service making it easier to find the latest news, this document can be found on Github as well
* Three failed login attempts will now result in a kick to stop spammers


'''Monday 20, July 2015 (GTWcore v-2.4-beta r-7409)'''
* Added the crime "vandalism" when hitting or damaging any vehicle
* Added local time at bottom left of the screen
* Added information about team and coccupation at bottom left
* Improved visibility of DX texts on screen


'''Wednesday 01, July 2015 (GTWcore v-2.3-beta r-7382)'''
* Fixed a issue where health and armor wasn't restored from last login session
* Added a warning when trying to use illegal symbols upon registration
* Added new camera views in hospital system
* Upgraded hospital system to look more professional
* Fixed a bunch of minor issues in open source resources, (see Github for more info)


'''Saturday 16, May 2015 (GTWcore v-2.3-beta r-6929)'''
* Upgraded police chief system using SQL database to store police chiefs and banned officers
* Upgraded jail map twice, added higher fences and made it a little harder to escape
* Increased rockets delay to 10 seconds and added a break so it only fires at one player at once
* Added more lamp posts in jail to make it harder to land there with a helicopter
* Added a fast food restaurant in jail (burger shot)
* Added a "drunk cell" in jail for obstructing people
* Optimized stngers to save performance and reduce lag
* Improved the stop sequence in train driver job
* Fixed iron miner job so that you can only mine on the ground


'''Friday 08, May 2015 (GTWcore v-2.3-beta r-6678)'''
* Fixed a bug related to stingers causing the tires not to blow on a hit
* Fixed minor bugs in the account system.
* Fixed cursor not dissapearing in the stat's window (F3)


'''Tuesday 05, May 2015 (GTWcore v-2.3-beta r-6641)'''
* Fixed the hospital respawn bug permanently
* When starting the engine of any vehicle, lights are only turned on if it's dark
* When a train is locked, all engines in the chain is toggled but none of the cars
* Possibly fixed a bug causing player to loose their weapons after being in jail
* Added AFK mode which warp you to another dimension using the /afk command
* Added the command /radarhighres to toggle the high resolution radar for a little better performance
* Fixed a bug related to fight and diving in jail
* Optimized iron miner job
* Fixed minor general and known bugs
* Updated the help system on F1


'''Saturday 25, April 2015 (GTWcore v-2.3-beta r-6331)'''
* Optimized many resources to remove any sign of lag by FPS drops.
* Updated IRC, the following channels will be used: #ingame, #gtwmtarpg, #gtwmtarace and #gtwmtafreeroam
* Made it easier to escape from jail, increased rockets delay and added an escape route at the north side
* Added the ability to fight and dive while jailed allowing you to kill guards or swim under the fence at some points
* Fixed a jail related respawn bug


'''Saturday 18, April 2015 (GTWcore v-2.3-beta r-6161)'''
* Improved mechanic job by allowing any vehicle to be repaired
* Fixed exploits in mechanic job allowing repairs and refuel of already fixed cars
* Initialized version 2.3-beta where job upgrades will be in focus
* Added more variations in trains and colors
* Fixed minor bugs in iron miner job


'''Wednesday 25, March 2015 (GTWcore v-2.2-beta r-5682)'''
* Installed major patches and prepared for the final 2.2 release
* Reverted the old weather system
* Made the job system freeze a player opening the GUI to prevent falls
* Fixed a bug where cops got paid twice on the same suspect after reconnect
* Optimized business system and added blips
* Improved search in rental vehicle system.


'''Friday 20, March 2015 (GTWcore v-2.2-beta r-5213)'''
* Made search operations in rental vehicle system case insensitive
* Fixed minor bugs in rental vehicle system, staff will see all vehicles when using /gv only while markers will display their own list of vehicles (Now with ability to search).
* Modified the effects of drugs to make it a little easier to escape from jail again.


'''Thursday 12, March 2015 (GTWcore v-2.2-beta r-5173)'''
* Fixed minor and known bugs in the civilian job system.
* Added the ability for players in any staff ACL group to use job commands (/goNAME_OF_JOB)
* Made the wanted level reduce faster if really far away.
* Made longest time in jail 40 minutes to motivate escape attempts
* Made all house pickups green and prepared for blips
* Added blips to businesses and a blue house pickup
* Added the ability to see the current speedlimit for trains at bottom right, it's based on the sharpness of nearest turn.
* Added speedlimit for trains and derailment if you drive to fast.
* Fixed /gv and vehicle spawners for staff including the search box for everyone.


'''Tuesday 10, March 2015 (GTWcore v-2.2-beta r-5098)'''
* Released our official editor WalruPad on Github.
* Lowered price of dynamite to $1200
* Improved iron miner job, updated GUI's and added a place to sell iron
* Fixed some NPC related bugs


'''Thursday 5, March 2015 (GTWcore v-2.2-beta r-5036)'''
* Added standard sized orange coloured "playerblips" to bots
* Added blips to vehicle spawners of size 1 and visible on a long distance, rental vehicle spawners are inciated by a car blip
* Command /Wanted will now display time left in jail for jailed players
* Removed the rocket launched on jail water tower as it could not hit anything anyway
* Made it a little harder to escape from jail by upgrading the map
* Added the ability to mine, walk up to a stone after the explosion caused by the dynamite you planted earlier to start mining
* Added dynamite for $2000 to iron miner, use the N key to plant the dynamite, then take cover
* Added a DX GUI to iron miner job
* Fixed some broken radio links on the phone


'''Sunday 1, March 2015 (GTWcore v-2.2-beta r-4867)'''
* Added the ability for law units to deliver a suspect directly to jail, near the helipad as well as near the jail docks.
* Added the new command /gtwhelp which will show a list of available commands in requested task
* Fixed the bug where nearest cop didn't get paid on suicide arrest
* Fixed the bug where hospitals respawn players that was supposed to be jailed by kill arrest
* Fixed kill arrest by tazer, on kill arrest, the tazer will now act as a normal weapon, aim for the body if you want to perform a normal arrest.
* Improved the rockets in jail, made them smarter and olny allow one rocket/prisoner to prevent rocket spam on multiple jailbreak attempts.
* Added armor pickups for cops at all police departments
* Added blips to all police departments to always know where the nearest of them is located
* Only free vehicle spawners will be marked by a blip, this blip looks like a car and is seen from long distance so you always know where nearest vehicle spawner is located.
* Added boat and heli spawners at Bayside marina police department


'''Saturday 28, February 2015 (GTWcore v-2.2-beta r-4824)'''
* Fixed minor map bugs in the core map
* IRC commands will no longer spam the chat in game
* Weapons are now saved while being in jail and can't be used in jail
* Fixed minor bugs in the law system
* Jail is now checking for players inside a vehicle or in water, stay away from water and vehicles or you'll get shot within short
* Improved the rocket algorithm around jail and made the rockets more powerful
* Added new islands around jail, some with guard towers on them
* Disabled the ability to recover and spawn vehicles while being jailed


'''Friday 27, February 2015 (GTWcore v-2.2-beta r-4757)'''
* Fixed the timer bug in jail
* Reduced turf payments per turf by 1.5x but increased the max payout by 4x, more turfs are now profitable.
* Made it harder to escape from jail by increasing the radius of the rockets.
* Added /speedlimit <km/h> to set a max speed limit of your current vehicle, useful for roleplay situations.
* Increased the length you can use your vehicle keys remote.
* Added height to the police tracker in case the criminal tries to escape in the air.
* Added red color code in /wanted to show who's violent
* Added suicide arrest
* Added a searchbox and a details column to vehicle spawners, (case sensitive) details will contain further information like trailers etc..
* Upgraded rental vehicle system, staff are now people who are in the staff team and that's required to use /gv


'''Monday 16, February 2015 (GTWcore v-2.2-beta r-4580)'''
* Fixed ~99 bugs, mostly minor but still annoying ones
* Added the ability to official escape from jail, (you get released but wanted on success)
* Added kill arrest
* Fixed kill arrest jailing the cop on suicide
* Added trailers to trucks when spawning from vehicle system
* Justified wanted levels and violent times
* Fixed a bug in hospitals not recharging
* Fixed staff protection not working
* Fixed issues related to death in jail or reconnect while jailed
* Fixed jail timer display, distance to nearest suspect etc
* Upgraded the /wanted command with more info
* Added /accept to /fine so you can view the charge before paying.]]
