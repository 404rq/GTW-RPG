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

--[[ Destroys a train as soon it streams out and no other players are nearby ]]--
function stream_out_train( )
	triggerServerEvent("GTWtrain.destroy", root, source)
end

--[[ Check when the train streams out and destroys it ]]--
function check_stream_out(c_train)
    	addEventHandler("onClientElementStreamOut", c_train, stream_out_train)
	setElementStreamable(c_train, false)
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
