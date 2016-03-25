<?php
// =============================
// (Config) HTTP Username / Password
// =============================

$http_username = '';
$http_password = '';

// =============================
// No need to edit below this line
// =============================

$host     = $_POST['host'];
$port     = intval($_POST['port']);
$resource = $_POST['resource'];
$function = $_POST['func'];
$val      = $_POST['val'];

try
{
	include('mta_sdk.php');
	$mtaSDK = new mta();
	
	if ( $http_username && $http_password )
	{
		$mtaSDK->http_username = $http_username;
		$mtaSDK->http_password = $http_password;
	}
	
	$val = explode(",", $val);
	$json_data = json_encode($val);
	
	echo $mtaSDK->do_post_request( $host, $port, "/" . $resource . "/call/" . $function, $json_data );
}
catch( Exception $e )
{
	@header("HTTP/1.0 500 Internal Server Error");
	echo $e->getMessage();
}
?>