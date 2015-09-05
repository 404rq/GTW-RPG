-- Made By XX3, from scratch with MS Notepad. Purpose: To make a new exotic compact HUD.
-- You may edit this resource, but please credit me if you wanted to post an edited / extended version.
-- PS: I was in MTA SA to show what Indonesia is really made of! :D


-- Weapon tables for ammo.
	resourceroot = getResourceRootElement(getThisResource())
	local lastWL = 0
	local crimInfoString = ""
	local noreloadweapons = {} --Weapons that doesn't reload(including the flamethrower, minigun, which doesn't have reload anim).
	noreloadweapons[16] = true
	noreloadweapons[17] = true
	noreloadweapons[18] = true
	noreloadweapons[19] = true
	noreloadweapons[25] = true
	noreloadweapons[33] = true
	noreloadweapons[34] = true
	noreloadweapons[35] = true
	noreloadweapons[36] = true
	noreloadweapons[37] = true
	noreloadweapons[38] = true
	noreloadweapons[39] = true
	noreloadweapons[41] = true
	noreloadweapons[42] = true
	noreloadweapons[43] = true

	local meleespecialweapons = {} --Weapons that don't shoot, and special weapons.
	meleespecialweapons[0] = true
	meleespecialweapons[1] = true
	meleespecialweapons[2] = true
	meleespecialweapons[3] = true
	meleespecialweapons[4] = true
	meleespecialweapons[5] = true
	meleespecialweapons[6] = true
	meleespecialweapons[7] = true
	meleespecialweapons[8] = true
	meleespecialweapons[9] = true
	meleespecialweapons[10] = true
	meleespecialweapons[11] = true
	meleespecialweapons[12] = true
	meleespecialweapons[13] = true
	meleespecialweapons[14] = true
	meleespecialweapons[15] = true
	meleespecialweapons[40] = true
	meleespecialweapons[44] = true
	meleespecialweapons[45] = true
	meleespecialweapons[46] = true

local wl_red,wl_green,wl_blue = 255,255,255

function DXdraw()
	-- Makes sure the hud is hidden
	showPlayerHudComponent("armour", false)
    showPlayerHudComponent("health", false)
    showPlayerHudComponent("money", false)
    showPlayerHudComponent("clock", false)
    showPlayerHudComponent("weapon", false)
    showPlayerHudComponent("ammo", false)
    showPlayerHudComponent("money", false)
	showPlayerHudComponent("wanted", false)

	-- Variables
	if getElementData(localPlayer, "isLoggedIn") then
		sWidth, sHeight = guiGetScreenSize() -- Getting the screen size

		health = getElementHealth(getLocalPlayer())
		lineLength1 = 114 *(health / 100) -- Health bar

		armor = getPedArmor(getLocalPlayer())
		lineLength2 = 114 *(armor / 100) -- Armor bar

		ammoinclip = getPedAmmoInClip(getLocalPlayer()) -- The ammo inside the clip
		totalammo = getPedTotalAmmo(getLocalPlayer())-getPedAmmoInClip(getLocalPlayer()) -- The total ammo minus ammo inside clip
		totalammo2 = getPedTotalAmmo(getLocalPlayer())
		showammo1 = ammoinclip
		showammo2 = totalammo
		showammo3 = totalammo2

		moneycount=getPlayerMoney(getLocalPlayer())
		money= '$'..convertNumber(moneycount) -- Money

		local wantedlevel = getPlayerWantedLevel(getLocalPlayer()) --Getting the player's wanted level.


-------- Dynamic health colour thanks to 50p ----------
		tick = getTickCount()

-- For active health bar
      local maxHealth = 100;  -- get max health stat
		local colourPercent =(health / maxHealth) * 200;
		local red, green; -- we don't need blue because we don't use it, it'll be 0
		if health <(maxHealth / 2) then
		red = 200;
		green =(health / 50) *(colourPercent * 2);
else
		green = 200;
		red = 200 -((health - 50) / 50) * 200;
end
-- For inactive health bar
		local maxHealth = 75;  -- get max health stat
		local colourPercent1 =(health / maxHealth) * 75;
		local red1, green1; -- we don't need blue because we don't use it, it'll be 0
		if health <(maxHealth / 2) then
		red1 = 75;
		green1 =(health / 50) *(colourPercent1 * 2);
else
		green1 = 75;
		red1 = 75 -((health - 50) / 50) * 75;
