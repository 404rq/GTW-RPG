--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

-- Available sounds
local h_list = {
	"x_d9_horn1",
	"2k_hornl",
	"2k_hornh",
	"7k_hornl",
	"7k_hornh"
}

-- Toggle the horn sound
sound = {}
function toggleTrainHorn(theTrain)
	local theTrain2 = nil
	local horn_signal = getElementData(theTrain, "horn") or "sound/"..h_list[math.random(#h_list)]..".wav"
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
			setSoundVolume(sound[k], 0.3)
			attachElements(sound[k], theTrain)
			setSoundMaxDistance( sound[k], 500 )	
		end
		
		if not getVehicleTowedByVehicle( theTrain ) then
			return
		end
		
		theTrain = theTrain2
	end
end
addEvent( "GTWtrainhorn.toggle", true )
addEventHandler( "GTWtrainhorn.toggle", root, toggleTrainHorn )