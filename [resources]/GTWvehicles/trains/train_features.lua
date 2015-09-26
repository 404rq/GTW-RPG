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

-- Turn a train around
function turnTrain(plr, command)
	local train_engine = getPedOccupiedVehicle(plr)
	if train_engine and getElementType(train_engine) == "vehicle" and
		getVehicleType(train_engine) == "Train" and math.abs(getTrainSpeed(train_engine)) < 0.01 then
		setTrainDirection(train_engine, not getTrainDirection(train_engine))
		exports.GTWtopbar:dm("Successfully turned the train", plr, 0, 255, 0)
	elseif train_engine and getElementType(train_engine) == "vehicle" and
		getVehicleType(train_engine) == "Train" and math.abs(getTrainSpeed(train_engine)) >= 0.01 then
		exports.GTWtopbar:dm("Stop the train before turning it's direction!", plr, 255, 0, 0)
	end
end
addCommandHandler("turntrain", turnTrain)