end
local color1 = tocolor(red1, green1, 0, 190)
local color2 = tocolor(red, green, 0, 230)

 -- Health & armor background
 --dxDrawRectangle(sWidth-206,29,92,33.0,tocolor(0,0,0,200),false)

 -- For the health bar
 if getTickCount() %1500 < 500 and health <= 20 and armor <=0 then -- If health is less than 20%, armor is 0%, the health bar will blink by hiding the health bar every 1.5 seconds.

 else
 dxDrawRectangle(sWidth-205,30,114.0,14.0,color1, false) -- Health inactive bar
 dxDrawRectangle(sWidth-205,30,lineLength1,14.0,color2,false) --Health active bar
 end

 if armor <= 0 then

 else
dxDrawRectangle(sWidth-205,47,lineLength2,14.0,tocolor(200,200,200,230),false) -- Armor active bar
dxDrawRectangle(sWidth-205,47,114.0,14.0,tocolor(50,50,50,190),false) -- Armor inactive bar
end

------ DX drawing that are visible at all times
dxDrawRectangle(sWidth-84,29,78.0,33.0,tocolor(0,0,0,200),false) -- GTA Time DX Rectangle

dxDrawText(tostring(money),sWidth-300,63,sWidth-5,54,tocolor(0,0,0,200),1.2,"pricedown","right","top",false,false,false) -- Money DX text(shadow)
if moneycount >= 0 then
	dxDrawText(tostring(money),sWidth-302,66,sWidth-7,57,tocolor(0,100,0,220),1.2,"pricedown","right","top",false,false,false) -- Money DX text
else
	dxDrawText(tostring(money),sWidth-302,66,sWidth-7,57,tocolor(150,0,0,220),1.2,"pricedown","right","top",false,false,false) -- Money DX text
end

local time = getRealTime()
local hours = time.hour
local minutes = time.minute
if hours < 10 then hours = "0"..hours end
if minutes < 10 then minutes = "0"..minutes end
time = hours..":"..minutes
dxDrawText(tostring(time),sWidth-81,31,sWidth-10,16,tocolor(250,250,250,200),1.0,"diploma","center","top",false,false,false) -- GTA Time DX text

-- Now decide if the optional stuff should be drawn
if noreloadweapons [getPedWeapon(getLocalPlayer())] then
	--dxDrawRectangle(sWidth-400,0,120,34,tocolor(0,0,0,200),false)
	dxDrawText(tostring(showammo3),sWidth-450,0,sWidth-295,20,tocolor(0,0,0,255),0.9,"bankgothic","right","top",false,false,false)
	dxDrawText(tostring(showammo3),sWidth-453,0,sWidth-297,20,tocolor(200,200,200,200),0.9,"bankgothic","right","top",false,false,false)
elseif meleespecialweapons [getPedWeapon(getLocalPlayer())] then
	-- Draw Nothing for melee and special weapons.
else
	-- Weapons that reloads.
	--dxDrawRectangle(sWidth-450,0,170,34,tocolor(0,0,0,200),false)
	dxDrawText(tostring(showammo2).."/"..tostring(showammo1),sWidth-450,0,sWidth-295,20,tocolor(0,0,0,255),0.9,"bankgothic","right","top",false,false,false)
    dxDrawText(tostring(showammo2).."/"..tostring(showammo1),sWidth-453,0,sWidth-297,20,tocolor(200,200,200,200),0.9,"bankgothic","right","top",false,false,false)
end

------- Weapon icons & Ammo DX drawings
local weaponID = getPedWeapon(getLocalPlayer()); -- Get weapon ID
dxDrawImage(sWidth-268,0,52.0,52.0,"icons/".. tostring(weaponID) .. ".png",0.0,0.0,0.0,tocolor(255,255,255,200),false) -- Weapon icons image. Check the icons file if you want to take and replace weapon icons.

