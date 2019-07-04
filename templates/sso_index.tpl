{%*********************************************************
  中正大學學生單一入口
  @ author:         porihuang@ccu.edu.tw
  @ maintainer:     porihuang@ccu.edu.tw
  @ para:           //$websit_name, $userACC
  @ css:            //$cssFile(sso_new.css)
  @ js:				none
**********************************************************%}

{%* HTML標頭區 *%}
{%include file='pub/head.tpl'%}
<script type="text/javascript" src="js/JSCal2/jscal2.js"></script><!-- 行事曆小工具要用 -->
<script type="text/javascript" src="js/JSCal2/lang/cn.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.paginate.js"></script>
<link rel="stylesheet" href="css/jquery-ui.min.css" type="text/css" />
<link rel="stylesheet" href="css/sso_index.css" type="text/css" />
<link rel="stylesheet" href="css/widget_dailyCourse.css" type="text/css"/>
<link rel="stylesheet" href="css/widget_sso.css" type="text/css" />
</head>

{%* HTML主體區 *%}
<noscript>
	<center style="background-color:yellow;font-weight:bold;color:red;font-size:large;">瀏覽本網站，強烈建議你把瀏覽器的Javascript功能開啟！</center>
</noscript>
<body>
	<div id="cwrap">
		<div id="header">
			<div id="ccu_logo">
				<a href="http://www.ccu.edu.tw" target="_blank" style="float:left;"><image src="images/ccu_logo.png" /></a>
				<span id="name_s">{%$username%}&nbsp;你好&nbsp;&nbsp;<a id="btn_logout" href="logout_check.php" >&nbsp;&nbsp;登出</a></span>
				<div style="clear:both;"></div>
			</div>
			<a href="sso_index.php"><div id=banner></div></a>
			<div id="navi">
				<div id="navi_left">
					{%if $show_ep%}
					<image src="images/triangle.png" style="height:48px; vertical-align: -15px;" /><span id="ccu_ep"><a href="javascript:openEPTab();">中正航海王 生涯定向系統</a></span>
					{%/if%}
					{%if $show_NUCloud_link%}
					<image src="images/triangle.png" style="height:48px; vertical-align: -15px;" /><span id="nucloud_link"><a href="javascript:signOnNUCloud();">中正雲</a></span>
					{%/if%}
				</div>
				<ul>
					<li id="navi_change_pwd"><a href="javascript:void(0);" onclick="showChangePwDlg();">密碼變更</a></li>
					<li id="navi_feedback"><a href="{%$feedback_url%}" target="_blank">意見回饋</a></li>
					<li id="navi_help"><a href="sso_help.html" target="_blank">說明</a></li>
				</ul>
			</div>
		</div>

		<div id="container">
			{%if $announcement != ''%}
			<div id="announcement">{%$announcement%}</div>
			{%/if%}
			<div id="columns">
				{%$widget_frames%}
			</div>
		</div>

		{%* HTML標尾區 *%}
		{%include file='pub/footer.tpl'%}

		<div id="changePwDlg" style="display:none;cursor:default;">
			<span>請輸入帳號、舊密碼與新密碼</span>
				<table class="dialogTable">
					<tr><td><label>舊密碼：</label></td>   <td><input type="password" id="oldPass" autocomplete="off" maxlength="{%$pass_len_input_limit%}" size="30" tabindex="1"/></td></tr>
					<tr><td><label>新密碼：</label></td> <td><input type="password" id="newPass" autocomplete="off" maxlength="{%$pass_len_input_limit%}" size="30" tabindex="2"/></td></tr>
					<tr><td><label>確認新密碼：</label></td> <td><input type="password" id="checkPass" autocomplete="off" maxlength="{%$pass_len_input_limit%}" size="30" tabindex="3"/></td></tr>
				</table>
				<span>密碼長度請介於 {%$pass_len_min%} 到 {%$pass_len_max%} 碼之間，使用大小寫英文、<br>數字、及以下特殊字元組合「! @ $ ^ _ -」</span>
				{%$change_pass_msg%}
			<input type="button" id="btnChangePw" class="dlgBtn" value="確認" onclick="onBtnChangePw();">&nbsp;<input type="button" id="btnPwCancel" class="dlgBtn" value="取消" onclick="onBtnPwCancel();">
		</div>

		<div id="dlg4nucloud" style="display:none;">
			<div>{%$NUCloud_dlg_msg%}</div>
			<label><input type="checkbox" name="hide_dlg4nucloud">不再顯示</input></label>
		</div>
	</div>
	<!-- Bottom of document js放這邊可加快載入速度 -->
	{%if $load_ec_js%}
	<script type="text/javascript" src="js/widget_ec.js"></script>
	<link rel="stylesheet" href="css/widget_ec.css" type="text/css" />
	{%/if%}
	</body>

