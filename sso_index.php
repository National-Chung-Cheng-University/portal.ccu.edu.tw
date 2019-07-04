<?php
/*
 * 登入後主頁面
 * updae: 2014.01.09
 */
require_once 'include/inc.smarty.php';

if(chk_session()) {
	/*
	function l_readSessions() {
		$encodedData    = session_encode();
		$explodeIt    = explode(";",$encodedData);
		for($i=0;$i<count($explodeIt)-1;$i++) {
			$sessGet    = explode("|",$explodeIt[$i]);
			$sessName[$i]    = $sessGet[0];
			if(substr($sessGet[1],0,2) == "s:") {
				$sessData[$i]    = str_replace("\"","",strstr($sessGet[1],"\""));
			} else {
				$sessData[$i]    = substr($sessGet[1],2);
			} // end if
		} // end for
		$result        = array_combine($sessName,$sessData);
		return $result;
	}
	*/
	//$session_life_time = ini_get('session.gc_maxlifetime');
	//$smarty->assign('session_life_time', SESSION_LIFE_TIME);
	$refresh_time = floor(SESSION_LIFE_TIME/3) - 5; // 每三分之一session life就refresh一次
	$smarty->assign('session_refresh_time', $refresh_time);
	$smarty->assign('session_maxrefresh_time', SESSION_MAXREFRESH_TIME); // 網頁持續開著時都會refresh, 超過SESSION_MAXREFRESH_TIME就不refresh, 直到逾時登出
	$smarty->assign('cssFile', 'sso_index.css');
	$smarty->display('sso_index.tpl');
} else {
	$message = '錯誤代碼：GLOBAL_001\\n您沒有權限，或是系統已自動登出，請重新登入！';
	err_msgAlert($message, DOOR_URL);
}
?>