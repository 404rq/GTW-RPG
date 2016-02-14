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

local e_time = getRealTime()

-- 2015-11-14 to 21
setTimer(function()
        if e_time.year == 115 and e_time.month == 11 and
                (e_time.monthday > 13 or e_time.monthday < 21) then
                for k,v in pairs(getElementsByType("player")) do
                        local x,y,z = getElementPosition(v)
                        if (getElementData(v, "GTWcore.event.px") or 0) ~= x and
                                (getElementData(v, "GTWcore.event.py") or 0) ~= y then
                                        givePlayerMoney(v, 1000)
                                        setElementData(v, "GTWcore.event.px", x)
                                        setElementData(v, "GTWcore.event.py", y)
                                        exports.GTWtopbar:dm("EVENT: You have received $1000 "..
                                        "for being online today!", v,255,255,255)
                        end
                end
        end
end, 5*60*1000, 0)
