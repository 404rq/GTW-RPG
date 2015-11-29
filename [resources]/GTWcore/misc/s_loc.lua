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

--[[ Periodically update the location of every player ]]--
function update_locations()
	for plr,v in pairs(getElementsByType("player")) do
        	-- Skip if there is no player
		if not plr or not isElement(plr) then return end

		-- Get current location coordinates
		local px,py,pz = getElementPosition(plr)

        	-- Skip update if location is unknown (i.e interior)
		if getZoneName(px,py,pz) == "Unknown" then return end

        	-- Update location on scoreboard
		setElementData(plr, "Location", getZoneName(px,py,pz))

		-- [Misc] Update money in scoreboard
		local money = tostring(getPlayerMoney(plr))
		setElementData(plr, "Money", "$"..convertNumber(money))
	end
end
setTimer(update_locations, 1000, 0)

--[[ Show location info ]]--
function display_indexed_location(plr)
	local x,y,z = getElementPosition(plr)
	local rx,ry,rz = getElementRotation(plr)
	outputChatBox("[0]={ "..x..", "..y..", "..z..", "..rz.." },", plr)
end
addCommandHandler("loc", display_indexed_location)

--[[ Show location info (non index) ]]--
function display_non_index_location(plr)
	local x,y,z = getElementPosition(plr)
	local rx,ry,rz = getElementRotation(plr)
	outputChatBox("{ "..x..", "..y..", "..z..", "..rz.." },", plr)
end
addCommandHandler("locn", display_non_index_location)

--[[ Show location info (xml) ]]--
function display_loc_xml(plr)
	local x,y,z = getElementPosition(plr)
	local rx,ry,rz = getElementRotation(plr)
	outputChatBox("<location id=\"1\" posX=\""..x.."\" posY=\""..y.."\" posZ=\""..z.."\" rot=\""..rz.."\" />", plr)
end
addCommandHandler("locx", display_loc_xml)
