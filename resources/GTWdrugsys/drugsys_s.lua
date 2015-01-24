--[[
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode, Price (Contributor)
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
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

addCommandHandler("sell",
function(player)
	if isElement(sellMarkers[player]) then
		destroyElement(sellMarkers[player])
		sellMarkers[player] = nil
		setElementData(player, "DurgsDealer", false)
		setElementFrozen(player, false)
		toggleAllControls(player, true)
		setPedAnimation(player, false)
		exports.GTWtopbar:dm("Sell drug is off", player, 255, 0, 0)
	else
		local MaxWeed = getElementData(player, "Weed") or 0
		local MaxGod = getElementData(player, "God") or 0
		local MaxSpeed = getElementData(player, "Speed") or 0
		local MaxLSD = getElementData(player, "LSD") or 0
		local MaxSteroids = getElementData(player, "Steroids") or 0
		local MaxHeroin = getElementData(player, "Heroin") or 0
		if MaxWeed <= 0 and MaxGod <= 0 and MaxSpeed <= 0 and MaxLSD <= 0 and MaxSteroids <= 0 and MaxHeroin <= 0 then
			exports.GTWtopbar:dm("You don't have any drugs to sell!", player, 255, 0, 0)
		else
			local x, y, z = getElementPosition(player)
			sellMarkers[player] = createMarker(x, y, z-1, "cylinder", 1, 255, 0, 255, 0)
			setElementData(sellMarkers[player], "sellDrugMarker", player)
			setElementData(player, "DurgsDealer", true)
			setElementFrozen(player, true)
			toggleAllControls(player, false, true, false)
			setPedAnimation(player, "DEALER", "DEALER_IDLE", -1, true, false)
			exports.GTWtopbar:dm("Sell drug is on", player, 0, 255, 0)
		end
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