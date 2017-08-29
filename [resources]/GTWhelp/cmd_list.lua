--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Staff and administrative commands ]]--
function show_admin_commands()
        local is_admin = exports.GTWstaff:isAdmin(localPlayer)
        if is_admin then
                outputChatBox("Administrative commands:                                                 ", 200,200,200)
                outputChatBox("    /accounts-info -> show total playtime from all accounts              ", 200,200,200)
        else
                outputChatBox("You are not an administrator for this server                             ", 255,0,0)
        end
end
addCommandHandler("adminhelp", show_admin_commands)
function show_staff_commands()
        local is_staff = exports.GTWstaff:isStaff(localPlayer)
        if is_staff then
                outputChatBox("Staff commands:                                                          ", 200,200,200)
                outputChatBox("    /jail <player_nick> <time> <reason> -> send a player to jail         ", 200,200,200)
                outputChatBox("    /mute <player_nick> <time> <reason> -> mute a player from all chats  ", 200,200,200)
                outputChatBox("    /setpos <x> <y> <z> [<int> <dim>] -> teleport to given position      ", 200,200,200)
                outputChatBox("    /golaw -> join the police force (/go<official_group> works too)      ", 200,200,200)
        else
                outputChatBox("You are not a staff memeber on this server                               ", 255,0,0)
        end
end
addCommandHandler("staffhelp", show_staff_commands)

--[[ Worker commands, civilians/criminals and law enforcement ]]--
function show_civilian_commands()
        outputChatBox("Civilian commands:                                                               ", 200,200,200)
        outputChatBox("    /sell -> sell ice cream or hot dogs, (requires relevant vehicle)             ", 180,180,180)
        outputChatBox("    /attachtrain -> attach one or more train cars to your train                  ", 200,200,200)
        outputChatBox("    /detachtrain -> detach the last traincar from your train                     ", 200,200,200)
        outputChatBox("    /detachtrailer -> detach a trailer from your semitruck                       ", 180,180,180)
        outputChatBox("    /plant -> Plant seed (farmer) or plant bomb (iron miner)                     ", 180,180,180)
        outputChatBox("    KEY: X -> (shows the cursor) click on a vehicle to repair (mechanics)        ", 180,180,180)
end
addCommandHandler("civhelp", show_civilian_commands)
addCommandHandler("civilianhelp", show_civilian_commands)
function show_criminal_commands()
        outputChatBox("Criminal commands:                                                               ", 200,200,200)
        outputChatBox("    /criminal -> become a criminal (you can also comit a crime to join the team) ", 180,180,180)
        outputChatBox("    /selldrugs -> start or stop selling drugs                                    ", 200,200,200)
        outputChatBox("    /fine -> pay a fine to loose your wanted level, (wont work near law units)   ", 200,200,200)
        outputChatBox("    Action: kill a player or bot to increase your weapon stats                   ", 200,200,200)
        outputChatBox("    Action: aim a gun at a shop keeper to initiate a robbery                     ", 180,180,180)
        outputChatBox("    Action: die in a turf and you'll become a gangster                           ", 180,180,180)
end
addCommandHandler("crimhelp", show_criminal_commands)
addCommandHandler("criminalhelp", show_criminal_commands)
function show_law_commands()
        outputChatBox("Law enforcement units commands:                                                  ", 200,200,200)
        outputChatBox("    /wanted -> list all wanted players and their last seen location              ", 180,180,180)
        outputChatBox("    /release -> release a suspect you have under arrest                          ", 200,200,200)
        outputChatBox("    Action: hit a wanted player with your nightstick to arrest                   ", 200,200,200)
        outputChatBox("    Action: fire at a wanted player with silenced pistol to taze them            ", 200,200,200)
end
addCommandHandler("lawhelp", show_law_commands)

