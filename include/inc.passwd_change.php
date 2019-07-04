<?php
// 2012.09.10 舊密碼檢查都在永祥的學籍系統+課程地圖那邊檢查，我這邊就不檢查了
// 2012.09.12 ChangePasswd() 變更LDAP密碼，同步修改圖書館tmp table密碼

require_once('inc.define.php');
require_once(WEB_PATH.'include/inc.ldaplink.php');

/*使用方法：建構子傳入學號，舊密碼，新密碼，身分種類
            呼叫LDAPChangePasswd來修改密碼
			如果學籍系統密碼同步更改失敗時,要呼叫restoreOldPasswd把LDAP還原回舊密碼
*/

/*
 * 這個class需再拆兩個，一個是完全核心的密碼變更，可以任意在其他程式看要變更ldap密碼或是圖書館的密碼
 * 另外一個則是比較上層的檢查input，混在一起不好使用，例如啟用帳號時不強制同步圖書館密碼，就無法使用這function了
 * 有幸改寫完之後，記得啟用帳號的地方也要修改
 */

class CChangeLDAPpwd {
	private $user_id = '';
	private $oldPasswd = '';
	private $newPasswd = '';
	private $type = '';//學生身分=student, 教職員工身分=staff
	private $ldapConn = null;
	private $error = 'Obj not initialed!';

	//建構子
	function __construct($para_id, $para_oldPass, $para_newPass, $para_type) {
		$this->user_id = $para_id;
		$this->oldPasswd = $para_oldPass;
		$this->newPasswd = $para_newPass;
		$this->type = $para_type;
		$this->ldapConn = new ssoModifyLDAP();
		$this->error = 'Obj initialed';
	}
	//解構子
	function __deconstruct() {
		$this->ldapConn = null;
	}

	public function getErrorMsg() {
		return $this->error;
	}
	public function checkInput() {
		if($this->user_id == '') {
			$this->error = '帳號欄位是空的(錯誤代碼PASS_005)！';
			return false;
		} else if($this->oldPasswd == '') {
			$this->error = '舊密碼欄位是空的(錯誤代碼PASS_006)！';
			return false;
		} else if($this->newPasswd == '') {
			$this->error = '密碼欄位是空的(錯誤代碼PASS_007)！';
			return false;
		} else if($this->type != 'student' && $this->type != 'staff') {
			$this->error = '未知的使用者種類(錯誤代碼008)！';
			return false;
		}
		return true;
	}

	//變更LDAP密碼，同步修改圖書館tmp table密碼
	public function ChangePasswd() {
		if(!$this->checkInput())
			return false;

		// 修改LDAP密碼
		if($this->type == 'student') {
			$result = $this->LDAPChangePasswd('login-stu');
		} else if($this->type == 'staff') {
			$result = $this->LDAPChangePasswd('anyid');
		}
		if(!$result) {
			return false;//$this->error在LDAPChangePasswd就有設定了,這邊不用設定
		}

		//LDAP更新成功,繼續同步到圖書館的tmp table
		$post = array(
			'id' => $this->user_id,
			'new_password' => $this->newPasswd,
			'type' => 'add'
		);
		if(!$this->ChangeLibPasswd($post)) {//圖書館密碼更改失敗,LDAP改回原密碼
			$this->restoreOldPasswdLDAP();
			return false;
			//return $this->restoreOldPasswdLDAP(); 2013.07.09嚴重bug, 造成密碼修改失敗，回朔舊密碼成功的情況，會return true;
		} else {
			return true;
		}
	}

	//*** LDAP跟圖書館沒有測試平台，測試時要注意 ***
	//變更圖書館密碼 for ChangePasswd()
	private function ChangeLibPasswd($post) {
		$ch = curl_init();
		$options = array(
			CURLOPT_URL=>CHANGE_PASS_ORACLE,
			CURLOPT_POST=>true,
			CURLOPT_RETURNTRANSFER=>true,
			CURLOPT_REFERER=>'http://portal.ccu.edu.tw/include/inc.paaawd_change.php',
			CURLOPT_POSTFIELDS=>http_build_query($post)
		);
		curl_setopt_array($ch, $options);
		// 自動重試5次來避免同步失敗
		$retryTimes = 5;
		$result = '';
		$is_success = false;
		for($i = 0; $i < $retryTimes; $i++) {
			$result = curl_exec($ch);
			if(strpos($result, 'SUCCEED') === FALSE) {
				// 圖書館尚未建立帳號時, 判斷成修改成功, 等教學組給他們帳號時, 再請他們來問
				//***-之後如果行政流程修改成教學組跟圖書館帳密有同步的話, 就不會有此問題了, 那時候再移除這個偷吃步
				if(strpos($result, 'no data found') !== FALSE) {
					$is_success = true;
					//***-偷吃步
					$this->error = '圖書館尚未建立帳號';
					$i = 6;
				} else {
					continue;
				}
			} else {
				$is_success = true;
				break;
			}
		}
		curl_close($ch);

		if($is_success) {
			return true;
		} else {
			$this->error = '圖書館密碼修改失敗(錯誤代碼PASS_012)！'.$result;
			return false;
		}
	}

