{%*********************************************************
中正大學個人化校務系統單一入口 啟用帳號界面
  @ author:         porihuang@ccu.edu.tw
  @ maintainer:     porihuang@ccu.edu.tw
  @ para:           $websit_name
  @ css:            
  @ js:				
**********************************************************%}

{%* HTML標頭區 *%}
{%include file='pub/head.tpl'%}
<link rel="stylesheet" href="css/index_template.css" type="text/css" />
</head>

{%* HTML主體區 *%}
<noscript>
	<center style="background-color:yellow;font-weight:bold;color:red;font-size:large;">瀏覽本網站，強烈建議你把瀏覽器的Javascript功能開啟！</center>
</noscript>
<body>
	<div id="cwrap">
		<div id="header">
			<div id="ccu_logo">
				<a href="http://www.ccu.edu.tw" target="_blank"><image src="images/ccu_logo.png" /></a>
			</div>
			<div id="navi">
				<ul>
					<li><a href="sso_help.html" target="_blank"><image src="images/btn_help.jpg" /></a></li>
					<li><a href="{%$feedback_url%}" target="_blank"><image src="images/btn_feedback.jpg" /></a></li>
				</ul>
			</div>
			<a href="index.php"><image src="images/banner.jpg"/></a>
		</div>

		<div id="container">
			<div id="content">
				<div id="inner_content">
					<div id="apply_header"><b>~教職員工SSO帳號申請~</b><br>
					為配合個資法施行，不再使用身分證字號當帳號，請先註冊帳號
					</div>

					<div id="step1_block">
						<div class="step_text">
							step1.&nbsp;請輸入『身分證字號』與『行政自動化系統的密碼』
						</div>
						<div class="row_block" id="row_id">
							<div class="row_left">
								◎&nbsp;身分證字號：<br>
								(居留證號碼)
							</div>
							<div class="row_right" id="right_id">
								<input type="text" id="ID" name="ID" autocomplete="off" size="42" tabindex="2" maxlength="10" >
							</div>
						</div>
						<div class="row_block" id="row_pass">
							<div class="row_left">
								◎&nbsp;行政自動化密碼：
							</div>
							<div class="row_right">
								<input type="password" id="passwd" name="passwd" autocomplete="off" size="34" tabindex="3" maxlength="15" >&nbsp;&nbsp;<button id="btn_check_pwd">&nbsp;驗證&nbsp;</button>
							</div>
						</div>
						<div class="warning_text" id="step1_warning"></div>
					</div>
					
					<div id="step2_block">
						<div class="step_text">step2.請設定要當成帳號的電子郵件地址</div>
						<div class="row_block" id="row_email">
							<div class="row_left" id="left_email">
								◎&nbsp;設定帳號：
							</div>
							<div class="row_right">
								行政自動化系統：<br>
								&nbsp;&nbsp;<label><input type="radio" name="sel_email" id="sel_email_p" value='p' /><span id="mail_p" size="40"></span></label><br>
								電子公文：<br>
								&nbsp;&nbsp;<label><input type="radio" name="sel_email" id="sel_email_e" value='e' /><span id="mail_e" size="40"></span></label><br>

								<div style="margin-top:10px; padding:3px 0;">請填入e-mail地址或由上列2選1</div>
								<input type="text" id="acc" name="acc" autocomplete="off" size="30" tabindex="4" maxlength="64">&nbsp;&nbsp;<button id="btn_check_acc">&nbsp;檢查帳號&nbsp;</button><br>
							</div>
						</div>
						<div class="warning_text" id="step2_warning"></div>

						<div id="row_btn">
							<button id="bt_applyAcc" tabindex="5" style="width:60px;" disabled>&nbsp;申請&nbsp;</button>
							&nbsp;&nbsp;<button id="bt_register" tabindex="6" disabled>&nbsp;重寄認證信&nbsp;</button>
						</div>
						<div class="red_text" id="row_apply_result">
						</div>
						<div id="msg_final">
							<ul>
								<li>帳號申請完成之後，會收到認證e-mail，請點選信件內的連結完以成帳號的啟用</li>
								<li>點選帳號啟用連結時，<span class="red_text">不會</span>要求您輸入帳號密碼</li>
								<li>若一直沒收到認證信，請到垃圾信箱檢查<span class="red_text">是否被當成垃圾信件</span><br>或請重填資料(可更換e-mail)，點選『重寄認證信』的按鈕</li>
								<li>認證完成後就無法再變更帳號</li>
								<li>若有任何問題，請到『<a href="https://docs.google.com/forms/d/1z3nGjbf56enhME29rvAuTKe4S_uViLWpJhF0a-BfA7U/viewform" target="_blank" tabindex="7">意見回饋</a>』頁面填寫問題情況，我們會儘快為您處理</li>
							</ul>
						</div>
					</div>
					<span style="display:inline-block; margin-top:10px;"><a href="index.php">返回登入頁面</a><span>
					&nbsp;&nbsp;&nbsp;&nbsp;<span style="display:inline-block; margin-top:10px;"><a href="sso_help_staff.html" target="_blank">註冊說明</a><span>
				</div>
			</div>
		</div>
		{%* HTML標尾區 *%}
		{%include file='pub/footer.tpl'%}
	</div>



	<span style="display:inline-block; margin-top:10px;"><a href="index.php">返回登入頁面</a><span>
