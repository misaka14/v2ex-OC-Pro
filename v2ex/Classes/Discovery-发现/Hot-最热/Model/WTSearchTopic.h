//
//  WTSearchTopic.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTSearchTopicPagemap;
@interface WTSearchTopic : NSObject

@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) NSString *published_time;

@property (nonatomic, strong) WTSearchTopicPagemap *pagemap;

@end

@class WTSearchTopicMetatags;
@interface WTSearchTopicPagemap : NSObject

@property (nonatomic, strong) NSMutableArray<WTSearchTopicMetatags *> *metatags;

@end

@interface WTSearchTopicMetatags : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) NSString *published_time;

@end
