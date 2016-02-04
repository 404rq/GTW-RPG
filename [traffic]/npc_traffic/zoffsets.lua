function loadZOffsets()
	z_offset = {}
	local zfile = xmlLoadFile("zoffsets.xml")
	if not zfile then
		outputDebugString("Failed to load zoffsets.xml",2)
		return
	end
	local znodes = xmlNodeGetChildren(zfile)
	for znum,znode in ipairs(znodes) do
		local attr = xmlNodeGetAttributes(znode)
		z_offset[tonumber(attr.model)] = tonumber(attr.z)
	end
	xmlUnloadFile(zfile)
end

