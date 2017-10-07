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
@class WTRegisterReqItem, WTLoginRequestItem, WTContinueRegisterReqItem;
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
 *  登录
 *
 *  @param loginRequestItem 请求参数key和value
 *  @param username         username的值
 *  @param password         password的值
 *  @param verificationCodeValue 验证码值
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)loginWithLoginRequestItem:(WTLoginRequestItem *)loginRequestItem username:(NSString *)username password:(NSString *)password verificationCodeValue:(NSString *)verificationCodeValue success:(void (^)())success failure:(void (^)(NSError *error))failure;


/**
 获取登陆请求参数（验证码、用户名、密码、once）
 
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
- (void)getLoginReqItemWithSuccess:(void(^)(WTLoginRequestItem *loginRequestItem))success failure:(void(^)(NSError *error))failure;

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
- (void)registerWithRegisterReqItem:(WTRegisterReqItem *)item success:(void (^)(NSString *once))success failure:(void(^)(NSError *error))failure;


/**
 继续注册
 
 @param continueRegisterReqItem 请求参数
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)continueRegisterWithContinueRegisterReqItem:(WTContinueRegisterReqItem *)continueRegisterReqItem success:(void (^)())success failure:(void(^)(NSError *error))failure;

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

