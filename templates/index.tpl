{%*********************************************************
中正大學個人化校務系統單一入口 登入界面
  @ author:         johnny@ccu.edu.tw
  @ maintainer:     porihuang@ccu.edu.tw
  @ para:           $websit_name
  @ css:
  @ js:
**********************************************************%}

{%* HTML標頭區 *%}
{%include file='pub/head.tpl'%}
<link rel="stylesheet" href="css/index_template.css" type="text/css" />
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
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
			<a href="index.php"><image src="images/banner.jpg" /></a>
			{%if $announcement != ''%}
			<div id="announcement">{%$announcement%}</div>
			{%/if%}
		</div>

		<div id="container">
			<div id="content">
				<div id="inner_content">
					<div id="sso_logo"><image src="images/sso_logo_b.png" /><image src="images/sso_logo.png" /></div>
					<div class="login_header">
						登入 Login
					</div>
					<div id="login_input">
						<form id="loginfrm" name="loginfrm" method="post" action="login_check.php">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										帳號：　<input type="text" id="acc" name="acc" tabindex="1" autocomplete="off" size="28" maxlength="64" value="請輸入帳號"/>
									</td>
									<td>
										&nbsp;<input type="checkbox" id="remember_acc" value= "true" tabindex="5"/><label for="remember_acc">記住帳號</label>
									</td>
								</tr>
								<tr>
									<td>
										密碼：　<input type="password" id="pass" name="pass" tabindex="2" autocomplete="off" size="28" maxlength="15" />
									</td>
									<td>
										&nbsp;&nbsp;<a href="javascript:onImgForget()" style="font-size:80%;" tabindex="6">忘記密碼</a>
									</td>
								</tr>
								<tr id="tr_imgcode" style="display:none;">
									<td>
										驗證碼：<input type="text" id="authcode" name="authcode" tabindex="3" autocomplete="off" size="28" maxlength="4" />
									</td>
									<td style="padding:5px;">
										&nbsp;&nbsp;<img id="authimg" class="authimg" src="misc/imgcode.php" alt="" onClick="this.src='misc/imgcode.php?rnd='+ Math.random();" title="點選此處，更新驗證碼" style="vertical-align:middle;"/>
									</td>
								</tr>
								<tr id="tr_imgcode_hint" style="display:none;">
									<td><span>　　　　　登入失敗兩次以上請輸入驗證碼</span></td>
								</tr>
							</table>
						</form>

					</div>
					<div style="width=640px; text-align:center;"><input type="image" id="login_btn" name="login" class="bt_index" value="" tabindex="4" src="images/btn_login.png"></div>
					<div class="login_header">
						第一次登入 First Time Login
					</div>
					<div id="login_text">
					學生　　：請先<a href="javascript:void(0);" onclick="accEnable();">按此啟用</a>帳號<br>
					教職員工：請先<a href="apply_acc.php">按此註冊</a>帳號
					</div>
<!--<div id="annoucement2" style="text-align:center; background-color:#FF9; color:red; padding:5px; font-weight:bold;">
	<div>公告：this is 多行公告<br>
	
