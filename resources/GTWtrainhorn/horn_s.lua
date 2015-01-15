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

-- Bink keys to control the horn
function bindTrainHorn(thePlayer, seat, jacked)
    if (getVehicleType(source) == "Train" or getElementData(thePlayer, "anon")) and getElementType(thePlayer) == "player" then
    	bindKey(thePlayer, "H", "down", toggleTrainHorn)
    	if not getElementData(source, "horn") then
    		setElementData(source, "horn", "sound/"..h_list[math.random(#h_list)]..".wav")
    	end
    end
end
addEventHandler("onVehicleEnter", root, bindTrainHorn) 

-- Toggle the horn sound
function toggleTrainHorn(thePlayer, cmd)
	if getPedOccupiedVehicle(thePlayer) and (getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Train" or getElementData(thePlayer, "anon")) then
		triggerClientEvent(root, "GTWtrainhorn.toggle", thePlayer, getPedOccupiedVehicle(thePlayer))
	end
end

-- Trigger the horn sound
function triggerTrainHorn(theTrain)
	if theTrain and isElement(theTrain) then
		triggerClientEvent(root, "GTWtrainhorn.toggle", theTrain, theTrain)
	end
end