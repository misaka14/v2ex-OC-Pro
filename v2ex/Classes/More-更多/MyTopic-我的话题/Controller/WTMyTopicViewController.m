//
//  WTMyTopicViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/29.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMyTopicViewController.h"
#import "WTTopicDetailViewController.h"
#import "WTMemberDetailViewController.h"
#import "UIViewController+Extension.h"

#import "WTTopicCell.h"

#import "WTTopicViewModel.h"
#import "WTAccountViewModel.h"

#import "WTRefreshNormalHeader.h"
#import "MJRefreshAutoFooter.h"

#import "UITableView+FDTemplateLayoutCell.h"

static NSString *const ID = @"myTopicCell";

@interface WTMyTopicViewController () <WTTopicCellDelegate>

@property (nonatomic, strong) WTTopicViewModel *topicVM;
@property (nonatomic, strong) NSString *urlString;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WTMyTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.urlString = [NSString stringWithFormat: @"https://www.v2ex.com/member/%@/topics", [WTAccountViewModel shareInstance].account.usernameOrEmail];
    
    self.topicVM = [WTTopicViewModel new];
    
    // 初始化页面
    [self setUpView];
}

#pragma mark - 初始化页面
- (void)setUpView
{
    [self navViewWithTitle: @"我的话题"];
    
    // 1、设置tableView一些属性
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTTopicCell class]) bundle: nil] forCellReuseIdentifier: ID];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    // 设置滚动条的内边距
//    self.tableView.separatorInset = self.tableView.contentInset;
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
    self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
    
    [self.tableView.mj_header beginRefreshing];
    
}



#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.topicVM.page = 1; // 由于是抓取数据的原因，每次下拉刷新直接重头开始加载
    
    [self.topicVM getNodeTopicWithUrlStr: self.urlString topicType: WTTopicTypeNormal avartorURL: [WTAccountViewModel shareInstance].account.avatarURL success:^{
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    self.topicVM.page ++;
    
    [self.topicVM getNodeTopicWithUrlStr: self.urlString topicType: WTTopicTypeNormal avartorURL: [WTAccountViewModel shareInstance].account.avatarURL success:^{
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicVM.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicCell *cell = [tableView dequeueReusableCellWithIdentifier: ID];
    cell.delegate = self;
    // 设置数据
    cell.topic = self.topicVM.topics[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中的效果
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    // 跳转至话题详情控制器
    WTTopic *topic = self.topicVM.topics[indexPath.row];
    WTTopicDetailViewController *detailVC = [WTTopicDetailViewController topicDetailViewController];
    detailVC.topicDetailUrl = topic.detailUrl;
    detailVC.topicTitle = topic.title;
    [self.navigationController pushViewController: detailVC animated: YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier: ID cacheByIndexPath: indexPath configuration:^(WTTopicCell *cell) {
        cell.topic = self.topicVM.topics[indexPath.row];
    }];
}

#pragma mark - WTTopicCellDelegate
- (void)topicCell:(WTTopicCell *)topicCell didClickMemberDetailAreaWithTopic:(WTTopic *)topic
{
    WTMemberDetailViewController *memeberDetailVC = [[WTMemberDetailViewController new] initWithTopic: topic];
    [self.navigationController pushViewController: memeberDetailVC animated: YES];
}

@end
