//
//  WTRegisterReqItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/22.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTRegisterReqItem.h"
#import "NSString+Regex.h"
@implementation WTRegisterReqItem

- (void)setVerificationCode:(NSString *)verificationCode
{
    _verificationCode = verificationCode;
    
    if ([verificationCode containsString: @"once="])
    {
        self.onceValue = [NSString subStringFromIndexWithStr: @"once=" string: verificationCode];
    }
}

- (NSString *)onceKey
{
    return @"once";
}

- (NSString *)phone_numberKey
{
    return @"phone_number";
}
- (NSString *)calling_codeKey
{
    return @"calling_code";
}
- (NSString *)calling_codeValue
{
    return @"86_CN";
}

@end

