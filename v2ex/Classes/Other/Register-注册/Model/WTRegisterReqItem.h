//
//  WTRegisterReqItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/22.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRegisterReqItem : NSObject
/** 用户名key　*/
@property (nonatomic, strong) NSString *usernameKey;
/** 密码key　*/
@property (nonatomic, strong) NSString *passwordKey;
/** 邮箱key　*/
@property (nonatomic, strong) NSString *emailKey;
/** 验证码key　*/
@property (nonatomic, strong) NSString *verificationCodeKey;
/** 验证码实际的值　*/
@property (nonatomic, strong) NSString *verificationCode;

/** 验证码Value　*/
@property (nonatomic, strong) NSString *verificationCodeValue;
/** 用户名的Value　*/
@property (nonatomic, strong) NSString *usernameValue;
/** 密码的Value　*/
@property (nonatomic, strong) NSString *passwordValue;
/** 邮箱的Value　*/
@property (nonatomic, strong) NSString *emailValue;

/** once的Key　*/
@property (nonatomic ,strong) NSString *onceKey;
/** once的Value　*/
@property (nonatomic, strong) NSString *onceValue;


/** 手机号的key */
@property (nonatomic, strong) NSString *phone_numberKey;
/** 手机号的Value */
@property (nonatomic, strong) NSString *phone_numberValue;
/** +86 */
@property (nonatomic, strong) NSString *calling_codeKey;
@property (nonatomic, strong) NSString *calling_codeValue;

@end