function showWlText()
	-- Compare last wanted level with current to see if it's increasing or reducing
	if not lastWL then lastWL = 0 end
	if not getElementData(localPlayer,"Wanted") then setElementData(localPlayer,"Wanted",0) end
	local diff = math.abs(lastWL - getElementData(localPlayer,"Wanted"))
	if lastWL < getElementData(localPlayer,"Wanted") then
		crimInfoString = "increasing"
		lastWL = getElementData(localPlayer,"Wanted")
	elseif lastWL >= getElementData(localPlayer,"Wanted") then
		crimInfoString = "reducing"
		lastWL = getElementData(localPlayer,"Wanted")
	end
	if round(diff,2) == 0.04 then
		wl_red,wl_green,wl_blue = 0,255,0
	elseif round(diff,2) == 0.03 then
		wl_red,wl_green,wl_blue = 50,255,50
	elseif round(diff,2) == 0.01 then
		wl_red,wl_green,wl_blue = 100,255,100
	elseif round(diff,3) == 0.005 then
		wl_red,wl_green,wl_blue = 255,255,255
	elseif round(diff,3) == 0.001 then	-- Usually negative
		wl_red,wl_green,wl_blue = 150,0,0
	end
	if getElementData(localPlayer, "violent_seconds") then
		wl_red,wl_green,wl_blue = 255,255,255
		dxDrawText(round(getElementData(localPlayer,"Wanted") or 0, 3)..
			" WP\n"..round(getElementData(localPlayer, "violent_seconds") or 0, 3)..
			" seconds left",0,127,sWidth-9,19.0,tocolor(0,0,0,255),0.6,
			"bankgothic","right","top",false,false,false)
		dxDrawText(round(getElementData(localPlayer,"Wanted") or 0, 3)..
			" WP\n"..round(getElementData(localPlayer, "violent_seconds") or 0, 3)..
			" seconds left",0,128,sWidth-10,19.0,tocolor(wl_red,wl_green,wl_blue,255),0.6,
			"bankgothic","right","top",false,false,false)
		if getElementData(localPlayer, "violent_seconds") == 0 then
			setElementData(localPlayer, "violent_seconds", nil)
		end
	else
		dxDrawText(round(getElementData(localPlayer,"Wanted") or 0, 3)..
			" WP\n"..crimInfoString,0,127,sWidth-9,19.0,tocolor(0,0,0,255),0.6,
			"bankgothic","right","top",false,false,false)
		dxDrawText(round(getElementData(localPlayer,"Wanted") or 0, 3)..
			" WP\n"..crimInfoString,0,128,sWidth-10,19.0,tocolor(wl_red,wl_green,wl_blue,255),0.6,
			"bankgothic","right","top",false,false,false)
	end
end

if wantedlevel == 0 then
					-- Draw nothing(Wanted level 0)
			elseif wantedlevel == 1 then
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 1
					showWlText()
			elseif wantedlevel == 2 then
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 2
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					showWlText()
			elseif wantedlevel == 3 then
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 3
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					showWlText()
			elseif wantedlevel == 4 then
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 4
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					showWlText()
			elseif wantedlevel == 5 then
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(0,0,0,100),false)
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 5
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					showWlText()
			else
					dxDrawImage(sWidth-21,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false) -- Wanted level 6
					dxDrawImage(sWidth-42,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-63,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-84,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-105,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					dxDrawImage(sWidth-126,105,16.0,19.0,"images/star.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
					showWlText()
		end
	end
end -- End of the DX Drawing function


-------- HUD toogle command functions.

function hudChanger()
    addEventHandler("onClientRender", getRootElement(), DXdraw)
    showPlayerHudComponent("armour", false)
    showPlayerHudComponent("health", false)
    showPlayerHudComponent("money", false)
    showPlayerHudComponent("clock", false)
    showPlayerHudComponent("weapon", false)
    showPlayerHudComponent("ammo", false)
    showPlayerHudComponent("money", false)
	showPlayerHudComponent("wanted", false)
	showPlayerHudComponent("breath", false)
end

addCommandHandler("showhud", hudChanger) -- Shows the Alternate HUD
addCommandHandler("hidegtahud", hudChanger) -- Hides the GTA HUD
addEventHandler("onClientResourceStart", resourceroot, hudChanger)
addEventHandler("onPlayerJoin", resourceroot, hudChanger) -- The same, but also on player join.

function hudChanger2()
	removeEventHandler("onClientRender", getRootElement(), DXdraw)
    showPlayerHudComponent("armour", true)
    showPlayerHudComponent("health", true)
    showPlayerHudComponent("money", true)
    showPlayerHudComponent("clock", true)
    showPlayerHudComponent("weapon", true)
    showPlayerHudComponent("ammo", true)
    showPlayerHudComponent("money", true)
	showPlayerHudComponent("wanted", true)
	showPlayerHudComponent("breath", true)
end
addCommandHandler("hidehud", hudChanger2) -- Removes the HUD, and shows the GTA HUD.
addCommandHandler("showgtahud", hudChanger2)
addEventHandler("onClientResourceStop", resourceroot, hudChanger2) -- When you stop the resource, executes.

function hudChanger3()
	 removeEventHandler("onClientRender", getRootElement(), DXdraw)
	 showPlayerHudComponent("all", false)
end
addCommandHandler("hideall", hudChanger3) -- Shows the Alternate HUD

function radarcommand1()
		showPlayerHudComponent("radar", true)
end
addCommandHandler("showradar", radarcommand1)

function radarcommand2()
		showPlayerHudComponent("radar", false)
end
addCommandHandler("hideradar", radarcommand2)

function round(number, digits)
  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult
end

--[[ Convert number e.g 100000 -> 100.000 ]]--
function convertNumber ( number )
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
		if ( k==0 ) then
			break
		end
	end
	return formatted
end
