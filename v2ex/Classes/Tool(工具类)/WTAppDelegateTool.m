//
//  WTAppDelegateTool.m
//  v2ex
//
//  Created by gengjie on 16/9/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTAppDelegateTool.h"
//#import <RongIMKit/RongIMKit.h>
#import "UMMobClick/MobClick.h"


#import "WTAccountViewModel.h"
#import "WTFPSLabel.h"
#import "WTTopWindow.h"
#import "WTShareSDKTool.h"
#import <Bugly/Bugly.h>
#import "IQKeyboardManager.h"
#import "WTTopicDetailViewController.h"
//#import "JPUSHService.h"
//#import "WTConversationViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface WTAppDelegateTool()/*<JPUSHRegisterDelegate, RCIMUserInfoDataSource>*/

@end

static WTAppDelegateTool *_appDelegateTool;

@implementation WTAppDelegateTool

#pragma mark - 单例
+ (instancetype)shareAppDelegateTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appDelegateTool = [WTAppDelegateTool new];
    });
    return _appDelegateTool;
}

#pragma mark - Public Method
#pragma mark 初始化第三方SDK
- (void)initAppSDKWithDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 1、键盘呼出隐藏
//    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    // 2、分享SDK
    [WTShareSDKTool initShareSDK];
    

    
    // 10.打印字体
    //    NSArray *familyNames = [UIFont familyNames];
    //    for( NSString *familyName in familyNames )
    //    {
    //        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    //        for( NSString *fontName in fontNames )
    //        {
    //            printf( "\tFont: %s \n", [fontName UTF8String] );
    //        }
    //    }
    
    
    // 3、初始化融云
    //[self initRCIM];
    
    // 4、腾讯Buglye
    [Bugly startWithAppId:@"f20a87e6ba"];
    
    
    
//#if Test == 0
//    // 5、初始化极光推送
//    [self initJPushWithDidFinishLaunchingWithOptions: launchOptions];
//    
//    // 6、初始化高德地图
//    [AMapServices sharedServices].apiKey = @"837660a1b113cc1edc65353e38414c2b";
//#else
//    
//#endif
    
    // 7、初始化友盟
    [self initMobClick];

    
    
}

#pragma mark 设置3D Touch按钮
- (void)setup3DTouchItems:(UIApplication *)application
{
    UIApplicationShortcutItem *publishTopicItem = [[UIApplicationShortcutItem alloc] initWithType: @"publishTopicItem" localizedTitle: @"发表话题" localizedSubtitle: @"" icon: [UIApplicationShortcutIcon iconWithTemplateImageName: @"3dTouch_Icon_Add"] userInfo: nil];
    UIApplicationShortcutItem *hotTopicItem = [[UIApplicationShortcutItem alloc] initWithType: @"hotTopicItem" localizedTitle: @"热门话题" localizedSubtitle: @"" icon: [UIApplicationShortcutIcon iconWithTemplateImageName: @"3dTouch_Icon_Hot"] userInfo: nil];
//    UIApplicationShortcutItem *notificationItem = [[UIApplicationShortcutItem alloc] initWithType: @"notificationItem" localizedTitle: @"消息" localizedSubtitle: @"" icon: [UIApplicationShortcutIcon iconWithTemplateImageName: @"3dTouch_Icon_Notification"] userInfo: nil];
    application.shortcutItems = @[hotTopicItem, publishTopicItem];
}

/**
 *  查找出view里面的所有scrollView
 */
- (void)searchAllScrollViewsInView:(UIView *)view
{
    // 如果不在keyWindow范围内（不跟window重叠），直接返回
    if (![view wt_intersectWithView:nil]) return;
    
    // 遍历所有的子控件
    for (UIView *subview in view.subviews) {
        [self searchAllScrollViewsInView:subview];
    }
    
    // 如果不是scrollView，直接返回
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    // 滚动scrollView
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offset = scrollView.contentOffset;
    offset.y = - scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
    
}


