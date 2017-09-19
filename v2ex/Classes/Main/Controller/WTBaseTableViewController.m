//
//  WTBaseTableViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTBaseTableViewController.h"

@interface WTBaseTableViewController ()

@end

@implementation WTBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、添加下拉刷新、上拉刷新
    self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
    self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
    
    // 2、开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
//    self.tableView.tableFooterView = [UIView new];
}

- (void)loadNewData{
    WTLog(@"loadNewData")
}
- (void)loadOldData{}

/**
 *  是否有下一页
 *
 */
//- (void)isHasNextPage:(WTTopic *)topic
//{
//    // 取出最后一个模型判断是有下一页
//    if (!topicViewModel.isHasNextPage)
//    {
//        self.tableView.mj_footer = nil;
//    }
//    else
//    {
//        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
//    }
//}
@end
