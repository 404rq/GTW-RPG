To install GTW-RPG resources and start them together with your server, add below lines to 
your servers configuration file. It's located at: "mods/deathmatch/mtaserver.conf" in
your servers root folder.

_Uncomment or overwrite current resources in "mtaserver.conf" if you install this on a new server, also temporary move files away from "mods/deathmatch/resources/" to prevent duplicates._

```xml
    <!-- Important imports -->
    <resource src="GTWtopbar" startup="1" protected="0" />
    <resource src="GTWgui" startup="1" protected="1" />
    <resource src="GTWcore" startup="1" protected="1" />
    
    <!-- Misc resource (non GTW-RPG) Must start before any 
        GTW-RPG resource except those above this line-->
    <resource src="admin" startup="1" protected="0"/>
    <resource src="bone_attach" startup="1" protected="0"/>
    <resource src="fastrope" startup="1" protected="0"/>
    <resource src="glue" startup="1" protected="0"/>
    <resource src="headshot" startup="1" protected="0"/>
    <resource src="heligrab" startup="1" protected="0"/>
    <resource src="killmessages" startup="1" protected="0"/>
    <resource src="parachute" startup="1" protected="0"/>
    <resource src="performancebrowser" startup="1" protected="1"/>
    <resource src="reload" startup="1" protected="1"/>
    <resource src="resourcebrowser" startup="1" protected="1" default="true"/>
    <resource src="resourcemanager" startup="1" protected="1"/>
    <resource src="shader_car_paint_reflect" startup="1" protected="0"/>
    <resource src="shader_detail" startup="1" protected="0"/>
    <resource src="shader_water" startup="1" protected="0"/>
    <resource src="webadmin" startup="1" protected="0"/>
	
    <!-- Misc resource (non GTW-RPG & modified) -->
    <resource src="alternate_hud" startup="1" protected="0" />
    <resource src="cruisespeed" startup="1" protected="0" />
    <resource src="dxmoneylogs" startup="1" protected="0" />
    <resource src="interiors" startup="1" protected="0" />
    <resource src="modshop" startup="1" protected="0" />
    <resource src="modsys" startup="1" protected="0" />
    <resource src="radar_hires" startup="1" protected="0" />
    <resource src="radar_icons" startup="1" protected="0" />
    <resource src="realdriveby" startup="1" protected="0" />
    <resource src="scoreboard" startup="1" protected="0"/>
    <resource src="scorefps" startup="1" protected="0"/>

    <!-- GTW resources -->
    <resource src="GTWaccounts" startup="1" protected="0" />
    <resource src="GTWantispam" startup="1" protected="0" />
    <resource src="GTWbusdriver" startup="1" protected="0" />
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
    <resource src="GTWtraindriver" startup="1" protected="0" />
    <resource src="GTWtrainhorn" startup="1" protected="0" />
    <resource src="GTWtramdriver" startup="1" protected="0" />
    <resource src="GTWturf" startup="1" protected="0" />
    <resource src="GTWturnsignals" startup="1" protected="0" />
    <resource src="GTWupdates" startup="1" protected="0" />
    <resource src="GTWvehicles" startup="1" protected="0" />
    <resource src="GTWvehicleshop" startup="1" protected="0" />
    <resource src="GTWwanted" startup="1" protected="0" />
    <resource src="GTWweather" startup="1" protected="0" />

    <!-- GTW maps -->
    <resource src="GTWbluehellpatch" startup="1" protected="1" />
    <resource src="GTWcoremap" startup="1" protected="1" />
    <resource src="GTWjailmap" startup="1" protected="1" />
    <resource src="GTWsapdbase" startup="1" protected="1" />
    <resource src="GTWswatbase" startup="1" protected="1" />
    
    <!-- Traffic and bots -->
    <resource src="slothbot" startup="1" protected="1" />
    <resource src="npc_traffic" startup="1" protected="1" />
```

Important! do not alter the order, some resorces depends on other resources and must 
therefore be started in certain order. Errors may occur otherwise. When possible, we
use alphabethical order (ascending) to make it easy to find certain resources.

Note! Some resources need certain ACL rights to work, ACL rights are found in the file _ACL.xml_ located in _mods/deathmatch/_ from your server binaries directory. The easiest way to find and enable these requirements are:
`aclrequest list <resource> all`
followed by:
`aclrequest allow <resource> all`
This will list requirements for a certain resource and then allow the required functionality to be used. This is a built in function which is executed in the server console.

For the "lazy" developers, here's a precompiled section of required ACL rights to add in your ACL file located at "_mods/deathmatch/ACL.xml_", ideally right after the opening <acl> tag at line 1. This procedure will allow the resources the access they need to work. Resources will however request their own ACL rights once started. GTWaccounts needs access to create accounts, GTWupdates needs access to callRemote in order to fetch the update list and GTWgui needs the ability to refresh resources using the GUI system to prevent annoying bugs in the GUI causing controls to appear allover the screen when the window is destroyed.

```xml
    <!-- Staff group "supporter" and "developer", you may define your own rights/permissions 
    	for these groups based on your needs, although it's only used by the resource GTWstaff 
    	to check the rights and purpose of various accounts, Admin and Moderator are already 
    	defined standard groups which you can find in the default ACL file -->	
    <group name="Supporter">
        <acl name="Moderator" />
        <!-- List your supporters here -->
        <object name="user.YOUR_ACCOUNT_NAME" />
    </group>
    <group name="Developer">
        <acl name="SuperModerator" />
        <!-- List your developers here -->
        <object name="user.YOUR_ACCOUNT_NAME" />
    </group>
```

For resources with php files included, (currently GTWupdates), upload the php file to a local web server, then look for the call url within the resource and point it to the php file. Included php files allow any server to fetch data from remote servers, something that mtasa servers can't do on their own.

And that's it folks! now your server should be successfully up and running the GTW-RPG gamemode, if not, don't hesitate to ask for support in our forum located at: https://forum.404rq.com/programming-and-software/
