//
//  WTProgressHUD.m
//  v2ex
//
//  Created by gengjie on 2016/10/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTProgressHUD.h"

@implementation WTProgressHUD

static WTProgressHUD *_progressHUD;

static UIView *_view;

+ (instancetype)shareProgressHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _progressHUD = [WTProgressHUD progressHUDWithStyle: JGProgressHUDStyleDark];
        _view = [_progressHUD currentVC: [UIApplication sharedApplication].keyWindow.rootViewController].view;
    });
    return _progressHUD;
}

- (void)errorWithMessage:(NSString *)message
{
    _progressHUD.textLabel.text = message;
    _progressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init]; //JGProgressHUDSuccessIndicatorView is also available
    [_progressHUD showInView: _view];
    [_progressHUD dismissAfterDelay: 2.0];
}

- (UIViewController *)currentVC:(UIViewController *)vc
{
    if ([vc isKindOfClass: [UITabBarController class]])
    {
        UITabBarController *tabBarVC = (UITabBarController *)vc;
        return [self currentVC: tabBarVC.selectedViewController];
    }
    else if([vc isKindOfClass: [UINavigationController class]])
    {
        UINavigationController *navVC = (UINavigationController *)vc;
        return [self currentVC: [navVC topViewController]];
    }
    else if(vc.presentedViewController)
    {
        UIViewController *presentVC = vc;
        return [self currentVC: presentVC];
    }
    return vc;
    
}
@end
