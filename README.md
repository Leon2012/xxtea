# xxtea for PHP&IOS
---

1，PHP安装pecl-xxtea扩展(https://github.com/liut/pecl-xxtea)


2，PHP加密代码

 	<?php
 	//加密
  	$data = array('a' => 1, 'b' => 2, 'c' => 3);
  	$json = json_encode($data);
  	$key = "123456";

  	$encrypt_data = xxtea_encrypt($json, $key);
  	echo base64_encode($encrypt_data);  //l70OdU5DwDecwKiebQ87zrAhXFf2b9BT
	
	

3，Objectie-c解密代码

	- (void)testDecrypt {
    	NSString *data = @"l70OdU5DwDecwKiebQ87zrAhXFf2b9BT";
    	NSString *key = @"123456";
    
    	NSString *decrypt = xxtea_decrypt(data, key);
    	NSLog(@"decrypt str %@", decrypt); //{"a":1,"b":2,"c":3}
	}
	


