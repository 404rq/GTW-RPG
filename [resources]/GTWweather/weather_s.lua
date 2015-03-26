--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name: 		GTW-RPG	
	Developers:   		GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:    		Open source
	License:    		GPL v.3 or later
	Status:     		Stable release
********************************************************************************
]]--

-- Weather id list
we = { 
	[1]=4, 
	[2]=5, 
	[3]=7, 
	[4]=8, 
	[5]=9, 
	[6]=11, 
	[7]=12, 
	[8]=16, 
	[9]=17, 
	[10]=18, 
	[11]=19, 
	[12]=14 
}

-- Update the weather
function chWeather( ) 
	local wid = math.random( #we ) 
	setWeatherBlended( we[wid] ) 
	outputServerLog("[Weather] Fading to: "..we[wid]) 
end
setTimer( chWeather, math.random(130,180)*60*1000, 0 ) 
setWeather( we[math.random( #we )] ) 
