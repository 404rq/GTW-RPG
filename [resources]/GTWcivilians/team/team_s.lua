--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

currTeam = { }
is_anon = { }
player_counts = getPlayerCount( )

function setMoney( )
    	local money = getPlayerMoney ( source )
    	setElementData( source, "Money", "$" .. money )

    	-- Message
    	exports.GTWtopbar:dm( getPlayerName(source).." has logged in", getRootElement(), 255, 150, 0 )
    	for k,v in pairs(getElementsByType("player")) do
	    	playSoundFrontEnd(v, 11)
    	end
end
addEventHandler( "onPlayerLogin", getRootElement(), setMoney )

function showJoinMessage( )
    	-- Message
    	exports.GTWtopbar:dm( getPlayerName(source).." has joined the game", getRootElement(), 255, 150, 0 )
    	for k,v in pairs(getElementsByType("player")) do
    		playSoundFrontEnd(source, 11)
	end
end
addEventHandler( "onPlayerJoin", getRootElement(), showJoinMessage )

function consoleSetPlayerPosition( source, commandName, posX, posY, posZ, interior, dimension )
	local accName = getAccountName ( getPlayerAccount ( source ) )
    if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" )) or
    	isObjectInACLGroup ("user."..accName, aclGetGroup( "SuperModerator" )) or
    	isObjectInACLGroup ("user."..accName, aclGetGroup( "Moderator" )) then

    	-- Default data
    	if not posX then posX = 0 end
    	if not posY then posY = 0 end
    	if not posZ then posZ = 50 end
    	if not interior then interior = 0 end
    	if not dimension then dimension = 0 end
    	local rx,ry,rz = getElementRotation( source )

    	local weapon = { 0,0,0,0,0,0,0,0,0,0,0,0 }
		local ammo = { 0,0,0,0,0,0,0,0,0,0,0,0 }

		-- Weapons save
		for k,wep in ipairs(weapon) do
		   	weapon[k] = getPedWeapon ( source, k )
		   	setPedWeaponSlot( source, getSlotFromWeapon( weapon[k] ))
		   	ammo[k] = getPedTotalAmmo ( source, k )
		end
		spawnPlayer( source, posX, posY, posZ, rz, getElementModel( source ), interior, dimension, getPlayerTeam( source ))
		-- Weapons restore
		for k,wep in ipairs(weapon) do
		   	if weapon[k] and ammo[k] then
		   		giveWeapon ( source, weapon[k], ammo[k], false )
		   	end
		end
	end
end
addCommandHandler( "setpos", consoleSetPlayerPosition  )

-- Move to the criminal team
function goCrim( source, command )
	if client then
		source = client
	end
	local team = getTeamFromName ( "Criminals" )
	if not getPedOccupiedVehicle( source ) then
		setPlayerTeam( source, team )
		setElementData( source, "Occupation", "Criminal", true )
		local r,g,b = getTeamColor(getTeamFromName("Criminals"))
		setPlayerNametagColor ( source, r, g, b )

		-- Remove attached blips
		local attachedElements = getAttachedElements( source )
  		if ( attachedElements ) then
		    for ElementKey, ElementValue in ipairs( attachedElements ) do
		    	destroyElement( ElementValue )
		    end
		end

		-- Return your bought skin or CJ skin (0) if none, replace with 0
		local skinID = exports.GTWclothes:getBoughtSkin ( source ) or getElementModel( source ) or 0
		setElementModel( source, skinID)
		setElementData( source, "admin", false)
		exports.GTWtopbar:dm( "You are now a criminal!", source, 0, 255, 0 )
	elseif getPedOccupiedVehicle( source ) then
		exports.GTWtopbar:dm( "Exit your vehicle before using this command!", source, 255, 0, 0 )
	end
end
addCommandHandler( "criminal", goCrim )
addEvent( "acorp_gocrim", true )
addEventHandler( "acorp_gocrim", root, goCrim )

-- End job
function endWork( source, command )
	local team = getTeamFromName ( "Unemployed" )
	setPlayerTeam( source, team )
	setElementData( source, "Occupation", "", true )
	local r,g,b = getTeamColor(team)
	setPlayerNametagColor ( source, r, g, b )

	-- Make shore that staff get's vulnerable as well
	setElementData( source, "admin", false)

	-- Return your bought skin or CJ skin (0) if none, replace with 0
	local skinID = exports.GTWclothes:getBoughtSkin ( source ) or getElementModel( source ) or 0
	exports.GTWtopbar:dm( "End work: successfully!", source, 255, 200, 0 )
	setElementModel(source, skinID)
end
addCommandHandler( "endwork", endWork )

-- End job button GUI click
function endWorkButton( )
	local team = getTeamFromName ( "Unemployed" )
	setPlayerTeam( client, team )
	setElementData( client, "Occupation", "", true )
	local r,g,b = getTeamColor(team)
	setPlayerNametagColor ( client, r, g, b )

	-- Make shore that staff get's vulnerable as well
	setElementData( client, "admin", false)

	-- Return your bought skin or CJ skin (0) if none, replace with 0
	local skinID = exports.GTWclothes:getBoughtSkin ( client ) or getElementModel( client ) or 0
	exports.GTWtopbar:dm( "End work: successfully!", client, 255, 200, 0 )
	setElementModel(client, skinID)
end
addEvent( "acorp_onEndWork", true )
addEventHandler( "acorp_onEndWork", root, endWorkButton )

-- Kill command
function killYourself ( source, command )
	if not isTimer( cooldown ) then
		if getElementData( source, "Jailed" ) ~= "Yes" and not getElementData( source, "Arrested" ) and
			exports.GTWpolice:distanceToCop( source ) > 400 then
			local pay = math.random( 100, 200 )
			if getPlayerMoney( source ) > pay then
				setTimer( doKill, 1000, 1, source )
				setElementFrozen( source, true )
				takePlayerMoney(source,pay)
				exports.GTWtopbar:dm( "You have committed suicide, it will cost "..
					tostring(pay).."$ + Hospital fines", source, 255, 200, 0 )
			else
				exports.GTWtopbar:dm( "You can't afford suicide (price: "..tostring(pay).."$)", source, 255, 0, 0 )
			end
		elseif exports.GTWpolice:distanceToCop( source ) <= 400 then
			exports.GTWtopbar:dm( "Suicide was interrupted, a cop is nearby!", source, 255, 0, 0 )
		else
			exports.GTWtopbar:dm( "You can not use this command in jail or when arrested!", source, 255, 0, 0 )
		end
		cooldown = setTimer( function() end, 60000, 1 )
	end
end
addCommandHandler( "kill", killYourself )
addCommandHandler( "stuck", killYourself )

function doKill(thePlayer)
	if isElement( thePlayer ) then
		setElementHealth( thePlayer, 0 )
		setElementFrozen( thePlayer, false )
	end
end

-- Clean up team data
function quitPlayer( quitType )
	currTeam[source] = nil
	is_anon[source] = nil

	-- Remove attached blips
	local attachedElements = getAttachedElements( source )
	if ( attachedElements ) then
		for ElementKey, ElementValue in pairs( attachedElements ) do
			if isElement( ElementValue ) and getElementType( ElementValue ) == "blip" and getBlipIcon( ElementValue ) == 0 then
			   	destroyElement( ElementValue )
			end
		end
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), quitPlayer )
