//
//  WTTopicCollectionViewModel.h
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WTTopicCollectionItem.h"

@interface WTTopicCollectionViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<WTTopicCollectionItem *> *topicCollectionItems;

@property (nonatomic, assign, getter=isNextPage)BOOL nextPage;

@property (nonatomic, assign) NSUInteger page;


/**
 *  获取话题收藏
 *
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getTopicCollectionItemsWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;
@end
