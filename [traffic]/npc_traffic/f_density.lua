function setTrafficDensity(trtype,density)
	density = tonumber(density)
	if density then
		density = density*0.01
		if traffic_density[trtype] then
			traffic_density[trtype] = density
			return true
		end
	else
		density = tonumber(trtype)
		if density then
			density = density*0.01
			for trtype in pairs(traffic_density) do
				traffic_density[trtype] = density
			end
			return true
		end
	end
	return false
end

function getTrafficDensity(trtype)
	return trtype and traffic_density[trtype] or false
end

