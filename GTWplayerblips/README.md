### Description
GTWplayerblips, modification to the default player blips resource, this will check for team colors, hide the blips between some teams and only show player blips of players within the radar area distance of 180 units, (available to local chat).

<br>
**Functions available**

`updateBlipColor(player thePlayer)`  
_(server) Called by timer, check so the color of a blip is the same as the team color._

`destroyBlipsAttachedTo(player thePlayer)`  
_(server) Destroys any attached blip element to a player._

`hasPlayerBlip(player thePlayer)`
_(server) Returns true if the input player has a blip, otherwise false._


<br>
**Exported functions**

None, _This resource doesn't have any exported functions._


<br>
**Requirements**

None, _this resource is standalone and will work without need of other resources._
