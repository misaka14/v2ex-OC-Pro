//
//  WTMemberReplyViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberReplyViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTReplyCell.h"
#import "WTNoDataView.h"

#import "WTTopicDetailViewModel.h"
#import "WTReplyViewModel.h"

#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NSString * const WTMemberReplyCellIdentifier = @"WTMemberReplyCellIdentifier";

@interface WTMemberReplyViewController () <DZNEmptyDataSetSource>
@property (nonatomic, strong) WTReplyViewModel *replyVM;
@end

@implementation WTMemberReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.replyVM = [WTReplyViewModel new];
    
    // 设置View
    [self setupView];
    
}

// 设置View
- (void)setupView
{
    
    self.title = @"我的回复";
    
    // tableView
    {
        // 自动计算行高
        self.tableView.estimatedRowHeight = 128.5;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTReplyCell class]) bundle: nil] forCellReuseIdentifier: WTMemberReplyCellIdentifier];
        
        // 添加下拉刷新、上拉刷新
//        self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
        
        // 空白tableView
        self.tableView.emptyDataSetSource = self;

    }
    
    [self loadNewData];
}

#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.replyVM.page = 1;
    
    if ([self.author isEqualToString: WTNoExistMemberTip]) {
        self.tableViewType = WTTableViewTypeNoData;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.replyVM getReplyItemsWithUsername: self.author avatarURL: nil success:^{
        weakSelf.tableViewType = weakSelf.replyVM.replyItems.count == 0 ? WTTableViewTypeNoData : WTTableViewTypeNormal;
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.replyVM.isNextPage)
    {
        self.replyVM.page ++;
        
        [self.replyVM getReplyItemsWithUsername: self.author avatarURL: nil success:^{
            
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

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyVM.replyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTReplyCell *cell = [tableView dequeueReusableCellWithIdentifier: WTMemberReplyCellIdentifier];
    
    cell.replyItem = self.replyVM.replyItems[indexPath.row];
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier: WTMemberReplyCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
//        
//    }];
//}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicDetailViewController *topicDetailVC = [WTTopicDetailViewController topicDetailViewController];
    WTReplyItem *replyItem = self.replyVM.replyItems[indexPath.row];
    topicDetailVC.topicDetailUrl = replyItem.detailUrl;
    topicDetailVC.topicTitle = replyItem.title;
    [self.navigationController pushViewController: topicDetailVC animated: YES];
}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if(self.tableViewType == WTTableViewTypeNoData)
    {
        [self.refreshView stopAnim];
        self.noDataView.tipTitleLabel.text = @"还没有回复过话题";
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
