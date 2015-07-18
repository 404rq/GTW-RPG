local root = getRootElement()
local player = getLocalPlayer()
local counter = 0
local starttick
local currenttick
local currFPS = 60
local sx, sy = guiGetScreenSize( )
addEventHandler("onClientRender",root,
	function()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			setElementData(player,"FPS",counter)
			currFPS = counter
			counter = 0
			starttick = false
		end
		dxDrawRectangle( sx-206, 0, 200, 24, tocolor( 0, 0, 0, 200 ) )
		dxDrawText ( "FPS: "..currFPS..", Ping: "..getPlayerPing( localPlayer ), sx-200, 2, 0, 0, 
			tocolor( 255, 255, 255, 200 ), 0.6, "bankgothic")
	end
)