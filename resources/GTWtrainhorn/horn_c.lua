--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.6
	Status:			Stable release
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
	local horn_signal = getElementData(theTrain, "horn") or h_list[math.random(#h_list)]
	for k=1, 20 do
		if getVehicleTowedByVehicle( theTrain ) then
			theTrain2 = getVehicleTowedByVehicle( theTrain )
		end 
		
		if theTrain and (getElementModel(theTrain) == 537 or getElementModel(theTrain) == 538) then
			x,y,z = getElementPosition(theTrain)
			sound[k] = playSound3D(horn_signal, x, y, z, false )
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