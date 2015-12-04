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

--[[ Countdown timer manager ]]--
countdownTimers = {}
function showCountDown(plr, cmd, seconds, text)
	local x,y,z = getElementPosition(plr)
	if seconds and text and math.floor(seconds) < 20 and math.floor(seconds) > 2 then
		seconds = math.floor(seconds)
    	for k,v in pairs(getElementsByType("player")) do
        	local rx,ry,rz = getElementPosition(v)
        	if getDistanceBetweenPoints3D(x,y,z, rx,ry,rz) < 100 and not isTimer(countdownTimers[v]) then
        		outputChatBox("-- "..getPlayerName(plr).." has requested a countdown --", v, 255, 255, 255)
        		countdownTimers[v] = setTimer(countDownTimerCount, 1000, seconds, v, seconds)
        		setTimer(outputChatBox, 1000*seconds+1000, 1, text, v, 255, 255, 255)
        	elseif isTimer(countdownTimers[v]) then
        		exports.GTWtopbar:dm("A timer is already counting down in this area, please wait!", plr, 255, 0, 0)
        	end
    	end
	else
		outputChatBox("Correct syntax: /countdown <seconds> <text>", plr, 255, 255, 255)
	end
end
addCommandHandler("countdown", showCountDown)

-- Display a count down timer for race or similar
function countDownTimerCount(owner, timeInSeconds)
	local i1,i2,i3 = getTimerDetails(countdownTimers[owner])
    outputChatBox("#66FF00[Countdown] #FFFFFF"..i2, owner, 255, 255, 255, true)
end