	// 變更ldap密碼 for ChangePasswd()
	private function LDAPChangePasswd($ldapTree) {
		if($this->Check_Password_Legal_Chars($this->newPasswd)) {
			// 需要輸入舊密碼，確認舊密碼正確 => 2012.09.12 LDAP不檢查舊密碼了,在學籍系統會檢查
			//if($this->ldapConn->bind($this->user_id, $this->oldPasswd, $ldapTree)) {
				if($this->ldapConn->bind_root()) {
					if($this->ldapConn->modPasswd($this->user_id, $this->newPasswd, $ldapTree)) {
						$this->error = 'success';
						return true;
					} else {
						$this->error = '密碼更改失敗(錯誤代碼PASS_003)，請洽詢電算中心開發人員！';
						return false;
					}
				} else {
					$this->error = '密碼更改失敗(錯誤代碼PASS_002)，請洽詢電算中心開發人員！';
					return false;
				}
			//} else {
			//	$this->error = '舊密碼輸入錯誤(錯誤代碼PASS_001)！';
			//	return false;
			//}
		} else {
			$this->error = '密碼格式錯誤(錯誤代碼PASS_004)！';
			return false;
		}
	}

	// get from 永祥
	private function Check_Password_Legal_Chars($new_password) {
		//$legal_chars = array('!','@','/$','^','&','_','-');
		$legal_chars = array('!','@','/$','^','_','-');//移除&
		$chars = str_split($new_password);
		foreach( $chars as $char ) {
			$ascii = ord($char);
			if     ( ($ascii >=48) and ($ascii <=57) ) 	continue;//  0~9
			else if( ($ascii >=65) and ($ascii <=90) ) 	continue;//  A~Z
			else if( ($ascii >=97) and ($ascii <=122) ) continue;//  a~z
			else if( in_array($char, $legal_chars) )	continue;//  檢查其他字元白名單
			else										return false;
		}
		return true;
   }

	//還原LDAP舊密碼
	public function restoreOldPasswdLDAP() {
		if($this->type == 'student') {
			return $this->LDAPRestoreOldPasswd('login-stu');
		} else if($this->type == 'staff') {
			return $this->LDAPRestoreOldPasswd('anyid');
		}
	}

	private function LDAPRestoreOldPasswd($ldapTree) {
		if($this->ldapConn->bind_root()) {
			if($this->ldapConn->modPasswd($this->user_id, $this->oldPasswd, $ldapTree)) {
				//$this->error = '舊密碼還原成功(錯誤代碼PASS_010)，請洽詢電算中心開發人員！';
				return true;
			} else {
				$this->error = '舊密碼還原失敗(錯誤代碼PASS_009)，請洽詢電算中心開發人員！';
				return false;
			}
		} else {
			$this->error = '舊密碼還原失敗(錯誤代碼PASS_011)，請洽詢電算中心開發人員！';
			return false;
		}
	}

	//還原密碼,用於學籍系統密碼更改失敗時,要還原回舊密碼
	public function restoreOldPasswdALL() {
		// 應該不需要再檢查密碼格式了
		//if(!$this->checkInput()) {
		//	$this->error = '還原舊密碼: '.$this->error;
		//	return false;
		//}

		if($this->restoreOldPasswdLDAP()) {
			return $this->restoreOldPasswdLib();
		} else {
			//錯誤訊息已經在LDAPRestoreOldPasswd當中設定了
			return false;
		}
	}

	//還原圖書館的密碼,作法是再把舊密碼insert到tmp table一次
	public function restoreOldPasswdLib() {
		$post = array(
			'id' => $this->user_id,
			'new_password' => $this->oldPasswd,
			'type' => 'add'
		);
		if(!$this->ChangeLibPasswd($post)) {
			$this->error = $this->error = '圖書館密碼還原失敗(錯誤代碼PASS_013)！';
			return false;
		}
		return true;
	}
}

?>
