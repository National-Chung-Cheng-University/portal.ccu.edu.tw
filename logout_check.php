<?php
/*
 * 登出
 */
header('Content-type: text/html; charset=UTF-8');
require_once('include/inc.config.php');

if(!isset($_SESSION)) {
	session_name('ccuSSO');
	session_start(); // have to start the session before you can unset or destroy it.
}

writeLog('Logout!');
reset_session();
header('Location: '.DOOR_URL);

?>