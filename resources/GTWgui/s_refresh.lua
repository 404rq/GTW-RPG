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

--[[ Make sure all calling resources are up to date ]]--
restartList = {
	"GTWaccounts",
	"GTWclothes",
	"GTWcivilians",
	"GTWfastfood",
	"GTWhelp",
	"GTWmechanic",
	"GTWphone",
	"GTWstats",
	"GTWteam",
	"GTWupdates",
	"GTWvehicles",
	"GTWvehicleshop"
}

--[[ Check all resources that use this GUI ]]--
for k, v in ipairs(restartList) do
	if getResourceFromName(v) then
		restartResource(getResourceFromName(v))
	end
end

-- Info to online players
exports.GTWtopbar:dm("Restarting GUI system, you may notice some lag for a few seconds, please be patient...", root, 255, 100, 0)