------------------------------------------------------------------------------------
--	PROJECT:			Business System v1.2
--	RIGHTS:				All rights reserved by developers
-- FILE:						business/server/updatecheck.lua
--	PURPOSE:			Check for released updates for the resource
--	DEVELOPERS:	JR10
------------------------------------------------------------------------------------

function onResourceStart()
	local function getVersionCallback(name, version)
		if name:lower():find("error") or version == 0 then return end
		checkForUpdate(version)
	end
	callRemote("http://community.mtasa.com/mta/resources.php", getVersionCallback, "version", "business")
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function checkForUpdate(version)
	local rv1, rv2, rv3 = unpack(split(version, "."))
	local v1, v2, v3 = unpack(split(getResourceInfo(resource, "version"), "."))
	if not rv3 then rv3 = 0 end
	if not v3 then v3 = 0 end
	rv1, rv2, rv3, v1, v2, v3 = tonumber(rv1), tonumber(rv2), tonumber(rv3), tonumber(v1), tonumber(v2), tonumber(v3)
	if rv1 and v1 then
		if rv1 > v1 then
			outputDebugString("Business System v"..getResourceInfo(resource, "version").." is outdated, v"..version.." is released. Be sure to download it.", 3)
		elseif rv2 > v2 and rv1 >= v1 then
			outputDebugString("Business System v"..getResourceInfo(resource, "version").." is outdated, v"..version.." is released. Be sure to download it.", 3)
		elseif rv3 > v3 and rv2 >= v2 and rv1 >= v1 then
			outputDebugString("Business System v"..getResourceInfo(resource, "version").." is outdated, v"..version.." is released. Be sure to download it.", 3)
		end
	end
end