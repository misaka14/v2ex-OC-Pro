//
//  WTReplyViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/2.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTReplyItem.h"
@interface WTReplyViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<WTReplyItem *> *replyItems;

@property (nonatomic, assign, getter=isNextPage)BOOL nextPage;

@property (nonatomic, assign) NSUInteger page;

/**
 *  根据用户名获取某个的回复
 *
 *  @param username  用户名
 *  @param avatarURL 头像
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)getReplyItemsWithUsername:(NSString *)username avatarURL:(NSURL *)avatarURL success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
