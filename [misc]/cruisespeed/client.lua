-- Author: __Vector__

local cruiseSpeedKey = "c";
local cruiseSpeedInfo = "Press \"" .. cruiseSpeedKey .. "\" key to enable/disable vehicle cruise speed";
local screenw, screenh = guiGetScreenSize ();
local cruiseSpeedInfoLabel = guiCreateLabel (0.35 * screenw, screenh - 80, 0.5 * screenw, 30, cruiseSpeedInfo, false);
guiSetFont (cruiseSpeedInfoLabel, "default-bold-small");
guiSetProperty (cruiseSpeedInfoLabel, "TextColours", "tl:AAAAAAAA tr:AAAAAAAA bl:AAAAAAAA br:AAAAAAAA");
guiSetVisible (cruiseSpeedInfoLabel, false);

local cruiseSpeedInfoStateLabel = guiCreateLabel (0.35 * screenw, screenh - 58, 0.4 * screenw, 30, "", false);
guiSetFont (cruiseSpeedInfoStateLabel, "default-bold-small");
guiSetProperty (cruiseSpeedInfoStateLabel, "TextColours", "tl:AAAAAAAA tr:AAAAAAAA bl:AAAAAAAA br:AAAAAAAA");
guiSetVisible (cruiseSpeedInfoStateLabel, false);

local hideCruiseSpeedInfoTimer, hideCruiseSpeedInfoUpdaterAlive;
local hideCruiseSpeedInfoStateTimer;

local function hideCruiseSpeedInfoUpdater (dt)
	dt = dt * 0.001;
	local alpha = guiGetAlpha (cruiseSpeedInfoLabel);
	alpha = alpha - 0.5 * dt;
	if alpha <= 0 then guiSetVisible (cruiseSpeedInfoLabel, false); removeEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoUpdater); return; end;
	guiSetAlpha (cruiseSpeedInfoLabel, alpha);
end;

local function hideCruiseSpeedInfoStateUpdater (dt)
	dt = dt * 0.001;
	local alpha = guiGetAlpha (cruiseSpeedInfoStateLabel);
	alpha = alpha - 0.5 * dt;
	if alpha <= 0 then guiSetVisible (cruiseSpeedInfoStateLabel, false); removeEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoStateUpdater); return; end;
	guiSetAlpha (cruiseSpeedInfoStateLabel, alpha);
end;


local cruiseSpeedEnabled, cruiseSpeed;
local function cruiseSpeedChecker ()
	local theVehicle = getPedOccupiedVehicle (getLocalPlayer ());
	local vX, vY, vZ = getElementVelocity (theVehicle);
	local pX, pY, pZ = getElementPosition(theVehicle);
	local iv = 1/math.sqrt (vX^2 + vY^2 + vZ^2);
	local mX, mY, mZ = vX * iv * cruiseSpeed, vY * iv * cruiseSpeed, vZ * iv * cruiseSpeed or 0,0,0
	local abs = math.sqrt (mX^2 + mY^2 + mZ^2);
	if getVehicleType( theVehicle ) == "Train" then
		if getTrainSpeed( theVehicle ) > 0 then
			--setTrainSpeed( theVehicle, abs )
			setControlState ( "accelerate", true )
		else
			--setTrainSpeed( theVehicle, -abs )
			setControlState ( "brake_reverse", true )
		end
	elseif getVehicleType( theVehicle ) == "Boat" and pZ < 0.5 then
		setControlState ( "accelerate", true )
	elseif getVehicleType( theVehicle ) == "Plane" or getVehicleType( theVehicle ) == "Helicopter" then
		setPedControlState( localPlayer, "accelerate", true )
	elseif getVehicleType( theVehicle ) == "Automobile" or getVehicleType( theVehicle ) == "Bike" then
		setElementVelocity( theVehicle, mX, mY, mZ)
	end
	local fuel = tonumber(getElementData( theVehicle, "vehicleFuel" )) or 0
	if fuel < 1 or not getVehicleEngineState( theVehicle ) then
		triggerServerEvent ("enableVehicleCruiseSpeed",  getPedOccupiedVehicle (getLocalPlayer ()), false);
		removeEventHandler ("onClientPreRender", getRootElement (), cruiseSpeedChecker);
		removeEventHandler ("onClientVehicleCollision", getPedOccupiedVehicle (getLocalPlayer ()), cruiseSpeedCollisionChecker);
		
		setControlState ( "accelerate", false )
		setControlState ( "brake_reverse", false )
		unbindKey ("accelerate", "down", toggleCruiseSpeed);
		unbindKey ("brake_reverse", "down", toggleCruiseSpeed);
	end