</div> -->
				</div>
			</div>
		</div>
		{%* HTML標尾區 *%}
		{%include file='pub/footer.tpl'%}
	</div>

	<div id="accEnableDlg" class="accDialog" style="display:none;cursor:default;">
		<p>請輸入<span class="red_text">學籍系統的帳號密碼</span>來啟用帳號</p>
		<p>( 新生請先登入&nbsp;<a href="{%$acdamicPath%}" target="_blank">學籍系統</a>&nbsp;進行第一次密碼修改的動作 )</p>
		<p>啟用後請於3~5分鐘後收信，並點選信件內的網頁連結，即可啟用您的帳號！</p>
		<p>如果一直沒收到認證信，<span class="red_text">請先檢查看看是否被當成垃圾信件</span></br>
		依然沒有的話，請再次執行啟用流程重寄一次！(可更換e-mail)</p>
			<table class="dialogTable">
				<tr><td><label>學號：</label></td>   <td><input type="text" id="enabID" autocomplete="off" maxlength="9" size="30" /></td></tr>
				<tr><td><label>密碼：</label></td>   <td><input type="password" id="enabPass" autocomplete="off" maxlength="100" size="30"/></td></tr>
				<tr><td><label>e-mail：</label></td> <td><input type="text" id="email" autocomplete="off" maxlength="100" size="30"/></td></tr>
			</table>
		<input type="button" id="btn_enable" class="dlgBtn" value="啟用" onclick="onBtnEnable();">&nbsp;<input type="button" id="btn_cancel" class="dlgBtn" value="取消" onclick="onBtnCancel();">
	</div>

	<div id="forgetPassDlg" class="accDialog" style="display:none;cursor:default;">
		<p>學、碩、博士班&nbsp;<a href="javascript:forgetPassRedirect();">請點此查詢密碼</a></p>
		<p>在職專班&nbsp;<a href="javascript:forgetPassRedirectGra();">請點此查詢密碼</a></p>
		<p>教職員工&nbsp;<a href="javascript:forgetPassRedirectStaff();">請點此查詢密碼</a></p>
		<input type="button" class="dlgBtn" value="關閉" onclick="onBtnUnblockUI();">
	</div>
