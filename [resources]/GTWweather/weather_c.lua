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

local we = {
	["LS"]={0,1,2,3,4},
	["SF"]={5,6,7,8,9},
	["LV"]={10,11,12},
	["RC"]={13,14,15,16},
	["BC"]={17,18,19},
}

local curr_weather,curr_region,region = 0,"LS","LS"
function change_weather()
	-- Check coordinates for each region
	local x,y,z = getElementPosition(localPlayer)
	if x < -1000 and y > -1500 and y < 1700 then region = "SF"
	elseif x < -2200 and y >= 1700 then region = "SF"
	elseif x > 900 and y > 600 then region = "LV"
	elseif x > 200 and y < -800 then region = "LS"
	elseif y < 700 then region = "RC"
	elseif y >= 700 then region = "BC" end

	-- DEBUG output
	--outputChatBox("Weather: "..curr_weather..", region: "..
	--	curr_region..", current region: "..region)

	-- Check if we're in the same region, then with 10% chance, change weather
	if curr_region == region and math.random(1,200000) > 5 then return false end

	-- Change the weather if we're in a new region
	curr_weather = math.random(#we[region])
	setWeather(we[region][curr_weather])

	-- Update current region
	curr_region = region
end
setTimer(change_weather, 1000, 0)
