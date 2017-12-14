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

-- Toggle the horn sound
sound = {}
function toggle_train_horn(theTrain)
	local theTrain2 = nil
	local horn_signal = getElementData(theTrain, "horn")
	if not horn_signal and getElementModel(theTrain) == 537 then
		horn_signal = "sound/"..h_list_freight[math.random(#h_list_freight)]..".wav"
	elseif not horn_signal and getElementModel(theTrain) == 538 then
		horn_signal = "sound/"..h_list_streak[math.random(#h_list_streak)]..".wav"
	elseif not horn_signal and getElementModel(theTrain) == 449 then
		horn_signal = "sound/"..h_list_tram[math.random(#h_list_tram)]..".wav"
	end
	if not getElementData(theTrain, "horn") then
		setElementData(theTrain, "horn", horn_signal)
	end
	for k=1, 20 do
		if getVehicleTowedByVehicle( theTrain ) then
			theTrain2 = getVehicleTowedByVehicle( theTrain )
		end

		if theTrain and getVehicleOccupant(theTrain) then
			x,y,z = getElementPosition(theTrain)
			sound[k] = playSound3D(horn_signal, x, y, z, false )
			setSoundVolume(sound[k], 0.5)
			attachElements(sound[k], theTrain)
			setSoundMaxDistance( sound[k], 400 )
		end

		if not getVehicleTowedByVehicle( theTrain ) then
			return
		end

		theTrain = theTrain2
	end
end
addEvent("GTWtrainhorn.toggle", true)
addEventHandler("GTWtrainhorn.toggle", root, toggle_train_horn)
