--
-- c_detail.lua
--

----------------------------------------------------------------
-- enableDetail
----------------------------------------------------------------
function enableDetail()
	if bEffectEnabled then return end

	-- Load textures
	detail22Texture = dxCreateTexture('media/detail22.png', "dxt3")
	detail58Texture = dxCreateTexture('media/detail58.png', "dxt3")
	detail68Texture = dxCreateTexture('media/detail68.png', "dxt1")
	detail63Texture = dxCreateTexture('media/detail63.png', "dxt3")
	dirtyTexture = dxCreateTexture('media/dirty.png', "dxt3")
	detail04Texture = dxCreateTexture('media/detail04.png', "dxt3")
	detail29Texture = dxCreateTexture('media/detail29.png', "dxt3")
	detail55Texture = dxCreateTexture('media/detail55.png', "dxt3")
	detail35TTexture = dxCreateTexture('media/detail35T.png', "dxt3")

	-- Create shaders
	brickWallShader, tec = getBrickWallShader()
	if brickWallShader then
		-- Only create the rest if the first one is OK
		grassShader = getGrassShader()
		road2Shader = getRoad2Shader()
		paveDirtyShader = getPaveDirtyShader()
		paveStretchShader = getPaveStretchShader()
		barkShader = getBarkShader()
		rockShader = getRockShader()
		mudShader = getMudShader()
		concreteShader = getBrickWallShader()	-- TODO make this better
		roadShader = getRoadShader()
		sandShader = getMudShader()				-- TODO make this better
	end

	-- Get list of all elements used
	effectParts = {
						detail22Texture, detail58Texture, detail68Texture, detail63Texture, dirtyTexture,
						detail04Texture, detail29Texture, detail55Texture, detail35TTexture,
						brickWallShader, grassShader, road2Shader, paveDirtyShader,
						paveStretchShader, barkShader, rockShader, mudShader,
						concreteShader, roadShader, sandShader
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end

	bEffectEnabled = true

	if not bAllValid then
		outputChatBox( "Detail: Could not create some things. Please use debugscript 3" )
		disableDetail()
	else

		engineApplyShaderToWorldTexture ( roadShader, "*road*" )
		engineApplyShaderToWorldTexture ( roadShader, "*tar*" )
		engineApplyShaderToWorldTexture ( roadShader, "*asphalt*" )
		engineApplyShaderToWorldTexture ( roadShader, "snpedtest1" )
		engineApplyShaderToWorldTexture ( roadShader, "sidelatino1_LAe" )
		engineApplyShaderToWorldTexture ( roadShader, "*freeway*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*floor*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*bridge*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*conc*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*drain*" )
		engineApplyShaderToWorldTexture ( paveDirtyShader, "*walk*" )
		engineApplyShaderToWorldTexture ( paveDirtyShader, "*pave*" )
		engineApplyShaderToWorldTexture ( paveDirtyShader, "*cross*" )

		engineApplyShaderToWorldTexture ( mudShader, "*mud*" )
		engineApplyShaderToWorldTexture ( mudShader, "*dirt*" )
		engineApplyShaderToWorldTexture ( rockShader, "*rock*" )
		engineApplyShaderToWorldTexture ( rockShader, "*stone*" )
		engineApplyShaderToWorldTexture ( grassShader, "*grass*" )
		engineApplyShaderToWorldTexture ( grassShader, "desertgryard256" )	-- grass

		engineApplyShaderToWorldTexture ( sandShader, "*sand*" )
		engineApplyShaderToWorldTexture ( barkShader, "*leave*" )
		engineApplyShaderToWorldTexture ( barkShader, "*log*" )
		engineApplyShaderToWorldTexture ( barkShader, "*bark*" )

		-- Roads
		engineApplyShaderToWorldTexture ( roadShader, "*carpark*" )
		engineApplyShaderToWorldTexture ( road2Shader, "*hiway*" )
		engineApplyShaderToWorldTexture ( roadShader, "*junction*" )
		engineApplyShaderToWorldTexture ( paveStretchShader, "snpedtest*" )

		-- Pavement
		engineApplyShaderToWorldTexture ( paveStretchShader, "sidelatino*" )
		engineApplyShaderToWorldTexture ( paveStretchShader, "sjmhoodlawn41" )
		
		-- Others
		engineApplyShaderToWorldTexture ( roadShader, "vgnlowbuild3_256" )
		engineApplyShaderToWorldTexture ( roadShader, "BLOCK2" )
		engineApplyShaderToWorldTexture ( roadShader, "*cliff*" )
		engineApplyShaderToWorldTexture ( paveDirtyShader, "backalley1_LAe" )
		engineApplyShaderToWorldTexture ( grassShader, "sjmlahus28" )
		engineApplyShaderToWorldTexture ( paveDirtyShader, "fence1" )
		engineApplyShaderToWorldTexture ( grassShader, "hedge" )
		--engineApplyShaderToWorldTexture ( paveDirtyShader, "*laspedhus*" )
		engineApplyShaderToWorldTexture ( roadShader, "block2bb" )
		engineApplyShaderToWorldTexture ( concreteShader, "*lawn*" )
		engineApplyShaderToWorldTexture ( roadShader, "*rubble*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*quarryr*" )
		engineApplyShaderToWorldTexture ( roadShader, "desgrns256" )
		engineApplyShaderToWorldTexture ( roadShader, "desertgravel256" )
		engineApplyShaderToWorldTexture ( roadShader, "*coast*" )
		engineApplyShaderToWorldTexture ( roadShader, "*des_scrub*" )
		engineApplyShaderToWorldTexture ( barkShader, "*tree*" )
		engineApplyShaderToWorldTexture ( barkShader, "planta256" )
		engineApplyShaderToWorldTexture ( barkShader, "*tree19*" )
		engineApplyShaderToWorldTexture ( barkShader, "pinelo128" )
		engineApplyShaderToWorldTexture ( concreteShader, "man_cellarfloor128" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_flooredge" )
		engineApplyShaderToWorldTexture ( concreteShader, "*peeling_ceiling*" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_apartmenttan1" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_classyshop2" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_walledge" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_oldoffice3" )
		engineApplyShaderToWorldTexture ( roadShader, "*ws_demolishw*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*ws_blistered*" )
		engineApplyShaderToWorldTexture ( road2Shader, "*greyground*" )
		engineApplyShaderToWorldTexture ( roadShader, "*arch*" )
		engineApplyShaderToWorldTexture ( roadShader, "pier69_roof1" )
		engineApplyShaderToWorldTexture ( concreteShader, "*posh*" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_alley2_128_plain" )
		engineApplyShaderToWorldTexture ( concreteShader, "*church_sfe*" )
		engineApplyShaderToWorldTexture ( concreteShader, "sl_plazatile01" )
		engineApplyShaderToWorldTexture ( concreteShader, "LAcityhwal1" )
		engineApplyShaderToWorldTexture ( concreteShader, "sl_LAbedingsoil" )
		engineApplyShaderToWorldTexture ( roadShader, "*copart*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*artgallery*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*ws_oldoffice*" ) 
		engineApplyShaderToWorldTexture ( concreteShader, "*ws_cityhall*" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_coppersheet" )
		engineApplyShaderToWorldTexture ( concreteShader, "*door*" )
		engineApplyShaderToWorldTexture ( roadShader, "ws_usflagcrumpled" )
		engineApplyShaderToWorldTexture ( roadShader, "timber_gz" )
		engineApplyShaderToWorldTexture ( road2Shader, "*wood*" )
		engineApplyShaderToWorldTexture ( roadShader, "*ws_altz_wall*" )
		engineApplyShaderToWorldTexture ( concreteShader, "*wall*" )
		engineApplyShaderToWorldTexture ( road2Shader, "*hus*" )
		engineApplyShaderToWorldTexture ( roadShader, "*compfence*" )
		engineApplyShaderToWorldTexture ( roadShader, "*driveway*" )
		engineApplyShaderToWorldTexture ( roadShader, "CJ_SKIP" )
		engineApplyShaderToWorldTexture ( road2Shader, "rooftoprd128" )
		engineApplyShaderToWorldTexture ( road2Shader, "lasjmslumruf" )
		engineApplyShaderToWorldTexture ( road2Shader, "adet" )
		engineApplyShaderToWorldTexture ( road2Shader, "*shingle*" )
		engineApplyShaderToWorldTexture ( road2Shader, "*Was_*" )
		engineApplyShaderToWorldTexture ( road2Shader, "pierboards_la" )
		engineApplyShaderToWorldTexture ( road2Shader, "sanpedowd5" )
		engineApplyShaderToWorldTexture ( road2Shader, "*mural*" )
		engineApplyShaderToWorldTexture ( roadShader, "sjmbigold1" )
		engineApplyShaderToWorldTexture ( roadShader, "ct_hole" )
		engineApplyShaderToWorldTexture ( roadShader, "czech" )
		engineApplyShaderToWorldTexture ( roadShader, "poolballsa1" )
		engineApplyShaderToWorldTexture ( roadShader, "ahoodfence2" )
		engineApplyShaderToWorldTexture ( roadShader, "counter01_law" )
		engineApplyShaderToWorldTexture ( roadShader, "pax256hi" )
		engineApplyShaderToWorldTexture ( roadShader, "sw_hardware02" )
		engineApplyShaderToWorldTexture ( roadShader, "*shp*" )
		engineApplyShaderToWorldTexture ( grassShader, "*crops*" )
		engineApplyShaderToWorldTexture ( road2Shader, "darkplanks1" )
		engineApplyShaderToWorldTexture ( road2Shader, "brick" )
		engineApplyShaderToWorldTexture ( roadShader, "*sunset*" )
		engineApplyShaderToWorldTexture ( road2Shader, "plasterLAh" )
		
		-- Remove detail from LOD models etc.
		for i,part in ipairs(effectParts) do
			if getElementType(part) == "shader" then
				engineRemoveShaderFromWorldTexture ( part, "tx*" )
				engineRemoveShaderFromWorldTexture ( part, "lod*" )
				engineRemoveShaderFromWorldTexture ( part, "kub_log" )
				engineRemoveShaderFromWorldTexture ( part, "*logo*" )
				engineRemoveShaderFromWorldTexture ( part, "*broadway92*" )
			end
		end
	end

end


----------------------------------------------------------------
-- disableDetail
----------------------------------------------------------------
function disableDetail()
	if not bEffectEnabled then return end

	-- Destroy all parts
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement( part )
		end
	end
	effectParts = {}
	bAllValid = false

	-- Flag effect as stopped
	bEffectEnabled = false
end


----------------------------------------------------------------
-- All the shaders
----------------------------------------------------------------
function getBrickWallShader()
	return getMakeShader( getBrickWallSettings () )
end

function getGrassShader()
	return getMakeShader( getGrassSettings () )
end

function getRoadShader()
	return getMakeShader( getRoadSettings () )
end

function getRoad2Shader()
	return getMakeShader( getRoad2Settings () )
end

function getPaveDirtyShader()
	return getMakeShader( getPaveDirtySettings () )
end

function getPaveStretchShader()
	return getMakeShader( getPaveStretchSettings () )
end

function getBarkShader()
	return getMakeShader( getBarkSettings () )
end

function getRockShader()
	return getMakeShader( getRockSettings () )
end

function getMudShader()
	return getMakeShader( getMudSettings () )
end

function getMakeShader(v)
	--  Create shader with a draw range of 100 units
	local shader,tec = dxCreateShader ( "fx/detail.fx", 1, 100 )
	if shader then
		dxSetShaderValue( shader, "sDetailTexture", v.texture );
		dxSetShaderValue( shader, "sDetailScale", v.detailScale )
		dxSetShaderValue( shader, "sFadeStart", v.sFadeStart )
		dxSetShaderValue( shader, "sFadeEnd", v.sFadeEnd )
		dxSetShaderValue( shader, "sStrength", v.sStrength )
		dxSetShaderValue( shader, "sAnisotropy", v.sAnisotropy )
	end
	return shader,tec
end


-- brick wall type thing
---------------------------------
function getBrickWallSettings ()
	local v = {}
	v.texture=detail22Texture
	v.detailScale=3
	v.sFadeStart=60
	v.sFadeEnd=100
	v.sStrength=0.6
	v.sAnisotropy=1
	return v
end
---------------------------------

-- grass
---------------------------------
function getGrassSettings ()
	local v = {}
	v.texture=detail58Texture
	v.detailScale=2
	v.sFadeStart=60
	v.sFadeEnd=100
	v.sStrength=0.6
	v.sAnisotropy=1
	return v
end
---------------------------------

-- road
---------------------------------
function getRoadSettings ()
	local v = {}
	v.texture=detail68Texture
	v.detailScale=1
	v.sFadeStart=60
	v.sFadeEnd=100
	v.sStrength=0.6
	v.sAnisotropy=1
	return v
end
---------------------------------

-- road2
---------------------------------
function getRoad2Settings ()
	local v = {}
	v.texture=detail63Texture
	v.detailScale=1
	v.sFadeStart=90
	v.sFadeEnd=100
	v.sStrength=0.7
	v.sAnisotropy=0.9
	return v
end
---------------------------------

-- dirty pave
---------------------------------
function getPaveDirtySettings ()
	local v = {}
	v.texture=dirtyTexture
	v.detailScale=1
	v.sFadeStart=60
	v.sFadeEnd=100
	v.sStrength=0.4
	v.sAnisotropy=1
	return v
end
---------------------------------

-- stretch pave 
---------------------------------
function getPaveStretchSettings ()
	local v = {}
	v.texture=detail04Texture
	v.detailScale=1
	v.sFadeStart=80
	v.sFadeEnd=100
	v.sStrength=0.3
	v.sAnisotropy=1
	return v
end
---------------------------------

-- tree bark
---------------------------------
function getBarkSettings ()
	local v = {}
	v.texture=detail29Texture
	v.detailScale=1
	v.sFadeStart=80
	v.sFadeEnd=100
	v.sStrength=0.6
	v.sAnisotropy=1
	return v
end
---------------------------------

-- rock
---------------------------------
function getRockSettings ()
	local v = {}
	v.texture=detail55Texture
	v.detailScale=1
	v.sFadeStart=80
	v.sFadeEnd=100
	v.sStrength=0.5
	v.sAnisotropy=1
	return v
end
---------------------------------

-- mud
---------------------------------
function getMudSettings ()
	local v = {}
	v.texture=detail35TTexture
	v.detailScale=2
	v.sFadeStart=80
	v.sFadeEnd=100
	v.sStrength=0.6
	v.sAnisotropy=1
	return v
end
---------------------------------
