--[[exports.scoreboard:addScoreboardColumn('Flag', getRootElement(), 25)
function showcountry()
	local flag = exports.admin:getPlayerCountry ( source )
    if flag then
    	setElementData(source,"Flag",":admin/client/images/flags/"..flag..".png")
    else
    	flag = "N/A"  
    end
end
addEventHandler("onPlayerJoin",getRootElement(),showcountry)

function updateFlags()
	for theKey,thePlayer in ipairs(getElementsByType("player")) do
	   	local flag = exports.admin:getPlayerCountry ( thePlayer )
	    if flag then
	    	setElementData(thePlayer,"Flag",":admin/client/images/flags/"..flag..".png")
	    else
	    	flag = "N/A"  
	    end
	end
end
setTimer(updateFlags, 1000, 1)]]--
