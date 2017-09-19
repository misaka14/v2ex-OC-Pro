//
//  WTPersonTableViewController.m
//  个人详情控制器
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTPersonTableViewController.h"

#import "WTTableView.h"
#import "UIImage+Image.h"



@interface WTPersonTableViewController ()


@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation WTPersonTableViewController


- (void)loadView
{
    WTTableView *tableView = [[WTTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    self.tableView = tableView;

    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastOffsetY = -(WTHeadViewH + WTTabBarH);
    
    // 设置顶部额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(WTHeadViewH + WTTabBarH , 0, WTToolBarHeight, 0);
    
    WTTableView *tableView = (WTTableView *)self.tableView;
    tableView.tabBar = _tabBar;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 获取偏移量差值
    CGFloat delta = offsetY - _lastOffsetY;
    
    CGFloat headH = WTHeadViewH - delta;
    
    if (headH < WTHeadViewMinH) {
        headH = WTHeadViewMinH;
    }
    
    _headHCons.constant = headH;
    
    // 计算透明度，刚好拖动200 - 64 136，透明度为1
    
    CGFloat alpha = delta / (WTHeadViewH - WTHeadViewMinH);
    
    // 获取透明颜色
    //UIColor *alphaColor = [UIColor colorWithWhite: 1 alpha: alpha];
    //[self.titleLabel setTextColor: [UIColor blackColor]];
    
    // 设置导航条背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:  [UIColor colorWithWhite: 1 alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.
}
@end
