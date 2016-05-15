=========================
 MODLOADER 1.0.3
 MANUAL
=========================

First of all, thanks for using this resource! I'm sure it will statisfy you.

=> Make sure this resource has access to the restartResource function! You can simply add it to the admingroup in the ACL.

How does it work? Well simple. Just get a mod from any website, for example gtainside.com.

Make sure all the files you place are lowercase, and thus not UPPERCASE! If not, ModLoader won't catch your mods.
Also, make sure the file-extenstion is lowercase.

If ModLoader doesnt see your mod, it's your problem. ModLoader works correct so you simply have an incorrect modname.
Please see or ask in the forum topic for solutions.

To install a mod:

= Vehicles ==============
Place the DFF and TXD in the "vehicles" folder.
Also, in the mod you downloaded you might have a readme.txt containing a custom handling line.

> To install that handling:
  Create a new file, with the same name as your DFF and TXD, and .hnd as extension.
  So, for example, if you're adding a new infernus, call this file "infernus.hnd".
  Now open this file with notepad or any other text editor, place the handling line in it, and save it. Done! :D


By default, custom collisions are DISABLED.
> To enable custom collisions for vehicles, open "replacer_c.lua" and change "allowCollisions" to true.

  == IMPORTANT NOTE ==
  Since version 1.0.3, ModLoader takes a little more time to load collisions. It can load 10 collisions consecutive with an interval of 300 MS.
  This means, if you have all 212 vehicles replaced, it will take a minute to load them all but it's almost guaranteed you won't crash.
  You can load more vehicles consecutive by changing "maxVehicles" in replacer_c.lua, but I do not recommend this.
  The reason I made it like this is to replace vehicles more stable. I've been experiencing crashes when there are too many vehicles replaced at a single time.



= Skins and weapons =====
Simply place the DFF and TXD in the "skins" or "weapons" folder, depending what you want to mod.



Also, I've included an option to delete mods since 1.0.1. It works simple with this command:
 mdel [moddir] [modname]
So, if you want to delete the vehiclemod infernus for example, the command is "mdel vehicles infernus". This deletes the TXD, DFF and the optional HND file.

Besides, if you want to CLEAR the complete mod directory use the command:
 mclear [moddir]
So, if you want to clear all vehicle mods, use "mdel vehicles".
And ofcourse, ingame you use a slash ( '/' ) in front of a command :P


Any problems or suggestions? Feel free to post these at the forum!
http://forum.mtasa.com/viewtopic.php?f=108&t=36481