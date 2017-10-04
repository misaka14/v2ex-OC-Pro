//
//  WTUserNotificationViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  通知控制器

#import "WTUserNotificationViewController.h"
#import "WTLoginViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTNoLoginView.h"
#import "WTNoDataView.h"
#import "WTNotificationCell.h"
#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"
#import "UIViewController+Extension.h"

#import "WTConst.h"
#import "NetworkTool.h"
#import "WTTopicViewModel.h"
#import "WTAccountViewModel.h"
#import "WTNotificationViewModel.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString * const ID = @"notificationCell";

@interface WTUserNotificationViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, WTNotificationCellDelegate>
/** 回复消息ViewModel */
@property (nonatomic, strong) WTNotificationViewModel          *notificationVM;
/** 请求地址 */
@property (nonatomic, strong) NSString                         *urlString;
/** 页数*/
@property (nonatomic, assign) NSInteger                        page;

@property (nonatomic, assign) WTTableViewType                  tableViewType;

@property (weak, nonatomic) IBOutlet UITableView               *tableView;

@end

@implementation WTUserNotificationViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1、初始化View
    [self initView];
    
    // 2、初始化数据
    [self loadData];
    
    // 3、初始化通知
    [self initNoti];
}

#pragma mark - Private 
- (void)initView
{
    [self navViewWithTitle: @"提醒" hideBack: YES];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    // iOS8 以后 self-sizing
    self.tableView.estimatedRowHeight = 96;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 注册cell
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTNotificationCell class]) bundle: nil] forCellReuseIdentifier: ID];
    
    self.notificationVM = [WTNotificationViewModel new];
    
    // 1、添加下拉刷新、上拉刷新
    self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
    self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)loadData
{
    
    // 2、登陆过
    if ([[WTAccountViewModel shareInstance] isLogin])
    {
        // 2、开始下拉刷新
        [self.tableView.mj_header beginRefreshing];
        
    }
    else
    {
        self.tableViewType = WTTableViewTypeLogout;
        [self.notificationVM.notificationItems removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)initNoti
{
    // 1、登陆状态变更通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loadData) name: WTLoginStateChangeNotification object: nil];
    
    // 2、未读通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(unReadNotification:) name: WTUnReadNotificationNotification object: nil];
}

#pragma mark 加载最新的数据
- (void)loadNewData
{
    
    __weak typeof(self) weakSelf = self;
    self.notificationVM.page = 1;
    [self.notificationVM getUserNotificationsSuccess:^{
        
        if (weakSelf.notificationVM.notificationItems.count == 0)
            weakSelf.tableViewType = WTTableViewTypeNoData;
        else
            weakSelf.tableViewType = WTTableViewTypeNormal;
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        weakSelf.navigationController.tabBarItem.badgeValue = nil;
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.notificationVM.isNextPage)
    {
        self.notificationVM.page ++;
        
        [self.notificationVM getUserNotificationsSuccess:^{
            
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

- (void)unReadNotification:(NSNotification *)noti
{
    // 1、未读个数
    NSInteger unReadNum = [[noti.userInfo objectForKey: WTUnReadNumKey] integerValue];
    
    // 2、设置角标
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat: @"%ld", unReadNum];
}

#pragma mark - 事件
- (void)goToLoginVC
{
    WTLoginViewController *loginVC = [WTLoginViewController new];
    [self presentViewController: loginVC animated: YES completion: nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationVM.notificationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier: ID];
    
    cell.noticationItem = self.notificationVM.notificationItems[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicDetailViewController *topicDetailVC = [WTTopicDetailViewController topicDetailViewController];
    WTNotificationItem *notificationItem = self.notificationVM.notificationItems[indexPath.row];
    topicDetailVC.topicDetailUrl = notificationItem.detailUrl;
    topicDetailVC.topicTitle = notificationItem.title;
    [self.navigationController pushViewController: topicDetailVC animated: YES];
}

#pragma mark - WTNotificationCellDelegate
- (void)notificationCell:(WTNotificationCell *)notificationCell didClickWithNoticationItem:(WTNotificationItem *)noticationItem
{
    __weak typeof(self) weakSelf = self;
    // 删除通知
    [self.notificationVM deleteNotificationByNoticationItem: noticationItem success:^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [weakSelf.notificationVM.notificationItems indexOfObject: noticationItem] inSection: 0];
        
        [weakSelf.notificationVM.notificationItems removeObject: noticationItem];
        [weakSelf.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationMiddle];
        
//        if (weakSelf.notificationVM.notificationItems.count == 0)
//        {
//            [weakSelf.tableView reloadData];
//        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSString *text = nil;
    if (self.tableViewType == WTTableViewTypeNoData)
    {
        text = @"还没有收到通知";
        [attributes setObject: [UIColor colorWithHexString: @"#BDBDBD"] forKey: NSForegroundColorAttributeName];
        return [[NSAttributedString alloc] initWithString: text attributes:attributes];
    }
    
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.tableViewType == WTTableViewTypeNoData)
    {
        return [UIImage imageNamed:@"no_notification"];
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject: WTSelectedColor forKey: NSForegroundColorAttributeName];
    [attributes setObject: [UIFont systemFontOfSize: 18 weight: UIFontWeightMedium] forKey: NSFontAttributeName];
    if (![WTAccountViewModel shareInstance].isLogin)
    {
        return [[NSAttributedString alloc] initWithString: @"登陆" attributes:attributes];
    }
    else if (self.notificationVM.notificationItems.count == 0)
    {
        return [[NSAttributedString alloc] initWithString: @"重新加载" attributes:attributes];
    }
    return nil;
}


- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if ([WTAccountViewModel shareInstance].isLogin)
    {
        [self.tableView.mj_header beginRefreshing];
    }
    else
    {
        WTLoginViewController *loginVC = [WTLoginViewController new];
        __weak typeof(self) weakSelf = self;
        loginVC.loginSuccessBlock = ^{
            [weakSelf loadNewData];
        };
        [self presentViewController: loginVC animated: YES completion: nil];
    }
    
}

#pragma mark - Lazy

@end
