<?php
	header('Content-type: text/html; charset=UTF-8');

	require_once('inc.define.php');
	require_once(WEB_PATH.'include/inc.cipher.php');
	require_once(WEB_PATH.'include/inc.dblink.php');
	require_once(WEB_PATH.'include/inc.ldaplink.php');
	require_once('inc.func.php');
	//require_once 'inc.sybaselink.php';

	/*
	//維護時要打開,限制只有某幾台機器能連線
	$ip = getIP();
	if(!checkSourceIP_maintain(getIP())) {
		echo'<script type="text/javascript">window.location = "maintaining.html";</script>';
		if(isset($_SESSION)) {
			session_unset();
			session_destroy();
			$_SESSION = array();
		}
		exit;
	}
	*/

	ini_set('session.gc_maxlifetime', SESSION_LIFE_TIME);
	if(!isset($_SESSION)) {
		session_name('ccuSSO');
		session_start();
	}

	if(isset($_GET['logout'])) {
		//err_msgConfirm('您是否要登出？', REAL_LOGOUT_URL, DOOR_URL);
		header('Location: '.REAL_LOGOUT_URL);
	}

	// 維護時限制ip時要用的
	function checkSourceIP_maintain($ip) {
		//開放可讀取資訊的server清單 (什麼時候全面改成IPv6?)
		$priv_ip= array('140.123.26.152',	//工讀時數登錄系統測試, 校園軟體下載(正式+測試), 網路投票測試
						'140.123.26.151',	//學籍系統測試，專科學籍系統測試
						'140.123.26.11',	//資訊能力測驗
						'140.123.4.10',		//生涯定向
						'140.123.4.9',
						'140.123.4.8',
						'140.123.4.5',
						'140.123.4.51',
						'140.123.5.6',
						'140.123.40.206',
						'140.123.30.102',	//學生成績查詢
						'140.123.30.101',	//學生成績查詢
						'140.123.30.92',	//課程地圖測試平台
						'140.123.4.51',		//ecourse教學平台
						'140.123.230.25',	//ecourse教學測試平台
						'140.123.4.210',	//
						'140.123.21.5',		//圖書館webpac
						'140.123.4.217',	//sso測試平台(讀入sso widget)
						'140.123.4.205',	//sso正式平台
						'140.123.19.145'//***-
						);

		if(in_array($ip, $priv_ip)) {
			//2012.09.17 移除check ok的log,減輕server loading,而且這資訊在accessLog也查的到
			//writeSysLog('Source check ok!','CcuRightXML');
			return true;
		} else {
			return false;
		}
	}
?>