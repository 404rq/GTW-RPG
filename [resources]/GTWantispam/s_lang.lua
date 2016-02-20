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

-- Definition of default language for this resource
r_lang = exports.GTWcore:getGTWLanguage() or "en_US"

-- Language text storage for this resource
txt = {
	-- English/English
	["en_US"] = {
		["msg_no_spam"] 	= "Do not spam commands!",
		["log_cmd_issuer"]	= " issued the server command: '",
	},

	-- Swedish/Svenska
	["sv_SE"] = {
		["msg_no_spam"] 	= "Kommando spam är ej tillåtet!",
		["log_cmd_issuer"]	= " utförde följande kommando: '",
	},
}
-- Spanish/Español
es_ES = {
	["msg_no_spam"] 	= "No hagas spam de comandos!",
	["log_cmd_issuer"]	= " ejecutó el siguiente comando: '",
}
