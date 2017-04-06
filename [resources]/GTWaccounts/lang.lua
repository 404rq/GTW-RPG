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
		["msg_rental_shop"] 	= "Här kan du hyra en bil för en fast timkostnad",
		["msg_fuel"] 		= "Alla fordon behöver bränsle, här kan du tanka bilen",
		["msg_skin_shop"] 	= "Detta är en skinshop, här kan du ändra utseende",
		["msg_gym"] 		= "Besök gymmet om du vill bygga muskler eller förbättra konditionen",
		["msg_health"] 		= "Du kan höja din hälsa genom att äta",
		["msg_gang"] 		= "Klicka på F6 för att öppna panelen där du kan skapa grupper och gäng",
		["msg_gang2"] 		= "Ta över och kontrollera områden för att tjäna pengar som gängmedlem",
		["msg_work"] 		= "Detta är ett arbete, här kan du söka jobb och tjäna pengar på hederligt vis",
		["msg_initialize"]	= "Initialiserar intro...",
	},
}
