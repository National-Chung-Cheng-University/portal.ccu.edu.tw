<?php

// put full path to Smarty.class.php
require_once('inc.config.php');
require_once('/usr/local/smarty3/Smarty.class.php');
$smarty = new Smarty();

$smarty->setTemplateDir(WEB_PATH.'templates');
$smarty->setCompileDir(WEB_PATH.'templates_c');
$smarty->setCacheDir(WEB_PATH.'cache');
$smarty->setConfigDir(WEB_PATH.'configs');
$smarty->left_delimiter = '{%';
$smarty->right_delimiter = '%}';

if(isset($_SESSION['ssoToken'])) {
	// $cid_Token 搬到login_check.php, 在login的時候就先建立
	//$cid_Token=md5(getIP().substr($_SESSION['ssoToken'],-10)).substr($_SESSION['ssoToken'],10,6);
	$smarty->assign('readRightFile', 'readssoCcuRightXML.php');
	//$smarty->assign('cid', '?cid='.$cid_Token);
	$smarty->assign('cid', '?cid='.$_SESSION['cidToken']);
	$smarty->assign('mixd', '&miXd='.$_SESSION['ssoToken']);
	$smarty->assign('username', $_SESSION['username']);	//顯示在畫面上的使用者名稱
	$smarty->assign('userACC', $_SESSION['ssoACC']);	//登入帳號
}

$smarty->assign('websit_name', SITE_NAME);
$smarty->assign('login_url', LOGIN_URL);
$smarty->assign('logout_url', LOGOUT_URL);
$smarty->assign('door_url', DOOR_URL);
$smarty->assign('index_url', INDEX_URL);
$smarty->assign('mail_addr', SSO_MAIL_ADDR);

?>
