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

function rainymood()
    setWeather (8)
end
addCommandHandler("rain", rainymood)

function foggymood()
   	setWeather (9)
end
addCommandHandler("foggy", foggymood)

function sunnymood()
   	setWeather (0)
end
addCommandHandler("sunny", sunnymood)