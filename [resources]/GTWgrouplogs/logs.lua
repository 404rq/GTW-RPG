local message 	= { }
local lastnick 	= { }

local db = dbConnect("sqlite", "logs.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS groupLog (name TEXT, log TEXT, date TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS lastNick (account TEXT, nick TEXT)")

function getServerTime ( )
    local aRealTime = getRealTime()
    return
	string.format ( "%04d/%02d/%02d", aRealTime.year + 1900, aRealTime.month + 1, aRealTime.monthday ),
	string.format ( "%02d:%02d:%02d", aRealTime.hour, aRealTime.minute, aRealTime.second )
end

function loadGroupLogs(handler)
	local data = dbPoll(handler, 0)
	
	if (not data) then return end
	
	for ind, dat in pairs(data) do
		local group = dat.name
		if (not message[group]) then message[group] = {} end
		table.insert(message[group], {msg = dat.log})
	end
end
dbQuery(loadGroupLogs, db, "SELECT * FROM groupLog")

 
function loadNicks(query)
        local d = dbPoll(query, 0)
       
        if (d) then
                for ind, data in pairs(d) do
                        lastnick[data.account] = data.nick
                end
        end
end
dbQuery(loadNicks, db, "SELECT * FROM lastNick")

function logSomething(group, msg)
	local date, time = getServerTime()
	local date = "["..date.." - "..time.."] "
	local msg = date..msg
	if (not message[group]) then message[group] = {} end
	table.insert(message[group], {msg =  msg})
	dbExec(db, "INSERT INTO groupLog (name, log, date) VALUES (?, ?, ?)", tostring(group), tostring(msg), tostring(date))
end

function viewLog(plr, group)
	triggerClientEvent(plr, "GTWlogs.openLog", plr, group, message[group], "groupLog", true)
end

function getLastNick(account)
        return lastnick[account] or "N/A"
end
 
function setLastNick(player)
        local account = getAccountName(getPlayerAccount(player))
        if (lastnick[account]) then
                dbExec(db, "UPDATE lastNick SET nick=? WHERE account=?", tostring(getPlayerName(player)), tostring(account))
        else
                dbExec(db, "INSERT INTO lastNick VALUES (?, ?)", tostring(account), tostring(getPlayerName(player)))
        end
        lastnick[account] = getPlayerName(player)
end
