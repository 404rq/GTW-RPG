### Description
GTWsmoke is a server side resource which creates animations and attach cigarettes to players hand to make it possible to smoke in game, use the command _"/smoke"_ to start smoke, press W to move and keep your cigarette and A or D to throw it away (finish smoking).

<br>
**Functions available**

`startSmoking(player thePlayer)`  
_(server) Called by command handler, force the player to start smoke._

`showDelayInfo(string text, player thePlayer, int red, int green, int blue)`  
_(server) Display the given top bar text for the local player (with delay by export)._

`stopSmoke(player thePlayer)`<br>
`stopSmoke2(player thePlayer)`<br>
_Triggers the stop event in various ways, one remove the cigarette and the other keeps it and let you continue by left click._

`smokeDrag(player thePlayer)`<br>
_Trigger the drag animation (bound to left mouse button click)._

`quitPlayer(string quitType)`<br>
_Clean up when a player quit the game._


<br>
**Exported functions**

None, _This resource doesn't have any exported functions._


<br>
**Requirements**

bone_attach<br>
GTWtopbar
