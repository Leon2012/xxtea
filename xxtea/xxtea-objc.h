//
//  xxtea-objc.h
//  xxtea
//
//  Created by Leon Peng on 15-1-23.
//  Copyright (c) 2015年 Leon Peng. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString* xxtea_encrypt(NSString *data, NSString *key);
NSString* xxtea_decrypt(NSString *data, NSString *key);
