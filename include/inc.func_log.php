<?php
require_once('inc.define.php');
require_once('inc.func_no_session.php');

if(!isset($_SESSION)) {
	session_name('ccuSSO');
	session_start();
}

// 寫入log檔，會寫兩份，一份是整體的log檔，會記錄全部使用者的log，另外一份是使用者自己的log檔
function writeLog($msg, $user = '') {
	// 整體log檔
	$gen_logFileName = getGeneralLogFilename();
	writeLog_format($msg, $gen_logFileName, $user);

	// 個人log檔, 2013.11.05 改用每個月一份檔案的方式來記錄, 要統計active user
	//$per_logFileName = getPersonalLogFilename($user);
	$per_logFileName = getPersonalLogFilename_v2($user);
	writeLog_format($msg, $per_logFileName, $user);
}

// 只記錄到整體log檔
function writeGeneralLog($msg, $user = '') {
	$gen_logFileName = getGeneralLogFilename();
	writeLog_format($msg, $gen_logFileName, $user);
}

// 格式：logs/general/年-月/年-月-日.log
function getGeneralLogFilename() {
	if(($time = $_SERVER['REQUEST_TIME']) == '') {
		$time = time();
	}
	$dateMonth = date("Y-m", $time);
	$dateStr = date("Y-m-d", $time);

	$log_path = LOG_PATH.'general/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	$log_path = LOG_PATH.'general/'.$dateMonth.'/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}

	$gen_logFileName = $log_path.$dateStr.'.log';
	return $gen_logFileName;
}

// 格式：logs/personal/年/id.log
function getPersonalLogFilename($user) {
	if(($time = $_SERVER['REQUEST_TIME']) == '') {
		$time = time();
	}
	$dateStr = date("Y", $time);
	$log_path = LOG_PATH.'personal/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	$log_path = LOG_PATH.'personal/'.$dateStr.'/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	if($user == '' && isset($_SESSION['ssoACC']))
		$user = $_SESSION['ssoACC'];
	$logFileName = $log_path.$user.'.log';
	return $logFileName;
}

// 2013.11.05 格式修改為logs/personal_v2/年-月/id.log
function getPersonalLogFilename_v2($user) {
	if(($time = $_SERVER['REQUEST_TIME']) == '') {
		$time = time();
	}
	$dateMonth = date("Y-m", $time);

	$log_path = LOG_PATH.'personal_v2/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	$log_path = LOG_PATH.'personal_v2/'.$dateMonth.'/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	if($user == '' && isset($_SESSION['ssoACC']))
		$user = $_SESSION['ssoACC'];
	$logFileName = $log_path.$user.'.log';
	return $logFileName;
}

function writeLog_format($msg, $filename, $user = '') {
	if(($time = $_SERVER['REQUEST_TIME']) == '') {
		$time = time();
	}
	$date = date("Y-m-d H:i:s", $time);
	$ip = getIP();

	// log字串格式：[時間] [ip] [user] msg
	if($user == '' && isset($_SESSION['ssoACC']))
		$user = $_SESSION['ssoACC'];
	$logStr = "[$date] [client $ip] [$user] $msg\n";

	$fp = fopen($filename, 'a+');
	if($fp) {
		//$result = fputcsv($fp, array($date, $user, $ip, $message));
		if(flock($fp, LOCK_EX)) {
			$result = fwrite($fp, $logStr);
			fclose($fp);
			if($result <= 0) {
				$msg = $filename.' write failed!';
				writeSysErrLog($date, $user, $ip, $msg);
			}
		} else {
			fclose($fp);
			$msg = $filename.' lock failed!';
			writeSysErrLog($date, $user, $ip, $msg);
		}
	} else {
		//echo'fp failed!</br>';
		$msg = $filename.' open failed!';
		writeSysErrLog($date, $user, $ip, $msg);
	}
}

// log檔寫失敗時記錄下來
function writeSysErrLog($date, $user, $ip, $msg) {
	//$filename = LOG_PATH.'system.log';
	$filename = SYS_LOG_FILE;
	if(!file_exists($filename)) {
		@mkdir($log_gen_path);
	}
	$fp = fopen($filename, 'a+');
	if($fp) {
		$logStr = "[$date] [client $ip] [$user] $msg \n";
		$result = fwrite($fp, $logStr);
		fclose($fp);
	} else {
		error_log('SSO writeSysErrLog() file open failed!', 0);
	}
}

//跟系統相關的訊息可用這個紀錄log
function writeSysLog($msg, $user = '') {
	if(($time = $_SERVER['REQUEST_TIME']) == '') {
		$time = time();
	}
	$dateMonth = date("Y-m", $time);
	$dateStr = date("Y-m-d", $time);

	$log_path = LOG_PATH.'system/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}
	$log_path = LOG_PATH.'system/'.$dateMonth.'/';
	if(!is_dir($log_path)) {
		@mkdir($log_path);
	}

	$filename = $log_path.$dateStr.'.log';
	writeLog_format($msg, $filename, $user);
}

?>
