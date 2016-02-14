--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchCarPaintReflect", root, true )
--
--	To switch off:
--			triggerEvent( "switchCarPaintReflect", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		outputDebugString('/reflect to switch the effect')
		triggerEvent( "switchCarPaintReflect", resourceRoot, true )

	end
)

function toggleShaderCarPaint(state)
	triggerEvent( "switchCarPaintReflect", resourceRoot, state)
end
function toggleShaderCarPaintCMD()
	triggerEvent( "switchCarPaintReflect", resourceRoot, not cprEffectEnabled )
end
addCommandHandler("reflect", toggleShaderCarPaintCMD)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchCarPaintReflect( cprOn )
	outputDebugString( "switchCarPaintReflect: " .. tostring(cprOn) )
	if cprOn then
		startCarPaintReflect()
	else
		stopCarPaintReflect()
	end
end

addEvent( "switchCarPaintReflect", true )
addEventHandler( "switchCarPaintReflect", resourceRoot, switchCarPaintReflect )
