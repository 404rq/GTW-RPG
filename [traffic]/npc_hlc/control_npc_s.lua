UPDATE_INTERVAL_MS = 2000
UPDATE_INTERVAL_MS_INV = 1/UPDATE_INTERVAL_MS
UPDATE_INTERVAL_S = UPDATE_INTERVAL_MS*0.001
UPDATE_INTERVAL_S_INV = 1/UPDATE_INTERVAL_S

function initNPCControl()
	addEvent("npc_hlc:onNPCTaskDone",false)
	setTimer(cycleNPCs,UPDATE_INTERVAL_MS,0)
end

function cycleNPCs()
	check_cols = get("npc_hlc.server_colchecking") == "true" and "true" or nil
	if check_cols then
		server_coldata = getResourceFromName("server_coldata")
		if server_coldata and getResourceState(server_coldata) == "running" then
			call(server_coldata,"generateColData")
		else
			check_cols = nil
		end
	end

	for npc,exists in pairs(all_npcs) do
		if isHLCEnabled(npc) then
			local syncer = getElementSyncer(getPedOccupiedVehicle(npc) or npc)
			if syncer then
				if unsynced_npcs[npc] then
					removeNPCFromUnsyncedList(npc)
				end
			else
				if not unsynced_npcs[npc] then
					addNPCToUnsyncedList(npc)
				end
			end
		else
			if unsynced_npcs[npc] then
				removeNPCFromUnsyncedList(npc)
			end
		end
	end
	local this_time = getTickCount()
	local gamespeed = getGameSpeed()
	for npc,unsynced in pairs(unsynced_npcs) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			local time_diff = (this_time-getNPCLastUpdateTime(npc))*gamespeed
			while time_diff > 1 do
				local thistask = getElementData(npc,"npc_hlc:thistask")
				if thistask then
					local task = getElementData(npc,"npc_hlc:task."..thistask)
					if not task then
						removeElementData(npc,"npc_hlc:thistask")
						removeElementData(npc,"npc_hlc:lasttask")
						break
					else
						local prev_time_diff,prev_task = time_diff,task
						time_diff = time_diff-performTask[task[1]](npc,task,time_diff)
						if time_diff ~= time_diff then
							break
						end
						if time_diff > 1 then
							setNPCTaskToNext(npc)
						end
					end
				else
					break
				end
			end
			updateNPCLastUpdateTime(npc,this_time)
		end
	end
end

function setNPCTaskToNext(npc)
	local thistask = getElementData(npc,"npc_hlc:thistask")
	setElementData(npc,"npc_hlc:thistask",thistask+1)
end

function cleanUpDoneTasks(dataname,oldval)
	if notrigger then return end
	if not oldval or dataname ~= "npc_hlc:thistask" then return end
	local newval = getElementData(source,dataname)
	if not newval then return end
	if newval < oldval then
		notrigger = true
		setElementData(source,dataname,oldval)
		notrigger = nil
	end
	for tasknum = oldval,newval-1 do
		local taskstr = "npc_hlc:task."..tasknum
		local task = getElementData(source,taskstr)
		if task then
			triggerEvent("npc_hlc:onNPCTaskDone",source,task)
			removeElementData(source,taskstr)
		end
	end
end

