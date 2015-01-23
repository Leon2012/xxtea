//
//  xxtea-objc.m
//  xxtea
//
//  Created by Leon Peng on 15-1-23.
//  Copyright (c) 2015年 Leon Peng. All rights reserved.
//

#import "xxtea-objc.h"
#include "xxtea.h"
#import "GTMBase64.h"

static xxtea_long *xxtea_to_long_array(unsigned char *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, *result;
    
    n = len >> 2;
    n = (((len & 3) == 0) ? n : n + 1);
    if (include_length) {
        result = (xxtea_long *)malloc((n + 1) << 2);
        result[n] = len;
        *ret_len = n + 1;
    } else {
        result = (xxtea_long *)malloc(n << 2);
        *ret_len = n;
    }
    memset(result, 0, n << 2);
    for (i = 0; i < len; i++) {
        result[i >> 2] |= (xxtea_long)data[i] << ((i & 3) << 3);
    }
    
    return result;
}

static unsigned char *xxtea_to_byte_array(xxtea_long *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, m;
    unsigned char *result;
    
    n = len << 2;
    if (include_length) {
        m = data[len - 1];
        if ((m < n - 7) || (m > n - 4)) return NULL;
        n = m;
    }
    result = (unsigned char *)malloc(n + 1);
    for (i = 0; i < n; i++) {
        result[i] = (unsigned char)((data[i >> 2] >> ((i & 3) << 3)) & 0xff);
    }
    result[n] = '\0';
    *ret_len = n;
    
    return result;
}

static unsigned char *php_xxtea_encrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    unsigned char *result;
    xxtea_long *v, *k, v_len, k_len;
    
    v = xxtea_to_long_array(data, len, 1, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_encrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 0, ret_len);
    free(v);
    free(k);
    
    return result;
}

static unsigned char *php_xxtea_decrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    unsigned char *result;
    xxtea_long *v, *k, v_len, k_len;
    
    v = xxtea_to_long_array(data, len, 0, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_decrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 1, ret_len);
    free(v);
    free(k);
    
    return result;
}

static unsigned char *fix_key_length(unsigned char *key, xxtea_long key_len){
    unsigned char *tmp = (unsigned char *)malloc(16);
    
    memcpy(tmp, key, key_len);
    memset(tmp + key_len, '\0', 16 - key_len);
    
    return tmp;
}


NSString* xxtea_encrypt(NSString *data, NSString *key) {
    if (data == nil || key == nil) {
        return nil;
    }
    
    if (data.length == 0 || key.length == 0) {
        return nil;
    }
    
    unsigned char *result;
    unsigned char *c_key = (unsigned char*)[key UTF8String];
    unsigned char *c_data = (unsigned char*)[data UTF8String];
    
    xxtea_long key_len = (xxtea_long)strlen(c_key);
    xxtea_long data_len = (xxtea_long)strlen(c_data);
    xxtea_long ret_length;
    
    NSLog(@"key len : %d", key_len);
    
    if (key_len < 16) {
        unsigned char *key2 = fix_key_length(c_key, key_len);
        result = php_xxtea_encrypt(c_data, data_len, key2, &ret_length);
        printf("%s\n", result);
        NSString *str = [GTMBase64 stringByEncodingBytes:result length:ret_length];
        free(key2);
        return str;
    }else{
        result = php_xxtea_encrypt(c_data, data_len, c_key, &ret_length);
        NSString *str = [GTMBase64 stringByEncodingBytes:result length:ret_length];
        return str;
    }
}


NSString* xxtea_decrypt(NSString *data, NSString *key) {
    if (data == nil || key == nil) {
        return nil;
    }
    
    if (data.length == 0 || key.length == 0) {
        return nil;
    }
    
    unsigned char *result;
    unsigned char *c_key = (unsigned char*)[key UTF8String];
    
    NSData *base64_data = [GTMBase64 decodeString:data];
    unsigned char *c_data = (unsigned char*)[base64_data bytes];
    
    xxtea_long key_len = (xxtea_long)strlen(c_key);;
    xxtea_long data_len = (xxtea_long)strlen(c_data);
    xxtea_long ret_length;
    
    NSLog(@"key len : %d", key_len);
    
    if (key_len < 16) {
        unsigned char *key2 = fix_key_length(c_key, key_len);
        result = php_xxtea_decrypt(c_data, data_len, key2, &ret_length);
        NSString *str = [[NSString alloc] initWithCString:result encoding:NSUTF8StringEncoding];
        free(key2);
        return str;
    }else{
        result = php_xxtea_decrypt(c_data, data_len, c_key, &ret_length);
        NSString *str = [[NSString alloc] initWithCString:result encoding:NSUTF8StringEncoding];
        return str;
    }
}


