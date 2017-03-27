
local modShops = { }

function loadModShops( )
    local file_root = xmlLoadFile( "modshops.xml" )
    local shop_node = xmlFindChild( file_root, "shop", 0 )
    local i = 1
    while shop_node do
        local name = xmlNodeGetAttribute( shop_node, "name" )
        local pos_node = xmlFindChild( shop_node, "position", 0 )
        modShops[ i ] = { }
        modShops[ i ].posX = tonumber( xmlNodeGetAttribute( pos_node, "X" ) )
        modShops[ i ].posY = tonumber( xmlNodeGetAttribute( pos_node, "Y" ) )
        modShops[ i ].posZ = tonumber( xmlNodeGetAttribute( pos_node, "Z" ) )
        shop_node = xmlFindChild( file_root, "shop", i )
        i = i + 1
    end
    xmlUnloadFile( file_root )
end
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource( ) ), loadModShops )

