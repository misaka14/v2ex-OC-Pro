//
//  WTNotificationViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/31.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNotificationItem.h"

@interface WTNotificationViewModel : NSObject
/** 通知数组 */
@property (nonatomic, strong) NSMutableArray<WTNotificationItem *> *notificationItems;
/** 是否有下一页 */
@property (nonatomic, assign, getter=isNextPage) BOOL nextPage;
/** 当前页数 */
@property (nonatomic, assign) NSUInteger page;

/**
 *  获取通知
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getUserNotificationsSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  根据NoticationItem删除通知
 *
 *  @param notificationItem notificationItem
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)deleteNotificationByNoticationItem:(WTNotificationItem *)notificationItem success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
