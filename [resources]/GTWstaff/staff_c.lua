--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ List of rights ]]--
local acl_table = {
	is_staff 	= { },
	is_admin 	= { },
	is_developer 	= { },
	is_moderator 	= { },
	is_supporter 	= { },
}

--[[ Return true if any of the administrative ACLs is assigned ]]--
function isStaff(plr)
	if not plr then plr = localPlayer end
	return acl_table.is_staff[plr] or false
end

--[[ Return true if a specific administrative ACL is assigned ]]--
function isAdmin(plr)
	if not plr then plr = localPlayer end
	return acl_table.is_admin[plr] or false
end
function isDeveloper(plr)
	if not plr then plr = localPlayer end
	return acl_table.is_developer[plr] or false
end
function isModerator(plr)
	if not plr then plr = localPlayer end
	return acl_table.is_moderator[plr] or false
end
function isSupporter(plr)
	if not plr then plr = localPlayer end
	return acl_table.is_supporter[plr] or false
end

--[[ Request rights from the server ]]--
function assign_rights_request(staff, admin, developer, moderator, supporter)
    	acl_table.is_staff = staff
    	acl_table.is_admin = admin
    	acl_table.is_developer = developer
    	acl_table.is_moderator = moderator
    	acl_table.is_supporter = supporter
end
addEvent("GTWstaff.sendToClient", true)
addEventHandler("GTWstaff.sendToClient", localPlayer, assign_rights_request)
