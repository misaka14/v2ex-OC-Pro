//
//  WTBaseSlidingViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/28.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTBaseSlidingViewController.h"


@interface WTBaseSlidingViewController () <UITableViewDelegate>
/** 记录scrollView的contentOff的Y值 */
@property (nonatomic, assign) CGFloat endY;
@end

@implementation WTBaseSlidingViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        [UIView animateWithDuration: 0.1 animations:^{
            
            
            self.endY += (-scrollView.contentOffset.y) * 0.3;
            self.footerContentView.y = self.headerViewH + self.endY;
            
        }];
        
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration: 0.3 animations:^{
        
        self.footerContentView.y = self.headerViewH;
        self.endY = 0;
    }];
}

- (void)setShowTabBarFlag:(BOOL)showTabBarFlag
{
    if (showTabBarFlag)
    {
        self.footerContentView.frame = CGRectMake(0, self.headerViewH, WTScreenWidth, WTScreenHeight - self.headerViewH);
    }
    else
    {
        self.footerContentView.frame = CGRectMake(0, self.headerViewH, WTScreenWidth, WTScreenHeight);
    }
}

#pragma mark -
- (UIView *)headerContentView
{
    if (_headerContentView == nil) {
        UIView *headerContentView = [UIView new];
        headerContentView.frame = CGRectMake(0, 0, WTScreenWidth, WTScreenHeight - WTTabBarHeight);
        [self.view addSubview: headerContentView];
        self.headerContentView = headerContentView;
        
        headerContentView.backgroundColor = [UIColor colorWithHexString: WTAppLightColor];
        _headerContentView = headerContentView;
    }
    return _headerContentView;
}

- (UIView *)footerContentView
{
    if (_footerContentView == nil)
    {
        // 2、footerView
        UIView *footerContentView = [UIView new];
        [self headerContentView];
        footerContentView.layer.cornerRadius = 5;
        footerContentView.layer.masksToBounds = YES;
        footerContentView.frame = CGRectMake(0, self.headerViewH, WTScreenWidth, WTScreenHeight - self.headerViewH);
        [self.view addSubview: footerContentView];
        _footerContentView = footerContentView;
        
    }
    return _footerContentView;
}
@end
