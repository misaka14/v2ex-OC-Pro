//
//  WTBlogViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  话题控制器

#import "WTTopicViewController.h"
#import "WTMemberDetailViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTTopicCell.h"

#import "UIScrollView+YYAdd.h"
#import "WTCellAnimationTool.h"
#import "NetworkTool.h"
#import "WTTopicViewModel.h"
#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"


#import "NSString+YYAdd.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


static NSString *const ID = @"topicCell";

@interface WTTopicViewController () <UIViewControllerPreviewingDelegate, WTTopicCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) WTTopicViewModel                    *topicVM;


@end

@implementation WTTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.topicVM = [WTTopicViewModel new];
    
    // 初始化页面
    [self setUpView];
    
    // 注册通知
    [self initNoti];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - 初始化页面
- (void)setUpView
{
    // 1、设置tableView一些属性
    
    // 2、自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    // 3、其他属性
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    // 4、注册cell
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTTopicCell class]) bundle: nil] forCellReuseIdentifier: ID];
    

    
    // 1.2只有'最近',　全部节点需要上拉刷新
    if ([WTTopicViewModel isNeedNextPage: self.urlString])
    {
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
    }
    else
    {
        self.tableView.mj_footer = nil;
    }
    
//    [self.tableView.mj_header beginRefreshing];
    
    // 2、判断3DTouch
    if (iOS9Later && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate: self sourceView: self.view];
    }
}

#pragma mark - 注册通知
- (void)initNoti
{
    if ([self.title isEqualToString: @"最近"])
    {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loadNewData) name: WTLoginStateChangeNotification object: nil];
    }
}

#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.topicVM.page = 1; // 由于是抓取数据的原因，每次下拉刷新直接重头开始加载
    [self.tableView scrollToTop];
    
    __weak typeof(self) weakSelf = self;
    [self.topicVM getNodeTopicWithUrlStr: self.urlString topicType: WTTopicTypeNormal success:^{
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
//        NSArray *cellArray = self.tableView.visibleCells;
//        
//        //  延迟
//        CGFloat delay =0.05;
//        for (UITableViewCell *cell in cellArray) {
//            cell.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
//        }
//        
//        for (int i = 0; i<cellArray.count; i++) {
//            UITableViewCell *cell = cellArray[i];
//            CGFloat cellDelay = delay *i;
//            
//            [UIView animateWithDuration:1.0 delay:cellDelay usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                cell.transform =  CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    self.topicVM.page ++;
    
    __weak typeof(self) weakSelf = self;
    [self.topicVM getNodeTopicWithUrlStr: self.urlString topicType: WTTopicTypeNormal success:^{
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
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
    __weak typeof(self) weakSelf = self;
    detailVC.ignoreTopicBlock = ^{
        [weakSelf.topicVM.topics removeObjectAtIndex: indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
    };
    [self.navigationController pushViewController: detailVC animated: YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // cell显示动效果
    [WTCellAnimationTool animation01WithCell: cell];

}


#pragma mark - WTTopicCellDelegate
- (void)topicCell:(WTTopicCell *)topicCell didClickMemberDetailAreaWithTopic:(WTTopic *)topic
{
    WTMemberDetailViewController *memeberDetailVC = [[WTMemberDetailViewController alloc] initWithTopic: topic];
    [self.navigationController pushViewController: memeberDetailVC animated: YES];
}

#pragma mark - UIViewControllerPreviewingDelegate 测试数据
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController: viewControllerToCommit sender: self];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: location];
    WTTopicCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
    if (!cell)
        return nil;
    
    WTTopic *topic = cell.topic;
    WTTopicDetailViewController *topicDetailVC = [WTTopicDetailViewController topicDetailViewController];
    topicDetailVC.hideNav = YES;
    topicDetailVC.topicDetailUrl = topic.detailUrl;
    return topicDetailVC;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    // 生成UIPreviewAction
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 selected");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Action 2" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 2 selected");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Action 3" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 3 selected");
    }];
    
    UIPreviewAction *tap1 = [UIPreviewAction actionWithTitle:@"tap 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"tap 1 selected");
    }];
    
    UIPreviewAction *tap2 = [UIPreviewAction actionWithTitle:@"tap 2" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"tap 2 selected");
    }];
    
    UIPreviewAction *tap3 = [UIPreviewAction actionWithTitle:@"tap 3" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"tap 3 selected");
    }];
    
    // 塞到UIPreviewActionGroup中
    NSArray *actions = @[action1, action2, action3];
    NSArray *taps = @[tap1, tap2, tap3];
    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:actions];
    UIPreviewActionGroup *group2 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:taps];
    NSArray *group = @[group1,group2];
    
    return group;
}

#pragma mark - DZNEmptyDataSetSource
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
//{
//    UIView *view;
//    if (self.tableViewType == WTTableViewTypeLogout)
//    {
//        WTNoDataView *noDataView = [WTNoDataView noDataView];
//        noDataView.tipImageView.image = [UIImage imageNamed:@"no_notification"];
//        noDataView.tipTitleLabel.text = @"快去发表主题吧";
//        view = noDataView;
//    }
//    return view;
//}

@end
