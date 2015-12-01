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
        setPlayerNametagColor(plr, tagR or 255, tagG or 255, tagB or 255)

        -- Load skind or set a random one if not available
        local rnd_skin = math.random(20,46)
        setElementModel(plr, getAccountData(acc, "GTWdata.skin.current") or rnd_skin)
        setAccountData(acc, "clothes.boughtSkin", getAccountData(acc, "GTWdata.skin.current") or rnd_skin)

        -- Load and set team and occupation
        setPlayerTeam(plr, getTeamFromName(getAccountData(acc,
                "GTWdata.team.occupation") or "Unemployed"))
        setElementData(plr, "Occupation", getAccountData(acc,
                "GTWdata.team.occupation.sub") or "")

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
        if not play_time then
        	setPlayerMoney(plr, 1337)
                setAccountData(acc, "GTWdata.playtime", 0)
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
       	applyStaffAdvantage(source)

        -- Jail player if arrested
        if getAccountData(acc, "GTWdata.police.isArrested") == "YES" then
                local wl,viol = exports.GTWwanted:getWl(plr)
                local j_time = math.floor(wl*1000*10)
                exports.GTWjail:Jail(plr, math.floor(j_time/1000), "LSPD")
        end

        -- Mark first spawn as valid
        setElementData(source, "GTWdata.isFirstSpawn", nil)
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
        setAccountData(acc, "GTWdata.wanted", getElementData(plr, "Wanted") or 0)
        setAccountData(acc, "GTWdata.wanted.viol", getElementData(plr, "violent_time" or 0))

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

        -- Skip these
        --setAccountData(playeraccount, "GTWdata.loc.city", city)
        --setAccountData(playeraccount, "GTWdata.gear.type", gearType)
        --setAccountData(playeraccount, "GTWdata.lawbanned", lawban)
        --setAccountData(playeraccount, "GTWdata.is.worker", isWorker)
end