<style>
#w_news #news_content #thumb_list .thumb_photo{
	/* trick: 避免IE校園新聞圖片擠成兩排，原100px */
	width: 93px;
}
</style>
<script type="text/javascript">
<!--
// global變數
var session_refresh_time = {%$session_refresh_time%}; // session更新間隔
var session_maxrefresh_time = {%$session_maxrefresh_time%}; // session持續更新的最大時限
var interval_id = '';
var last_activity_time = '';
$(document).ready(function() {
	//changeTitlePic(8);

	var date_obj = new Date();
	last_activity_time = Math.floor(date_obj.getTime()/1000); // milliseconds
	interval_id = setInterval(refresh_timer, session_refresh_time*1000);

	$('input#checkPass').keydown(function(e) {
		if(e.keyCode == '13') { // 按下enter
			onBtnChangePw();
		}
		//e.stopPropagation();
	});

	$('#changePwDlg').keyup(function(e) {
		if(e.keyCode == '27') { // 按下esc
			onBtnPwCancel();
		}
		//e.stopPropagation();
	});

	// 禁止複製貼上
	//$('input#oldPass, input#newPass, input#checkPass').bind('cut copy paste', function(e) {
	//	e.preventDefault(); // 取消動作
	//});

	/*
	var stop_d_click = true;
	$('#menu').click(function() {
		if($('#options').css('display') == 'none'){
			stop_d_click=true;
			$('#options').show();
			$('#menu').text("選單▲");
		}
	});
	$(document).click(function() {
		// 任何click都算user alive
		var date_obj = new Date();
		last_activity_time = Math.floor(date_obj.getTime()/1000); // milliseconds

		// 在任何地方click，收回選單
		if(($('#options').css('display') == 'block') && (stop_d_click == false)) {
			$('#options').hide();
			$('#menu').text("選單▼");
		} else {
			stop_d_click = false;
		}
	});
	*/

	// {%*單一登入小工具要用的*%}
	$('.iconer li, .guest_iconer li').has('a').mouseover(function(e) {
		$(this).css('background-color', '#DEDEDE');
	});
	$('.iconer li, .guest_iconer li').has('a').mouseleave(function(e) {
		$(this).css('background-color','');
	});
	$('.iconer a, .guest_iconer a').click(onSignOn);

	// {%*nucloud宣傳*%}
	if("{%$show_NUCloud_dlg%}" == "true") {
		var show_NUCloud_dlg = true;
		var last_login_date = $.cookie('login_date');
		// {%*第一次登入(無cookie值)或是登入間隔超過一天才需要顯示*%}		
		if((typeof last_login_date !== 'undefined')) {
			var date_tmp = new Date(last_login_date);
			var diff = new Date(date_obj - date_tmp);
			var diff_days  = diff/1000/60/60/24;
			//log(diff_days);
			if(diff_days < 1) {
				show_NUCloud_dlg = false;
			}
		}
		if(show_NUCloud_dlg) {
			$('#dlg4nucloud').dialog({
				modal: true,
				title: "中正雲小提醒",
				buttons: {
					Ok: function() {
						if($('input[name="hide_dlg4nucloud"]').prop("checked")) {
							$.ajax({
								url: "ajax/sso_ajax.php",
								cache: false,
								type: "POST",
								data: {
									pType: "hide_NUCloud_dlg",
									hide_nucloud_dlg: "hide"
								},
								error: function(xhr) {
									alert("發生異常！");
								}
							});
						}
						var year = date_obj.getFullYear()
						var month = date_obj.getMonth()+1;
						var day = date_obj.getDate();
						var login_date1 = year + '/' + (month<10 ? '0' : '')+month + '/' + (day<10 ? '0' : '') + day;
						$.cookie('login_date', login_date1, {path:'/', expires:1});
						$(this).dialog("close");
					}
				},
				open: function() {
					$('.ui-widget-overlay').addClass('custom-overlay');
					$('#dlg4nucloud a').blur();
				},
				close: function() {
					$('.ui-widget-overlay').removeClass('custom-overlay');
				}
			});
		}
	}

	// 頁面載入完成或是按下F5的情況，也要重刷session存活時間
	$.post('ajax/refresh_time_ajax.php');
});

