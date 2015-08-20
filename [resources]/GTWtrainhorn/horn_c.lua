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

-- Available sounds
h_list_freight = {
	"x_gp_horn1",
	"x_gp_horn1_alt",
	"gp_horn1"
}
h_list_streak = {
	"k31_horn1",
	"2k_hornl",
	"7k_hornl"
}
h_list_tram = {
	"k31_horn1"
}

-- Toggle the horn sound
sound = {}
function toggleTrainHorn(theTrain)
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

		if theTrain and (getElementModel(theTrain) == 537 or getElementModel(theTrain) == 538 or
			getElementModel(theTrain) == 449 or getVehicleOccupant(theTrain)) then
			x,y,z = getElementPosition(theTrain)
			sound[k] = playSound3D(horn_signal, x, y, z, false )
			setSoundVolume(sound[k], 0.25)
			attachElements(sound[k], theTrain)
			setSoundMaxDistance( sound[k], 400 )
		end

		if not getVehicleTowedByVehicle( theTrain ) then
			return
		end

		theTrain = theTrain2
	end
end
addEvent( "GTWtrainhorn.toggle", true )
addEventHandler( "GTWtrainhorn.toggle", root, toggleTrainHorn )