#pragma mark 初始化融云
- (void)initRCIM
{
//    NSString *token = [WTAccountViewModel shareInstance].userItem.rongToken;
//    
//    [[RCIM sharedRCIM] initWithAppKey: @"ik1qhw0911lep"];
//    
//    [[RCIM sharedRCIM] setUserInfoDataSource: self];
//    
//    [[RCIM sharedRCIM] connectWithToken: token success:^(NSString *userId) {
//        WTLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        WTLog(@"登陆的错误码为:%ld", status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        WTLog(@"token错误");
//    }];
}

#pragma mark - 初始化友盟统计
- (void)initMobClick
{
    UMConfigInstance.appKey = @"56e97541e0f55a8b7900237a";
#if Test == 0
    UMConfigInstance.channelId = @"Test";
    UMConfigInstance.ePolicy = REALTIME;
#else
    UMConfigInstance.channelId = @"App Store";
#endif
    
    [MobClick startWithConfigure: UMConfigInstance];
}

#pragma mark - 注册DeviceToken
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    WTLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken])
//    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark - iOS10以下系统接收通知
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    [JPUSHService handleRemoteNotification:userInfo];
    WTLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo])
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)initJPushWithDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//#endif
//    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
//    
//    //如不需要使用IDFA，advertisingIdentifier 可为nil
//    [JPUSHService setupWithOption: launchOptions appKey: @"ee0077cf29d6b3aa6f40f280"
//                          channel: nil
//                 apsForProduction: NO
//            advertisingIdentifier: nil];
}

#pragma mark - OpenURL
- (void)openURL:(NSURL *)url
{
    NSString *prefix = @"v2exclient://skip=";
    NSString *urlStr = [url absoluteString];
    
    // 跳转的URL
    if ([urlStr rangeOfString: prefix].location != NSNotFound)
    {
        
        NSString *skip = [urlStr substringFromIndex: prefix.length];
        
        // 跳转至话题详情
        if ([skip containsString: @"topicDetail"])
        {
            NSString *topicDetailPrefix = @"v2exclient://skip=topicDetail?urlString=";
            WTLog(@"topicDetail");
            NSString *topicDetailUrl = [[url absoluteString] substringFromIndex: topicDetailPrefix.length];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WTTopicDetailViewController *topicDetailVC = [WTTopicDetailViewController topicDetailViewController];
                topicDetailVC.topicDetailUrl = topicDetailUrl;
                [[self currentNavigationController] pushViewController:topicDetailVC animated: YES];
//            });
            
        }
    }
}

#pragma mark - 获取当前显示的控制器
- (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    
    UIViewController *currentVC = [self getCurrentVC: keyWindow.rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVC:(UIViewController *)vc
{
    if ([vc isKindOfClass: [UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController *)vc;
        UIViewController *selectVC = tabVC.selectedViewController;
        return [self getCurrentVC: selectVC];
    }
    else if([vc isKindOfClass: [UINavigationController class]])
    {
        UINavigationController *navVC = (UINavigationController *)vc;
        UIViewController *topVC = navVC.topViewController;
        return [self getCurrentVC: topVC];
    }
    else if(vc.presentedViewController)
    {
        UIViewController *presentedVC = vc.presentedViewController;
        return [self getCurrentVC: presentedVC];
    }
    
    return vc;
}

/**
 获取当前显示的导航控制器
 
 */
- (UINavigationController *)currentNavigationController;
{
    return [self currentViewController].navigationController;
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
//    {
//        [JPUSHService handleRemoteNotification:userInfo];
//        WTLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//    }
//    else
//    {
//        // 判断为本地通知
//        WTLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
//
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
//    {
//        [JPUSHService handleRemoteNotification:userInfo];
//        WTLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//    }
//    else
//    {
//        // 判断为本地通知
//        WTLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//    }
//    
//    completionHandler();  // 系统要求执行这个方法
//}
//
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion
//{
//    WTUserItem *userItem = [WTUserItem new];
//    userItem.uid = [userId integerValue];
//    [WTAccountViewModel getUserInfoFromMisaka14WithUserItem: userItem success:^(WTUserItem *userItem) {
//        
//        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId: [NSString stringWithFormat: @"%zd", userItem.uid] name: userItem.username portrait: userItem.avatarUrl];
//        
//        completion(userInfo);
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



@end
