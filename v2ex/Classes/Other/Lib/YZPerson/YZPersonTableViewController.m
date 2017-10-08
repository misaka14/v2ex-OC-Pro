//
//  YZPersonTableViewController.m
//  个人详情控制器
//
//  Created by yz on 15/8/13.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "YZPersonTableViewController.h"

#import "YZTableView.h"
#import "UIImage+Image.h"

#define YZHeadViewH 200

#define YZHeadViewMinH WTNavigationBarMaxY

#define YZTabBarH WTNavigationBarHeight

@interface YZPersonTableViewController ()


@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation YZPersonTableViewController


- (void)loadView
{
    YZTableView *tableView = [[YZTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    self.tableView = tableView;

    self.view = tableView;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    _lastOffsetY = -(YZHeadViewH + YZTabBarH);
    
    // 设置顶部额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(YZHeadViewH + YZTabBarH , 0, 0, 0);
    
    YZTableView *tableView = (YZTableView *)self.tableView;
    tableView.tabBar = _tabBar;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);

    //声明tableView的位置 添加下面代码
    if (@available(iOS 11.0, *))
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *headerView = [UIView new];
    headerView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    headerView.width = WTScreenWidth;
    headerView.height = 10;
    self.tableView.tableHeaderView = headerView;
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 获取偏移量差值
    CGFloat delta = offsetY - _lastOffsetY;
    
    CGFloat headH = YZHeadViewH - delta;
    
    if (headH < YZHeadViewMinH) {
        headH = YZHeadViewMinH;
    }
    
    _headHCons.constant = headH;
    
    // 计算透明度，刚好拖动200 - 64 136，透明度为1
    
    CGFloat alpha = delta / (YZHeadViewH - YZHeadViewMinH);
    
    // 获取透明颜色
    UIColor *alphaColor = [UIColor colorWithWhite:0 alpha:alpha];
    [_titleLabel setTextColor:alphaColor];
    
    // 设置导航条背景图片
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.y = 0;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString: WTAppLightColor alpha: alpha]] forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - Lazy Method
- (WTNoDataView *)noDataView
{
    if (_noDataView == nil)
    {
        WTNoDataView *noDataView = [WTNoDataView noDataView];
        noDataView.tipImageView.image = [UIImage imageNamed:@"no_topic"];
        noDataView.tipTitleLabel.text = @"还没有发表过话题";
        
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (WTRefreshView *)refreshView
{
    if (_refreshView == nil)
    {
        WTRefreshView *refreshView = [WTRefreshView refreshView];
        self.refreshView = refreshView;
    }
    return _refreshView;
}
@end
