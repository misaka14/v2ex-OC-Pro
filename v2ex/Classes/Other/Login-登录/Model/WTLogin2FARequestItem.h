//
//  WTLogin2FARequestItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/12.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTLogin2FARequestItem : NSObject

@property (nonatomic, strong) NSString *once;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *usernameOrEmail;

@property (nonatomic, strong) NSString *password;


/**
 Init
 */
- (instancetype)initWithOnce:(NSString *)once usernameOrEmail:(NSString *)usernameOrEmail password:(NSString *)password;

@end
