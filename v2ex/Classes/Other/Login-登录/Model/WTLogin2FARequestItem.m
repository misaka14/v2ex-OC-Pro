//
//  WTLogin2FARequestItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/12.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTLogin2FARequestItem.h"

@implementation WTLogin2FARequestItem
/**
 Init
 */
- (instancetype)initWithOnce:(NSString *)once usernameOrEmail:(NSString *)usernameOrEmail password:(NSString *)password
{
    WTLogin2FARequestItem *item = [WTLogin2FARequestItem new];
    item.once = once;
    item.usernameOrEmail = usernameOrEmail;
    item.password = password;
    return item;
}
@end
