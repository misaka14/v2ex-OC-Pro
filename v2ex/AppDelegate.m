//
//  AppDelegate.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "AppDelegate.h"

#import "WTTabBarController.h"
#import "WTAccountViewModel.h"
#import "WTFPSLabel.h"
#import "WTTopWindow.h"


#import "WTAppDelegateTool.h"
#import "WTPublishTopicViewController.h"


static WTAppDelegateTool *_appDelegateTool;


@implementation AppDelegate

+ (void)load
{
    _appDelegateTool = [WTAppDelegateTool shareAppDelegateTool];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 0、初始化主题文件
    [self initTheme];
    
    // 0、自动登录
    [[WTAccountViewModel shareInstance] autoLogin];
    
    // 1、创建窗口
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    
    // 2、设置根控制器
    self.window.rootViewController = [WTTabBarController new];
    
    // 3、显示窗口
    [self.window makeKeyAndVisible];
    
    // 5、全局设置状态栏颜色
//    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    application.applicationIconBadgeNumber = 0;
    
    // 6、界面 FPS 代码
//#if DEBUG
//    WTFPSLabel *fpsLabel = [[WTFPSLabel alloc] initWithFrame: CGRectMake(15, WTScreenHeight - 80, 55, 50)];
//    [self.window addSubview: fpsLabel];
//#else
//    
//#endif

//    // 7、显示顶层window
//    [WTTopWindow showWithStatusBarClickBlock:^{
//        
//        [_appDelegateTool searchAllScrollViewsInView: application.keyWindow];
//    }];
    
    // 8、设置3DTouch 按钮
    if (iOS9Later)
    {
        [_appDelegateTool setup3DTouchItems: application];
    }
    
    // 9、初始化第三方SDK
    [_appDelegateTool initAppSDKWithDidFinishLaunchingWithOptions: launchOptions];
    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(dkNightVersionThemeChanging) name: DKNightVersionThemeChangingNotification object: nil];
    
    // 10、开启摇一摇的功能
    [application setApplicationSupportsShakeToEdit:YES];
    
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }
    return;
}

#pragma mark - 处理3DTouch点击事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    UITabBarController *rootVC = (UITabBarController *)application.keyWindow.rootViewController;
    NSString *type = shortcutItem.type;
    if ([type isEqualToString: @"publishTopicItem"])
    {
        WTLog(@"发表话题")
    }
    else if([type isEqualToString: @"hotTopicItem"])
    {
        rootVC.selectedIndex = 2;
    }
    else
    {
        WTLog(@"消息")
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    // iOS10
    [_appDelegateTool openURL: url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // iOS10以下
    [_appDelegateTool openURL: url];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler
{
    [_appDelegateTool didReceiveRemoteNotification: userInfo fetchCompletionHandler: completionHandler];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [_appDelegateTool didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

#pragma mark 初始化主题
- (void)initTheme
{
    // 0、主题文件
    [DKColorTable sharedColorTable].file = @"themes.txt";
}

@end