</body>

<style>
#inner_content{
	margin: 0 auto;
	padding: 20px;
	width: 507px;
	text-align:center;
}
#apply_header{
	background-color: #5096c9;
	height: 60px;
	width: 100%;
	color: #FFF;
	padding-top: 20px;
}
#apply_header b{
	font-size: 150%;
	display: inline-block;
	margin-bottom: 10px;
}
.row_block{
	display: inline-block;
	overflow: hidden;
	text-align: left;
}
.row_block li{
	padding: 3px 0;
}

.row_left{
	width: 150px;
	float: left;
	background-color: #d2d6e8;
	text-align: center;
	padding-top: 10px;
	margin-right: 2px;

	/*自動調整div高度*/
	padding-bottom: 500em;
    margin-bottom: -500em;
}
.row_right{
	width: 340px;
	float: left;
	background-color: #EEE;
	padding: 5px 0 5px 15px;
	padding-bottom: 500em;
    margin-bottom: -500em;
}
#row_id{
	height: 65px;
}
#row_id .row_left{
	padding-top: 20px;
}
#right_id{
	line-height: 60px;
}
.step_text{
	margin: 5px;
	text-align: left;
}
.warning_text{
	margin: 5px;
	text-align: center;
	line-height: 1.2em;
	color: red;
}
#row_pass{
	height: 35px;
}
#row_email{
	height: 150px;
}
#left_email{
	padding-top: 70px;
}
#mail_p, #mail_e{
	display: inline-block;
	padding: 3px 5px;
}
#msg_final ul{
	list-style: square;
	padding-left: 20px;
}
.red_text{
	color: red;
}
#row_btn{
	margin: 5px;
}
#row_apply_result{
	margin: 5px;
}
#msg_final{
	margin: 5px;
	text-align: left;
}
#msg_final li{
	line-height: 1.3em;
	padding: 3px;
}
</style>

