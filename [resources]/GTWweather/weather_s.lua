--[[
********************************************************************************
Project owner:		RageQuit community
Project name: 		GTW-RPG
Developers:   		Mr_Moose

Source code:		https://github.com/404rq/GTW-RPG/
Bugtracker: 		https://discuss.404rq.com/t/issues
Suggestions:		https://discuss.404rq.com/t/development

Version:    		Open source
License:    		BSD 2-Clause
Status:     		Stable release
********************************************************************************
]]--

-- Remove speed blur level
for k,v in pairs(getElementsByType("player")) do
	setPlayerBlurLevel(v, 0)
end
function remove_speed_blur(old_acc, acc)
	setPlayerBlurLevel(source, 0)
end
addEventHandler("onPlayerLogin", root, remove_speed_blur)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
	getThisResource(), "author")..", v-"..getResourceInfo(
	getThisResource(), "version")..", is represented", plr)
end)
