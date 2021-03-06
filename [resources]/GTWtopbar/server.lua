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

--[[ Dispaly a DX topbar message ]]--
function dm(text, plr, r,g,b, col, bell)
	if col == nil then col = false end
	if bell then playSoundFrontEnd(plr, 11) end
	if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end
	triggerClientEvent(plr, "GTWtopbar.addText", root, text, r,g,b, col)
end

--[[ Display basic information ]]--
addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
