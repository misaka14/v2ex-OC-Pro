//
//  PublishTopicViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTPublishTopicItem;
@interface WTPublishTopicViewModel : NSObject

+ (void)publishTopicWithPublishTopicItem:(WTPublishTopicItem *)item;
    
@end