--[[ General commands, available to everyone currently in a vehicle ]]--
function show_vehicle_commands()
        outputChatBox("General commands available for everyone:                                         ", 200,200,200)
        outputChatBox("    /od[0-5] -> open all doors (or specific door [0-5])                          ", 180,180,180)
        outputChatBox("    /cd[0-5] -> close all doors (or specific door [0-5])                         ", 180,180,180)
        outputChatBox("    /engine -> turn engine on or off                                             ", 180,180,180)
        outputChatBox("    /lock -> lock or unlock all vehicle doors                                    ", 180,180,180)
        outputChatBox("    /warn -> toggle hazard lights (use , and . keys for indicators)              ", 180,180,180)
        outputChatBox("    /limitspeed <speed_in_kmh> -> limit top speed of a vehicle                   ", 180,180,180)
        outputChatBox("    /drop -> drop passengers via rope from helicopter                            ", 180,180,180)
        outputChatBox("    KEY: C -> toggle cruise control                                              ", 180,180,180)
        outputChatBox("    KEY: L -> turn headlights on or off (default: auto)                          ", 180,180,180)
        outputChatBox("    KEY: H -> Horn (will also toggle emergency lights and sirens)                ", 180,180,180)
        outputChatBox("    KEY: G -> Enter/exit as passenger                                            ", 180,180,180)
        outputChatBox("    Mouse: right button -> toggle drive by (requires compatible weapon)          ", 180,180,180)

end
addCommandHandler("vehhelp", show_vehicle_commands)
addCommandHandler("vehiclehelp", show_vehicle_commands)

--[[ General commands, available to everyone ]]--
function show_general_commands()
        outputChatBox("General commands available for everyone:                                         ", 200,200,200)
        outputChatBox("    /me <text> -> light upo a cigarette                                          ", 180,180,180)
        outputChatBox("    /do <text> -> light upo a cigarette                                          ", 180,180,180)
        outputChatBox("    /give <player_nick> <amount> -> send money to another player                 ", 180,180,180)
        outputChatBox("    /stats -> view your current stats (GUI accessible from F3)                   ", 180,180,180)
        outputChatBox("    /cower -> Take cover on the ground                                           ", 180,180,180)
        outputChatBox("    /cpr -> Do CPR on a person in front of you                                   ", 180,180,180)
        outputChatBox("    KEY: B -> Open your phone for radio, SMS or calls                            ", 180,180,180)
end
addCommandHandler("genhelp", show_general_commands)
addCommandHandler("generalhelp", show_general_commands)

--[[ Animation commands, available to everyone ]]--
function show_anim_commands()
        outputChatBox("Animation commands available for everyone:                                       ", 200,200,200)
        outputChatBox("    /cower -> Take cover on the ground                                           ", 180,180,180)
        outputChatBox("    /cpr -> Do CPR on a person in front of you                                   ", 180,180,180)
        outputChatBox("    /handsup -> surrender a gun fight                                            ", 180,180,180)
        outputChatBox("    /lookaround -> suspiciously look around                                      ", 180,180,180)
        outputChatBox("    /smoke -> light upo a cigarette                                              ", 180,180,180)
        outputChatBox("    /lean -> lean towards a wall or object                                       ", 180,180,180)
        outputChatBox("    /sit -> sit down                                                             ", 180,180,180)
        outputChatBox("    /mourn -> make you mourn                                                     ", 180,180,180)
        outputChatBox("    /wave -> Wave to someone, i.e a taxi                                         ", 180,180,180)
        outputChatBox("Animations can be interrupted by pressing W, more animations exist               ", 200,200,200)
end
addCommandHandler("animhelp", show_anim_commands)
addCommandHandler("animationhelp", show_anim_commands)

function show_command_classess()
        outputChatBox("These are the help classes, use any of below commands for more info              ", 200,200,200)
        outputChatBox("    /civhelp -> list all commands for civilian jobs                              ", 200,200,200)
        outputChatBox("    /crimhelp -> list all commands for criminals and gangsters                   ", 200,200,200)
        outputChatBox("    /lawhelp -> list all commands for law enforcement jobs                       ", 200,200,200)
        outputChatBox("    /vehhelp -> list all vehicle commands                                        ", 200,200,200)
        outputChatBox("    /genhelp -> list all useful commands available for everyone                  ", 200,200,200)
        outputChatBox("    /animhelp -> list animations and misc commands                               ", 200,200,200)
        outputChatBox("    /adminhelp -> list all commands for server administrators                    ", 200,200,200)
        outputChatBox("    /staffhelp -> list all commands for server staff                             ", 200,200,200)
end
addCommandHandler("helpme", show_command_classess)
