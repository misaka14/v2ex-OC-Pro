//
//  WTLoginRequestItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTLoginRequestItem.h"

@implementation WTLoginRequestItem
/**
 *  快速创建的方法
 *
 */
+ (instancetype) loginRequestItemWithOnce:(NSString *)once usernameKey:(NSString *)usernameKey passwordKey:(NSString *)passwordKey
{
    WTLoginRequestItem *item = [WTLoginRequestItem new];
    
    item.once = once;
    item.usernameKey = usernameKey;
    item.passwordKey = passwordKey;
    
    return item;
}

/**
 *  根据key和value拼接请求参数字典
 *
 *  @param usernameValue username的值
 *  @param passwordValue password的值
 *
 *  @return 请求参数的字典
 */
- (NSDictionary *) getLoginRequestParam:(NSString *)usernameValue passwordValue:(NSString *)passwordValue
{
    NSDictionary *param = @{
                            self.usernameKey : usernameValue,
                            self.passwordKey : passwordValue,
                            @"once"          : self.once,
                            @"next"          : @"/"
                            };
    return param;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"once:%@, usernameKey:%@, passwordKey:%@", self.once, self.usernameKey, self.passwordKey];
}
@end
