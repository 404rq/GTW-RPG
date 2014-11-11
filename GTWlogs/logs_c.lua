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

--[[ Get money ]]--
function add(amount)
	triggerServerEvent("GTWlogs.add", root, amount)
end

--[[ Set money ]]--
function sub(amount)
	triggerServerEvent("GTWlogs.sub", root, amount)
end