--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "onClientSwitchDetail", root, true )
--
--	To switch off:
--			triggerEvent( "onClientSwitchDetail", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		triggerEvent( "onClientSwitchDetail", resourceRoot, true )
	end
)

--------------------------------
-- Command handler
--		Toggle via command
--------------------------------

function toggleShaderDetail(state)
	triggerEvent("onClientSwitchDetail", resourceRoot, state)
end
function toggleShaderDetailCMD()
	triggerEvent("onClientSwitchDetail", resourceRoot, not bEffectEnabled)
end
addCommandHandler("detail", toggleShaderDetailCMD)


--------------------------------
-- Switch effect on or off
--------------------------------
function handleOnClientSwitchDetail( bOn )
	if bOn then
		enableDetail()
	else
		disableDetail()
	end
end

addEvent( "onClientSwitchDetail", true )
addEventHandler( "onClientSwitchDetail", resourceRoot, handleOnClientSwitchDetail )
