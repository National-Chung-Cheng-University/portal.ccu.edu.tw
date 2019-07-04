<?php
/*
 * EnableSSOacc.php
 * 啟用帳號
 */
require_once 'include/inc.smarty.php';

$enid  = (isset($_GET['enid'])) ? trim($_GET['enid']) : '';
$enAcc = (isset($_GET['enAcc'])) ? trim($_GET['enAcc']) : '';
$type = (isset($_GET['type'])) ? trim($_GET['type']) : '';

// 倒數5秒動畫
$jscript =  '<script type="text/javascript">
			var sec = 4;
			var timer = setInterval(function() {
				$(\'#counter\').html(sec--);
				if(sec <= -1) {
					clearInterval(timer);
				}
			}, 1000);
			</script>';

if(!empty($enid) and (strlen($enid) == 8) and preg_match('/^[\w]+$/', $enid) and !empty($enAcc)) {
	//將$enAcc解密
	$aes = new CryptAES();
	$de_enAcc = trim($aes->decrypt($enAcc));
	$aes = null;

	//建立ldap連線
	$ldapConn = new ssoModifyLDAP();

	//繫結LDAP rootdn，以便取得更新LDAP的權限
	//$ldapConn->bind_root();
	$result = $ldapConn->bind_root();
	if($result) {
		if($type == 1)
			list($get_initials) = $ldapConn->getval($de_enAcc, 'initials', 'login-stu');
		else
			list($get_initials) = $ldapConn->getval($de_enAcc, 'initials', 'anyid');
		if($get_initials == $enid) {
			//修改自訂帳號的initials屬性值為自訂帳號，修改成功再於anyid新建帳號
			if($type == 1)
				$isModified = $ldapConn->modInitials($de_enAcc, 'Y', 'login-stu');
			else
				$isModified = $ldapConn->modInitials($de_enAcc, 'Y', 'anyid');
			if($isModified) {
				writeLog('Account enabled!', $de_enAcc);//記錄啟用帳號的log
				$webContent_txt = '<p>帳號啟用成功！ <br><span id="counter" style="color:red;">5</span>秒後自動導向到單一入口首頁，或<a href="'.DOOR_URL.'">由此登入sso</a></p>'
								 .'<meta http-equiv="refresh" content="5;url='.DOOR_URL.'"> '.$jscript;
			} else {
				$webContent_txt = '帳號啟用失敗(錯誤代碼ES_001)，請洽詢電算中心開發人員！<br><a href="'.DOOR_URL.'">由此回sso首頁</a>';
			}
		} else {
			$webContent_txt = '帳號啟用失敗或您已經啟用過帳號(錯誤代碼ES_004)，請洽詢電算中心開發人員！<br><a href="'.DOOR_URL.'">由此回sso首頁</a>';
		}
	} else {
		$errMsg = $ldapConn->get_errMsg();
		if($errMsg == 'Can\'t contact LDAP server')
			$webContent_txt = '帳號啟用失敗(錯誤代碼ES_002)，請洽詢電算中心開發人員！<br><a href="'.DOOR_URL.'">由此回sso首頁</a>';
		else
			$webContent_txt = '帳號啟用失敗(錯誤代碼ES_003)，請洽詢電算中心開發人員！<br><a href="'.DOOR_URL.'">由此回sso首頁</a>';
	}

	//釋放ldap連線
	$ldapConn = null;
} else {
	$webContent_txt = '<b>錯誤操作！ </b><span id="counter" style="color:red;">5</span>秒後自動導向到單一入口首頁<meta http-equiv="refresh" content="5;url='.DOOR_URL.'">'.$jscript;
}

$smarty->assign('webContent', $webContent_txt);
$smarty->assign('cssFile', 'enable.css');
$smarty->display('EnableSSOacc.tpl');

?>