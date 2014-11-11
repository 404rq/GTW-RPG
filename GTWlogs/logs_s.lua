--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

money_data = dbConnect("sqlite", "logs.db")

--[[ Create a database table to store money data ]]--
addEventHandler("onResourceStart", getResourceRootElement(),
function()	
	dbExec(money_data, "CREATE TABLE IF NOT EXISTS `money_log` (`ID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, `account` TEXT, `nick` TEXT, `m_type` NUMERIC, `amount` NUMERIC, `date` NUMERIC);")
end)

--[[ Insert changes into database ]]--
function insertDB(amount, c_type)
	-- Get player account
	local account = getAccountName(getPlayerAccount(client))
	if not account then return end
	if not amount or not tonumber(amount) then return end
	
	-- Save into log
	local time = getRealTime()
	local m_type = 1
	if c_type then m_type = 2 end
	dbExec(money_data, "INSERT INTO money_log VALUES (NULL, ?, ?, ?, ?, ?);", account, getPlayerName(client), m_type, tonumber(amount), time.timestamp)
end
addEvent("GTWlog.insert", true)
addEventHandler("GTWlog.insert", root, insertDB)

--[[ Get money ]]--
function add(plr, amount)
	givePlayerMoney(plr, tonumber(amount))
end
function addC(amount)
	givePlayerMoney(client, tonumber(amount))
end
addEvent( "GTWlogs.add", true )
addEventHandler("GTWlogs.add", root, addC)

--[[ Set money ]]--
function sub(plr, amount)
	takePlayerMoney(plr, tonumber(amount))
end
function subC(amount)
	takePlayerMoney(client, tonumber(amount))
end
addEvent( "GTWlogs.sub", true )
addEventHandler( "GTWlogs.sub", root, subC )