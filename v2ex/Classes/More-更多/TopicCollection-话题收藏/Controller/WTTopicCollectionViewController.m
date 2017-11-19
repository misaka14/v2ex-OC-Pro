//
//  WTTopicCollectionViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  话题收藏控制器

#import "WTTopicCollectionViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTTopicCollectionCell.h"
#import "WTTopicCollectionViewModel.h"
#import "UIViewController+Extension.h"

#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NSString * const WTTopicCollectionCellIdentifier = @"WTTopicCollectionCellIdentifier";

@interface WTTopicCollectionViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate>

@property (nonatomic, strong) WTTopicCollectionViewModel *topicCollectionVM;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WTTopicCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topicCollectionVM = [WTTopicCollectionViewModel new];
    
    // 1、设置View
    [self setupView];
    
//    self.myFollowingVM = [WTMyFollowingViewModel new];
//    
//    // 2、登陆过
//    if ([[WTAccountViewModel shareInstance] isLogin])
//    {
//        // 2、开始下拉刷新
//        [self.tableView.mj_header beginRefreshing];
//    }
}

// 设置View
- (void)setupView
{
    [self navViewWithTitle: @"话题收藏"];
    
    // tableView
    {
        // 自动计算行高
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 128.5;
        
        self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTTopicCollectionCell class]) bundle: nil] forCellReuseIdentifier: WTTopicCollectionCellIdentifier];
        
        // 添加下拉刷新、上拉刷新
        self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
        
        // 空白tableView
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    }
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.topicCollectionVM.page = 1;
    
    [self.topicCollectionVM getTopicCollectionItemsWithSuccess:^{
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.topicCollectionVM.isNextPage)
    {
        self.topicCollectionVM.page ++;
        
        [self.topicCollectionVM getTopicCollectionItemsWithSuccess:^{
            
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
    return self.topicCollectionVM.topicCollectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier: WTTopicCollectionCellIdentifier];
    
    cell.topicCollectionItem = self.topicCollectionVM.topicCollectionItems[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转至话题详情控制器
    WTTopicCollectionItem *topic = self.topicCollectionVM.topicCollectionItems[indexPath.row];
    WTTopicDetailViewController *detailVC = [WTTopicDetailViewController topicDetailViewController];
    detailVC.topicDetailUrl = topic.detailUrl;
    detailVC.topicTitle = topic.title;
    [self.navigationController pushViewController: detailVC animated: YES];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView fd_heightForCellWithIdentifier: WTTopicCollectionCellIdentifier configuration:^(WTTopicCollectionCell *cell) {
//        cell.topicCollectionItem = self.topicCollectionVM.topicCollectionItems[indexPath.row];
//    }];
//}

@end
