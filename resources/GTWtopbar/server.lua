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

function dm( message, thePlayer, red, green, blue, colorCoded )
	if colorCoded == nil then
		colorCoded = false
	end		
	if isElement( thePlayer ) then
		triggerClientEvent ( thePlayer, "onTextAdd", getRootElement(), message, red, green, blue, colorCoded )
	end
end