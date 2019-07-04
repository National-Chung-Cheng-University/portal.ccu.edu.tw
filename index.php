<?php
/*
 * index.php
 * 登入前：登入頁    登入後：首頁
 * update: 2014.01.09
 */

require_once 'include/inc.smarty.php'; // 會載入config.php, session已在此啟用

if(!isset($_SESSION['fail_counts']))
	$_SESSION['fail_counts'] = 0; // 登入失敗次數
$fail_counts = $_SESSION['fail_counts'];

//if(isset($_SESSION['ssoToken']) and strlen($_SESSION['ssoToken'])<>0) {
if(chk_session()) {
	header('Location: '.INDEX_URL);
} else {
	//$smarty->assign('ssid',session_id());
	$smarty->assign('cssFile', 'index.css');
	$smarty->assign('acdamicPath', ACADEMIC_PATH);
	$smarty->assign('acdamicGraPath', ACADEMIC_GRA_PATH);
	$smarty->assign('max_fail_counts', 2); // 登入幾次失敗就會出現驗證碼
	$smarty->assign('fail_counts', $fail_counts); // 登入失敗次數
	$smarty->display('index.tpl');
}

?>