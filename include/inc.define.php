<?php
	header('Content-type: text/html; charset=UTF-8');

	// 常用變數設定
	define('SITE_NAME', '::國立中正大學-校園系統單一入口::');
	//define('SMARTY_PATH', '/usr/local/smarty3/');//already set the path in php config file.
	define('WEB_PATH', '/home/center/porihuang/');
	define('HOME_URL', 'http://portal.ccu.edu.tw/');
	define('DOOR_URL', HOME_URL.'index.php');
	define('INDEX_URL', HOME_URL.'sso_index.php');
	define('LOGOUT_URL', $_SERVER['PHP_SELF'].'?logout');// 會變成：目前頁面.php?logout, 然後在目前頁面.php的include inc.config.php當中的$_GET['logout']來判斷是否登出
	define('REAL_LOGOUT_URL', HOME_URL.'logout_check.php');
	define('LOGIN_URL', HOME_URL.'login_check.php');
	define('AUTH_MAIL_URL', HOME_URL.'EnableSSOacc.php');//認證信連回來的位址
	define('SSO_MAIL_ADDR', 'sso@ccu.edu.tw');
	define('WGT_XML_PATH', WEB_PATH.'widgetsXML/');

	// log檔路徑
	define('LOG_PATH', WEB_PATH.'log/');
	define('SYS_LOG_FILE', LOG_PATH.'system/sysErr.log');

	// 用於忘記密碼的選單
	define('ACADEMIC_PATH', 'http://miswww1.cc.ccu.edu.tw/academic/'); // 學籍系統
	define('ACADEMIC_GRA_PATH', 'http://miswww1.cc.ccu.edu.tw/academic/gra/'); // 專班學籍系統

	// 學籍、選課同步變更密碼
	define('CHANGE_PASS_REF','http://portal.ccu.edu.tw/ajax/apply_acc_ajax.php'); // 給curl設定referer設定來源
	define('CHANGE_PASS_URL', 'http://kiki.ccu.edu.tw/~ccmisp06/cgi-bin/class/Change_Password01.php'); // 學籍、選課同步變更密碼,06一般生正式,07專班正式,08一般生測試,專班無測試平台
	define('CHANGE_PASS_GRA_URL', 'http://kiki.ccu.edu.tw/~ccmisp07/cgi-bin/class/Change_Password01.php'); // 專班(學號5開頭)
	define('CHANGE_PASS_URL_ISSCOURSE', 'http://miswww1.cc.ccu.edu.tw/academic/isscourse/change_password_sso.php'); // 校際選課

	// oracle寫資料的php(for 圖書館同步帳密的table)
	define('CHANGE_PASS_ORACLE', 'http://140.123.4.218/~porihuang/p2Oracle.php');

	// sso service檔案路徑
	define('SSO_SERVICE', HOME_URL.'ssoService.php');

	// sso代簽入ticket檔案路徑
	define('SSO_TICKET_FILE', WEB_PATH.'ticket_files/');

	// 
	define('SESSION_LIFE_TIME', 1800); // 30*60, 關閉網頁後的session存活時間30分鐘
	define('SESSION_MAXREFRESH_TIME', 10860); // 3*60*60, 網頁開著時，會持續refresh直到SESSION_MAXREFRESH_TIME，就不再refresh直到逾時登出
?>