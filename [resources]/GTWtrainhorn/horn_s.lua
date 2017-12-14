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

-- Available sounds
h_list_freight = {
	"x_gp_horn1",
	"x_gp_horn1_alt",
}
h_list_streak = {
	"x_gp_horn1",
	"x_gp_horn1_alt",
}
h_list_tram = {
	"2k_hornh"
}

-- Bink keys to control the horn
function bindTrainHorn(thePlayer, seat, jacked)
	local is_admin = exports.GTWstaff:isAdmin(thePlayer)
    if thePlayer and getElementType(thePlayer) == "player" and (getElementModel(source) == 537 or
    	getElementModel(source) == 538 or getElementModel(source) == 449 or is_admin) then
    	bindKey(thePlayer, "H", "down", toggleTrainHorn)
    	if not getElementData(source, "horn") then
    		if getElementModel(source) == 537 then
    			setElementData(source, "horn", "sound/"..h_list_freight[math.random(#h_list_freight)]..".wav")
    		elseif getElementModel(source) == 538 then
    			setElementData(source, "horn", "sound/"..h_list_streak[math.random(#h_list_streak)]..".wav")
    		elseif getElementModel(source) == 449 then
    			setElementData(source, "horn", "sound/"..h_list_tram[math.random(#h_list_tram)]..".wav")
			else
				setElementData(source, "horn", "sound/"..h_list_freight[math.random(#h_list_freight)]..".wav")
    		end
    	end
    end
end
addEventHandler("onVehicleEnter", root, bindTrainHorn)

-- Toggle the horn sound
function toggleTrainHorn(thePlayer, cmd)
	local train = getPedOccupiedVehicle(thePlayer)
	local is_admin = exports.GTWstaff:isAdmin(thePlayer)
	if train and (getElementModel(train) == 537 or getElementModel(train) == 538 or
		getElementModel(train) == 449 or (is_admin and cmd == "thorn")) and getVehicleOccupants(train)[0] == thePlayer then
		triggerClientEvent(root, "GTWtrainhorn.toggle", thePlayer, train)
	end
end
addCommandHandler("thorn", toggleTrainHorn)

-- Trigger the horn sound
function triggerTrainHorn(theTrain)
	if theTrain and isElement(theTrain) then
		triggerClientEvent(root, "GTWtrainhorn.toggle", theTrain, theTrain)
	end
end

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
