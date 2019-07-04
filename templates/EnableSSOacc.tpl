{%*********************************************************
中正大學個人化校務系統單一入口 啟用帳號界面
  @ author:         johnny@ccu.edu.tw
  @ maintainer:     porihuang@ccu.edu.tw
  @ para:           $websit_name $webContent
  @ css:            index.css
  @ js:				none
**********************************************************%}

{%* HTML標頭區 *%}
{%include file='pub/head.tpl'%}
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
			<div id="inner_content">
				{%$webContent%}
			</div>
		</div>
		{%* HTML標尾區 *%}
		{%include file='pub/footer.tpl'%}
	</div>
</body>


<style>
#cwrap{
	width: 980px;
	margin: 0 auto;
}
#header{
	background-color: #d2e6f6;
}
#ccu_logo{
	height: 48px;
	padding: 0 0 0 15px;
	float: left;
}
#navi{
	height: 50xp;
}
#navi li{
	float: right;
	margin-bottom: -3px;
}
#container{
	text-align: center;
	background-color: #d2e6f6;
	padding: 40px 60px;
	font-size: 180%;
	font-weight: bold;
	line-height: 40px;
}
#content{
	position: relative;
	width: 860px;
}
#inner_content{
	margin: 0 auto;
	width: 650px;
	text-align: left;
}
</style>

</html>