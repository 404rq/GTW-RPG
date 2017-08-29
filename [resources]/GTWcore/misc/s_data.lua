--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/404rq/GTW-RPG/
	Bugtracker: 		https://discuss.404rq.com/t/issues
	Suggestions:		https://discuss.404rq.com/t/development

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

--[[ Load player data ]]--
function load_data(plr)
        -- Make sure we have a vaplid player element
        if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end

        -- Get and validate player account
        local acc = getPlayerAccount(plr)
        if not acc or isGuestAccount(acc) then return end

        -- Load money in pocket
        setPlayerMoney(plr, tonumber(get_account_data(acc, "GTWdata.money")) or 0)

        -- Restore rotation
        local rotX = get_account_data(acc, "GTWdata.loc.rot.x") or 0
    	local rotY = get_account_data(acc, "GTWdata.loc.rot.y") or 0
    	local rotZ = get_account_data(acc, "GTWdata.loc.rot.z") or 0
        setElementRotation(plr, rotX, rotY, rotZ)

        -- Load team and nametag colors
        local tagR = get_account_data(acc, "GTWdata.col.r")
        local tagG = get_account_data(acc, "GTWdata.col.g")
        local tagB = get_account_data(acc, "GTWdata.col.b")
        setPlayerNametagColor(plr, tagR or 255, tagG or 255, tagB or 0)

        -- Load skind or set a random one if not available
        local rnd_skin = math.random(20,46)
        setElementModel(plr, get_account_data(acc, "GTWdata.skin.current") or rnd_skin)

        -- Load and set team and occupation
        setPlayerTeam(plr, getTeamFromName(get_account_data(acc,
                "GTWdata.team.occupation") or "Unemployed"))
        setElementData(plr, "Occupation", get_account_data(acc,
                "GTWdata.team.occupation.sub") or "")

        -- Load current group
        setElementData(plr, "Group", get_account_data(acc, "GTWdata.group") or "")

        -- Load wanted level and violent time
        exports.GTWwanted:setWl(plr, (tonumber(get_account_data(acc,
                "GTWdata.wanted")) or 0), (tonumber(get_account_data(acc,
                "GTWdata.wanted.viol")) or 0))

        setElementInterior(plr, get_account_data(acc, "GTWdata.loc.int") or 0)
        setElementDimension(plr, get_account_data(acc, "GTWdata.loc.dim") or 0)

        -- Load health and armor
        setElementHealth(plr, get_account_data(acc, "GTWdata.health") or 100)
        setPedArmor(plr, get_account_data(acc, "GTWdata.armor") or 0)

        -- Assuming first login, hand out start money and setup basic defaults
        local play_time = get_account_data(acc, "GTWdata.playtime") or 0
        if tonumber(play_time) == 0 then
        	setPlayerMoney(plr, 4000)
                set_account_data(acc, "GTWdata.playtime", 0)
                set_account_data(acc, "GTWdata.skin.current", rnd_skin)
                set_account_data(acc, "GTWclothes.personal.skin", get_account_data(acc, "GTWdata.skin.current"))

		-- Give the player their first weapon
		giveWeapon(plr, 4, 1, false)
		giveWeapon(plr, 24, 35, false)

		-- Display basic newbie information
		local px,py,pz = getElementPosition(plr)
		exports.GTWtopbar:dm("You have just arrived in "..getZoneName(px,py,pz)..", "..
			getZoneName(px,py,pz, true).." with $4´000 in your pocket", plr, 255,255,255, false, true)
       	end

        -- Show welcome message
        outputChatBox("[GTWhelp]#EEEEEE Welcome to GTW-RPG! press F1 for help GUI or type /helpme for a list of available commands", plr, 255,100,0, true)

        -- Enable help if playtime is less than 12 hour only
        if tonumber(play_time) < 12*3600*1000 then
                setElementData(plr, "GTWdata.isNew", true)
        end

	-- 2016-02-11 Bugfix for an issue where work skins became players owned skin,
	-- forbidden skins are reset by default
	local forbidden_skins = {     [265]=true,[266]=true,[267]=true,[274]=true,[275]=true,[276]=true,
		[278]=true,[279]=true,[280]=true,[281]=true,[282]=true,[283]=true,[284]=true,[285]=true,
		[286]=true,[287]=true,[288]=true }
	if forbidden_skins[getElementModel(plr)] and getPlayerTeam(plr) ~= getTeamFromName("Government")
		and getPlayerTeam(plr) ~= getTeamFromName("Emergency service") then
		set_account_data(acc, "GTWclothes.personal.skin", 0)
		exports.GTWtopbar:dm("Notice: Your skin was reset to CJ (ID: 0) due to a previous skin bug", plr, 255,100,0)
		setElementModel(plr, 0)
	end

        -- Load weapons and stats
        for k=1, 12 do
        	local weapon = tonumber(get_account_data(acc, "GTWdata.weapon."..tostring(k))) or 0
        	local ammo = tonumber(get_account_data(acc, "GTWdata.ammo."..tostring(k))) or 0
                local stat = tonumber(get_account_data(acc, "GTWdata.weapon.stats."..tostring(k+68))) or 0

                -- Set weapon, saved amount of ammo and stats
               	giveWeapon(plr, weapon, ammo, false)
                setPedStat(plr, (k+68), stat)
        end

        -- Apply jetpack and other advantages if staff
       	applyStaffAdvantage(plr)

        -- Jail player if arrested
        if get_account_data(acc, "GTWdata.police.jailTimeOffline") and tonumber(get_account_data(acc, "GTWjail.timeLeftInMS") or 0) > 0 then
                local wl = tonumber(get_account_data(acc, "GTWdata.wanted")) or 0
                local j_time = math.floor(tonumber(get_account_data(acc, "GTWjail.timeLeftInMS"))/(1000))
                if j_time and j_time > 0 and wl > 0 then
		        exports.GTWjail:Jail(plr, j_time, "LSPD")
                end

		-- Reset jail order
		set_account_data(acc, "GTWdata.police.jailTimeOffline", nil)
        end

        -- Mark first spawn as valid
        setElementData(plr, "GTWdata.isFirstSpawn", nil)
