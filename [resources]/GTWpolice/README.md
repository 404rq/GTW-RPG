The core system of GTW law and wanted level system, by splitting up and rewriting the old complex system
into 4 new resources with this as the core system managing exports it's finally here, law jobs are assigned 
by GTWcivilians, the team is "Government" and the occupation could be anything, special features can be
restricted to specific occupations. Vehicles are managed by GTWvehicles but the rest is included.
 
GTWwanted will manage wanted level and tell you who you can arrest or not.<br>
GTWjail and GTWjailmap will manage everything related to jail.

## Functions available

`int dist = distanceToCop(player crim)` _(server)  
Get the distance from a criminal element (player) to nearest law enforcer._

`player cop = nearestCop(player crim)` _(server)  
Get the nearest law enforcer as player element._

`bool isArrested = isArrested(player crim)` _(server)  
Returns true if the criminal is arrested, false otherwise._

## Exported functions

`int dist = distanceToCop(player crim)` _(server)  
Get the distance from a criminal element (player) to nearest law enforcer._

`player cop = nearestCop(player crim)` _(server)  
Get the nearest law enforcer as player element._

`bool isArrested = isArrested(player crim)` _(server)  
Returns true if the criminal is arrested, false otherwise._

## Requirements

GTWtopbar<br>
GTWwanted<br>
GTWjail<br>
GTWjailmap (required if using "GTWjail")<br>
GTWclothes (optional)<br>
GTWpolicechief (optional)<br>
GTWvehicles *(optional, (_coming soon_))<br>
