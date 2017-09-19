//
//  WTTopWindow.m
//  监听状态栏区域的点击
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopWindow.h"

/***** WTTopViewController *****/
@interface WTTopViewController : UIViewController
@property (nonatomic, copy) void (^statusBarClickBlock)();
@end

@implementation WTTopViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.statusBarClickBlock) self.statusBarClickBlock();
//    !self.statusBarClickBlock ? : self.statusBarClickBlock();
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
/***** XMGTopViewController *****/

@implementation WTTopWindow

static WTTopWindow *window_;

+ (void)showWithStatusBarClickBlock:(void (^)())block
{
    if (window_) return;
    
    window_ = [[WTTopWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    // 先显示window
    window_.hidden = NO;
    
    // 设置根控制器
    WTTopViewController *topVc = [[WTTopViewController alloc] init];
    topVc.view.backgroundColor = [UIColor clearColor];
    topVc.view.frame = [UIApplication sharedApplication].statusBarFrame;
    topVc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topVc.statusBarClickBlock = block;
    window_.rootViewController = topVc;
}

/**
 *  当用户点击屏幕时，首先会调用这个方法，询问谁来处理这个点击事件
 *
 *  @return 如果返回nil，代表当前window不处理这个点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 如果触摸点的y值 > 20，当前window不处理
    if (point.y > 20) return nil;
    
    // 如果触摸点的y值 <= 20，按照默认做法处理
    return [super hitTest:point withEvent:event];
}

@end
