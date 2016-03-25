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
	[9]=10,
	[10]=12,
	[11]=16,
	[12]=17,
	[13]=18
}

-- Update the weather
function chWeather( )
	local wid = math.random(#we)
	setWeatherBlended(we[wid])
	setWaveHeight(math.random(10,100)*0.002)
end
setTimer(chWeather, math.random(130,180)*60*1000, 0)
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
