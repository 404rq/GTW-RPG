--[[ 
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

function onAcceptJob( ID, skinID )
	-- Get job data
    local team, max_wl, description, skins = unpack(work_items[ID])
    
    -- Check if a skin was passed
    if not skinID then return end
    
    -- Note that -1 means default player skin
    if skinID > -1 then
    	setElementModel( client, skinID )
    elseif skinID == -1 then
    	skinID = exports.GTWclothes:getBoughtSkin( client ) or getElementModel( client ) or 0
    	setElementModel( client, skinID )
    else
    	exports.GTWtopbar:dm( "Select a skin before applying for the job!", client, 255, 0, 0 )
    	return
    end
    
    -- Check if a player already have the job or not
    if getElementData(client, "Occupation") ~= ID then
    	setElementData(client, "Occupation", ID)
        setPlayerTeam(client, getTeamFromName(team))
        local r,g,b = getTeamColor(getTeamFromName(team))
        setPlayerNametagColor(client, r, g, b)
        setElementData(client, "admin", nil)
        exports.GTWtopbar:dm("("..ID..") Welcome to your new job!", client, 0, 255, 0)
    end
end
addEvent( "GTWcivilians.accept", true )
addEventHandler( "GTWcivilians.accept", root, onAcceptJob )

function onBuyTool(name, ammo, price, weapon_id)
	if getPlayerMoney(client) >= tonumber(price) then
		giveWeapon(client, weapon_id, ammo, true)
		takePlayerMoney(client, price)
	else
		exports.GTWtopbar:dm("You cannot afford this tool!", client, 255, 0, 0)
	end
end
addEvent( "GTWcivilians.buyTools", true )
addEventHandler( "GTWcivilians.buyTools", root, onBuyTool )
