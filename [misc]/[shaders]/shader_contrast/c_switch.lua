--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		triggerEvent( "switchContrast", resourceRoot, true )
	end
)

--------------------------------
-- Command handler
--		Toggle via command
--------------------------------

function toggleShaderContrast(state)
	triggerEvent( "switchContrast", resourceRoot, state)
end
function toggleShaderContrastCMD()
	triggerEvent( "switchContrast", resourceRoot, not bEffectEnabled)
end
addCommandHandler("contrast", toggleShaderContrastCMD)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchContrast( bOn )
	if bOn then
		enableContrast()
	else
		disableContrast()
	end
end
addEvent( "switchContrast", true )
addEventHandler( "switchContrast", resourceRoot, switchContrast )
