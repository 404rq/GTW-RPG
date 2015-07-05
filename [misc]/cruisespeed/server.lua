-- Author: __Vector__ 

addEvent ("enableVehicleCruiseSpeed", true);
addEventHandler ("enableVehicleCruiseSpeed", getRootElement (),
	function (state) 
		if state then 
			setElementSyncer (source, getVehicleController (source));
		else 		
			setElementSyncer (source, true);
		end; 
	end);

