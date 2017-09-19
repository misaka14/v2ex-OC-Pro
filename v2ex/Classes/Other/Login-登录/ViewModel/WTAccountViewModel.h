//
//  WTAccountViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/16.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTAccount.h"
#import "WTUserItem.h"
@class WTRegisterReqItem;
@interface WTAccountViewModel : NSObject

@property (nonatomic, strong) WTAccount *account;

@property (nonatomic, strong) WTUserItem *userItem;

/**
 *  单例
 *
 */
+ (instancetype)shareInstance;

/**
 *  自动登陆
 */
- (void)autoLogin;

/**
 *  是否登陆过
 *
 */
- (BOOL)isLogin;

/**
 *  是否登陆过
 *
 */
- (BOOL)isMasakaLogin;

/**
 *  退出登陆
 */
- (void)loginOut;

- (void)saveUsernameAndPassword;



/**
 *  登陆
 *
 *  @param username 用户名
 *  @param password 密码
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getOnceWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;


/**
 *  获取注册的请求参数
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getRegisterReqItemWithSuccess:(void (^)(WTRegisterReqItem *item))success failure:(void (^)(NSError *error))failure;
/**
 *  注册
 *
 *  @param item     注册请求参数
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)registerWithRegisterReqItem:(WTRegisterReqItem *)item success:(void (^)(BOOL isSuccess))success failure:(void(^)(NSError *error))failure;

/**
 *  签到
 */
- (void)pastWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;


/**
 登陆至misaka14

 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
- (void)loginToMisaka14WithUserItem:(WTUserItem *)userItem success:(void(^)(WTUserItem *loginUserItem))success failure:(void(^)(NSError *error))failure;


/**
 获取用户信息
 
 @param userId  WTUserItem
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)getUserInfoFromMisaka14WithUserItem:(WTUserItem *)userItem success:(void(^)(WTUserItem *userItem))success failure:(void(^)(NSError *error))failure;
@end
