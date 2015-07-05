for i, v in ipairs(getElementsByType("player")) do
	setElementData(v, "PlayerIpAddress", getPlayerIP(v))
end

addEventHandler("onPlayerJoin", root, function ()
	setElementData(source, "PlayerIpAddress", getPlayerIP(source))
end)