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

--[[ Destroys a train as soon it streams out and no other players are nearby ]]--
function stream_out_train( )
	triggerServerEvent("GTWtrain.destroy", root, source)
end

--[[ Check when the train streams out and destroys it ]]--
function check_stream_out(c_train)
    	addEventHandler("onClientElementStreamOut", c_train, stream_out_train)
	--setElementStreamable(c_train, false)
end
addEvent("GTWtrain.onStreamOut", true)
addEventHandler("GTWtrain.onStreamOut", root, check_stream_out)

--[[ Updating control state based on server orders ]]--
function set_train_control_policy(engineer, state)
	if state == 0 then
		setPedControlState(engineer, "accelerate", false)
		setPedControlState(engineer, "brake_reverse", false)
	elseif state == 1 then
		setPedControlState(engineer, "accelerate", true)
		setPedControlState(engineer, "brake_reverse", false)
	elseif state == 2 then
		setPedControlState(engineer, "accelerate", false)
		setPedControlState(engineer, "brake_reverse", true)
	end
end
addEvent("GTWtrain.setControlState", true)
addEventHandler("GTWtrain.setControlState", root, set_train_control_policy)

function set_train_track(cmd, new_track)
	-- Verify MTA version
	local version = getVersion()
	if tonumber(version.mta) < 1.6 then
		exports.GTWtopbar:dm("This feature is not yet supported! please download MTASA v1.6 or later", 255,0,0)
		return
	end

	-- Check if the player is driving a train
	local train = getPedOccupiedVehicle(localPlayer)
	if not train or getVehicleType(train) ~= "Train" then return end
	local x,y,z = getElementPosition(train)

	if cmd == "gettrack" then
		exports.GTWtopbar:dm("Current track is: "..getTrainTrack(train), 255,100,0)
	elseif new_track then
		setTrainTrack(train, new_track)
		setElementPosition(train, x,y,z)
		exports.GTWtopbar:dm("Current track is: "..getTrainTrack(train), 255,100,0)
	end
end
addCommandHandler("settrack", set_train_track)
addCommandHandler("gettrack", set_train_track)
