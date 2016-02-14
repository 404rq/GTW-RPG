function initNPCHLC()
	all_npcs = {}
	unsynced_npcs = {}
	last_update = {}
	initNPCControl()
end
addEventHandler("onResourceStart",resourceRoot,initNPCHLC)

function addNPCToUnsyncedListOnStopSync()
	addNPCToUnsyncedList(source)
end

function removeNPCFromUnsyncedListOnStartSync()
	removeNPCFromUnSyncedList(source)
end

function addNPCToUnsyncedList(npc)
	unsynced_npcs[npc] = true
	updateNPCLastUpdateTime(npc)
end

function removeNPCFromUnsyncedList(npc)
	unsynced_npcs[npc] = nil
	clearNPCLastUpdateTime(npc)
end

function destroyNPCInformationOnDestroy()
	destroyNPCInformation(source)
end

function destroyNPCInformation(npc)
	removeNPCFromUnsyncedList(npc)
	all_npcs[npc] = nil
end

--------------------------------

function updateNPCLastUpdateTime(npc,newtime)
	last_update[npc] = newtime or getTickCount()
end

function clearNPCLastUpdateTime(npc)
	last_update[npc] = nil
end

function getNPCLastUpdateTime(npc)
	return last_update[npc]
end

