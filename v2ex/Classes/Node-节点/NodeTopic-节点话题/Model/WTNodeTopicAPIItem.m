//
//  WTNodeTopicAPIItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNodeTopicAPIItem.h"
#import "MJExtension.h"
@implementation WTNodeTopicAPIItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"uid" : @"id"};
}

@end
