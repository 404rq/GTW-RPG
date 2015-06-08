A spawn management system with a fail proof weapon saving system, whenver a player dies the 
weapons will be saved in a temporary table, indexed by player. Then the nearest hospital will 
be found from a list of hospitals, once the player spawns the weapons will be returned.

## Features
* Respawn after a player dies
* Save weapons currently owned by the player
* Look for the nearest hospital to spawn at from a list of 9
* Refuse to spawn jailed players (require GTWjail)
* Dump weapons to account data up on rage quit during the death process.
* Fading out, fading in, viewing the player from a different angle
* (New) Plays spawn sounds and show screen tips regarding death. (require GTWtopbar)

## Functions available

Not available, _There is no information about this resource functions available currently, 
see the source code for details, or fork and contribute by yourself (pull request)._

## Exported functions

None, _This resource doesn't have any exported functions._

## Requirements

GTWjail<br>
GTWtopbar
