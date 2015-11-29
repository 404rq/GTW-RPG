<?php
	//Get list of updates
	$text = file_get_contents('https://404rq.com/update-list/mtasa.txt');
	
	//Return updates list
	include("php-sdk/mta_sdk.php");
	mta::doReturn($text);
?>
