function logPayment(message)
	--outputServerLog(message)
end
addEvent("dxmoneylogs.logPayment", true)
addEventHandler("dxmoneylogs.logPayment", root, logPayment)