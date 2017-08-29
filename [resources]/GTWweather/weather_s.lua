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

-- Weather id list
we = {
	[1]=1,
	[2]=2,
	[3]=3,
	[4]=4,
	[5]=5,
	[6]=6,
	[7]=7,
	[8]=8,
	[9]=9,
	[10]=10,
	[11]=12,
	[12]=16,
	[13]=17,
	[14]=18
}

-- Update the weather
function change_weather( )
	local wid = math.random(#we)
	setWeatherBlended(we[wid])
	setWaveHeight(math.random(10,100)*0.002)
end
setTimer(change_weather, math.random(15,30)*60*1000, 0)
setWeather(we[math.random( #we )])

-- Remove speed blur level
for k,v in pairs(getElementsByType("player")) do
	setPlayerBlurLevel(v, 0)
end
function remove_speed_blur(old_acc, acc)
    	setPlayerBlurLevel(source, 0)
end
addEventHandler("onPlayerLogin", root, remove_speed_blur)

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)
