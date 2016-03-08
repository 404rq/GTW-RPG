------------------------------------------------------------------------------------
--	PROJECT:			Business System v1.2
--	RIGHTS:				All rights reserved by developers
-- FILE:						business/client/dxoutput.lua
--	PURPOSE:			outputMessage using dx
--	DEVELOPERS:	JR10
------------------------------------------------------------------------------------

local screenWidth, screenHeight = guiGetScreenSize()
local left = (screenWidth / 1440) * 983
local curLeft = left
local difference = (screenWidth / 1440) * 20
local curMessage = ""
local curColor = {255, 255, 255}
local moving = false
local movingBack = false
local movingBackTimer

addEventHandler("onClientRender",root,
    function()
        dxDrawFramedText(curMessage,curLeft,(screenHeight / 900) * 618.0,curLeft + ((screenWidth / 1440) * 456.0),(screenHeight / 900) * 645.0,tocolor(curColor[1],curColor[2],curColor[3],255),1.0,"default-bold","center","center",false,true,false)
    end
)

function dxOutputMessage(message, r, g, b)
	if moving then removeEventHandler("onClientRender", root, moveMessage) end
	if movingBack then removeEventHandler("onClientRender", root, moveMessageBack) end
	if isTimer(movingBackTimer) then killTimer(movingBackTimer) end
	curLeft = (screenWidth / 1440) * 1440
	curMessage = message
	curColor = {r, g, b}
	movingBackTimer = setTimer(hideMessage, 5000, 1)
	addEventHandler("onClientRender", root, moveMessage)
	moving = true
end

function moveMessage()
	curLeft = curLeft - difference
	if curLeft <= left then
		removeEventHandler("onClientRender", root, moveMessage)
		curLeft = (screenWidth / 1440) * 983
		moving = false
	end
end

function hideMessage()
	movingBack = true
	addEventHandler("onClientRender", root, moveMessageBack)
end

function moveMessageBack()
	curLeft = curLeft + difference
	if curLeft >= (screenWidth / 1440) * 1440 then
		removeEventHandler("onClientRender", root, moveMessageBack)
		curLeft = (screenWidth / 1440) * 1440
		movingBack = false
	end
end
	
function dxDrawFramedText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left + 1, top + 1, width + 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left + 1, top - 1, width + 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left - 1, top + 1, width - 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left - 1, top - 1, width - 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

addEvent("client:dxOutputMessage", true)
addEventHandler("client:dxOutputMessage", root,
	function(message, r, g, b)
		dxOutputMessage(message, r, g, b)
	end
)