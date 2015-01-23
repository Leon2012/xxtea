# xxtea for IOS&MAC
---

1，PHP安装pecl-xxtea扩展(https://github.com/liut/pecl-xxtea)

  <?php
  $data = array('a' => 1, 'b' => 2, 'c' => 3);
  $json = json_encode($data);
  $key = "123456";

  $encrypt_data = xxtea_encrypt($json, $key);
  echo $encrypt_data."<br />";
  echo base64_encode($encrypt_data)."<br />";

  $json = xxtea_decrypt($encrypt_data, $key);
  print_r(json_decode($json, true));



