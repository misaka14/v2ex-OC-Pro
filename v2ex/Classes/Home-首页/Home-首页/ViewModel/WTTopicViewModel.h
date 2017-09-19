//
//  WTTopicViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTTopic.h"

/** 话题类型 */
typedef NS_ENUM(NSUInteger, WTTopicType) {
    WTTopicTypeNormal,
    WTTopicTypeHot
};


@interface WTTopicViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<WTTopic *>     *topics;

@property (nonatomic, assign) NSUInteger                    page;

@property (nonatomic, assign, getter=isNextPage)BOOL        nextPage;

/**
 *  根据url和话题type获取节点话题
 *
 *  @param url       url
 *  @param topicType 话题type
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getNodeTopicWithUrlStr:(NSString *)url topicType:(WTTopicType)topicType success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  根据url和话题type获取节点话题
 *
 *  @param url       url
 *  @param topicType 话题type
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getNodeTopicWithUrlStr:(NSString *)url topicType:(WTTopicType)topicType avartorURL:(NSURL *)avartorURL success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  是否是 `最近`节点
 *
 *  @param urlSuffix url后缀
 *
 *  @return YES 是 NO 否
 */
+ (BOOL)isNeedNextPage:(NSString *)urlSuffix;


@end
