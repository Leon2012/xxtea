//
//  xxtea.m
//  xxtea
//
//  Created by Leon Peng on 15-1-23.
//  Copyright (c) 2015年 Leon Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "xxtea-objc.h"

@interface xxtea : XCTestCase

@end

@implementation xxtea

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testEncrypt {
    NSString *data = @"hello world";
    NSString *key = @"123456";
    
    NSString *encrypt = xxtea_encrypt(data, key);
    NSLog(@"encrypt str %@", encrypt);
    
//    NSString *decrypt = xxtea_decrypt(encrypt, key);
//    NSLog(@"decrypt str %@", decrypt);
}

- (void)testDecrypt {
    NSString *data = @"l70OdU5DwDecwKiebQ87zrAhXFf2b9BT";
    NSString *key = @"123456";
    
    NSString *decrypt = xxtea_decrypt(data, key);
    NSLog(@"decrypt str %@", decrypt);
}


@end
