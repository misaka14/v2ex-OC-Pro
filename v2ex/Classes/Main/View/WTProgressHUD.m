//
//  WTProgressHUD.m
//  v2ex
//
//  Created by gengjie on 2016/10/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTProgressHUD.h"
#import "UIViewController+Extension.h"
@implementation WTProgressHUD

static WTProgressHUD *_progressHUD;

static UIView *_view;

+ (instancetype)shareProgressHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _progressHUD = [WTProgressHUD progressHUDWithStyle: JGProgressHUDStyleDark];
        _view = [UIViewController topVC].view;
    });
    return _progressHUD;
}

- (void)errorWithMessage:(NSString *)message
{
    _progressHUD.textLabel.text = message;
    _progressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    [_progressHUD showInView: _view];
    [_progressHUD dismissAfterDelay: 2.0];
}

- (void)successWithMessage:(NSString *)message
{
    _progressHUD.textLabel.text = message;
    _progressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    [_progressHUD showInView: _view];
    [_progressHUD dismissAfterDelay: 2.0];
}

- (void)progress
{
    _progressHUD.textLabel.text = @"正在加载中";
    _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
    [_progressHUD showInView: _view];
}

- (void)hide
{
    [_progressHUD dismiss];
}
@end

