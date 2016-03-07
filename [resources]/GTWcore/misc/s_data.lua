--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		http://forum.404rq.com/bug-reports/
	Suggestions:		http://forum.404rq.com/mta-servers-development/

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
        setPlayerMoney(plr, tonumber(getAccountData(acc, "GTWdata.money")) or 0)

        -- Restore rotation
        local rotX = getAccountData(acc, "GTWdata.loc.rot.x") or 0
    	local rotY = getAccountData(acc, "GTWdata.loc.rot.y") or 0
    	local rotZ = getAccountData(acc, "GTWdata.loc.rot.z") or 0
        setElementRotation(plr, rotX, rotY, rotZ)

        -- Load team and nametag colors
        local tagR = getAccountData(acc, "GTWdata.col.r")
        local tagG = getAccountData(acc, "GTWdata.col.g")
        local tagB = getAccountData(acc, "GTWdata.col.b")
        setPlayerNametagColor(plr, tagR or 255, tagG or 255, tagB or 0)

        -- Load skind or set a random one if not available
        local rnd_skin = math.random(20,46)
        setElementModel(plr, getAccountData(acc, "GTWdata.skin.current") or rnd_skin)

        -- Load and set team and occupation
        setPlayerTeam(plr, getTeamFromName(getAccountData(acc,
                "GTWdata.team.occupation") or "Unemployed"))
        setElementData(plr, "Occupation", getAccountData(acc,
                "GTWdata.team.occupation.sub") or "")

        -- Load current group
        setElementData(plr, "Group", getAccountData(acc, "GTWdata.group") or "")

        -- Load wanted level and violent time
        exports.GTWwanted:setWl(plr, (tonumber(getAccountData(acc,
                "GTWdata.wanted")) or 0), (tonumber(getAccountData(acc,
                "GTWdata.wanted.viol")) or 0))

        setElementInterior(plr, getAccountData(acc, "GTWdata.loc.int") or 0)
        setElementDimension(plr, getAccountData(acc, "GTWdata.loc.dim") or 0)

        -- Load health and armor
        setElementHealth(plr, getAccountData(acc, "GTWdata.health") or 100)
        setPedArmor(plr, getAccountData(acc, "GTWdata.armor") or 0)

        -- Assuming first login, hand out start money and setup basic defaults
        local play_time = getAccountData(acc, "GTWdata.playtime") or 0
        if play_time == 0 then
        	setPlayerMoney(plr, 4000)
                setAccountData(acc, "GTWdata.playtime", 0)
                setAccountData(acc, "GTWclothes.personal.skin", getAccountData(acc, "GTWdata.skin.current"))

		-- Give the player their first weapon
		giveWeapon(plr, 4, 1, false)
		giveWeapon(plr, 24, 35, false)

		-- Display basic newbie information
		outputChatBox("[GTWhelp]#EEEEEE Welcome to GTW-RPG! press F1 for help", plr, 255,100,0, true)
		local px,py,pz = getElementPosition(plr)
		exports.GTWtopbar:dm("You have just arrived in "..getZoneName(px,py,pz)..", "..
			getZoneName(px,py,pz, true).." with $4´000 in your pocket", plr, 255,255,255, false, true)
       	end

        -- Enable help if playtime is less than 12 hour only
        if play_time < 12*3600*1000 then
                setElementData(plr, "GTWdata.isNew", true)
        end

	-- 2016-02-11 Bugfix for an issue where work skins became players owned skin,
	-- forbidden skins are reset by default
	local forbidden_skins = {     [265]=true,[266]=true,[267]=true,[274]=true,[275]=true,[276]=true,
		[278]=true,[279]=true,[280]=true,[281]=true,[282]=true,[283]=true,[284]=true,[285]=true,
		[286]=true,[287]=true,[288]=true }
	if forbidden_skins[getElementModel(plr)] and getPlayerTeam(plr) ~= getTeamFromName("Government")
		and getPlayerTeam(plr) ~= getTeamFromName("Emergency service") then
		setAccountData(acc, "GTWclothes.personal.skin", 0)
		exports.GTWtopbar:dm("Notice: Your skin was reset to CJ (ID: 0) due to a previous skin bug", plr, 255,100,0)
		setElementModel(plr, 0)
	end

        -- Load weapons and stats
        for k=1, 12 do
        	local weapon = tonumber(getAccountData(acc, "GTWdata.weapon."..tostring(k)) or 0)
        	local ammo = tonumber(getAccountData(acc, "GTWdata.ammo."..tostring(k)) or 0)
                local stat = tonumber(getAccountData(acc, "GTWdata.weapon.stats."..tostring(k+68)) or 0)

                -- Set weapon, saved amount of ammo and stats
               	giveWeapon(plr, weapon, ammo, false)
                setPedStat(plr, (k+68), stat)
        end

        -- Apply jetpack and other advantages if staff
       	applyStaffAdvantage(plr)

        -- Jail player if arrested
        if getAccountData(acc, "GTWdata.police.jailTimeOffline") then
                local wl = tonumber(getAccountData(acc, "GTWdata.wanted")) or 0
                if wl > 0 then
                        local j_time = math.floor(wl*60)
		        exports.GTWjail:Jail(plr, j_time, "LSPD")
                end

		-- Reset jail order
		setAccountData(acc, "GTWdata.police.jailTimeOffline", nil)
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
        setAccountData(acc, "GTWdata.money", getPlayerMoney(plr) or 0)

        -- Move on to location data
        local x,y,z = getElementPosition(plr)
        setAccountData(acc, "GTWdata.loc.x", x)
        setAccountData(acc, "GTWdata.loc.y", y)
        setAccountData(acc, "GTWdata.loc.z", z)

        -- And rotation data
        local rotX,rotY,rotZ = getElementRotation(plr)
        setAccountData(acc, "GTWdata.loc.rot.x", rotX)
        setAccountData(acc, "GTWdata.loc.rot.y", rotY)
        setAccountData(acc, "GTWdata.loc.rot.z", rotZ)

        -- Do not forget interior and dimension
        setAccountData(acc, "GTWdata.loc.int", getElementInterior(plr) or 0)
        setAccountData(acc, "GTWdata.loc.dim", getElementDimension(plr) or 0)

        -- Save current skin for the next login
        setAccountData(acc, "GTWdata.skin.current", getElementModel(plr) or 0)

        -- Save wanted level and violent time
        local wl,viol = exports.GTWwanted:getWl(plr)
        setAccountData(acc, "GTWdata.wanted", wl or 0)
        setAccountData(acc, "GTWdata.wanted.viol", viol or 0)

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
        setAccountData(acc, "GTWdata.team.occupation", getTeamName(plr_team))
        setAccountData(acc, "GTWdata.team.occupation.sub", getElementData(plr, "Occupation") or "")
        setAccountData(acc, "GTWdata.col.r", r)
        setAccountData(acc, "GTWdata.col.g", g)
        setAccountData(acc, "GTWdata.col.b", b)

        -- Save current health and armor
        setAccountData(acc, "GTWdata.health", getElementHealth(plr))
        setAccountData(acc, "GTWdata.armor", getPedArmor(plr))

        -- Weapons, ammo and weapon stats
        local tmp_slot = getPedWeaponSlot(plr)
        for k=1, 12 do
                local stat_wep = getPedStat(plr, (k+68))
                setAccountData(acc, "GTWdata.weapon.stats."..tostring((k+68)), stat_wep)
                local weapon = getPedWeapon(plr, k)
                setPedWeaponSlot(plr, k)
                local ammo = getPedTotalAmmo(plr, k)

                -- Save data fetched earlier
                setAccountData(acc, "GTWdata.weapon."..tostring(k), weapon)
	   	setAccountData(acc, "GTWdata.ammo."..tostring(k), ammo)
        end
        setPedWeaponSlot(plr, tmp_slot)

        -- Skip these
        --setAccountData(playeraccount, "GTWdata.loc.city", city)
        --setAccountData(playeraccount, "GTWdata.gear.type", gearType)
        --setAccountData(playeraccount, "GTWdata.lawbanned", lawban)
        --setAccountData(playeraccount, "GTWdata.is.worker", isWorker)
end
