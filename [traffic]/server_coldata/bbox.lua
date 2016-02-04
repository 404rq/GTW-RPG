function getModelBoundingBox(model,part)
	if not model or not bs_r[model] then
		outputDebugString("Invalid model argument",2)
		return false
	end

	if not part then
		return bb_x1[model],bb_y1[model],bb_z1[model],bb_x2[model],bb_y2[model],bb_z2[model]
	else
		local part_coords = bbox_part[part]
		if not part_coords then
			outputDebugString("Invalid bounding box part argument",2)
			return false
		end

		return part_coords[model]
	end
end

