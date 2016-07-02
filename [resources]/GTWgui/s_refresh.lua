--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- List of resources to refresh
restart_list = { }

--[[ Load list from HDD and apply GUI ]]--
function load_list(res)
	--[[ Load dynamic list of resources to refresh ]]--
	restart_list = getElementData(root, "GTWgui.refreshList")
	--[[ Don't do anything if the table doesn't exist (mainly onResourceStart)]]
	if not resource_list then 
		setTimer( load_list, 2500, 1 )
		return 
	end
	--[[ Restart all resources using this GUI system ]]--
	for k, v in pairs(restart_list) do
		if getResourceFromName(k) then
			restartResource(getResourceFromName(k))
			outputServerLog("GTWgui: refreshed: '"..k.."'")
		end
	end

	--[[ Inform online players that this refresh may cause some lag ]]--
	if not getResourceFromName("GTWtopbar") then return end
	exports.GTWtopbar:dm("Restarting GUI system, you may notice some lag for a few seconds, please be patient...", root, 255, 100, 0)
end
addEventHandler("onResourceStart", resourceRoot, load_list)

--[[ Save refresh array in HDD ]]--
function save_list(res)
	setElementData(root, "GTWgui.refreshList", restart_list)
end
addEventHandler("onResourceStop", resourceRoot, save_list)

--[[ Add missing resource to dynamic refresh list
  	Use: exports, triggerEvent or triggerServerEvent
	(client) to add a resource ]]--
function addToRefreshList(res_str)
	restartList[res_str]=true
end
addEvent("GTWgui.addToRefreshList", true)
addEventHandler("GTWgui.addToRefreshList", resourceRoot, addToRefreshList)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
