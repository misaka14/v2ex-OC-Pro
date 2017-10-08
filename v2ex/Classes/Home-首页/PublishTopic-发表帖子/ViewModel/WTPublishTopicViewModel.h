//
//  PublishTopicViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTNodeItem;
@interface WTPublishTopicViewModel : NSObject


/**
 发表帖子

 @param nodeItem 要发表的节点
 @param title 标题
 @param content 正文
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)publishTopicWithNodeItem:(WTNodeItem *)nodeItem title:(NSString *)title content:(NSString *)content success:(void(^)(NSString *topicDetailUrl))success failure:(void(^)(NSError *error))failure;
    
@end