/*
// 圖片輪撥:每次reload亂數顯示圖片
function changeTitlePic(picMaxNum) {
	var picNum = Math.floor((Math.random()*picMaxNum)+1);
	var picName = 'url(images/bg-header0' + picNum + '.jpg)';
	$('#header').css('background-image', picName);
	//$('#columns .widget .widget-content').css('background-image', 'none');
}
*/

function log(logStr) {
	if(window.console && console.log)
		console.log(logStr);
}

function showChangePwDlg() {
	if('{%$userACC%}' == 'guest') {
		alert('訪客帳號不提供變更密碼功能！');
	} else {
		$.blockUI({
			message: $('#changePwDlg'),
			css:{width:'450px'},
			focusInput:false
		});
	}
}

var enabReady = true;
function onBtnChangePw() {
	var oldPass = $('#oldPass').val().replace(/[\s]+/g, '');
	var newPass = $('#newPass').val().replace(/[\s]+/g, '');
	var checkPass = $('#checkPass').val().replace(/[\s]+/g, '');
	if(oldPass.length == 0) {
		alert('請輸入舊密碼！');
		return;
	}
	if(newPass.length == 0) {
		alert('請輸入新密碼！');
		return;
	}
	if(checkPass.length == 0) {
		alert('請確認新密碼！');
		return;
	}
	if(newPass.length < {%$pass_len_min%}) {
		alert('密碼不足{%$pass_len_min%}碼！');
		return;
	}
	if(newPass.length > {%$pass_len_max%}) {
		alert('密碼大於{%$pass_len_max%}碼！');
		return;
	}
	//舊密碼不檢查非法字元
	var regex = /[^a-zA-Z0-9!@$^_-]/;//符合就是不合法字串
	if(newPass.match(regex)) {//match找不到會回傳null
		alert('密碼有不合法的字元！');
		return;
	}
	if(newPass != checkPass) {
		alert('兩次輸入的新密碼不同！');
		return;
	}

	if(enabReady) {
		enabReady = false;//不能寫在ajax當中,會造成短時間內一樣可以連續點擊
		$.ajax({
			url: 'ajax/apply_acc_ajax.php',
			cache: false,
			type: 'POST',
			data: {
				type: 'changePW',
				oldPass: oldPass,
				newPass: newPass
			},
			dataType: 'json',
			error: function(xhr) {
				alert('變更密碼請求發生異常，請洽詢電算中心開發人員！');
				enabReady = true;
				$.unblockUI();
			},
			success: function(response) {
				if(response['result']) {
					alert('密碼變更成功！');
				} else {
					alert('密碼變更失敗('+response['msg']+')，重試依然無法解決的話，請洽詢電算中心開發人員！');
				}
				enabReady = true;
				if(response['closeDlg'])
					onBtnPwCancel();
			}
		});
	} else {
		alert('請勿連續點擊！');
	}
}
function onBtnPwCancel() {
	$.unblockUI();
	$('#oldPass').val('');
	$('#newPass').val('');
	$('#checkPass').val('');
}
function openEPTab() { // 二版代簽入
	signOnEP(); // this file is in widget_sso.tpl
}

