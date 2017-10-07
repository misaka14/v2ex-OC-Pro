//
//  WTContineRegisterReqItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/6.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTContinueRegisterReqItem.h"

@implementation WTContinueRegisterReqItem
/**
 快速初始化
 
 @param once once
 @param code code
 @return WTContinueRegisterReqItem
 */
- (instancetype)initWithOnce:(NSString *)once code:(NSString *)code
{
    WTContinueRegisterReqItem *item = [WTContinueRegisterReqItem new];
    item.once = once;
    item.code = code;
    return item;
}
@end
