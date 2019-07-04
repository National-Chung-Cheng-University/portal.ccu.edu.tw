<?php
/*
 * login_check.php
 * 登入確認
 */

require_once('include/inc.config.php');
require_once('include/inc.errorMsg.php');

$user_id = (isset($_POST['acc'])) ? trim($_POST['acc']) : NULL;
$user_passwd = (isset($_POST['pass'])) ? trim($_POST['pass']) : NULL;
$imgcode = (isset($_POST['authcode'])) ? trim($_POST['authcode']) : NULL;

if(!isset($_SESSION['fail_counts'])) {
	$_SESSION['fail_counts'] = 1; // 登入失敗次數
	header('Location: '.DOOR_URL);
}

$user_id = strtolower($user_id); // 帳號都轉小寫

// 輸入錯誤兩次以上才跳出驗證碼
$imgcode_result = false;
if($_SESSION['fail_counts'] >= 2) {
	if(!empty($imgcode) && !empty($_SESSION['imgcode']) && $imgcode == $_SESSION['imgcode'])
		$imgcode_result = true;
	//else
	//	$imgcode_result = false;
} else {
	$imgcode_result = true; // 錯誤次數<2 一律視為驗證碼驗證成功
}

// 停用cookie會造成登入時驗證碼出錯,因為停用cookie會造成session也無法使用(browser無法記錄sessionID),$_SESSION['imgcode']就抓不出數值
//if($imgcode == @$_SESSION['imgcode']) {
if($imgcode_result) {
	//connect LDAP DB & bind
	$ldapConn = new ssoModifyLDAP();
	$ldapConn->bind_root();
	$pid = '';
	$success = false;
	$isStu = false;
	$ldapTree = 'anyid';
	$username = '';

	// 檢查是否為學號(9個數字)
	if( strlen($user_id) == 9 && preg_match('/^\d{9}/', $user_id) ) {
		$isStu = true;
		$ldapTree = 'login-stu';
	}
	if($ldapConn->bind($user_id, $user_passwd, $ldapTree)) {
//***如果還沒有initials欄位時,這一行會有error msg
		list($initials) = $ldapConn->getval($user_id, 'initials', $ldapTree);
		if((strlen($initials) == 1) && ($initials == 'Y')) {
			if($isStu) {
				list($pid) = $ldapConn->getval($user_id, 'cn', $ldapTree); // 學生的話取學號
				// 抓取學生姓名(沒改入osa測試平台,osa PDO連測試資料庫有問題)
				$stuInfo = new studentInfo($pid);
				$username = $stuInfo->getName();
				if($username == '') {
					$username = $pid;
					writeSysLog('db error: '.$stuInfo->getErrMsg(),$pid);
				}
			} else {
				list($pid) = $ldapConn->getval($user_id, 'sn', $ldapTree); // 身分證字號
				if($user_id == 'guest') {
					$username = '訪客';
				} else {
					$username = $user_id;
				}
			}
			$success = true;
		} else {
			// 登入失敗時,session還沒有帳號資訊,因此需要傳入輸入的ID來記錄log,而且只記錄整體log檔
			$_SESSION['fail_counts']++;
			writeGeneralLog('Login failed: Account is not enabled!', $user_id);
			$err_msg = '錯誤代碼：LOGIN_003\\n帳號尚未啟用！';
			err_msgAlert($err_msg, DOOR_URL);
		}
	} else {
		// 登入失敗時,session還沒有帳號資訊,因此需要傳入輸入的ID來記錄log,而且只記錄整體log檔
		$_SESSION['fail_counts']++;
		writeGeneralLog('Login failed: wrong ID or password!', $user_id);
		$err_msg = '錯誤代碼：LOGIN_001\\n帳號或密碼錯誤,請重新登錄！';
		err_msgAlert($err_msg, DOOR_URL);
	}

	if($success) {
		$ldapConn = null;
		$now_time = time();
		$_SESSION['ssoIP'] = getIP();
		$_SESSION['ssoACC'] = $user_id;
		$_SESSION['ssoLOGTIME'] = date('Y-m-d H:i:s', $now_time);
		$_SESSION['ssoSSID'] = session_id();
		$_SESSION['ssoPID'] = $pid;
		$_SESSION['ssoToken'] = makeToken($_SESSION['ssoIP'], $_SESSION['ssoSSID'], $_SESSION['ssoACC'], $_SESSION['ssoPID'], $_SESSION['ssoLOGTIME']);//miXd
		$_SESSION['cidToken'] = md5(getIP().substr($_SESSION['ssoToken'],-10)).substr($_SESSION['ssoToken'], 10, 6);//cid
		$_SESSION['username'] = $username;
		$_SESSION['last_activity'] = time(); // update last activity time stamp
		writeLog('Login!');
		deleteUnusedTickets();
		header('Location: '.INDEX_URL);
	}
} else {
	// 登入失敗時,session還沒有帳號資訊,因此需要傳入輸入的ID來記錄log,而且只記錄整體log檔
	$_SESSION['fail_counts']++;
	writeGeneralLog('Login failed: wrong authorization code!', $user_id);
	$err_msg = '錯誤代碼：LOGIN_002\\n驗證碼錯誤,請重新登錄！';
	err_msgAlert($err_msg, DOOR_URL);
}

// 刪除已經過期的ticket file, BJ建議登入時執行,設定自動執行比較有風險,例如系統轉移的時候又忘記設定回去,就會出問題了
// http://www.inote.tw/2009/04/php_13.html
// 不用太常清除，每天的 6-8 點登入時才清除
function deleteUnusedTickets() {
	$hour = date('G');
	if($hour > 6 && $hour < 9 ) {
		$files = scandir(SSO_TICKET_FILE);
		if($files !== FALSE) {
			foreach($files as $filename) {
				if($filename != '.' && $filename != '..') {
					$ticketFile = SSO_TICKET_FILE.$filename;
					$ftime = filemtime($ticketFile);
					$expire_time = time() - 60; // ticket檔案時間超過1分鐘就判斷為沒用的ticket
					if($ftime < $expire_time) {
						if(file_exists($ticketFile)) {
							if(!unlink($ticketFile)) {
								writeSysLog(getSSOErrorLog('TICKET_004', $filename));
							}
						}
					}
				}
			}
		}
	}
}
?>