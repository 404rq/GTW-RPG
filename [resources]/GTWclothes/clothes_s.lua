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

-- Storage for skins
t_skins 			= { }
t_skins.all_skins 	= { }
t_skins.by_category = { }

--[[ Initialize and load all the skins from XML ]]--
function initialize_skins()
	local xml = xmlLoadFile("skin_data.xml")
	for i1, category in pairs(xmlNodeGetChildren(xml)) do
		local c_name = xmlNodeGetAttribute(category, "name")
		t_skins.by_category[c_name] = {}
		for i2, skin in pairs(xmlNodeGetChildren(category)) do
			local id, name = xmlNodeGetAttribute(skin, "model"), xmlNodeGetAttribute(skin, "name")
			t_skins.by_category[c_name][id] = name
			t_skins.all_skins[id] = name
		end
	end
	xmlUnloadFile(xml)
end
addEventHandler("onResourceStart", resourceRoot, initialize_skins)

--[[ Return available skins from table ]]--
function get_skins(category)
	if not category then
		return  t_skins.by_category or false
	elseif category == "all" then
		return t_skins.all_skins or false
	else
		return t_skins[category] or false
	end
	return false
end

--[[ Initialize the skin shops ]]--
function make_the_shop()
	for i, shop in pairs(shops) do
		local x, y, z, int, dim, type = shop.x, shop.y, shop.z, shop.int, shop.dim, shop.type
		marker = createMarker(x, y, z, "cylinder", 1.5, 255, 255, 255, 30)
		setElementInterior(marker, int)
		setElementDimension(marker, dim)
		if type == 2 then
			setElementAlpha(marker,0)
		end
		addEventHandler("onMarkerHit", marker, on_marker_hit)
	end
	for i2, shop_blip in pairs(shop_blips) do
		local x, y, z = shop_blip.x, shop_blip.y, shop_blip.z
		blip = createBlip( x, y, z, 45, 2, 0, 0, 0, 255, 2, 180 )
	end
end
addEventHandler("onResourceStart", resourceRoot, make_the_shop)

--[[ On entering the shop ]]--
function on_marker_hit(plr, matchingDim)
	if (plr and getElementType(plr) == "player" and matchingDim) then
		local skins = get_skins()
		triggerClientEvent(plr, "GTWclothes.show_skin", plr, skins)
	end
end

--[[ On client request buy skin ]]--
function buy_the_skin(model)
	if getPlayerMoney(client) >= 50 then
		takePlayerMoney(client, 50)
		exports.GTWtopbar:dm("You have succesfully bought a new skin!", client, 0, 255, 0)
		setAccountData(getPlayerAccount(client), "GTWclothes.personal.skin", model)
		setElementData(client, "GTWclothes.personal.skin", model)
		-- Save skin to account if user is logged in
		if getPlayerAccount(client) then
			setAccountData(getPlayerAccount(client), "GTWclothes.personal.skin", model)
		end
		setElementModel(client, model)
	else
		exports.GTWtopbar:dm( "Feck off you little pleb, get yourself some cash before you come back.", client, 255, 0, 0 )
	end
end
addEvent("GTWclothes.buy_the_skin", true)
addEventHandler("GTWclothes.buy_the_skin", root, buy_the_skin)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

--[[ Exported function to get the current skin ]]--
function getBoughtSkin(plr)
	if not isElement(plr) then return nil end
	return tonumber(getAccountData(getPlayerAccount(plr), "GTWclothes.personal.skin")) or getElementModel(plr) or 0
end

--[[ Save the skin as element data ]]--
function save_skin( )
	setElementData(source, "GTWclothes.personal.skin", getBoughtSkin(source))
end
addEventHandler("onPlayerLogin", root, save_skin)
