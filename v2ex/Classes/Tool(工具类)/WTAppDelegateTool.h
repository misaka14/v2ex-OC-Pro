//
//  WTAppDelegateTool.h
//  v2ex
//
//  Created by gengjie on 16/9/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTAppDelegateTool : NSObject

+ (instancetype)shareAppDelegateTool;

/**
 初始化第三方SDK
 */
- (void)initAppSDKWithDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


/**
 初始化融云
 */
- (void)initRCIM;

/**
 注册deviceToken

 @param deviceToken deviceToken
 */
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;


/**
 接收远程通知

 @param userInfo          userInfo
 @param completionHandler completionHandler
 */
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 openURL
 
 @param url url
 */
- (void)openURL:(NSURL *)url;

/**
 设置3D Touch按钮

 @param application application
 */
- (void)setup3DTouchItems:(UIApplication *)application;

/**
 *  查找出view里面的所有scrollView
 */
- (void)searchAllScrollViewsInView:(UIView *)view;


/**
 获取当前显示的控制器

 */
- (UIViewController *)currentViewController;


/**
 获取当前显示的导航控制器

 */
- (UINavigationController *)currentNavigationController;

@end
