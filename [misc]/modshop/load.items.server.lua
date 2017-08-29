
vehicleUpgrades = { names = { }, prices = { } }


function loadItems( )
    local file_root = xmlLoadFile( "moditems.xml" )
    local sub_node = xmlFindChild( file_root, "item", 0 )
    local i = 1
    while sub_node do
        vehicleUpgrades.names[ i ] = xmlNodeGetAttribute( sub_node, "name" )
        vehicleUpgrades.prices[ i ] = xmlNodeGetAttribute( sub_node, "price" )
        sub_node = xmlFindChild( file_root, "item", i )
        i = i + 1
    end
end

