function mta()
{
	// =============================
	// URL pointing to ajax_interface.php on your server:
	// =============================
	
	this.interfaceUrl = "";
	
	// =============================
	// No need to edit below this line
	// =============================
	
	this.xmlHttpObject;
	this.onDataReceived;
	
	this.initXmlHttp = function()
	{
		if ( window.XMLHttpRequest )
		{
			try
			{
				this.xmlHttpObject = new XMLHttpRequest();
			}
			catch(e) 
			{
				return false;
			}
		}
		else if ( window.ActiveXObject )
		{
			try
			{
				this.xmlHttpObject = new ActiveXObject( "Msxml2.XMLHTTP" );
			}
			catch(e)
			{
				try
				{
					this.xmlHttpObject = new ActiveXObject( "Microsoft.XMLHTTP" );
				}
				catch(e)
				{
					return false;
				}
			}
		}
	}
	
	this.onreadystatechange = function()
	{
		if ( this.xmlHttpObject.readyState == 1 || this.xmlHttpObject.readyState == 2 || this.xmlHttpObject.readyState == 3 )
		{
			document.documentElement.style.cursor = 'wait';
		}
		else if ( this.xmlHttpObject.readyState == 4 )
		{
			document.documentElement.style.cursor = 'auto';
					
			try
			{
				if ( this.xmlHttpObject.status && this.xmlHttpObject.status != 200 )
				{
					alert( 'ERROR: ' + this.xmlHttpObject.responseText );
					return;
				}
			}
			catch(e){}
			
			var runFunc = null;
			
			if ( typeof( this.onDataReceived ) == "function" )
			{
				var runFunc = this.onDataReceived;
				this.onDataReceived = null;
				
				try
				{
					var jsonResponse = eval( "(" + this.xmlHttpObject.responseText + ")" );
				}
				catch(e)
				{
					alert('ERROR: The server did not return valid JSON data\n\n' + this.xmlHttpObject.responseText);
				}
				
				runFunc( this.convertToObjects(jsonResponse) );
			}
		}
	}
	
	this.callFunction = function( host, port, resource, func )
	{
		if ( this.interfaceUrl == '' )
		{
			alert( 'ERROR: You must supply the URL pointing to ajax_interface.php' );
			return;
		}
		
		if ( typeof(arguments[arguments.length-1]) == "function" )
		{
			this.onDataReceived = arguments[arguments.length-1];
		}
		
		var val = Array();
		
		for ( i = 4; i < arguments.length; i++ )
		{
			if ( typeof(arguments[i]) == "function" )
			{
				continue;
			}
			
			val[i-4] = arguments[i];
		}
		
		val = this.convertFromObjects( val );
		val = escape( val.join(',') );
		
		if ( !this.xmlHttpObject ) this.initXmlHttp();
		
		this.xmlHttpObject.abort(); // Keeps IE happy and allows us to re-use the XmlHttp object as many times as we like.
		
		var me = this;
		this.xmlHttpObject.onreadystatechange = function(){ me.onreadystatechange(); }
		
		try
		{
			this.xmlHttpObject.open( "POST", this.interfaceUrl, true );
		}
		catch(e)
		{
			alert('ERROR: Could not access the AJAX Interface URL');
			return;
		}
		
		this.xmlHttpObject.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
		this.xmlHttpObject.send( "host=" + host + "&port=" + port + "&resource=" + resource + "&func=" + func + "&val=" + val );
	}
	
	this.convertToObjects = function( item )
	{
		if ( item instanceof(Array) )
		{
			for ( i in item )
			{
				item[i] = this.convertToObjects( item[i] );
			}
		}
		else if ( typeof(item) == 'string' || typeof(item) == 'number' )
		{
			if ( typeof(item) == 'number' ) item = item.toString();
			
			if ( item.substring( 0, 3 ) == "^E^" )
			{
				item = new this.Element( item.substring( 3 ) );
			}
			else if ( item.substring( 0, 3 ) == "^R^" )
			{
				item = new this.Resource( item.substring( 3 ) );
			}
		}
		
		return item;
	}
	
	this.convertFromObjects = function( item )
	{
		if ( item instanceof(Array) )
		{
			for ( i in item ) 
			{
				item[i] = this.convertFromObjects( item[i] );
			}
		}
		else if ( typeof(item) == "object" )
		{
			if ( item.constructor.toString() == this.Element.toString() || item.constructor.toString() == this.Resource.toString() )
			{
				item = item.mtoString();
			}
		}
		
		return item;
	}
	
	this.Element = function( id )
	{
		this.id = id;
		
		this.mtoString = function()
		{
			return "^E^" + this.id;
		}
	}
	
	this.Resource = function( name )
	{
		this.name = name;
		
		this.mtoString = function()
		{
			return "^R^" + this.name;
		}
	}
}