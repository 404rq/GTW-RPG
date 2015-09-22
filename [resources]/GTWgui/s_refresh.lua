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

-- List of resources to refresh
restartList = { }

--[[ Load list from HDD and apply GUI ]]--
function loadList( )
	--[[ Load dynamic list of resources to refresh ]]--
	--local settings_store = getAccount("SETTINGS")
	--restartList = getAccountData(settings_store, "resources_to_refresh")

	--[[ Predefined static list of resources to refresh ]]--
	--[[restartList = {
		["GTWaccounts"]=true,
		["GTWammunation"]=true,
		["GTWbusdriver"]=true,
		["GTWclothes"]=true,
		["GTWcivilians"]=true,
		["GTWfastfood"]=true,
		["GTWgroups"]=true,
		["GTWhelp"]=true,
		["GTWmechanic"]=true,
		["GTWphone"]=true,
		["GTWstats"]=true,
		["GTWteam"]=true,
		["GTWtransport"]=true,
		["GTWupdates"]=true,
		["GTWvehicles"]=true,
		["GTWvehicleshop"]=true
	}]]

	--[[ Check all resources that use this GUI ]]--
	for k, v in pairs(restartList) do
		if getResourceFromName(k) then
			restartResource(getResourceFromName(k))
			outputServerLog("GTWgui: refreshed: '"..k.."'")
		end
	end

	--[[ Inform online players that this refresh may cause some lag ]]--
	if not getResourceFromName("GTWtopbar") then return end
	exports.GTWtopbar:dm("Restarting GUI system, you may notice some lag for a few seconds, please be patient...", root, 255, 100, 0)
end
addEventHandler("onResourceStart", resourceRoot, loadList)

--[[ Save refresh array in HDD ]]--
function saveList( )
	local settings_store = getAccount("SETTINGS")
	setAccountData(settings_store, "resources_to_refresh", restartList)
end
addEventHandler("onResourceStop", resourceRoot, saveList)

--[[ Add missing resource to dynamic refresh list ]]--
function addToRefreshList(res)
	restartList[res]=true
end
addEvent("GTWgui.addToRefreshList", true)
addEventHandler("GTWgui.addToRefreshList", resourceRoot, addToRefreshList)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
