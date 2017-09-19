//
//  WTAdvertiseItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTAdvertiseItem.h"

@implementation WTAdvertiseItem

+ (instancetype)advertiseItem:(NSURL *)icon title:(NSString *)title content:(NSString *)content detailUrl:(NSURL *)detailUrl;
{
    WTAdvertiseItem *item = [WTAdvertiseItem new];
    
    item.icon = icon;
    item.title = title;
    item.content = content;
    item.detailUrl = detailUrl;
    
    return item;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"icon:%@,title:%@,content:%@,detailUrl:%@", self.icon, self.title, self.content, self.detailUrl];
}
@end
