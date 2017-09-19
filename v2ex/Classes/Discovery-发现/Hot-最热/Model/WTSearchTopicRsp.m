//
//  WTSearchTopicRsp.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTSearchTopicRsp.h"

#import "MJExtension.h"

@implementation WTSearchTopicRsp

- (NSString *)description
{
    return [NSString stringWithFormat: @"items:%@", self.items];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"items" : NSStringFromClass([WTSearchTopic class])};
}
@end