end;

__cruiseSpeedCollisionChecker = {};
local function cruiseSpeedCollisionChecker ()
	__cruiseSpeedCollisionChecker ();
end;

local function toggleCruiseSpeedInfoState ()
	if isTimer (hideCruiseSpeedInfoStateTimer) then
		killTimer (hideCruiseSpeedInfoStateTimer);
	else
		if guiGetVisible (cruiseSpeedInfoStateLabel) then
			removeEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoStateUpdater);
		end;
	end;

	guiSetVisible (cruiseSpeedInfoStateLabel, true);
	guiSetAlpha (cruiseSpeedInfoStateLabel, 1);
	if cruiseSpeedEnabled then guiSetText (cruiseSpeedInfoStateLabel, "Cruise Speed Enabled");
	else  guiSetText (cruiseSpeedInfoStateLabel, "Cruise Speed Disabled");
	end;
	hideCruiseSpeedInfoStateTimer = setTimer (
		function ()
			addEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoStateUpdater);
		end,
		3000,1);
end;

local function toggleCruiseSpeed ()
	if not cruiseSpeedEnabled then
		local theVehicle = getPedOccupiedVehicle (getLocalPlayer ());
		local vX, vY, vZ = getElementVelocity (theVehicle);
		cruiseSpeed = math.sqrt (vX^2 + vY^2 + vZ^2);
		if cruiseSpeed < (1/180) then return; end;
		triggerServerEvent ("enableVehicleCruiseSpeed", theVehicle, true);
		addEventHandler ("onClientPreRender", getRootElement (), cruiseSpeedChecker);
		addEventHandler ("onClientVehicleCollision", theVehicle, cruiseSpeedCollisionChecker);
		
		--setControlState ( "accelerate", true )
		bindKey ("accelerate", "down", toggleCruiseSpeed);
		bindKey ("brake_reverse", "down", toggleCruiseSpeed);
	else
		triggerServerEvent ("enableVehicleCruiseSpeed",  getPedOccupiedVehicle (getLocalPlayer ()), false);
		removeEventHandler ("onClientPreRender", getRootElement (), cruiseSpeedChecker);
		removeEventHandler ("onClientVehicleCollision", getPedOccupiedVehicle (getLocalPlayer ()), cruiseSpeedCollisionChecker);
		
		setControlState ( "accelerate", false )
		unbindKey ("accelerate", "down", toggleCruiseSpeed);
		unbindKey ("brake_reverse", "down", toggleCruiseSpeed);
	end;
	cruiseSpeedEnabled = not cruiseSpeedEnabled;
	toggleCruiseSpeedInfoState ();
end;

setmetatable (__cruiseSpeedCollisionChecker, {__call = function () toggleCruiseSpeed (); end});

local function onClientVehicleEnterHandler ()
	guiSetVisible (cruiseSpeedInfoLabel, true);
	guiSetAlpha (cruiseSpeedInfoLabel, 1);
	hideCruiseSpeedInfoTimer = setTimer (
		function ()
			hideCruiseSpeedInfoUpdaterAlive = true;
			addEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoUpdater);
		end,
		3000,1);
	bindKey (cruiseSpeedKey, "down", toggleCruiseSpeed);
	cruiseSpeedEnabled = false;
end;

addEventHandler ("onClientVehicleEnter", getRootElement (),
	function (thePlayer, seat)
		if (thePlayer == getLocalPlayer ()) and (seat == 0) then onClientVehicleEnterHandler (); end;
	end);

addEventHandler ("onClientResourceStart", getResourceRootElement (getThisResource ()),
	function ()
		if isPedInVehicle (getLocalPlayer ()) then
			local theVehicle = getPedOccupiedVehicle (getLocalPlayer ());
			if getVehicleController (theVehicle) == getLocalPlayer () then onClientVehicleEnterHandler (); end;
		end;
	end);

addEventHandler ("onClientVehicleExit", getRootElement (),
	function (thePlayer, seat)
		if (thePlayer == getLocalPlayer ()) and (seat == 0) then
			if isTimer (hideCruiseSpeedInfoTimer) then
				guiSetVisible (cruiseSpeedInfoLabel, false);
				killTimer (hideCruiseSpeedInfoTimer);
			else
				if hideCruiseSpeedInfoUpdaterAlive then
					guiSetVisible (cruiseSpeedInfoLabel, false);
					removeEventHandler ("onClientPreRender", getRootElement (), hideCruiseSpeedInfoUpdater);
				end;
			end;
			unbindKey (cruiseSpeedKey, "down", toggleCruiseSpeed);
		end;
	end);


