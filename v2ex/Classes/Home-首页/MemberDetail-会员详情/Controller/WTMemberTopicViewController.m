//
//  WTMemberTopicViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberTopicViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTTopicCell.h"

#import "WTConst.h"
#import "WTTopicDetailViewModel.h"
#import "WTMemberTopicViewModel.h"

#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NSString * const WTMemberTopicIdentifier = @"WTMemberTopicIdentifier";

@interface WTMemberTopicViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) WTMemberTopicViewModel *memberTopicVM;

@end

@implementation WTMemberTopicViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.memberTopicVM = [WTMemberTopicViewModel new];
    
    // 设置View
    [self setupView];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.width = WTScreenWidth;
    self.tableView.height = WTScreenHeight;
}

// 设置View
- (void)setupView
{
    
    self.title = @"我的回复";
    
    // tableView
    {
        self.tableView.backgroundColor = WTTableViewBackgroundColor;
        // 自动计算行高
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 128.5;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTTopicCell class]) bundle: nil] forCellReuseIdentifier: WTMemberTopicIdentifier];
        
        // 添加下拉刷新、上拉刷新
        //        self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
        
        // 空白tableView
        self.tableView.emptyDataSetSource = self;
    }
    
    [self loadNewData];
//    [self.tableView reloadData];
}

#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.memberTopicVM.page = 1;
    self.tableViewType = WTTableViewTypeRefresh;
    
    __weak typeof (self) weakSelf = self;
    [self.memberTopicVM getMemberTopicsWithUsername: self.author iconURL: self.iconURL success:^{
        
        weakSelf.tableViewType = weakSelf.memberTopicVM.topics.count == 0 ? WTTableViewTypeNoData : WTTableViewTypeNormal;
        [self reloadAvatar];
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.memberTopicVM.isNextPage)
    {
        [self.memberTopicVM getMemberTopicsWithUsername: self.author iconURL: self.iconURL success:^{

            
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

/**
 刷新头像
 */
- (void)reloadAvatar
{
    NSUInteger count = self.memberTopicVM.topics.count;
    if (count > 0)
    {
        for (NSUInteger i = 0; i < count; i++)
        {
            WTTopic *topic = [self.memberTopicVM.topics objectAtIndex: i];
            topic.iconURL = self.iconURL;
        }
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberTopicVM.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicCell *cell = [tableView dequeueReusableCellWithIdentifier: WTMemberTopicIdentifier];
    
    cell.topic = self.memberTopicVM.topics[indexPath.row];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView fd_heightForCellWithIdentifier: WTMemberTopicIdentifier cacheByIndexPath: indexPath configuration:^(WTTopicCell *cell) {
//        cell.topic = self.memberTopicVM.topics[indexPath.row];
//    }];
//}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中的效果
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    // 跳转至话题详情控制器
    WTTopic *topic = self.memberTopicVM.topics[indexPath.row];
    WTTopicDetailViewController *detailVC = [WTTopicDetailViewController topicDetailViewController];
    detailVC.topicDetailUrl = topic.detailUrl;
    detailVC.topicTitle = topic.title;
    [self.navigationController pushViewController: detailVC animated: YES];
}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if(self.tableViewType == WTTableViewTypeNoData)
    {
        [self.refreshView stopAnim];
        self.noDataView.tipTitleLabel.text = @"还没有发表过主题";
        return self.noDataView;
    }
    else if(self.tableViewType == WTTableViewTypeRefresh)
    {
        [self.refreshView startAnim];
        return self.refreshView;
    }
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: DKThemeVersionNormal])
        return [UIColor colorWithHexString: @"#F4F4F4"];
    else
        return [UIColor colorWithHexString: @"#1B1B1B"];
}

@end