<script type="text/javascript">
var g_registed_acc = ''; // 是否之前註冊過
var g_check_pwd_ready = true;
$(document).ready(function() {
	step1_init();

	$('#btn_check_pwd').click(on_btn_check_pwd);

	$('input[name=sel_email]').click(function() {
		var selected_email = $('input[name=sel_email]:checked').val();
		var email_addr = $('#mail_'+selected_email).html();
		//var idx = email_addr.indexOf('@');
		//var acc = email_addr.substr(0, idx);

		$('#acc').val(email_addr);
		toAvail(); // 預設先自動檢查預設帳號格式
	});

	$('#btn_check_acc').click(function(){
		toAvail();
	});

	// 申請帳號
	var ready1 = true;
	$('#bt_applyAcc').click(function() {
		if(ready1) {
			var result = check_input();
			if(result === true) {
				ready1 = false;
				$.ajax({
					url: 'ajax/apply_acc_ajax.php',
					type: 'POST',
					cache: false,
					dataType: 'json',
					data: {
						type: 'apply',
						apid: $('#ID').val(),
						apacc: $('#acc').val(),
						appass: $('#passwd').val(),
					},
					error: function(xhr) {
						$('#step2_warning').html('資料請求發生錯誤，請重試或洽詢電算中心！');
						//$('#step2_warning').fadeIn('slow');
					},
					success: function(response) {
						if(response['result']) {
							g_registed_acc = $('#acc').val();
							diable_apply_UI();
						}
						$('#step2_warning').html(response['msg']);
						//$('#step2_warning').fadeIn('slow');
					},
					complete: function() {
						ready1 = true;
					}
				});
			} else {
				$('#step2_warning').html(result);
				//$('#step2_warning').fadeIn('slow');
			}
		} else {
			alert('系統處理中，請勿連續點擊！');
		}
	});

	// 重寄認證信
	var ready2 = true;
	$('#bt_register').click(function() {
		if(ready2) {
			var result = check_input();
			if(result === true) {
				$.ajax({
					url: 'ajax/apply_acc_ajax.php',
					type: 'POST',
					cache: false,
					dataType: 'json',
					data: {
						type: 'register',
						apacc: $('#acc').val(),
						apid:  $('#ID').val(),
						appass: $('#passwd').val(),
					},
					error: function(xhr) {
						$('#step2_warning').html('資料請求發生錯誤，請重試或洽詢電算中心！');
						//$('#step2_warning').fadeIn('slow');
					},
					success: function(response) {
						// 1分鐘只能重寄一次
						ready2 = false;
						//setTimeout(clearready(), 60000); //***- 這樣的寫法是錯的
						setTimeout(function(){ready2=true;}, 60000);
						$('#step2_warning').html(response['msg']);
						//$('#step2_warning').fadeIn('slow');
					}
				});
			} else {
				$('#step2_warning').html(result);
			}
		} else {
			alert('請稍後一分鐘之後才可再次寄發認證信');
		}
	});

	$('#row_pass').keydown(function(e) {
		if(e.keyCode == '13') { // 按下enter
			on_btn_check_pwd();
		}
		e.stopPropagation();
	});

	// 避免輸入空白字元，可是左右鍵頭也被影響了，改成用change
	//$('input[type="text"]').change(function() {
	//	$(this).val($(this).val().replace(/[\s]/g,''));
	//});
});

function step1_init() {
	$('#step2_block').hide();
	email_reset();
}
function email_reset() {
	$('input[name=sel_email]').attr('checked', false);
	$('#sel_email_p').html('');
	$('#sel_email_e').html('');
	$('#acc').val('');
	$('#step2_warning').html('');
	$('#row_apply_result').html('');
}

// 已經註冊過的身分證字號，關掉申請帳號功能
function diable_apply_UI() {
	$('#bt_applyAcc').attr('disabled', true);
	$('#bt_register').attr('disabled', false);
}

// 未註冊的身分證字號，開啟申請帳號功能
function enable_apply_UI() {
	$('#bt_applyAcc').attr('disabled', false);
	$('#bt_register').attr('disabled', true);
}

function step2_init() {
	$('#step2_block').hide();
	$('#step2_block').slideDown('slow');
	email_reset();
	enable_apply_UI();
}

function on_btn_check_pwd() {
	// 檢查帳號
	var id = $.trim($('#ID').val());
	if(id == '') {
		step1_init();
		$('#step1_warning').html('<span class="red_text">請輸入身分證字號</span>');
		return;
	} else if(id.length < 10) {
		step1_init();
		$('#step1_warning').html('<span class="red_text">身分證字號長度須為10碼</span>');
		return;
	}
	if($.trim($('#passwd').val()) == '') {
		step1_init();
		$('#step1_warning').html('<span class="red_text">請輸入密碼</span>');
		return;
	}

	if(g_check_pwd_ready) {
		$.ajax({
			url: 'ajax/apply_acc_ajax.php',
			type: 'POST',
			cache: false,
			data: {
				type: 'get_email',
				apid: $('#ID').val(),
				appass: $('#passwd').val(),
			},
			dataType: 'json',
			error: function(xhr) {
				$('#step1_warning').html('<span class="red_text">資料請求發生錯誤，請與系統維護人員反應！</span>');
			},
			success: function(response) {
				var msg = '';
				if(response['result']) {
					step2_init();

					var flag_email_p = true;
					var flag_email_e = true;
					// 檢查email格式
					if(response['email_p'] == '') {
						$('#mail_p').html('');
					} else {
						if(check_email(response['email_p'])) {
							$('#mail_p').html(response['email_p']);
						} else {
							$('#mail_p').html('e-mail格式不正確');
							flag_email_p = false;
						}
					}

					if(response['email_e'] == '')
						$('#mail_e').html('');
					else {
						if(check_email(response['email_e'])) {
							$('#mail_e').html(response['email_e']);
						} else {
							$('#mail_e').html('e-mail格式不正確');
							flag_email_e = false;
						}
					}

					// 是否之前註冊過
					g_registed_acc = response['acc'];
					if(g_registed_acc != '') {
						$('#acc').val(g_registed_acc);
						diable_apply_UI();
						msg = '您已註冊過的帳號'+g_registed_acc;
					}

					if($('#mail_p').html() == '' || flag_email_p == false) {
						$('#sel_email_p').attr('disabled', true);
					} else {
						$('#sel_email_p').attr('disabled', false);
					}

					if($('#mail_e').html() == '' || flag_email_e == false) {
						$('#sel_email_e').attr('disabled', true);
					} else {
						$('#sel_email_e').attr('disabled', false);
					}

					if(($('#mail_p').html() == '' || flag_email_p == false) && ($('#mail_e').html() == '' || flag_email_e == false)) {
						if(msg != '')
							msg += '<br>';
						msg += '系統內無電子郵件地址，請先到電子公文或行政自動化系統設定<br>或直接在欄位內輸入'
					}
				} else {
					step1_init();
					msg = response['msg'];
				}
				$('#step1_warning').html('<span>'+msg+'</span>');
			},
			complete: function() {
				g_check_pwd_ready = true;
			}
		});
	} else {
		alert('系統處理中，請勿連續點擊！');
	}
}

