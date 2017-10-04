//
//  WTMyFollowingViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/9.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  我的关注 

#import "WTMyFollowingViewController.h"
#import "WTTopicDetailViewController.h"
#import "UIViewController+Extension.h"
#import "WTLoginViewController.h"

#import "WTMyFollowingCell.h"
#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"

#import "WTAccountViewModel.h"
#import "WTMyFollowingViewModel.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NSString * const WTMyFollowingCellIdentifier = @"WTMyFollowingCellIdentifier";

@interface WTMyFollowingViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) WTMyFollowingViewModel *myFollowingVM;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WTMyFollowingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1、设置View
    [self setupView];
    
    self.myFollowingVM = [WTMyFollowingViewModel new];
    
    // 2、登陆过
    if ([[WTAccountViewModel shareInstance] isLogin])
    {
        // 2、开始下拉刷新
        [self.tableView.mj_header beginRefreshing];
    }
}

// 设置View
- (void)setupView
{
    [self navViewWithTitle: @"特别关注"];

    
    // tableView
    {
        // 自动计算行高
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 128.5;
        
        self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTMyFollowingCell class]) bundle: nil] forCellReuseIdentifier: WTMyFollowingCellIdentifier];
        
        // 添加下拉刷新、上拉刷新
        self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
        
        // 空白tableView
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
    }
    
}




#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.myFollowingVM.page = 1;
    
    [self.myFollowingVM getMyFollowingItemsWithSuccess:^{
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.myFollowingVM.isNextPage)
    {
        self.myFollowingVM.page ++;
        
        [self.myFollowingVM getMyFollowingItemsWithSuccess:^{
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myFollowingVM.myFollowingItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTMyFollowingCell *cell = [tableView dequeueReusableCellWithIdentifier: WTMyFollowingCellIdentifier];
    
    cell.myFollowingItem = self.myFollowingVM.myFollowingItems[indexPath.row];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView fd_heightForCellWithIdentifier: WTMyFollowingCellIdentifier cacheByIndexPath: indexPath configuration:^(WTMyFollowingCell *cell) {
//        cell.myFollowingItem = self.myFollowingVM.myFollowingItems[indexPath.row];
//    }];
//}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicDetailViewController *topicDetailVC = [WTTopicDetailViewController topicDetailViewController];
    WTMyFollowingItem *myFollowingItem = self.myFollowingVM.myFollowingItems[indexPath.row];
    topicDetailVC.topicDetailUrl = myFollowingItem.detailUrl;
    topicDetailVC.topicTitle = myFollowingItem.title;
    [self.navigationController pushViewController: topicDetailVC animated: YES];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self presentViewController: [WTLoginViewController new] animated: YES completion: nil];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([[WTAccountViewModel shareInstance] isLogin])
    {
        return false;
    }
    return true;
}

@end
