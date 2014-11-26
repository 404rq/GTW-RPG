--[[ Make sure all calling resources are up to date ]]--
restartList = {
	"GTWclothes",
	"GTWcivilians",
	"GTWhelp",
	"GTWmechanic",
	"GTWphone",
	"GTWstats",
	"GTWteam",
	"GTWupdates",
	"GTWvehicles"
}

--[[ Check all resources that use this GUI ]]--
for k, v in ipairs(restartList) do
	if getResourceFromName(v) then
		restartResource(getResourceFromName(v))
	end
end

-- Info to online players
exports.GTWtopbar:dm("Restarting GUI system, you may notice some lag for a few seconds, please be patient...", root, 255, 100, 0)