function refresh_timer() {
	var d = new Date();
	var now_time = Math.floor(d.getTime()/1000);
	var total_time = now_time - last_activity_time;
	if(now_time - last_activity_time <= session_maxrefresh_time) {
		//var delta = now_time - last_activity_time;
		//log('now_time is '+now_time+', last activity time is '+last_activity_time+', delta is '+delta+', session_maxrefresh_time is '+session_maxrefresh_time);
		$.post('ajax/refresh_time_ajax.php');
	} else {
		clearInterval(interval_id);
	}
}

// {%*禁止任意更換代碼，因為log檔也會記錄代簽入到哪個系統，以後可以用來統計一些數據*%}
function onSignOn(event) {
	$.ajax({
		url: 'ajax/refresh_time_ajax.php',
		cache: false,
		type: 'POST',
		data: {
			type: 'is_alive'
		},
		success: function(response) {
			if(response.search('s_expire') != -1) {
				location.replace('logout_check.php');
			}
		}
	});

	var linkId 	= $(this).attr('name');
	var service = '';
	var para	= '';

	var user = '{%$userACC%}';
	switch(linkId) {
	case '0000': // E-course課程平台
		service = '{%$target_urls.i0000%}';
		break;
	case '0001': // 課程地圖
		service = '{%$target_urls.i0001%}';
		break;
	case '0002': // 選課系統
		// {%* 需要用學號開頭判斷是在職專班或是碩博班,選課系統會導向不同主機 *%}
		var firstChar = user.charAt(0);
		if(firstChar == '5') { // 專班
			service = '{%$target_urls.i0002g%}';
		} else {
			service = '{%$target_urls.i0002%}';
		}
		break;
	case '0003': // 圖書館
		service = '{%$target_urls.i0003%}';
		break;
	case '0004': // 學籍系統
		service = '{%$target_urls.i0004%}';
		break;
	case '0005': // 在職專班學籍系統
		service = '{%$target_urls.i0005%}';
		break;
	case '0006': // 生涯定向
		service = '{%$target_urls.i0006%}';
		break;
	case '0007': // 成績查詢
		var firstChar = user.charAt(0);
		if(firstChar == '5') {//專班
			service = '{%$target_urls.i0007g%}';
		} else {
			service = '{%$target_urls.i0007%}';
		}
		break;
	case '0008': // 校園授權軟體下載
		service = '{%$target_urls.i0008%}';
		break;
	case '0009': // 碩/博士宿舍系統
		service = '{%$target_urls.i0009%}';
		break;
	case '0010': // 大學部宿舍管理系統
		service = '{%$target_urls.i0010%}';
		break;
	case '0011': // 宿舍維修系統
		service = '{%$target_urls.i0011%}';
		break;
	case '0012': // 學雜費減免申請系統
		service = '{%$target_urls.i0012%}';
		break;
	case '0013': // 弱勢助學申請系統
		service = '{%$target_urls.i0013%}';
		break;
	case '0014': // 工讀時數登錄系統測試
		service = '{%$target_urls.i0014%}';
		break;
	case '0015': // 網路投票系統測試
		service = '{%$target_urls.i0015%}';
		break;
	case '0016': // 電子賀卡
		service = '{%$target_urls.i0016%}';
		break;
	case '0017': // 資訊能力測驗
		service = '{%$target_urls.i0017%}';
		break;
	case '0018': // 線上學習
		service = '{%$target_urls.i0018%}';
		break;
	case '0019': // 初次晤談預約系統(測試)
		service = '{%$target_urls.i0019%}';
		break;
	case '0020': // 學位服借用管理系統 
		service = '{%$target_urls.i0020%}';
		break;
	case '0021': // 差勤系統
		if('{%$is_pla%}' == 'Y') // {%* 計畫人員的差勤系統 *%}
			service = '{%$target_urls.i0021p%}';
		else
			service = '{%$target_urls.i0021%}';
		break;
	case '0022': // 人事系統
		service = '{%$target_urls.i0022%}';
		break;
	case '0023': // 會計Web查詢, 跳出資料庫選取dialog, 後續由dialog的確定function跑流程
		service = '{%$target_urls.i0023%}';
		break;
	case '0024': // 教師專業資訊系統
		service = '{%$target_urls.i0024%}';
		break;
	case '0025': // 財產管理系統
		service = '{%$target_urls.i0025%}';
		break;
	case '0026': // 薪資查詢系統
		service = '{%$target_urls.i0026%}';
		break;
	case '0027': // 致遠樓線上申請
		service = '{%$target_urls.i0027%}';
		break;
	case '0028': // 校際選課
		service = '{%$target_urls.i0028%}';
		break;
	case '0029': // 電子公文
		service = '{%$target_urls.i0029%}';
		break;
	case '0030': // 物品管理系統
		service = '{%$target_urls.i0030%}';
		break;
	case '0031': // 計畫系統
		service = '{%$target_urls.i0031%}';
		break;
	case '0032': // NUCloud
		service = '{%$target_urls.i0032%}';
		break;
	case '0040': // 校務建言系統
		service = '{%$target_urls.i0040%}';
		break;
	default:
		service = '';
	}

	signOn(service, linkId, para);
}

