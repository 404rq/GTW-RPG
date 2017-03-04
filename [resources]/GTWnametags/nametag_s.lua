--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Hide default nametag
function disable_nametag()
        setPlayerNametagShowing(source, false)
end
addEventHandler("onPlayerJoin", root, disable_nametag)

-- Hide default nametags for all players on start
for k,v in pairs(getElementsByType("player")) do
        setPlayerNametagShowing(v, false)
end
