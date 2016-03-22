function initTraffic()
	last_yield = getTickCount()
	initTrafficMap()
	loadPaths()
	calculateNodeLaneCounts()
	loadZOffsets()
	initAI()
	initTrafficGenerator()
	traffic_initialized = true
end

function startTrafficInitialization()
	traffic_initialization = coroutine.create(initTraffic)
	keepLoadingTraffic()
end
addEventHandler("onResourceStart",resourceRoot,startTrafficInitialization)

function keepLoadingTraffic()
	if traffic_initialized then
		traffic_initialized = nil
		last_yield = nil
		return
	end
	coroutine.resume(traffic_initialization)
	setTimer(keepLoadingTraffic,50,1)
end

function checkThreadYieldTime()
	local this_time = getTickCount()
	if this_time-last_yield >= 4000 then
		coroutine.yield()
		last_yield = this_time
	end
end

