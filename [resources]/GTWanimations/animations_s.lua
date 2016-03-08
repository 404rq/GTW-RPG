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

--[[ Start or stop requested animation ]]--
function set_anim(a_block, a_ID)
	local is_arrested = exports.GTWpolice:isArrested(client)
	if a_block == nil or a_ID == nil then
		if not is_arrested then
			setPedAnimation(client)
		end
	else
		if not is_arrested then
			setPedAnimation(client, a_block, a_ID,-1, true, false)
		end
	end
end
addEvent("GTWanimations.setAnimation", true)
addEventHandler("GTWanimations.setAnimation", root, set_anim)

--[[ Stop any active anumation ]]--
function stop_anim(plr, cmd)
	local is_arrested = exports.GTWpolice:isArrested(plr)
	if is_arrested then
		exports.GTWtopbar:dm("You can't use animations when you are arrested!", plr, 255, 0, 0)
		return
	end

    	setPedAnimation(plr)
    	unbindKey(plr, "w", "down")
end
addCommandHandler("stopanim", stop_anim)

--[[ Start the requested animation ]]--
function start_anim(plr, cmd)
	-- Check if arrested, if so reject request
	local is_arrested = exports.GTWpolice:isArrested(plr)
	if is_arrested then
		exports.GTWtopbar:dm("You can't use animations when you are arrested!", plr, 255, 0, 0)
		return
	end

	-- Validate Command
	if not cmd_anim_map[cmd] then return end

	-- Special case with looping animations
	local anim_loop = true
	if cmd == "handsup" then anim_loop = false end

	-- Start animation
    	setPedAnimation(plr, cmd_anim_map[cmd][1], cmd_anim_map[cmd][2], -1, anim_loop, false)
    	bindKey(plr, "w", "down", "stopanim")
end
addCommandHandler("handsup", start_anim)
addCommandHandler("lookaround", start_anim)
addCommandHandler("deal1", start_anim)
addCommandHandler("deal2", start_anim)
addCommandHandler("deal3", start_anim)
addCommandHandler("fatidle", start_anim)
addCommandHandler("tired", start_anim)
addCommandHandler("mourn", start_anim)
addCommandHandler("wave", start_anim)
addCommandHandler("lean", start_anim)
addCommandHandler("cpr", start_anim)
addCommandHandler("sit", start_anim)
addCommandHandler("cower", start_anim)
addCommandHandler("handcower", start_anim)
addCommandHandler("gum", start_anim)
addCommandHandler("getup", start_anim)
addCommandHandler("getupfront", start_anim)
addCommandHandler("chat", start_anim)
addCommandHandler("taxiwink", start_anim)
addCommandHandler("turn180", start_anim)
addCommandHandler("urp", start_anim)
addCommandHandler("gumchew", start_anim)
