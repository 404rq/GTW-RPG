--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG
	Bugtracker: 		https://forum.404rq.com/bug-reports
	Suggestions:		https://forum.404rq.com/mta-servers-development
	Donations:		https://www.404rq.com/donations

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Get account data for given key and account ]]--
function get_account_data(account, data_key)
        -- Use desault function if MySQL is inactive
        if not core_db then return getAccountData(account, data_key) end

        -- Correct details
        if tostring(account) == "guest" then return end
        if not getAccount(tostring(account)) then account = getAccountName(account) end

        -- Use MySQL to store data
        if not account or not data_key then return nil end
        local query_res = dbQuery(core_db, "SELECT data_value FROM account_data WHERE account=? AND data_key=?", account, data_key)
        local result = dbPoll(query_res, -1)
        local str_data = nil

        -- Get the json string
        for _,row in ipairs(result) do
                --outputServerLog("getAccountData: "..account..", "..data_key.." = "..row["data_value"])
                str_data = row["data_value"]
                break
        end

        -- Cleanup and return result
        if query_res then dbFree(query_res) end
        if not str_data then str_data = nil end
        if tonumber(str_data) ~= nil then str_data = tonumber(str_data) end
        return str_data
end

--[[ Set account data for given key and account ]]--
function set_account_data(account, data_key, data_value)
        -- Use desault function if MySQL is inactive
        if not core_db then setAccountData(account, data_key, data_value) return end

        -- Correct details
        if tostring(account) == "guest" then return end
        if not getAccount(tostring(account)) then account = getAccountName(account) end

        -- Use MySQL to store data
        local query_res = nil
        local old_value = get_account_data(account, data_key)
        if old_value == false then old_value = true end
        if old_value == 0 then old_value = true end
        if old_value and data_value and data_key and account then
                --outputServerLog("setAccountData: (UPDATE) "..tostring(old_value).." | "..account..", "..data_key.." = "..data_value)
                query_res = dbQuery(core_db, "UPDATE account_data SET data_value=? WHERE account=? AND data_key=?", data_value, account, data_key)
        elseif data_value and data_key and account then
                --outputServerLog("setAccountData: (INSERT) "..tostring(old_value).." | "..account..", "..data_key.." = "..data_value)
                query_res = dbQuery(core_db, "INSERT INTO account_data (`account`, `data_key`, `data_value`)VALUES (?,?,?)", account, data_key, data_value)
        end
        if query_res then dbFree(query_res) end
        return query_res
end
