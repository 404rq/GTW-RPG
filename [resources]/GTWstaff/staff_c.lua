--[[
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

--[[ List of rights ]]--
local acl_table = {
	is_staff 		= nil,
	is_admin 		= nil,
	is_developer 	= nil,
	is_moderator 	= nil,
	is_supporter 	= nil,
}

--[[ Return true if any of the administrative ACLs is assigned ]]--
function isStaff(plr)
	return acl_table.is_staff or false
end

--[[ Return true if a specific administrative ACL is assigned ]]--
function isAdmin(plr)
	return acl_table.is_admin or false
end
function isDeveloper(plr)
	return acl_table.is_developer or false
end
function isModerator(plr)
	return acl_table.is_moderator or false
end
function isSupporter(plr)
	return acl_table.is_supporter or false
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