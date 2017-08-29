addEventHandler("onResourceStart", resourceRoot,
function()
	-- Database connection setup, MySQL or fallback SQLite
        local mysql_host    	= exports.GTWcore:getMySQLHost() or nil
        local mysql_database 	= exports.GTWcore:getMySQLDatabase() or nil
        local mysql_user    	= exports.GTWcore:getMySQLUser() or nil
        local mysql_pass    	= exports.GTWcore:getMySQLPass() or nil
        database = dbConnect("mysql", "dbname="..mysql_database..";host="..mysql_host, mysql_user, mysql_pass, "autoreconnect=1")
        if not database then database = dbConnect("sqlite", "moneylogs.db") end

	dbExec(database, "CREATE TABLE IF NOT EXISTS moneylog(ID INT, account TEXT, amount INT, date INT)")
end)

-- Log any transaction bigger than $500
function log_payment(plr, diff)
        if not plr or not isElement(plr) or not getPlayerAccount(plr) or diff < 500 then return end
        local acc = getAccountName(getPlayerAccount(plr))
        local time = getRealTime()
	dbExec(database, "INSERT INTO moneylog(account,amount,date) VALUES(?,?,?);", acc, diff, time.timestamp)
end
addEvent("dxmoneylogs.logPayment", true)
addEventHandler("dxmoneylogs.logPayment", root, log_payment)
