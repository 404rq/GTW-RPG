--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Flat tires for a random player, the risk is
	higher the faster the player is driving ]]--
setTimer(function()
	-- Define emergency vehicles
	local em_vehs = {
		[416]=true,
		[433]=true,
		[427]=true,
		[490]=true,
		[528]=true,
		[407]=true,
		[544]=true,
		[523]=true,
		[470]=true,
		[598]=true,
		[596]=true,
		[597]=true,
		[599]=true,
		[432]=true,
		[601]=true,
		[428]=true
	}

	-- Get a random victim player
	local plr = getRandomPlayer()
	if not plr or not isElement(plr) or not getPedOccupiedVehicle(plr) then return end

	-- Make sure the player is driving faster
	local veh = getPedOccupiedVehicle(plr)
	if not getVehicleType(getElementModel(veh)) == "Automobile" and
		not getVehicleType(getElementModel(veh)) == "Bike" and 
		not getVehicleType(getElementModel(veh)) == "Trailer" then return end

	-- Get a random wheel
	local rnd_wheel = math.random(1,4)
	local x,y,z = getElementVelocity(plr)
	local actualspeed = (x^2 + y^2 + z^2)^(0.5)
	local kmh = actualspeed * 180

	-- Get the chance of occurance
	local rnd_chance = math.random(1,20000)
	if rnd_chance > kmh or kmh < 70 or em_vehs[getElementModel(veh)] then return end

	-- Flatten the tire
	if rnd_wheel == 1 then setVehicleWheelStates(veh, 1, -1,-1,-1) end
	if rnd_wheel == 2 then setVehicleWheelStates(veh, -1, 1,-1,-1) end
	if rnd_wheel == 3 then setVehicleWheelStates(veh, -1,-1, 1,-1) end
	if rnd_wheel == 4 then setVehicleWheelStates(veh, -1,-1,-1, 1) end

	-- Inform the driver
	exports.GTWtopbar:dm("Driver: You got a flat tire due to recless driving, press B and call a mechanic",
		plr, 255,0,0, false, true)
	exports.GTWtopbar:dm("Or find a pay'n spray shop to repair your vehicle", plr, 255,100,0)
end, 5000, 0)
