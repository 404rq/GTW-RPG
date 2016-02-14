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

local cigarettes 	= { }
local cooldowns 	= { }
local syncTimer 	= { }
function startSmoking ( thePlayer )
	if isPedInVehicle(thePlayer) then return end
    	setElementData ( thePlayer, "smoking", not getElementData ( thePlayer, "smoking" ) )
    	if cigarettes[thePlayer] == nil and not isTimer(cooldowns[thePlayer]) then
    		-- Bink keys to control the smoking
    		bindKey( thePlayer, "mouse2", "down", "smoke_drag" )
    		bindKey( thePlayer, "W", "down", "stopsmoke2" )
    		bindKey( thePlayer, "A", "down", "stopsmoke" )
    		bindKey( thePlayer, "D", "down", "stopsmoke" )

    		-- Info message
    		exports.GTWtopbar:dm( "Smoking: Right click to smoke, walk forward to stop smoke (W).", thePlayer, 255, 200, 0 )
    		setTimer( showDelayInfo, 2000, 1, "Smoking: Use /stopsmoke or walk sideways (A or D) to throw your ciggarete away", thePlayer, 255, 200, 0)

    		-- Anim in
    		setPedAnimation( thePlayer, "SMOKING", "M_smk_in", -1, false, false )
    		cooldowns[thePlayer] = setTimer( function() end, 3000, 1 )

    		-- Sync interiors and dimension
    		syncTimer[thePlayer] = setTimer(function()
    			if thePlayer and cigarettes[thePlayer] then
    				setElementInterior( cigarettes[thePlayer], getElementInterior(thePlayer))
    				setElementDimension( cigarettes[thePlayer], getElementDimension(thePlayer))
    			elseif isTimer(syncTimer[thePlayer]) then
    				killTimer(syncTimer[thePlayer])
    			end
    		end, 1000, 0)

    		-- Increase stats by 1
		local playeraccount = getPlayerAccount(thePlayer)
		local cigarrs = getAccountData(playeraccount, "GTWdata_stats_cigarrs_smoked") or 0
		setAccountData(playeraccount, "GTWdata_stats_cigarrs_smoked", cigarrs + 1)

    		-- Create and attach cigarrete
        	local sigarette = createObject(1485, 0,0,0)
		cigarettes[thePlayer] = sigarette
        	exports.bone_attach:attachElementToBone(sigarette,thePlayer,11,0.15,0.1,0.15,0,180,30)
	end
end
addCommandHandler("smoke", startSmoking )

function showDelayInfo(msgText, thePlayer, r, g, b)
	exports.GTWtopbar:dm(msgText, thePlayer, r, g, b)
end

function stopSmoke2( thePlayer )
	-- Stop animation
	setPedAnimation ( thePlayer )
end
addCommandHandler( "stopsmoke2", stopSmoke2 )

function stopSmoke( thePlayer )
	-- Unbind control keys
	unbindKey( thePlayer, "mouse2", "down", "smoke_drag" )
	unbindKey( thePlayer, "W", "down", "stopsmoke2" )
	unbindKey( thePlayer, "A", "down", "stopsmoke" )
	unbindKey( thePlayer, "D", "down", "stopsmoke" )

	-- Stop smoking with animation
	if isElement(cigarettes[thePlayer]) then
		setPedAnimation( thePlayer, "SMOKING", "M_smk_out", -1, false, false )
	end
	setTimer( function()
		setPedAnimation ( thePlayer )
		if isElement(cigarettes[thePlayer]) then
			-- Free memory
			destroyElement (cigarettes[thePlayer])
			cigarettes[thePlayer]=nil
		end
	end, 3000, 1)
end
addCommandHandler( "stopsmoke", stopSmoke )

function smokeDrag( thePlayer )
	setPedAnimation( thePlayer, "SMOKING", "M_smkstnd_loop", -1, false, false )
end
addCommandHandler( "smoke_drag", smokeDrag )

addCommandHandler("gtwinfo", function(plr, cmd)
	outputChatBox("[GTW-RPG] "..getResourceName(
	getThisResource())..", by: "..getResourceInfo(
        getThisResource(), "author")..", v-"..getResourceInfo(
        getThisResource(), "version")..", is represented", plr)
end)

function quitPlayer( quitType )
	if cigarettes[source] and isElement(cigarettes[source]) then
		-- Free memory
		destroyElement (cigarettes[source])
		cigarettes[source]=nil
	end
	if isTimer(syncTimer[source]) then
		killTimer(syncTimer[source] )
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), quitPlayer )
