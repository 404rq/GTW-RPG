--[[
********************************************************************************
	Project owner:		RageQuit community
	Project name: 		GTW-RPG
	Developers:   		Mr_Moose

	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker: 		https://forum.404rq.com/bug-reports/
	Suggestions:		https://forum.404rq.com/mta-servers-development/

	Version:    		Open source
	License:    		BSD 2-Clause
	Status:     		Stable release
********************************************************************************
]]--

-- Initialize tables for data storage
settings        = { }
settings.timer  = { }
settings.frames = { }
settings.is_running = nil

-- Setup introduction for new players
settings.intro = {
        -- LookAtX, LookAtY, LookAtZ, PosX, PosY, PosZ, Message
        [1]={ 1804.1455078125, -1932.4345703125, 13.386493682861, 1793.5693359375,
                -1924.181640625, 17.390524864197, "This is a rental shop from where you can get a car" },
        [2]={ 1940.4599609375, -1772.3994140625, 13.390598297119, 1970.6015625,
                -1742.7529296875, 17.546875, "All vehicles need fuel, you can buy fuel at any gas station" },
        [3]={ 2245.490234375, -1663.033203125, 15.469003677368, 2263.44140625,
                -1650.8525390625, 19.432439804077, "This is a skin shop, walk inside to buy a new skin" },
        [4]={ 2227.2275390625, -1721.541015625, 13.554790496826, 2223.6796875,
                -1756.4375, 16.5625, "Visit the gym to improve your stamina or muscles" },
        [5]={ 2396.2890625, -1911.6201171875, 16.460195541382, 2360.251953125,
                -1880.6142578125, 22.553737640381, "You can regain your health by eating, literally anything" },
        [6]={ 2495.810546875, -1666.443359375, 13.34375, 2456.9892578125,
                -1697.0546875, 22.953369140625, "Create/join a gang by pressing F6 to open your gang/goup/clan panel" },
        [7]={ 2495.810546875, -1666.443359375, 13.34375, 2456.9892578125,
                -1697.0546875, 22.953369140625, "When you're in a gang you can capture turfs to gain money and respect" },
        [8]={ 1808.2685546875, -1897.8447265625, 13.578125, 1797.71484375,
                -1897.3994140625, 20.402294158936, "This is a work place, you can get a job here to make money" },
}
settings.timer.limit = 360
settings.timer.current = settings.timer.limit - 30
settings.frames.current = 0
settings.message = "Initializing..."
sx,sy = guiGetScreenSize()

--[[ Reset and clean up ]]--
function reset_data()
        settings.timer.limit = 360
        settings.timer.current = settings.timer.limit - 30
        settings.frames.current = 0
        settings.message = "Initializing..."

        -- Kill event handler and reset view
        removeEventHandler("onClientRender", root, view_gtw_intro)
        if not isClientLoggedIn() then
                local x = getElementData(localPlayer, "GTWaccounts.login.coordinates.x")
                local y = getElementData(localPlayer, "GTWaccounts.login.coordinates.y")
                local z = getElementData(localPlayer, "GTWaccounts.login.coordinates.z")
                local x2 = getElementData(localPlayer, "GTWaccounts.login.coordinates.x2")
                local y2 = getElementData(localPlayer, "GTWaccounts.login.coordinates.y2")
                local z2 = getElementData(localPlayer, "GTWaccounts.login.coordinates.z2")
                setCameraMatrix(x,y,z, x2,y2,z2, 0, 80)
                guiSetVisible(window, true)
        else
                setCameraTarget(localPlayer)
                showChat(true)
        end

        -- Show radar again
        showPlayerHudComponent("radar", true)

        -- Reset temporary view coordinates
        setElementData(localPlayer, "GTWaccounts.login.coordinates.x", nil)
        setElementData(localPlayer, "GTWaccounts.login.coordinates.y", nil)
        setElementData(localPlayer, "GTWaccounts.login.coordinates.z", nil)
        setElementData(localPlayer, "GTWaccounts.login.coordinates.x2", nil)
        setElementData(localPlayer, "GTWaccounts.login.coordinates.y2", nil)
        setElementData(localPlayer, "GTWaccounts.login.coordinates.z2", nil)
end

--[[ Update 3D text message and picture ]]--
function view_gtw_intro( )
        dxDrawText(settings.message, sx+1,0, 0,sy-70, tocolor(0,0,0,255),
                1, "bankgothic", "center", "bottom", false, true)
        dxDrawText(settings.message, sx,0, 0,sy-69, tocolor(255,100,0,255),
                1, "bankgothic", "center", "bottom", false, true)

        -- Update text and screen position
        if settings.timer.current == settings.timer.limit then
                settings.frames.current = settings.frames.current + 1
                setCameraMatrix(settings.intro[settings.frames.current][4],
                        settings.intro[settings.frames.current][5],
                        settings.intro[settings.frames.current][6],
                        settings.intro[settings.frames.current][1],
                        settings.intro[settings.frames.current][2],
                        settings.intro[settings.frames.current][3], 0, 80)
                settings.message = settings.intro[settings.frames.current][7]
                settings.timer.current = 0
                fadeCamera(true, 2, 0,0,0)
                playSoundFrontEnd(11)
                -- Hise radar and chat
                showPlayerHudComponent("radar", false)
                showChat(false)
        end

        -- Stop if finished
        if settings.frames.current >= #settings.intro then
                -- Stop the intro
                reset_data()
        end

        -- Update timer
        settings.timer.current = settings.timer.current + 1
end

--[[ Start the introduction ]]--
function start_intro()
	settings.is_running = true
        addEventHandler("onClientRender", root, view_gtw_intro)
        if window then guiSetVisible(window, false) end
end
addCommandHandler("intro", start_intro)

--[[ Function to stop the intro and reset ]]--
function stop_intro()
	if not settings.is_running then return end
        -- Stop the intro
        reset_data()
        showPlayerHudComponent("radar", true)
	removeEventHandler("onClientRender", root, view_gtw_intro)
        unbindKey("space", "down", stop_intro)
	settings.is_running = nil
end
addCommandHandler("stopintro", stop_intro)
bindKey("space", "down", stop_intro)
