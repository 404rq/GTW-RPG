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

--[[ Time to open/close any door ]]--
time_to_switch 	= 700

--[[ Close all the doors ]]--
function close_doors(source)
	local vehicle = getPedOccupiedVehicle(source)
	if vehicle then
		if getVehicleOccupant(vehicle, 0) ~= source then return end
		for i=0,5 do
			-- Cloose the doors
			setVehicleDoorOpenRatio(vehicle, i, 0, time_to_switch)
		end
	end
end
addCommandHandler("cd", close_doors)

--[[ Open all the doors ]]--
function open_doors(source)
	local vehicle = getPedOccupiedVehicle(source)
	if vehicle then
		if getVehicleOccupant(vehicle, 0) ~= source then return end
		for i=0,5 do
			-- Cloose the doors
			setVehicleDoorOpenRatio(vehicle, i, 1, time_to_switch)
		end
	end
end
addCommandHandler("od", open_doors)

--[[ Manage doors individually (open/close) TODO: minimize this block of code ]]--
function control_individual_doors(source, command)
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle or getVehicleOccupant(vehicle, 0) ~= source then return end
	if command == "cd0" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 0, 0, time_to_switch)
	elseif command == "cd1" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 1, 0, time_to_switch)
	elseif command == "cd2" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 2, 0, time_to_switch)
	elseif command == "cd3" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 3, 0, time_to_switch)
	elseif command == "cd4" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 4, 0, time_to_switch)
	elseif command == "cd5" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 5, 0, time_to_switch)
	elseif command == "od0" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 0, 1, time_to_switch)
	elseif command == "od1" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 1, 1, time_to_switch)
	elseif command == "od2" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 2, 1, time_to_switch)
	elseif command == "od3" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 3, 1, time_to_switch)
	elseif command == "od4" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 4, 1, time_to_switch)
	elseif command == "od5" and vehicle then
		setVehicleDoorOpenRatio(vehicle, 5, 1, time_to_switch)
	end
end
addCommandHandler("cd0", control_individual_doors)
addCommandHandler("cd1", control_individual_doors)
addCommandHandler("cd2", control_individual_doors)
addCommandHandler("cd3", control_individual_doors)
addCommandHandler("cd4", control_individual_doors)
addCommandHandler("cd5", control_individual_doors)
addCommandHandler("od0", control_individual_doors)
addCommandHandler("od1", control_individual_doors)
addCommandHandler("od2", control_individual_doors)
addCommandHandler("od3", control_individual_doors)
addCommandHandler("od4", control_individual_doors)
addCommandHandler("od5", control_individual_doors)