</body>
<style>
#inner_content{
	margin: 0 auto;
	width: 650px;
	text-align: left;
}
#sso_logo{
	padding-top: 30px;
	margin: 0 auto;
	display: inline-block;
}
.login_header{
	border-top: #000 1px dashed;
	border-bottom: #000 1px dashed;
	color: #2D2991;
	font-size: 200%;
	font-weight: bold;
	line-height: 1.8em;
	margin-top: 10px;
	margin-bottom: 10px;
	padding-left: 10px;
	/*border:2px solid #FFCCCC;*/
}
#login_text{
	font-size: 120%;
	line-height: 1.5em;
	padding: 0 20px 10px 20px;
}
#login_input{
	margin: 0 auto;
	width: 600px;
	font-size: 120%;
	font-weight: bold;
	line-height: 1.5em;
}
#acc, #pass, #authcode{
	border:2px solid #F25A24;
	font-size: 120%;
}
table tr td{
	padding:3px;
}
#tr_imgcode_hint{
	font-size: 80%;
}
#login_btn{
	margin: 0 auto;
}
#authimg{
	cursor:pointer;
}
.accDialog{
	text-align: center;
	padding: 20px;
	line-height: 1.5em;
}
.dialogTable{
	margin: 0 auto;
	text-align: right;
}
.accDialog input{
	margin: 5px;
}
.accDialog .dlgBtn{
	width: 60px;
	height: 30px;
}
.red_text{
	color: red;
}
</style>
<script type="text/javascript">
	<!--
	$(document).ready(function() {
		$('#authcode').val('請輸入右邊文字');

		if($.cookie('cookie_acc')) {
			$("#acc").val($.cookie('cookie_acc'));
			$("#remember_acc").prop('checked', true);
		}

		$('#acc, #pwID').blur(function() {
			if($.trim($(this).val()) == '') {
				$(this).val('請輸入帳號');
			}
		});
		$('#acc, #pwID').focus(function() {
			if($(this).val().indexOf('帳號') != -1) {
				$(this).val('');
			} else {
				$(this).select();
			}
		});

		$('#authcode').blur(function() {
			if($.trim($(this).val()) == '') {
				$(this).val('請輸入右邊文字');
			}
		});
		$('#authcode').focus(function() {
			if($(this).val().indexOf('輸入') != -1) {
				$(this).val('');
			} else {
				$(this).select();
			}
		});

		$('#login_btn').click(login_check);


		$('#applyacc').click(function() {
			var pwdWin2 = window.open('apply_acc.php', 'pwdWin', 'left=50,top=50,width=500,height=400,scrollbars=yes,resizable=yes');
			pwdWin2.focus();
		});

		// {%* 在帳號輸入一個空格之後立刻按下enter竟然能避掉"請輸入帳號"的檢查, 因此改成只在驗証碼欄位才抓enter執行登入動作 *%}
		//$('input#acc, input#pass, input#authcode').keydown(function(e) {
		$('#pass, #authcode').keydown(function(e) {
			if(e.keyCode == '13') { // 按下enter
				login_check();
			}
			e.stopPropagation();
		});

		$('#email').keydown(function(e) {
			if(e.keyCode == '13') { // 按下enter
				onBtnEnable();
			}
			e.stopPropagation();
		});

		$('#accEnableDlg').keyup(function(e) {
			if(e.keyCode == '27') { // 按下esc
				onBtnCancel();
			}
			e.stopPropagation();
		});

		// 禁止複製貼上
		//$('#pass, #enabPass').bind('cut copy paste', function(e) {
		//	e.preventDefault(); // 取消動作
		//});

		// 超過失敗次數上限，顯示驗證碼
		if({%$fail_counts%} >= {%$max_fail_counts%}) {
			$('#tr_imgcode, #tr_imgcode_hint').show();
		}

		$("#remember_acc").change(function(){
			if( !$(this).prop('checked') ) {
				$('#acc').val('請輸入帳號');
				$.removeCookie('cookie_acc', { path: '/' });
			}
		});
	});

	function loginfrm() {
		remenber_acc();
		$('#loginfrm').submit();
	}

	function login_check() {
		var flag = false;
		if({%$fail_counts%} >= {%$max_fail_counts%}) {
			flag = checkfrm($('input#acc').val(), $('input#pass').val(), true, $('input#authcode').val())
		} else {
			flag = checkfrm($('input#acc').val(), $('input#pass').val(), false, $('input#authcode').val())
		}
		if(flag) {
			$.blockUI({
				message:'<img src=images/loading.gif class=loading align=absmiddle>登入中.....',
				css:{border:'5px solid white',background:'#07538f',padding:'10px',color:'white'}
			});
			setTimeout(loginfrm, 900);
		}
	}
	//check_authcode 是否檢查驗證碼
	function checkfrm(acc, pass, check_authcode, authcode) {
		var alert_text = '';
		var check_sign = true;

		if(acc.length==0 || acc.indexOf('帳號') != -1) {
			alert_text += '尚未輸入帳號 \n';
			check_sign = false;
		//}else if(acc.length < 5){
			//alert_text += "不合法的帳號字串，帳號不足五碼，請重新輸入！\n";
			//check_sign=false;
		}
		if(pass.length == 0) {
			alert_text += '尚未輸入密碼 \n';
			check_sign = false;
		} else if(pass.length < 4) {
			alert_text += '不合法的密碼字串，密碼不足四碼，請重新輸入！ \n';
			check_sign = false;
		}
		/***- 密碼限制要跟學籍、人事系統同步，這邊或許可以改成善意提醒
		else if(pass.match(/[\W]/)) {
			alert_text += '不合法的密碼字串，密碼不能含有_之外的特殊字元，請重新輸入！\n';
			check_sign = false;
		} else if(pass == acc) {
			alert_text += '帳號與密碼不可以一樣哦！\n';
			check_sign = false;
		} else if(pass.indexOf(acc) != -1) {
			alert_text += '密碼不可以含有帳號的字串哦！\n';
			check_sign = false;
		}
		*/
		if(acc.match(/^[a-zA-Z]\d{9}/g)) {
			alert_text += '教職員工請輸入e-mail當帳號 \n';
			check_sign = false;
		}

		if(check_authcode) {
			if(authcode.length == 0 || authcode.indexOf('輸入') != -1) {
				alert_text += '尚未輸入驗證碼，請輸入！ \n';
				check_sign = false;
			} else if(authcode.length != 4) {
				alert_text += '驗證碼不足四碼，請重新輸入！ \n';
				check_sign = false;
			}
		}
		if(check_sign == false) {
			alert(alert_text);
		}
		return check_sign;
	}

	function accEnable() {
		$.blockUI({
			message: $('#accEnableDlg'),
			css:{
				width:'610px',
				centerX:true,
				centerY:true
			},
			focusInput:false
		});
	}

	// 啟用帳號
	var enabReady = true;
	function onBtnEnable() {
		var id = $('#enabID').val().replace(/[\s]+/g, '');
		var pass = $('#enabPass').val().replace(/[\s]+/g, '');
		var email = $('#email').val().replace(/[\s]+/g, '');
		if(id.length == 0 || id.indexOf('帳號') != -1) {
			alert('請輸入帳號！');
			return;
		}
		if(pass.length == 0) {
			alert('請輸入密碼！');
			return;
		}// else if(pass.length < 5) {
		//	alert('不合法的密碼字串，密碼不足五碼。\n請至行政自動化或學籍系統修改密碼！\n');
		//	return;
		//}
		if(email.length == 0) {
			alert('請輸入e-mail！');
			return;
		}
		//檢查email正確性
		if(!email.match(/^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]+$/)) {
			alert('E-mail格式不正確！\n');
			return;
		}

		if(enabReady) {
			enabReady = false; // 避免連續點擊
			$.ajax({
				url: 'ajax/apply_acc_ajax.php',
				cache: false,
				type: 'POST',
				dataType: 'json',
				data: {
					type: 'stuEnable',
					id: id,
					pass: pass,
					email: email
				},
				error: function(xhr) {
					alert('錯誤代碼：ID_APPLY_301\n啟用帳號請求發生錯誤，請洽詢電算中心開發人員！');
					enabReady = true;
					$.unblockUI();
				},
				success: function(response) {
					enabReady = true;
					alert(response['msg']);
					if(response['result'])
						onBtnCancel();
				}
			});
		} else {
			alert('請勿連續點擊，稍待一會兒再執行啟用帳號功能！');
		}
	}
	function onBtnCancel() {
		$.unblockUI();
		//$('#enabID').val('請輸入帳號');
		$('#enabPass').val('');
		$('#email').val('');
	}

	function onBtnUnblockUI() {
		$.unblockUI();
	}

	function onImgForget() {
		$.blockUI({
			message: $('#forgetPassDlg'),
			css:{width:'400px', top:'40%', left:'40%'},
			focusInput:false
		});
	}

	// 參考學籍系統查詢密碼的寫法
	window.onfocus = blowOut;
	var popup_ask_passwd = null;
	function forgetPassRedirect() {
		popup_ask_passwd = window.open( '{%$acdamicPath%}lost_passwd.htm', 'lost_passwd', 'width=650, height=500, scrollbars=yes' );
	}
	function forgetPassRedirectGra() {
		popup_ask_passwd = window.open( '{%$acdamicGraPath%}lost_passwd.htm', 'lost_passwd', 'width=650, height=500, scrollbars=yes' );
	}
	function forgetPassRedirectStaff() {
		popup_ask_passwd = window.open( 'http://miswww1.cc.ccu.edu.tw/account/common/query_pwd.php', 'lost_passwd', 'width=650, height=600, scrollbars=yes' );
	}
	function blowOut() {
		if(popup_ask_passwd != null && !popup_ask_passwd.closed) {
			popup_ask_passwd.close();
			popup_ask_passwd = null;
		}
	}

	function remenber_acc() {
		if($('#remember_acc').prop('checked'))
			$.cookie('cookie_acc', $('#acc').val(), {path:'/', expires:30});
		else
			$.cookie('cookie_acc', "", {path:'/', expires:-1});
	}
	//-->
	</script>
</html>