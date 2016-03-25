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

function applyStaffAdvantage(plr)
	-- Staff advantage
    local accName = getAccountName(getPlayerAccount(plr))
    if isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) then
     	setElementData(plr, "staff", 10)
     	bindKey(plr, "J", "down", "jetpack")
     	if subOccupation and subOccupation == "Admin" then
     		setElementData(plr, "admin", true)
     	end
    elseif isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) then
     	setElementData(plr, "staff", 9)
     	bindKey(plr, "J", "down", "jetpack")
     	if subOccupation and subOccupation == "Developer" then
     		setElementData(plr, "admin", true)
     	end
    elseif isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) then
    	setElementData(plr, "staff", 8)
     	bindKey(plr, "J", "down", "jetpack")
     	if subOccupation and subOccupation == "Moderator" then
     		setElementData(plr, "admin", true)
     	end
    elseif isObjectInACLGroup("user."..accName, aclGetGroup("Supporter")) then
    	setElementData(plr, "staff", 7)
     	bindKey(plr, "J", "down", "jetpack")
     	if subOccupation and subOccupation == "Supporter" then
     		setElementData(plr, "admin", true)
     	end
    end
end

function jetpack(thePlayer)
    if doesPedHaveJetPack(thePlayer) then
        removePedJetPack(thePlayer)
        return
    end

    -- Otherwise, give him one if he has access
    local accName = getAccountName(getPlayerAccount(thePlayer))
    if (isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Supporter"))) and
		getPlayerWantedLevel(thePlayer) == 0 then
        if not doesPedHaveJetPack(thePlayer) then
            givePedJetPack(thePlayer)
			bindKey(thePlayer, "J", "down", "jetpack")
        end
    elseif getPlayerWantedLevel(thePlayer) > 0 then
    	exports.GTWtopbar:dm("You can't use jetpack while being wanted", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("jetpack", jetpack)

function goStaff(source, command)
    local accName = getAccountName(getPlayerAccount(source))
    if (isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Supporter"))) and
		getPlayerWantedLevel(source) == 0 then
	    setElementData(source, "admin",true)
        exports.GTWtopbar:dm("Staff mode is now enabled", source, 0, 255, 0)
        setPlayerNametagColor(source, getTeamColor(getTeamFromName("Staff")))
        --setPlayerNametagShowing(source, false)
        if command == "gostaff" then
        	setElementModel(source, 217)
        elseif command == "gostafff" then
        	setElementModel(source, 211)
        end
     	setPlayerTeam(source, getTeamFromName("Staff"))
     	if isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) then
	     	setElementData(source, "Occupation", "Admin")
     		setElementData(source, "staff", 10)
     	elseif isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) then
     		setElementData(source, "Occupation", "Developer")
     		setElementData(source, "staff", 9)
     	elseif isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) then
     		setElementData(source, "Occupation", "Moderator")
     		setElementData(source, "staff", 8)
     	elseif isObjectInACLGroup("user."..accName, aclGetGroup("Supporter")) then
     		setElementData(source, "Occupation", "Supporter")
     		setElementData(source, "staff", 7)
     	end
     	bindKey(source, "J", "down", "jetpack")
     	setPlayerWantedLevel(source, 0)
     	setElementData(source, "Wanted", 0.0)
     	setElementAlpha(source, 255)
     	--setPlayerNametagShowing(source, false)
    elseif getPlayerWantedLevel(source) > 0 then
    	exports.GTWtopbar:dm("You can't use staff mode while being wanted", source, 255, 0, 0)
    end
end
addCommandHandler("gostaff", goStaff)
addCommandHandler("gostafff", goStaff)

function endStaff(source)
    local accName = getAccountName(getPlayerAccount(source))
    if isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Developer")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) or
		isObjectInACLGroup("user."..accName, aclGetGroup("Supporter")) then
	    setElementData(source, "admin",false)
        setPlayerNametagColor(source, getTeamColor(getTeamFromName("Unemployed")))
        --setPlayerNametagShowing(source, false)
        local skinID = exports.GTWclothes:getBoughtSkin(source)
        setElementModel(source, skinID)
     	setPlayerTeam(source, getTeamFromName("Unemployed"))
     	setElementData(source, "Occupation", "")
    end
end
addCommandHandler("endwork", endStaff)
addEvent("GTWdata_onEndWork", true)
addEventHandler("GTWdata_onEndWork", root, endStaff)
