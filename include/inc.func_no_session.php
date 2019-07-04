<?php
/**
 * HTTP_X_FORWARDED_FOR只有使用Transparent Proxy(#1)時,裡面才會有東西
 * 否則裡面的資料是空的,使用Anonymous(#2),High Anonymity Proxy(#3)也是空的
 *
 * #1 透明代理伺服器,Transparent Proxy(Hinet的Proxy是Transparent Proxy)
 * #2 匿名代理伺服器,Anonymous Proxy
 * #3 高隱匿代理伺服器,High Anonymity Proxy
 */
function getIP() {
	//取得使用者IP, 紅龍提供, http://www.jaceju.net/blog/archives/1913/
	foreach(array(	'HTTP_CLIENT_IP',
					'HTTP_X_FORWARDED_FOR',
					'HTTP_X_FORWARDED',
					'HTTP_X_CLUSTER_CLIENT_IP',
					'HTTP_FORWARDED_FOR',
					'HTTP_FORWARDED',
					'REMOTE_ADDR') as $key) {
        if(array_key_exists($key, $_SERVER)) {
            foreach(explode(',', $_SERVER[$key]) as $ip) {//有可能回傳多個ip
                $ip = trim($ip);
                if((bool) filter_var($ip,	FILTER_VALIDATE_IP,
											FILTER_FLAG_IPV4 |
											FILTER_FLAG_NO_PRIV_RANGE |
											FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
    }
    return null;
}

function prevent_xss($str) {
	return htmlspecialchars($str);
}

function prevent_SQLInjct($str) {
	//return addslashes($str);
	return mysql_real_escape_string($str);
}

function prvent_xss_sqli($str) {
	return $this->prevent_SQLInjct($this->prevent_xss($str));
}
?>
