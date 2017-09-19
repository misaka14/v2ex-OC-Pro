//
//  WTMyFollowingViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/9.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMyFollowingItem.h"

@interface WTMyFollowingViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<WTMyFollowingItem *> *myFollowingItems;

@property (nonatomic, assign, getter=isNextPage)BOOL nextPage;

@property (nonatomic, assign) NSUInteger page;

/**
 *  获取我的关注
 *
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getMyFollowingItemsWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
