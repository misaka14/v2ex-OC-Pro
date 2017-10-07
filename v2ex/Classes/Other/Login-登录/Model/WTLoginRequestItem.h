//
//  WTLoginRequestItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTLoginRequestItem : NSObject

@property (nonatomic, strong) NSString *once;               // once
@property (nonatomic, strong) NSString *usernameKey;        // username的key
@property (nonatomic, strong) NSString *passwordKey;        // password的key
@property (nonatomic, strong) NSString *verificationCodeKey;  /** 验证码key　*/
@property (nonatomic, strong) NSString *verificationCode;     /** 验证码实际的值　*/



/**
 *  快速创建的方法
 *
 */
+ (instancetype) loginRequestItemWithOnce:(NSString *)once usernameKey:(NSString *)usernameKey passwordKey:(NSString *)passwordKey verificationCodeKey:(NSString *)verificationCodeKey;

/**
 *  根据key和value拼接请求参数字典
 *
 *  @param usernameValue username的值
 *  @param passwordValue password的值
 *  @param verificationCodeValue 验证码的值
 *
 *  @return 请求参数的字典
 */
- (NSDictionary *)getLoginRequestParam:(NSString *)usernameValue passwordValue:(NSString *)passwordValue verificationCodeValue:(NSString *)verificationCodeValue;

@end
