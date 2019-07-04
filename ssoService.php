<?php
/* 
 * 說明：產生ticket跟使用header()代簽入到子系統
 *       1.sso產生隨機檔名的檔案，檔名當ticket
 *		 2.ticket丟給子系統，子系統收到後拿ticket向sso認證
 *		 3.sso檢查ticket通過之後，刪除剛剛產生的檔案(一次性驗證)，回傳登入資訊給子系統
 *		 4.有可能給外部系統呼叫，因此不能鎖定只有本機可以存取
 * 參數：service:要代簽入的子系統URL
 *		 code:要寫到log當中的子系統代碼
 * LastUpdate: 2014.01.09
 */

//***-如果要給外部系統呼叫，應該也是要限制ip*****
require_once('include/inc.define.php');
require_once(WEB_PATH.'include/inc.cipher.php');
require_once('include/inc.func.php'); // session在這裡有宣告
require_once('include/inc.errorMsg.php');

$service  = isset($_GET['service']) ? trim($_GET['service']) : '';
$linkId   = isset($_GET['linkId']) ? trim($_GET['linkId']) : '';

if($service != '') {
	if(chk_session()) {
		$miXd 	= isset($_SESSION['ssoToken']) ? trim($_SESSION['ssoToken']) : ''; // ssotoken = miXd
		if($miXd != '') {
			// 隨機產生唯一檔名, http://bjstation.pixnet.net/blog/post/30260489-%5Bphp%5D-%E5%B8%B8%E7%94%A8%E5%87%BD%E6%95%B8%E9%9B%86
			$times = 0;
			$limits = 10; // 重試10次都失敗的話,宣告不治
			$flag = false;
			do {
				$times++;
				srand((double) microtime() * 1000000);
				$uniq = uniqid(rand());
				$ticketFile = SSO_TICKET_FILE.$uniq;
				if(!file_exists($ticketFile)) {
					$fp = fopen($ticketFile, 'w+');
					if($fp !== FALSE) {
						$err	 = 'N';
						$err_msg = 'Success';
						// 到這邊應該代簽入成功了,記下log
						$logStr = 'ssoService: _sso_'.$linkId.' '.$service;
						writeLog($logStr);
						$flag = true;
						if(fclose($fp) === FALSE)	{
							$logStr = 'ticket file:'.$ticketFile.' close failed!';
							writeLog($logStr);
						}
						break; // 檔案不存在,檔名沒重複,且寫檔成功,結束迴圈
					}
				} else {
					$logStr = 'ticket file: '.$ticketFile.' already exist.';
					writeSysLog($logStr);
				}
			} while($times < $limits);

			if($flag) {
				//error_log("$service?miXd=$miXd&ticket=$uniq");
				header("Location: $service?miXd=$miXd&ticket=$uniq");
				// 如果子系統沒有回應,會造成檔案存留在目錄裡面,本來想停一秒再刪除檔案
				// 可是這樣寫會造成header也跟著停著,看來header是要等程式都執行完,才會真的導向過去,看來還是得定時刪除了
				//sleep('1');
				//unlink($ticketFile);
			} else {
				$err		= 'Y';
				$err_msg  = getSSOErrorMsg('TICKET_003');
				writeSysLog(getSSOErrorLog('TICKET_003').', while loops are: '.$times);
			}
		} else {
			$err		= 'Y';
			$err_msg  = getSSOErrorMsg('TICKET_004'); // 系統異常
			writeSysLog(getSSOErrorLog('TICKET_004').'no miXd value!');
		}
	} else {
		// 放到被登出的情況下點選代簽入，並不會產生ticket file
		$err		= 'Y';
		$err_msg  = getSSOErrorMsg('TICKET_002'); // 請先登入系統

		// 逾時登出的情況不用記錄log
		//if(!isset($_SESSION['ssoToken']))
		//	writeSysLog(getSSOErrorLog('TICKET_002').', no $_SESSION[ssoToken]');
		//else
		//	writeSysLog(getSSOErrorLog('TICKET_002'));
	}
} else {
	$err		= 'Y';
	$err_msg  = getSSOErrorMsg('TICKET_001');
	writeSysLog(getSSOErrorLog('TICKET_001'));
}

if($err == 'Y') {
	echo'<script type="text/javascript">alert(\''.$err_msg.'\');</script>';
	echo'<script> top.close(); </script>';
}

/*本來有把內容寫在檔案內,改成一樣由mixd帶參數,檔案只拿來當ticket
if($service != '') {
//***-如果是從外部呼叫的情況?不能從session讀入mixd
	$miXd 	= isset($_SESSION['ssoToken']) ? trim($_SESSION['ssoToken']):'';//ssotoken = miXd
	if($miXd != '') {
		//解密所接收到的miXd資訊
		$aes = new CryptAES();
		$dec = $aes->decrypt($miXd);
		unset($aes);
		$dec_arr = explode('::', $dec);

		//初始化變數
		$err		= 'N';
		$err_msg  	= '';
		$uniq		= '';// 隨機檔名

		$data = array(	'clientIP'	=>trim($dec_arr[0]),
						'userID'	=>trim($dec_arr[2]),
						'p_id'		=>trim($dec_arr[3]),
						'logintime'	=>trim($dec_arr[4]),
						'sess_alive'=>'Y');
		//隨機產生唯一檔名, http://bjstation.pixnet.net/blog/post/30260489-%5Bphp%5D-%E5%B8%B8%E7%94%A8%E5%87%BD%E6%95%B8%E9%9B%86
		$times = 0;
		$limits = 10;//重試10次都失敗的話,宣告不治
		$flag = false;
		do {
			$times++;
			srand((double) microtime() * 1000000);
			$uniq = uniqid(rand());
			$ticketFile = SSO_TICKET_FILE.$uniq;
			if(!file_exists($ticketFile)) {
				//寫入array http://www.webdeveloper.com/forum/showthread.php?184484-how-to-save-array-to-php-file
				if(file_put_contents($ticketFile, serialize($data))) {
					$err	 = 'N';
					$err_msg = 'Success';
					//到這邊應該代簽入成功了,記下log
					$logStr = "sign in to $service";
					writeLog($logStr);
					$flag = true;
					break;//檔案不存在,檔名沒重複,且寫檔成功,結束迴圈
				}
			}
		} while($times < $limits);

		if($flag) {
			header("Location: $service"."?miXd=$miXd&ticket=$uniq");
			//如果子系統沒有回應,會造成檔案存留在目錄裡面,本來想停一秒再刪除檔案
			//可是這樣寫會造成header也跟著停著,看來header是要等程式都執行完,才會真的導向過去,看來還是得定時刪除了
			//sleep('1');
			//unlink($ticketFile);
		} else {
			$err		= 'Y';
			$err_msg  = getSSOErrorMsg('TICKET_003');
			writeSysLog(getSSOErrorLog('TICKET_003'));
		}
	} else {
		$err		= 'Y';
		$err_msg  = getSSOErrorMsg('TICKET_002');
		writeSysLog(getSSOErrorLog('TICKET_002'));
	}
} else {
	$err		= 'Y';
	$err_msg  = getSSOErrorMsg('TICKET_001');
	writeSysLog(getSSOErrorLog('TICKET_001'));
}
*/
?>