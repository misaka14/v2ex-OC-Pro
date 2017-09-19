//
//  WTTabBarController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/30.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTabBarController.h"
#import "UIViewController+Extension.h"
#import "WTHomeViewController.h"
#import "WTNavigationController.h"
#import "WTHotTopicViewController.h"
#import "WTNodeViewController.h"
#import "WTMoreViewController.h"
#import "WTNodeViewController.h"
#import "WTMessageViewController.h"
#import "WTUserNotificationViewController.h"

@interface WTTabBarController () <UITabBarDelegate>

@end

@implementation WTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加所有的子控制器
    [self addChildViewControllers];
    
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);

    self.tabBar.dk_tintColorPicker =  DKColorPickerWithKey(UITabbarTintColor);
    
    self.tabBar.translucent = NO;
    
}

#pragma mark - 添加所有的子控制器
- (void)addChildViewControllers
{
    // 首页
    WTHomeViewController *homeVC = [WTHomeViewController new];
    [self addOneChildViewController: homeVC title: @"首页" imageName: @"Tabbar_Feed_Normal" selectedImageName: nil];
    
    // 节点
    WTNodeViewController *nodeVC = [[WTNodeViewController alloc] init];
    [self addOneChildViewController: nodeVC title: @"节点" imageName: @"Tabbar_Discover_Normal" selectedImageName: nil];
    
#if Test == 0
    // 消息
    WTMessageViewController *messageVC = [WTMessageViewController new];
    [self addOneChildViewController: messageVC title: @"消息" imageName: @"Tabbar_Messages_Normal" selectedImageName: nil];
#else
    
#endif
    WTHotTopicViewController *discoveryVC = [WTHotTopicViewController new];
    [self addOneChildViewController: discoveryVC title: @"最热" imageName: @"tabbar_hot_normal" selectedImageName: nil];
    
    
    // 通知
    WTUserNotificationViewController *notificationVC = [WTUserNotificationViewController new];
    notificationVC.view.backgroundColor = notificationVC.view.backgroundColor;
    [self addOneChildViewController: notificationVC title: @"通知" imageName: @"Tabbar_Notifications_Normal" selectedImageName: nil];
    
    
    // 更多
    WTMoreViewController *moreVC = [WTMoreViewController new];
    [self addOneChildViewController: moreVC title: @"更多" imageName: @"Tabbar_More_Normal" selectedImageName: nil];
    
    
}

#pragma mark - 添加单个子控制器
- (void)addOneChildViewController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
//    vc.edgesForExtendedLayout = UIRectEdgeNone;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed: imageName];
   // vc.tabBarItem.selectedImage = [UIImage imageNamed: selectedImageName];
    
    
    // 设置文字正常状态属性
//    NSDictionary *textAttrNormal = @{NSForegroundColorAttributeName : [UIColor colorWithHexString: WTNormalColor]};
//    [vc.tabBarItem setTitleTextAttributes: textAttrNormal forState: UIControlStateNormal];
    
    // 设置文字选中状态下属性
//    NSDictionary *textAttrSelected = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
//    [vc.tabBarItem setTitleTextAttributes: textAttrSelected forState: UIControlStateSelected];
    
    WTNavigationController *nav = [[WTNavigationController alloc] initWithRootViewController: vc];
    [self addChildViewController: nav];
}


@end
