//
//  PublishTopicViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTPublishTopicViewModel.h"
#import "WTPublishTopicItem.h"

#import "WTURLConst.h"
#import "NetworkTool.h"

#import "MJExtension.h"


@implementation WTPublishTopicViewModel

+ (void)publishTopicWithPublishTopicItem:(WTPublishTopicItem *)item
{
    NSString *urlString = @"https://www.v2ex.com/new/sandbox";
    
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(id data) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

@end
