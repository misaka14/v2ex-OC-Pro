//
//  v2exTests.m
//  v2exTests
//
//  Created by gengjie on 2016/10/19.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTAccountViewModel.h"
#import "WTUserItem.h"

@interface v2exTests : XCTestCase
@property (nonatomic,strong) WTAccountViewModel *accountVM;
@end

@implementation v2exTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.accountVM = [WTAccountViewModel new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLogin
{
    WTUserItem *userItem = [WTUserItem new];
    userItem.username = @"username";
    userItem.avatarUrl = @"http://www.baidu.com";
    [self.accountVM loginToMisaka14WithUserItem: userItem success:^(WTUserItem *loginUserItem) {
        
        NSLog(@"loginUserItem:%@", loginUserItem);
        
    } failure:^(NSError *error){
        NSLog(@"error:%@", error);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
