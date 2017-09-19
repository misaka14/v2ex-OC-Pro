//
//  MJExtensionConfig.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "WTUserItem.h"

@implementation MJExtensionConfig

+ (void)load
{
    [WTUserItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"uid" : @"id"};
    }];
}



@end
