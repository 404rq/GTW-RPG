--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Price

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

sec = {{{{{{},{},{},{}}}}}}

addEvent("BuyDrugs", true)
addEventHandler("BuyDrugs", root,
function(Cost, WeedAmount, GodAmount, SpeedAmount, LSDAmount, SteroidsAmount, HeroinAmount, drugDealer)
	if getPlayerMoney(source) >= tonumber(Cost) then
		takePlayerMoney(source, Cost)
		if WeedAmount > 0 then setElementData(source, "GTWdrugs.weed", (getElementData(source, "GTWdrugs.weed") or 0) + WeedAmount) end
		if GodAmount > 0 then setElementData(source, "GTWdrugs.god", (getElementData(source, "GTWdrugs.god") or 0) + GodAmount) end
		if SpeedAmount > 0 then setElementData(source, "GTWdrugs.speed", (getElementData(source, "GTWdrugs.speed") or 0) + SpeedAmount) end
		if LSDAmount > 0 then setElementData(source, "GTWdrugs.lsd", (getElementData(source, "GTWdrugs.lsd") or 0) + LSDAmount) end
		if SteroidsAmount > 0 then setElementData(source, "GTWdrugs.steroids", (getElementData(source, "GTWdrugs.steroids") or 0) + SteroidsAmount) end
		if HeroinAmount > 0 then setElementData(source, "GTWdrugs.heroin", (getElementData(source, "GTWdrugs.heroin") or 0) + HeroinAmount) end
		exports.GTWtopbar:dm(drugDealer and "You bought Drugs from "..getPlayerName(drugDealer).." for $"..Cost.."." or "You bought Drugs for $"..Cost..".", source, 0, 255, 0)
		if drugDealer then
			givePlayerMoney(drugDealer, Cost)
			exports.GTWtopbar:dm(getPlayerName(source).." has bought from you Drugs for $"..Cost..".", drugDealer, 0, 255, 0)
			local MaxWeed = getElementData(drugDealer, "GTWdrugs.weed") or 0
			local MaxGod = getElementData(drugDealer, "GTWdrugs.god") or 0
			local MaxSpeed = getElementData(drugDealer, "GTWdrugs.speed") or 0
			local MaxLSD = getElementData(drugDealer, "GTWdrugs.lsd") or 0
			local MaxSteroids = getElementData(drugDealer, "GTWdrugs.steroids") or 0
			local MaxHeroin = getElementData(drugDealer, "GTWdrugs.heroin") or 0
			if MaxWeed >= WeedAmount then
				setElementData(drugDealer, "GTWdrugs.weed", (getElementData(drugDealer, "GTWdrugs.weed") or 0) - WeedAmount)
			else
				setElementData(drugDealer, "GTWdrugs.weed", 0)
			end
			if MaxGod >= GodAmount then
				setElementData(drugDealer, "GTWdrugs.god", (getElementData(drugDealer, "GTWdrugs.god") or 0) - GodAmount)
			else
				setElementData(drugDealer, "GTWdrugs.god", 0)
			end
			if MaxSpeed >= SpeedAmount then
				setElementData(drugDealer, "GTWdrugs.speed", (getElementData(drugDealer, "GTWdrugs.speed") or 0) - SpeedAmount)
			else
				setElementData(drugDealer, "GTWdrugs.speed", 0)
			end
			if MaxLSD >= LSDAmount then
				setElementData(drugDealer, "GTWdrugs.lsd", (getElementData(drugDealer, "GTWdrugs.lsd") or 0) - LSDAmount)
			else
				setElementData(drugDealer, "GTWdrugs.lsd", 0)
			end
			if MaxSteroids >= SteroidsAmount then
				setElementData(drugDealer, "GTWdrugs.steroids", (getElementData(drugDealer, "GTWdrugs.steroids") or 0) - SteroidsAmount)
			else
				setElementData(drugDealer, "GTWdrugs.steroids", 0)
			end
			if MaxHeroin >= HeroinAmount then
				setElementData(drugDealer, "GTWdrugs.heroin", (getElementData(drugDealer, "GTWdrugs.heroin") or 0) - HeroinAmount)
			else
				setElementData(drugDealer, "GTWdrugs.heroin", 0)
			end
		end
	else
		exports.GTWtopbar:dm("You don't have enough money to buy the drugs!", source, 255, 0, 0)
	end
end)

sell_markers = {}

