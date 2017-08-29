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
r_lang = exports.GTWcore:getLanguage() or "en_US"

-- Language text storage for this resource
lang_txt = {
	-- English/English
	["en_US"] = {
		["msg_rental_shop"] 	= "This is a rental shop from where you can get a car",
		["msg_fuel"] 		= "All vehicles need fuel, you can buy fuel at any gas station",
		["msg_skin_shop"] 	= "This is a skin shop, walk inside to buy a new skin",
		["msg_gym"] 		= "Visit the gym to improve your stamina or muscles",
		["msg_health"] 		= "You can regain your health by eating, literally anything",
		["msg_gang"] 		= "Create/join a gang by pressing F6 to open your gang/goup/clan panel",
		["msg_gang2"] 		= "When you're in a gang you can capture turfs to gain money and respect",
		["msg_work"] 		= "This is a work place, you can get a job here to make money",
		["msg_initialize"]	= "Initializing...",
	},

	-- Swedish/Svenska
	["sv_SE"] = {
		["msg_rental_shop"] 	= "H�r kan du hyra en bil f�r en fast timkostnad",
		["msg_fuel"] 		= "Alla fordon beh�ver br�nsle, h�r kan du tanka bilen",
		["msg_skin_shop"] 	= "Detta �r en skinshop, h�r kan du �ndra utseende",
		["msg_gym"] 		= "Bes�k gymmet om du vill bygga muskler eller f�rb�ttra konditionen",
		["msg_health"] 		= "Du kan h�ja din h�lsa genom att �ta",
		["msg_gang"] 		= "Klicka p� F6 f�r att �ppna panelen d�r du kan skapa grupper och g�ng",
		["msg_gang2"] 		= "Ta �ver och kontrollera omr�den f�r att tj�na pengar som g�ngmedlem",
		["msg_work"] 		= "Detta �r ett arbete, h�r kan du s�ka jobb och tj�na pengar p� hederligt vis",
		["msg_initialize"]	= "Initialiserar intro...",
	},
}
