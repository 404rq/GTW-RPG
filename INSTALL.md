To install GTW-RPG resources and start them together with your server, add below lines to 
your servers configuration file. It's located at: "mods/deathmatch/mtaserver.conf" in
your servers root folder.

```xml
<!-- Important imports -->
<resource src="GTWtopbar" startup="1" protected="0" />
<resource src="GTWgui" startup="1" protected="1" />

<!-- GTW resources -->
<resource src="GTWaccounts" startup="1" protected="0" />
<resource src="GTWantispam" startup="1" protected="0" />
<resource src="GTWchat" startup="1" protected="0" />
<resource src="GTWcivilians" startup="1" protected="0" />
<resource src="GTWclothes" startup="1" protected="0" />
<resource src="GTWdrugsys" startup="1" protected="0" />
<resource src="GTWfarmer" startup="1" protected="0" />
<resource src="GTWfastfood" startup="1" protected="0" />
<resource src="GTWfisher" startup="1" protected="0" />
<resource src="GTWgates" startup="1" protected="0" />
<resource src="GTWgrouplogs" startup="1" protected="0" />
<resource src="GTWhelp" startup="1" protected="0" />
<resource src="GTWhospital" startup="1" protected="0" />
<resource src="GTWironminer" startup="1" protected="0" />
<resource src="GTWjail" startup="1" protected="0" />
<resource src="GTWmechanic" startup="1" protected="0" />
<resource src="GTWnametags" startup="1" protected="0" />
<resource src="GTWphone" startup="1" protected="0" />
<resource src="GTWplayerblips" startup="1" protected="0" />
<resource src="GTWpolice" startup="1" protected="0" />
<resource src="GTWpolicechief" startup="1" protected="0" />
<resource src="GTWrob" startup="1" protected="0" />
<resource src="GTWsafeareas" startup="1" protected="0" />
<resource src="GTWsmoke" startup="1" protected="0" />
<resource src="GTWstaff" startup="1" protected="0" />
<resource src="GTWtrain" startup="1" protected="0" />
<resource src="GTWtrainhorn" startup="1" protected="0" />
<resource src="GTWturf" startup="1" protected="0" />
<resource src="GTWturnsignals" startup="1" protected="0" />
<resource src="GTWupdates" startup="1" protected="0" />
<resource src="GTWvehicleshop" startup="1" protected="0" />
<resource src="GTWwanted" startup="1" protected="0" />
<resource src="GTWweather" startup="1" protected="0" />

<!-- GTW maps -->
<resource src="GTWbluehellpatch" startup="1" protected="1" />
<resource src="GTWcoremap" startup="1" protected="1" />
<resource src="GTWjailmap" startup="1" protected="1" />
<resource src="GTWsapdbase" startup="1" protected="1" />
<resource src="GTWswatbase" startup="1" protected="1" />
```

Important! do not alter the order, some resorces depends on other resources and must 
therefore be started in certain order. Errors may occur otherwise. When possible, we
use alphabethical order (ascending) to make it easy to find certain resources.

Note! Some resources need certain ACL rights to work, ACL rights are found in the file _ACL.xml_ located in _mods/deathmatch/_ from your server binaries directory. The easiest way to find and enable these requirements are:
`aclrequest list <resource> all`
followed by:
`aclrequest allow <resource> all`
This will list requirements for a certain resource and then allow the required functionality to be used. This is a built in function which is executed in the server console.
