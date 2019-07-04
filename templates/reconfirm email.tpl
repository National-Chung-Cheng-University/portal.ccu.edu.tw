<!DOCTYPE html>

<html>
	<head>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>國立中正大學-校園系統單一入口 重新確認email</title>
		<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
		<link rel="stylesheet" href="css/reset.css" type="text/css" />
		<link rel="stylesheet" href="css/main.css" type="text/css" />
		<!-- https://mathiasbynens.be/notes/touch-icons -->
		<!-- For Chrome for Android: -->
		<!-- <link rel="icon" sizes="192x192" href="images/touch-icon-192x192.png">-->
		<!-- For iPhone 6 Plus with @3× display: -->
		<link rel="apple-touch-icon-precomposed" sizes="180x180" href="images/apple-touch-icon-180x180-precomposed.png">
		<!-- For iPad with @2× display running iOS ≥ 7: -->
		<link rel="apple-touch-icon-precomposed" sizes="152x152" href="images/apple-touch-icon-152x152-precomposed.png">
		<!-- For iPad with @2× display running iOS ≤ 6: -->
		<link rel="apple-touch-icon-precomposed" sizes="144x144" href="images/apple-touch-icon-144x144-precomposed.png">
		<!-- For iPhone with @2× display running iOS ≥ 7: -->
		<link rel="apple-touch-icon-precomposed" sizes="120x120" href="images/apple-touch-icon-120x120-precomposed.png">
		<!-- For iPhone with @2× display running iOS ≤ 6: -->
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/apple-touch-icon-114x114-precomposed.png">
		<!-- For the iPad mini and the first- and second-generation iPad (@1× display) on iOS ≥ 7: -->
		<link rel="apple-touch-icon-precomposed" sizes="76x76" href="images/apple-touch-icon-76x76-precomposed.png">
		<!-- For the iPad mini and the first- and second-generation iPad (@1× display) on iOS ≤ 6: -->
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="images/apple-touch-icon-72x72-precomposed.png">
		<!-- For non-Retina iPhone, iPod Touch, and Android 2.1+ devices: -->
		<link rel="apple-touch-icon-precomposed" href="images/apple-touch-icon-precomposed.png"><!-- 57×57px -->
	</head>

	<body>
		<div id="cwrap">
			<div id="header">
				<div id="ccu_logo">
					<a href="http://www.ccu.edu.tw" target="_blank"><image src="images/ccu_logo.png" /></a>
				</div>
				<div id="navi">
					<ul>
						<li><a href="sso_help.html" target="_blank"><image src="images/btn_help.jpg" /></a></li>
						<li><a href="https://docs.google.com/forms/d/1z3nGjbf56enhME29rvAuTKe4S_uViLWpJhF0a-BfA7U/viewform" target="_blank"><image src="images/btn_feedback.jpg" /></a></li>
					</ul>
				</div>
				<a href="sso_index.php"><image src="images/banner.jpg"/></a>
			</div>

			<div id="container">
				<div id="inner_content">
					<p style="font-size:150%; font-weight:bold;">請重新確認您的e-mail</p>
					<p>因系統問題造成一些e-mail資料遺失，會看到這個頁面表示您的e-mail已遺失，請重新確認您的e-mail。</p>
						<table>
							<tr><td><label>e-mail：</label></td> <td><input type="text" id="email" autocomplete="off" maxlength="100" size="50"/></td></tr>
						</table>
					<input type="button" id="btn_enable" class="dlgBtn" value="寄送認證信" onclick="onBtnSend();">&nbsp;<input type="button" id="btn_cancel" class="dlgBtn" value="取消" onclick="onBtnCancel();">
					<p>請於3~5分鐘後收信，並點選信件內的網頁連結來完成確認的動作，完成後請<span class="red_text">先登出後再重新登入</span>到單一入口。
					   如果一直沒收到認證信，請先檢查看看是否被當成垃圾信件。</p>
					<p>此頁面每次登入都會出現，直到您完成e-mail認證，造成您的不便請見諒 <(_ _)></p>
				</div>
			</div>

			<!--版權宣告區-->
			<div id="footer" style="height:100px; text-align:center; background-image:url(images/footer.png); color:#fff;">
				<div id="footer_text1" style="padding-top:10px;">
					<image src="images/ccucc logo.png" style="vertical-align:-15px;"/>
					<span style="padding:0 15px;">系統開發 @ 國立中正大學電算中心&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E-mail : <a href="mailto:sso@ccu.edu.tw" style="color:#fff">sso@ccu.edu.tw</a></span>
				</div>
				<div id="footer_text2" style="padding-top:20px;">
					Copyright©2012 National Chung Cheng University All rights reserved.
				</div>
			</div>

		</div>
	</body>
<style>
#cwrap {
	width: 980px;
	margin: 0 auto;
}
#header { background-color: #d2e6f6; }
#ccu_logo {
	height: 48px;
	padding: 0 0 0 15px;
	float: left;
}
#navi { height: 50xp; }
#navi li {
	float: right;
	margin-bottom: -3px;
}
#container {
	text-align: center;
	background-color: #d2e6f6;
	padding: 40px 60px;
	line-height: 40px;
}
#content {
	position: relative;
}
#inner_content {
	text-align: left;
	width: 750px;
	margin: 0 auto;
}
.red_text { color:red; }
</style>
<script>
<!--
	//$(document).ready(function() {
	//});
	function onBtnCancel() {
		window.location.href = 'sso_index.php';
	}

	var enabReady = true;
	function onBtnSend() {
		var email = $('#email').val().replace(/[\s]+/g, '');
		if(!email.match(/^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]+$/)) {
			alert('E-mail格式不正確！\n');
			return;
		} else {
			if(enabReady) {
				enabReady = false; // 避免連續點擊
				$.ajax({
					url: 'ajax/reconfirm_email_ajax.php',
					cache: false,
					type: 'POST',
					dataType: 'json',
					data: {
						email: email
					},
					error: function(xhr) {
						alert('發生錯誤，請洽詢電算中心開發人員！');
						enabReady = true;
					},
					success: function(response) {
						enabReady = true;
						if(response['result']) {
							alert(response['msg']);
							window.location.replace('sso_index.php');
						} else {
							alert(response['msg']);
						}
					}
				});
			} else {
				alert('請勿連續點擊！');
			}
		}
	}
	//-->
</script>
</html>
