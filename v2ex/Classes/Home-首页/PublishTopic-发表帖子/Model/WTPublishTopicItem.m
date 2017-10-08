//
//  WTPublishTopic.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTPublishTopicItem.h"

@implementation WTPublishTopicItem
- (instancetype)initWithContent:(NSString *)content once:(NSString *)once title:(NSString *)title
{
    WTPublishTopicItem *item = [WTPublishTopicItem new];
    item.content = content;
    item.once = once;
    item.title = title;
    item.syntax = @"1";
    return item;
}
@end