end

--[[ Save player data ]]--
function save_data(plr)
        -- Make sure we have a vaplid player element
        if not plr or not isElement(plr) or getElementType(plr) ~= "player" then return end

        -- Get and validate player account
        local acc = getPlayerAccount(plr)
        if not acc or isGuestAccount(acc) then return end

        -- Save the money in pocket first
        set_account_data(acc, "GTWdata.money", getPlayerMoney(plr) or 0)

        -- Move on to location data
        local x,y,z = getElementPosition(plr)
        set_account_data(acc, "GTWdata.loc.x", x)
        set_account_data(acc, "GTWdata.loc.y", y)
        set_account_data(acc, "GTWdata.loc.z", z)

        -- And rotation data
        local rotX,rotY,rotZ = getElementRotation(plr)
        set_account_data(acc, "GTWdata.loc.rot.x", rotX)
        set_account_data(acc, "GTWdata.loc.rot.y", rotY)
        set_account_data(acc, "GTWdata.loc.rot.z", rotZ)

        -- Do not forget interior and dimension
        set_account_data(acc, "GTWdata.loc.int", getElementInterior(plr) or 0)
        set_account_data(acc, "GTWdata.loc.dim", getElementDimension(plr) or 0)

        -- Save current skin for the next login
        set_account_data(acc, "GTWdata.skin.current", getElementModel(plr) or 0)

        -- Save wanted level and violent time
        local wl,viol = exports.GTWwanted:getWl(plr)
        set_account_data(acc, "GTWdata.wanted", wl or 0)
        set_account_data(acc, "GTWdata.wanted.viol", viol or 0)

        -- Solutions for servers without GTWcivilians
        if not getTeamFromName("Unemployed") then
                local new_team = createTeam("Unemployed", 255,255,0)
                setPlayerTeam(plr, new_team)

                -- Add some scoreboard collumns
                exports.scoreboard:scoreboardAddColumn("Occupation", root, 90)
        	exports.scoreboard:scoreboardAddColumn("Money", root, 70)
        	exports.scoreboard:scoreboardAddColumn("Playtime", root, 70)

                -- Create a staff team assuming that doesn't exist
                if not getTeamFromName("Staff") then
                        createTeam("Staff", 255,255,255)
                end
        end

        -- Team, occupation and team colors
        local plr_team = getPlayerTeam(plr) or getTeamFromName("Unemployed")
        local r,g,b = getTeamColor(plr_team)
        set_account_data(acc, "GTWdata.team.occupation", getTeamName(plr_team))
        set_account_data(acc, "GTWdata.team.occupation.sub", getElementData(plr, "Occupation") or "")
        set_account_data(acc, "GTWdata.col.r", r)
        set_account_data(acc, "GTWdata.col.g", g)
        set_account_data(acc, "GTWdata.col.b", b)

        -- Save current health and armor
        set_account_data(acc, "GTWdata.health", getElementHealth(plr))
        set_account_data(acc, "GTWdata.armor", getPedArmor(plr))

        -- Weapons, ammo and weapon stats
        local tmp_slot = getPedWeaponSlot(plr)
        for k=1, 12 do
                local stat_wep = getPedStat(plr, (k+68))
                set_account_data(acc, "GTWdata.weapon.stats."..tostring((k+68)), stat_wep)
                local weapon = getPedWeapon(plr, k)
                setPedWeaponSlot(plr, k)
                local ammo = getPedTotalAmmo(plr, k)

                -- Save data fetched earlier
                set_account_data(acc, "GTWdata.weapon."..tostring(k), tostring(weapon))
	   	set_account_data(acc, "GTWdata.ammo."..tostring(k), tostring(ammo))
        end
        setPedWeaponSlot(plr, tmp_slot)
end