function signOn(service, linkId, para) { // {%*和event分開是為了也要給sso_index.tpl的生涯定向代簽入使用*%}
	if(service != '') {
		var targetUrl = '{%$ssoServiceURL%}?service='+service+'&linkId='+linkId+'&para='+para;
		window.open(targetUrl, linkId);
	} else {
		alert('Unknown service!');
	}
}

// 生涯定向小工具title連結要用的
function signOnEP() {
	var linkId = '0006';
	service = '{%$target_urls.i0006%}';
	signOn(service, linkId, '');
}

var initial_sw_setting_dlg;
function show_sso_widget_setting_dlg() {
	if('{%$userACC%}' == 'guest') {
		alert('訪客帳號不提供自訂連結功能！');
	} else {
		initial_sw_setting_dlg = $('#sso_widget_setting_Dlg').html();
		$.blockUI({
			message:$('#sso_widget_setting_Dlg'),
			css:{width:'530px', top:'3%', left:'30%'},
			focusInput:false
		});
	}
}

function sso_widget_check(click_id) {
	var id = click_id.split('_')[1];
	if($('#check_'+id).prop('checked')) {
		$('#check_'+id).prop('checked', false);
		$('#ili_'+id).hide();
	} else {
		$('#check_'+id).prop('checked', true);
		$('#ili_'+id).show();
	}
}

function onBtnChangeWidget() {
	$('#btnChangeWidget').prop('disabled', true);
	$('#sso_widget_setting_form').submit();
}

function onBtnWidgetCancel() {
	$('#sso_widget_setting_Dlg').html(initial_sw_setting_dlg);
	$.unblockUI();
}

// 網路投票公告快速連結
function signOnVote() {
	var linkId = '0015';
	service = '{%$target_urls.i0015%}';
	signOn(service, linkId, '');
}

// nucloud快速連結
function signOnNUCloud() {
	var linkId = '0032';
	service = '{%$target_urls.i0032%}';
	signOn(service, linkId, '');
}

// e-course widget
$('#ec_nav ul li').on('click', function(event) {
	event.preventDefault();
	$('#ec_nav ul li').removeClass('active');
	$(this).addClass('active');
	$('.ec_page').removeClass('active');
	if($(this).html() == "教材") {
		$('#ec_material').addClass('active');
		$('.ec_material_files').removeClass('active');
		$('#ec_material_list').show();
	} else if($(this).html() == "作業") {
		$('#ec_homework').addClass('active');
	} else if($(this).html() == "成績") {
		$('#ec_score').addClass('active');
	} else { // 公告
		$('#ec_news').addClass('active');
	}
});

$('.ec_table tr td').on('click', function(event) {
	//event.preventDefault();
	//$(this).html()
	var course_id = $(this).attr('id');
	var arr = course_id.split('_');
	$('#ec_material_list').hide();
	//var target_id = ;
	if(course_id == 'ec_course_'+arr[2]) {
		$('#ec_materail_files_course_'+arr[2]).addClass('active');
	}
});


//-->
</script>
<!--<script type="text/javascript" src="js/ccu-sso.js"></script>-->

</html>
