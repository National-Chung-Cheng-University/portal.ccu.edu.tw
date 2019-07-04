<?php
/*
 *
 */

function getSSOErrorMsg($code) {
	$msg = '';
	switch($code)	{
		case 'TICKET_001':
			$msg = '錯誤代碼'.$code.' \n參數錯誤!';
			break;
		case 'TICKET_002':
			$msg = '錯誤代碼'.$code.' \n請先登入系統';
			break;
		case 'TICKET_003':
		case 'TICKET_004':
			$msg = '錯誤代碼'.$code.' \n系統異常!';
			break;
		//case '':
		//	$msg = 
		//	break;
		default:
			$msg = '';
			break;
	}
	return $msg;
}

function getSSOErrorLog($code, $exMsg='') {
	$msg = '';
	switch($code)	{
		case 'TICKET_001':
		case 'TICKET_002':
		case 'TICKET_003':
			$msg = 'ERROR: '.$code;
			break;
		case 'TICKET_004':
			$msg = $code.': deleteUnusedTickets() failed: '.$exMsg;
			break;
		case 'SSO_CCU_RIGHT_001':
			$msg = $code.': Invalid source IP!';
			break;
		case 'SSO_CCU_RIGHT_002':
			$msg = $code.': No _GET value!';
			break;
		case 'SSO_CCU_RIGHT_003':
			$msg = $code.': Session expired!';
			break;
		case 'SSO_CCU_RIGHT_004':
			$msg = $code.': No ticket file: ';
			break;
		case 'SSO_CCU_RIGHT_005':
			$msg = $code.': Fail to delete ticket file : ';
			break;
		case 'SSO_CCU_RIGHT_006':
			$msg = $code.': No last_activity value!';
			break;
		//case '':
		//	$msg = 
		//	break;
		default:
			$msg = '';
			break;
	}
	return $msg;
}

?>