<?php
header('Content-type: text/html; charset=UTF-8');

require_once('inc.define.php');
require_once(WEB_PATH.'include/inc.cipher.php');
require_once('inc.func_log.php');

//big5 轉 utf-8
//$str = iconv('big5', 'UTF-8', $str);
//utf-8 轉 big5
//$str = iconv('UTF-8', 'big5', $str);

/**
 * check session
 * 檢查session的內容，如果是空的就是手動登出的情況
 * 檢查session的時間，如果過期就表示是放到逾時登出的情況
 * 不啟用session的情況，直接去抓檔案來看時間，fileatime，filemtime不會變更，的確是會expired
 * 一旦啟用session，session file的時間就會立刻被更新，也就是說，頁面一旦有重整，fileatime，filemtime就會變更
 * 因此只要session檔案還沒被回收，不管什麼時候連進來，都會被更新成還沒過期，結果繼續維持登入狀態，這樣正確嘛？
 * 改用$_SESSION['last_activity']來監控session最後更新時間
 */
function chk_session() {
	// 第一次連線進來，或是清除cookie的情況，一定會檢查不到session，是正常情況，所以這裡不用記錄log
	if(!isset($_SESSION['last_activity'])) {
		//error_log('debug_info: chk_session false 1!');
		return false;
	} else {
		if((time() - $_SESSION['last_activity'] <= SESSION_LIFE_TIME)) {
			// 還沒逾期登出就延長session壽命
			$_SESSION['last_activity'] = time(); // update last activity time stamp
			return true;
		} else {
			//error_log('debug_info: session expired!');
			return false;
		}
	}

	// $sfile = session_id();
	// $sess_file = '/var/tmp/sess_'.$sfile;
	// if(file_exists($sess_file) && filesize($sess_file)>0) {
		// $file_time = fileatime($sess_file);
		// $expire_time = $file_time + 30*60; // 登出超過30分鐘就過期
		// $now_time = time();
		// if($expire_time >= $now_time) {
			// $handle = fopen($sess_file, 'r');
			// $contents = fread($handle, filesize($sess_file));
			// fclose($handle);
			// $pos = strpos($contents, 'ssoACC|');
			// if($pos === false) {
				// return false;
			// } else {
				// touch($sess_file);
				// return true;
			// }
		// } else {
			// return false;
		// }
	// } else {
		// return false;
	// }
}

function reset_session() {
	session_unset();
	session_destroy();
	$_SESSION = array();
}

/**
 * make the token
 */
function makeToken($ip, $ssid, $acc, $pid, $logintime) {
	$p_token = $ip.'::'.$ssid.'::'.$acc.'::'.$pid.'::'.$logintime;
	$aes = new CryptAES();
	$e_token = $aes->encrypt($p_token);
	//$aes = null;
	unset($aes);
	return $e_token;
}

function err_msgAlert($msg, $url) {
	echo '<script type="text/javascript">
			alert("'.$msg.'");
			window.location.href="'.$url.'";
	</script>';
}

function err_msgConfirm($msg, $url_a, $url_b) {
	echo '<script type="text/javascript">
			if(confirm("'.$msg.'") )
				parent.location="'.$url_a.'";
			else
				parent.location="'.$url_b.'";
	</script>';
}
//echo '<script type="text/javascript"> alert("  ");</script>';

//////////////////////////////////////////////////////////////////////////////////////////
/////  Generate_Key()
/////  由學號, 密碼, 與大略的時間產生一個 md5 過的 key, 作為基本的安全保護,
/////  避免有心者直接連結改密碼網頁, 看到學生的部份個人資訊.
/////  Coder: Nidalap :D~, 2006/05/19
function Generate_Key($id, $password) {
  $debug_flag = 0;
  $time = time();
  $time = substr($time, 0, 7);          //  切掉後三碼的 timestamp, 允許約 16 分鐘的時間差

  if( $password == '' ) {               //  如果沒有傳入 password, 使用預設密碼 
    $password = 'ThiS_is_pAsswOrd_for_InfOtEst';
  }
  $key = $id . $time . $password;
  $key = md5($key);

  if( $debug_flag == 1 ) {
    echo("[ id,time,password,key ] = [ $id,$time,$password,$key ]<BR>\n");
  }

  return $key;
}

// 學籍、選課系統修改密碼同步到LDAP,傳輸資料加密,參考自inc.cipher.php
class Crypt_SSOpw {
    private $cipher     = 'rijndael-128';
    private $mode       = 'cbc';
    private $key 		= '#sSoPW14!405_';
    private $iv         = 'Spw#aTo#ken84';
	private $pkey		= 'SsO_8Ccu135_';
	private $piv		= '#lDapPa3s!s';

    function __construct() {
		$td	= mcrypt_module_open($this->cipher, '', $this->mode, '');
		$key_size = mcrypt_enc_get_key_size($td);
		$iv_size = mcrypt_enc_get_iv_size($td);
		mcrypt_module_close($td);
        $this->iv = substr(md5($this->piv),0,$iv_size);
        $this->key = substr(md5($this->pkey),0,$key_size);
    }

    function encrypt($str) {
		$td	= mcrypt_module_open($this->cipher, '', $this->mode, '');
        mcrypt_generic_init($td, $this->key, $this->iv);
        $cyper_text = mcrypt_generic($td, $str);
        $r = bin2hex($cyper_text);
        mcrypt_generic_deinit($td);
		mcrypt_module_close($td);
        return $r;
    }

    function decrypt($str) {
		$td	= mcrypt_module_open($this->cipher, '', $this->mode, '');
        mcrypt_generic_init($td, $this->key, $this->iv);
        $decrypted_text = mdecrypt_generic($td, $this->hex2bin($str));
        $r = $decrypted_text;
        mcrypt_generic_deinit($td);
		mcrypt_module_close($td);
        return $r;
    }

    private function hex2bin($hexdata) {
        $bindata = '';
        for($i=0; $i<strlen($hexdata); $i+=2) {
            $bindata .= chr(hexdec(substr($hexdata, $i, 2)));
        }
        return $bindata;
    }
}

?>
