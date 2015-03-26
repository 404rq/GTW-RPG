Advanced wanted level system, stores wanted level and violent time for all online players in a table, 
detect crimes and increase a players wanted level, exported functions to determine if a player is violent,
wanted etc. This is a part of GTW law system which is a set of multiple resources, the main one is GTWpolice.
To make it work, you need to install all required resources.

## Functions available

Not available, _There is no information about this resource functions available currently, see the source code for details, or fork and contribute by yourself (pull request)._

## Exported functions

`setWl(player plr, int level, int violent_time, string reason, bool add_to, bool reduce_health)`  
_(server/client) Set wanted level and violent time to add to current or set it to whatever you want, 
ability to reduce the health if the crime was to crash a car for instance or something else that 
would reduce health, this function exist on both server and client, player is not needed when used 
client side._

`int wanted_level, violent_time = getWl(player plr)`  
_(server/client) Get a players wanted level and violent time._

## Requirements

GTWtopbar<br>
GTWpolice<br>
GTWjail<br>
GTWjailmap (required if using "GTWjail")<br>
GTWclothes (optional)<br>
GTWpolicechief (optional)<br>