function toAvail() {
	var check_result = check_acc_format();
	if(check_result !== true) {
		$('#step2_warning').html(check_result);
		//$('#step2_warning').fadeIn('slow');
	} else {
		$.ajax({
			url: 'ajax/apply_acc_ajax.php',
			type: 'POST',
			cache: false,
			data: {
				type: 'avail',
				chkid: $('#acc').val()
			},
			dataType: 'json',
			error: function(xhr) {
				$('#step2_warning').html('<span class="red_text">資料請求發生錯誤，請與系統維護人員反應！</span>');
				//$('#step2_warning').fadeIn('slow');
			},
			success: function(response) {
				$('#step2_warning').html(response['msg']);
				//$('#step2_warning').fadeIn('slow');
			}
		});
	}
}

function check_input() {
	var acc		= $('#acc').val();
	var pass	= $('#passwd').val();

	var check_result = check_acc_format();
	if(check_result !== true) {
		return check_result;
	} else if(pass.length < 5) {
		return '不合法的密碼字串，密碼不足五碼。請至行政自動化系統修改密碼！';
	} else if(pass == acc) {
		return '帳號與密碼不可以一樣。請修改帳號名稱或到行政自動化系統修改密碼！';
	} else if(!check_email(acc)) { // acc就是email
		return 'E-mail格式不正確！';
	}

	return true;
}

function check_email(email) {
	return email.match(/^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]+$/);
}

function check_acc_format() {
	//var acc = $('#acc').val().replace(/[\s]+/g, '');
	var acc = $('#acc').val();

	// 長度 6～64
	if(acc.length <= 0){
		return '請輸入帳號！';
	} else if(acc.length < 6 ) {
		return '帳號長度請大於6碼！';
	} else if(acc.length > 64) {
		return '帳號長度請小於64碼！';
	}
	if(check_email(acc)) { // acc就是email
		return true;
	} else {
		return '請輸入正確的e-mail格式！';
	}
	/*
	// 只能是英數字元(空白在這裡其實就被擋掉了)
	var patt = /[^0-9A-Za-z@.]/;
	if(patt.test(acc)) {
		return '帳號只能是英文或數字！';
	}
	// 不能是身分證字號
	patt = /^[a-zA-Z]\d{9}$/;
	if(patt.test(acc)) {
		return '因應個資法，請勿以身分證字號當帳號！';
	}
	// 不能是學號
	patt = /^\d{9}$/;
	if(patt.test(acc)) {
		return '請勿以學號當帳號！';
	}

	// 要有一個英文字元 {%*(http://stackoverflow.com/questions/1559751/regex-to-make-sure-that-the-string-contains-at-least-one-lower-case-char-upper)*%}
	patt = /^(?=.*[a-zA-Z]).+$/;
	if(patt.test(acc)) {
		return true;
	} else {
		return '至少要有一個英文字元！';
	}
	*/
}

</script>

</html>
