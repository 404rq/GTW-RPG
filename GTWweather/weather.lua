--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

we = {
	-- Weather id list
	[1]={ 4 },
	[2]={ 5 },
	[3]={ 7 },
	[4]={ 8 },
	[5]={ 9 },
	[6]={ 11 },
	[7]={ 12 },
	[8]={ 16 },
	[9]={ 17 },
	[10]={ 18 },
	[11]={ 19 },
	[12]={ 14 },
}

function chWeather( source )
	local wid = math.random( #we )
    setWeatherBlended( we[wid][1] )
    outputServerLog("[Weather] Fading to: "..we[wid][1])
end

setTimer( chWeather, math.random(120, 300)*60000, 0 )
setWeather( we[math.random( #we )][1] )
