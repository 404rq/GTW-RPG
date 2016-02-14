--
-- c_water.lua
--

local bEffectEnabled = true
local myShader,tec = nil,nil

function toggleShaderWater(state)
	if myShader and isElement(myShader) and not state then
		destroyElement(myShader)
		myShader = nil
	elseif state then
		enableShader()
	end
end
function toggleShaderWaterCMD()
	if myShader and isElement(myShader) then
		destroyElement(myShader)
		myShader = nil
	else
		enableShader()
	end
end
addCommandHandler("water", toggleShaderWaterCMD)

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		enableShader()
	end
)

function enableShader()
	-- Version check
	--[[if getVersion ().sortable < "1.1.0" then
		outputChatBox( "Resource is not compatible with this client." )
		return
	end]]--

	-- Create shader
	myShader, tec = dxCreateShader ( "water.fx" )

	if not myShader then
		outputChatBox( "Could not create shader. Please use debugscript 3" )
	else
		-- Set textures
		local textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
		local textureCube = dxCreateTexture ( "images/cube_env256.dds" );
		dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );

		-- Apply to global txd 13
		engineApplyShaderToWorldTexture ( myShader, "waterclear256" )

		-- Update water color incase it gets changed by persons unknown
		--[[setTimer(	function()
						if myShader then
							local r,g,b,a = getWaterColor()
							dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
						end
					end
					,500,0 )]]--
	end
end
