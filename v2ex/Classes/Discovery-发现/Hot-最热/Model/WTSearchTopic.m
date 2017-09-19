//
//  WTSearchTopic.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTSearchTopic.h"
#import "MJExtension.h"

@implementation WTSearchTopic

- (NSString *)description
{
    return [NSString stringWithFormat: @"title:%@ detail:%@", self.title, self.detail];
}

- (void)setPagemap:(WTSearchTopicPagemap *)pagemap
{
    _pagemap = pagemap;
    
    if (pagemap.metatags.count > 0)
    {
        WTSearchTopicMetatags *metatags = pagemap.metatags.firstObject;
        
        self.detail = metatags.detail;
        
        self.published_time = metatags.published_time;
    }
    
}

- (void)setPublished_time:(NSString *)published_time
{
    _published_time = [[published_time stringByReplacingOccurrencesOfString: @"T" withString: @" "] stringByReplacingOccurrencesOfString: @"Z" withString: @" "];
}

@end

@implementation WTSearchTopicPagemap;

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"metatags" : NSStringFromClass([WTSearchTopicMetatags class])};
}

- (void)setMetatags:(NSMutableArray<WTSearchTopicMetatags *> *)metatags
{
    _metatags = metatags;
}

@end

@implementation WTSearchTopicMetatags

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"detail" : @"og:description", @"published_time": @"article:published_time", @"avatar": @"twitter:image"};
}

@end
