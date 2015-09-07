--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Price

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

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
		if WeedAmount > 0 then setElementData(source, "Weed", (getElementData(source, "Weed") or 0) + WeedAmount) end
		if GodAmount > 0 then setElementData(source, "God", (getElementData(source, "God") or 0) + GodAmount) end
		if SpeedAmount > 0 then setElementData(source, "Speed", (getElementData(source, "Speed") or 0) + SpeedAmount) end
		if LSDAmount > 0 then setElementData(source, "LSD", (getElementData(source, "LSD") or 0) + LSDAmount) end
		if SteroidsAmount > 0 then setElementData(source, "Steroids", (getElementData(source, "Steroids") or 0) + SteroidsAmount) end
		if HeroinAmount > 0 then setElementData(source, "Heroin", (getElementData(source, "Heroin") or 0) + HeroinAmount) end
		exports.GTWtopbar:dm(drugDealer and "You bought Drugs from "..getPlayerName(drugDealer).." for $"..Cost.."." or "You bought Drugs for $"..Cost..".", source, 0, 255, 0)
		if drugDealer then
			givePlayerMoney(drugDealer, Cost)
			exports.GTWtopbar:dm(getPlayerName(source).." has bought from you Drugs for $"..Cost..".", drugDealer, 0, 255, 0)
			local MaxWeed = getElementData(drugDealer, "Weed") or 0
			local MaxGod = getElementData(drugDealer, "God") or 0
			local MaxSpeed = getElementData(drugDealer, "Speed") or 0
			local MaxLSD = getElementData(drugDealer, "LSD") or 0
			local MaxSteroids = getElementData(drugDealer, "Steroids") or 0
			local MaxHeroin = getElementData(drugDealer, "Heroin") or 0
			if MaxWeed >= WeedAmount then
				setElementData(drugDealer, "Weed", (getElementData(drugDealer, "Weed") or 0) - WeedAmount)
			else
				setElementData(drugDealer, "Weed", 0)
			end
			if MaxGod >= GodAmount then
				setElementData(drugDealer, "God", (getElementData(drugDealer, "God") or 0) - GodAmount)
			else
				setElementData(drugDealer, "God", 0)
			end
			if MaxSpeed >= SpeedAmount then
				setElementData(drugDealer, "Speed", (getElementData(drugDealer, "Speed") or 0) - SpeedAmount)
			else
				setElementData(drugDealer, "Speed", 0)
			end
			if MaxLSD >= LSDAmount then
				setElementData(drugDealer, "LSD", (getElementData(drugDealer, "LSD") or 0) - LSDAmount)
			else
				setElementData(drugDealer, "LSD", 0)
			end
			if MaxSteroids >= SteroidsAmount then
				setElementData(drugDealer, "Steroids", (getElementData(drugDealer, "Steroids") or 0) - SteroidsAmount)
			else
				setElementData(drugDealer, "Steroids", 0)
			end
			if MaxHeroin >= HeroinAmount then
				setElementData(drugDealer, "Heroin", (getElementData(drugDealer, "Heroin") or 0) - HeroinAmount)
			else
				setElementData(drugDealer, "Heroin", 0)
			end
		end
	else
		exports.GTWtopbar:dm("You don't have enough money to buy the drugs!", source, 255, 0, 0)
	end
end)

sellMarkers = {}

addCommandHandler("selldrugs",
function(plr)
	if not getPlayerTeam(plr) or getPlayerTeam(plr) ~= getTeamFromName("Criminals") then return end
 	if isElement(sellMarkers[plr]) then
		destroyElement(sellMarkers[plr])
		sellMarkers[plr] = nil
		setElementData(plr, "DurgsDealer", false)
		setElementFrozen(plr, false)
		toggleAllControls(plr, true)
		setPedAnimation(plr, false)
		exports.GTWtopbar:dm("Drugs: You're no longer selling drugs", plr, 255, 100, 0)
		bindKey(plr, "w", "down", "selldrugs")
	else
		local MaxWeed = getElementData(plr, "Weed") or 0
		local MaxGod = getElementData(plr, "God") or 0
		local MaxSpeed = getElementData(plr, "Speed") or 0
		local MaxLSD = getElementData(plr, "LSD") or 0
		local MaxSteroids = getElementData(plr, "Steroids") or 0
		local MaxHeroin = getElementData(plr, "Heroin") or 0
		if MaxWeed <= 0 and MaxGod <= 0 and MaxSpeed <= 0 and MaxLSD <= 0 and MaxSteroids <= 0 and MaxHeroin <= 0 then
			exports.GTWtopbar:dm("You don't have any drugs to sell!", plr, 255, 0, 0)
		else
			local x, y, z = getElementPosition(plr)
			sellMarkers[plr] = createMarker(x, y, z-1, "cylinder", 1, 255, 0, 255, 0)
			setElementData(sellMarkers[plr], "sellDrugMarker", plr)
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
	if type == "God" then
		setPedStat(source, 24, arg1)
	end
end)

addEventHandler("onPlayerQuit", root,
function()
	local account = getPlayerAccount(source)
	if account and not isGuestAccount(account) then
		local WeedAmount = getElementData(source, "Weed") or 0
		local GodAmount = getElementData(source, "God") or 0
		local SpeedAmount = getElementData(source, "Speed") or 0
		local LSDAmount = getElementData(source, "LSD") or 0
		local SteroidsAmount = getElementData(source, "Steroids") or 0
		local HeroinAmount = getElementData(source, "Heroin") or 0
		setAccountData(account, "Weed", WeedAmount)
		setAccountData(account, "God", GodAmount)
		setAccountData(account, "Speed", SpeedAmount)
		setAccountData(account, "LSD", LSDAmount)
		setAccountData(account, "Steroids", SteroidsAmount)
		setAccountData(account, "Heroin", HeroinAmount)
		if isElement(sellMarkers[source]) then
			destroyElement(sellMarkers[source])
			sellMarkers[source] = nil
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
	local WeedAmount = getAccountData(account, "Weed") or 0
	local GodAmount = getAccountData(account, "God") or 0
	local SpeedAmount = getAccountData(account, "Speed") or 0
	local LSDAmount = getAccountData(account, "LSD") or 0
	local SteroidsAmount = getAccountData(account, "Steroids") or 0
	local HeroinAmount = getAccountData(account, "Heroin") or 0
	setElementData(source, "Weed", WeedAmount)
	setElementData(source, "God", GodAmount)
	setElementData(source, "Speed", SpeedAmount)
	setElementData(source, "LSD", LSDAmount)
	setElementData(source, "Steroids", SteroidsAmount)
	setElementData(source, "Heroin", HeroinAmount)
end)
