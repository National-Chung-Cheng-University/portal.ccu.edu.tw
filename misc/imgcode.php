<?php

//隨機生成4位驗證碼
function l_authnum_gen() {
	list($usec, $sec) = explode(' ', microtime());
	mt_srand((float)$sec + ((float)$usec * 100000));
	$number = '';
	$number_len = 4;
	//$stuff = '23456789abcdefghijkmnpqrstuvwxyz';
	$stuff = '1234567890';
	$stuff_len = strlen($stuff) - 1;
	for ($i = 0; $i < $number_len; $i++) 
		$number .= substr($stuff, mt_rand(0, $stuff_len), 1);
	return $number;
}

// 存入 session
if(!isset($_SESSION)) {
	session_name('ccuSSO');
	session_start();
}

//取得亂數
$_SESSION['imgcode'] = l_authnum_gen();
$number = $_SESSION['imgcode'];

header('Content-type:image/png');
header('Content-Disposition:filename=image_code.png');

// 圖片的寬度與高度
$imageWidth = 60;
$imageHeight = 25;
// 建立圖片物件
$im = @imagecreatetruecolor($imageWidth, $imageHeight) or die('無法建立圖片！');

//主要色彩設定
// 圖片底色
$bgColor = imagecolorallocate($im, 168, 212, 227);
// 文字顏色
$Color = imagecolorallocate($im, 215, 0, 0);
// 干擾線條顏色
$gray1 = imagecolorallocate($im, 112, 84, 247);
// 干擾像素顏色
$gray2 = imagecolorallocate($im, 200, 200, 200);

//設定圖片底色
imagefill($im, 0, 0, $bgColor);

//底色干擾線條
for($i=0; $i<10; $i++) {
   imageline($im, rand(0, $imageWidth), rand(0, $imageHeight), rand($imageHeight, $imageWidth), rand(0, $imageHeight), $gray1);
}

//利用true type字型來產生圖片
imagettftext($im, 16, 4, 4, 20, $Color,"fonts/arial.ttf",$number);
/*
imagettftext (int im, int size, int angle,int x, int y, int col,string fontfile, string text)
im 圖片物件
size 文字大小
angle 0度將會由左到右讀取文字，而更高的值表示逆時鐘旋轉
x y 文字起始座標
col 顏色物件
fontfile 字形路徑，為主機實體目錄的絕對路徑，可自行設定想要的字型
text 寫入的文字字串
*/

// 干擾像素
for($i=0; $i<30; $i++) {
   imagesetpixel($im, rand()%$imageWidth , rand()%$imageHeight , $gray2);
}

imagepng($im);
imagedestroy($im);

?>