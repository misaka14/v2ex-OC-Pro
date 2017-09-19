//
//  WTTopicDetailNew.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetail.h"

@implementation WTTopicDetail

- (NSString *)description
{
    return [NSString stringWithFormat: @"icon:%@, author:%@, createTime:%@, floor:%@", self.icon, self.author, self.createTime, self.floor];
}

@end
