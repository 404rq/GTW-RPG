This resource manage the jail and is mainly a helper resource for GTWpolice, it requires "GTWjailmap" 
which can be found in ../[maps].

## Functions available

function name (string arg1, int arg2, ...) _(server/client) description._

Not available, _There is no information about this resource functions available currently, see the source code for details, or fork and contribute by yourself (pull request)._

## Exported functions

`Jail(player crim, int time_seconds, [ string police_dept, string reason, player admin ])` 
_(server) Jails a criminal for the provided time in seconds, optional parameters is a code name for 
the police department where the player will be jailed at, e.g "LSPD" or "SFPD". Reason will be 
displayed as a chat output for the jailed player and is mainly for admin jails, player admin is 
the player element of the admin who jailed the player, leave that field empty if the player was 
jailed by a law enforcer._

`Unjail(player crim, string police_dept, [ string reason, player admin ])` 
_(server) Unjail a jailed player and send him/her to the specified police department, 
e.g "LSPD", "SFPD", "LVPD" etc.._

## Requirements

GTWtopbar<br>
GTWpolice<br>
GTWwanted<br>
GTWjailmap<br>
GTWclothes (optional)<br>
GTWpolicechief (optional)<br>
