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

local timer = nil
local text = ""
local text2 = ""
local messages = { }
local r,g,b = 255,255,255
local isColorCoded = false

function hpm(message, red, green, blue, colorCoded)
	if colorCoded == nil then
		colorCoded = false
	end
	text = message
	r = red
	g = green
	b = blue
	isColorCoded = colorCoded

	-- Fix the ability to set the same
	-- message twice with anti spam included
	if isTimer( timer ) then
		killTimer( timer )
	end
	timer = setTimer( function() text = "" end, 10000, 1 )

	-- Play notification sound
	playSound("sound/beep.mp3")
end
addEvent("GTWhelp.onTextAdd", true)
addEventHandler("GTWhelp.onTextAdd", root, hpm)

addEventHandler("onClientRender", root, function( )
	local tick = getTickCount ( )
	local sx,sy = guiGetScreenSize ( )
	if ( text ~= text2 and text ~= "" ) then
		table.insert ( messages, { text, true, tick + 7000, 170, r, g, b, isColorCoded })
	end
	text2 = text
	if ( #messages > 7 ) then
		table.remove ( messages, 1 )
	end

	for index, data in ipairs ( messages ) do
		local v1 = data[1]
		local v2 = data[2]
		local v3 = data[3]
		local v4 = data[4]
		local v5 = data[5]
		local v6 = data[6]
		local v7 = data[7]
		local v8 = data[8]
		dxDrawRectangle( sx/2 - 100, sy-((-101)+(index*100)), 200, 100, tocolor( 0, 0, 0, v4 ) )
		dxDrawText( v1, sx/2, (-100)+(index*46), sx/2, 0, tocolor( v5, v6, v7, v4+75 ), 0.7, "bankgothic", "center", "center", false, true, false, v8 )

		if ( tick >= v3 ) then
			messages[index][4] = v4-2
			if ( v4 <= 1 ) then
				table.remove ( messages, index )
			end
		end
	end
end)
