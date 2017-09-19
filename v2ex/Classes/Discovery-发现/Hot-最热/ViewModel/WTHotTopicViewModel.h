//
//  WTHotTopicViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSearchTopicReq.h"
#import "WTSearchTopic.h"

@interface WTHotTopicViewModel : NSObject


/**
 搜索帖子

 @param searchTopicReq 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)searchTopicWithSearchTopicReq:(WTSearchTopicReq *)searchTopicReq success:(void(^)(NSMutableArray<WTSearchTopic *> *searchTopics))success failure:(void(^)(NSError *error))failure;

@end