addCommandHandler("selldrugs",
function(plr)
	if not getPlayerTeam(plr) or getPlayerTeam(plr) ~= getTeamFromName("Criminals") then return end
 	if isElement(sell_markers[plr]) then
		destroyElement(sell_markers[plr])
		sell_markers[plr] = nil
		setElementData(plr, "DurgsDealer", false)
		setElementFrozen(plr, false)
		toggleAllControls(plr, true)
		setPedAnimation(plr, false)
		exports.GTWtopbar:dm("Drugs: You're no longer selling drugs", plr, 255, 100, 0)
		bindKey(plr, "w", "down", "selldrugs")
	else
		local MaxWeed = getElementData(plr, "GTWdrugs.weed") or 0
		local MaxGod = getElementData(plr, "GTWdrugs.god") or 0
		local MaxSpeed = getElementData(plr, "GTWdrugs.speed") or 0
		local MaxLSD = getElementData(plr, "GTWdrugs.lsd") or 0
		local MaxSteroids = getElementData(plr, "GTWdrugs.steroids") or 0
		local MaxHeroin = getElementData(plr, "GTWdrugs.heroin") or 0
		if MaxWeed <= 0 and MaxGod <= 0 and MaxSpeed <= 0 and MaxLSD <= 0 and MaxSteroids <= 0 and MaxHeroin <= 0 then
			exports.GTWtopbar:dm("You don't have any drugs to sell!", plr, 255, 0, 0)
		else
			local x, y, z = getElementPosition(plr)
			sell_markers[plr] = createMarker(x, y, z-1, "cylinder", 1, 255, 0, 255, 0)
			setElementData(sell_markers[plr], "sellDrugMarker", plr)
			setElementData(plr, "DurgsDealer", true)
			setElementFrozen(plr, true)
			toggleAllControls(plr, false, true, false)
			setPedAnimation(plr, "DEALER", "DEALER_IDLE", -1, true, false)
			exports.GTWtopbar:dm("Drugs: You're selling drugs, use /sell to stop selling", plr, 255, 100, 0)
		end
		unbindKey(plr, "w", "down", "selldrugs")
	end
end)

addEvent("takeDrug", true)
addEventHandler("takeDrug", root,
function(type, arg1)
	if type == "GTWdrugs.god" then
		setPedStat(source, 24, arg1)
	end
end)

addEventHandler("onPlayerQuit", root,
function()
	local account = getPlayerAccount(source)
	if account and not isGuestAccount(account) then
		local WeedAmount = getElementData(source, "GTWdrugs.weed") or 0
		local GodAmount = getElementData(source, "GTWdrugs.god") or 0
		local SpeedAmount = getElementData(source, "GTWdrugs.speed") or 0
		local LSDAmount = getElementData(source, "GTWdrugs.lsd") or 0
		local SteroidsAmount = getElementData(source, "GTWdrugs.steroids") or 0
		local HeroinAmount = getElementData(source, "GTWdrugs.heroin") or 0
		exports.GTWcore:set_account_data(account, "GTWdrugs.weed", getElementData(source, "GTWdrugs.weed") or 0)
		exports.GTWcore:set_account_data(account, "GTWdrugs.god", getElementData(source, "GTWdrugs.god") or 0)
		exports.GTWcore:set_account_data(account, "GTWdrugs.speed", getElementData(source, "GTWdrugs.speed") or 0)
		exports.GTWcore:set_account_data(account, "GTWdrugs.lsd", getElementData(source, "GTWdrugs.lsd") or 0)
		exports.GTWcore:set_account_data(account, "GTWdrugs.steroids", getElementData(source, "GTWdrugs.steroids") or 0)
		exports.GTWcore:set_account_data(account, "GTWdrugs.heroin", getElementData(source, "GTWdrugs.heroin") or 0)
		if isElement(sell_markers[source]) then
			destroyElement(sell_markers[source])
			sell_markers[source] = nil
		end
	end
end)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

addEventHandler("onPlayerLogin", root,
function(_, account)
	local WeedAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.weed") or 0
	local GodAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.god") or 0
	local SpeedAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.speed") or 0
	local LSDAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.lsd") or 0
	local SteroidsAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.steroids") or 0
	local HeroinAmount = exports.GTWcore:get_account_data(account, "GTWdrugs.heroin") or 0
	setElementData(source, "GTWdrugs.weed", WeedAmount)
	setElementData(source, "GTWdrugs.god", GodAmount)
	setElementData(source, "GTWdrugs.speed", SpeedAmount)
	setElementData(source, "GTWdrugs.lsd", LSDAmount)
	setElementData(source, "GTWdrugs.steroids", SteroidsAmount)
	setElementData(source, "GTWdrugs.heroin", HeroinAmount)
end)
