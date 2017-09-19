//
//  WTtopicDetailViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/17.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  话题详情控制器

#import "WTTopicDetailViewController.h"
#import "WTTopicDetailTableViewController.h"

#import "WTTopicViewModel.h"

#import "WTShareSDKTool.h"
#import "WTToolBarView.h"

#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+Extension.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

static CGFloat const WTNavViewHeight = 64;

@interface WTTopicDetailViewController ()
/** 导航栏*/
@property (weak, nonatomic) IBOutlet UIView             *navView;
/** 导航栏用户信息ContentView */
@property (weak, nonatomic) IBOutlet UIView             *navUserInfoContentView;

/** 用户名　*/
@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *navLineView;

/** 已经登陆过的View */
@property (weak, nonatomic) IBOutlet UIView             *normalView;
/** 正在加载的View */
@property (weak, nonatomic) IBOutlet UIView             *loadingView;
/** 工具条的View */
@property (nonatomic, weak) WTToolBarView               *toolBarView;
/** 提示的View */
@property (weak, nonatomic) IBOutlet UIView             *tipView;
/** 帖子的tableView */
@property (nonatomic, weak) UITableView                 *tableView;

@end

@implementation WTTopicDetailViewController

+ (instancetype)topicDetailViewController
{
    return [UIStoryboard storyboardWithName: NSStringFromClass([self class]) bundle: nil].instantiateInitialViewController;
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化View
    [self initView];
    
    // 设置话题详情数据
    [self setupTopicDetailData];
}

#pragma mark - 初始化View
- (void)initView
{
    self.navView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    
    self.navUserInfoContentView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    
    self.navLineView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarLineViewBackgroundColor);
    
//    self.titleLabel.dk_textColorPicker =  DKColorPickerWithKey(UITabBarTitleColor);

//    self.topicDetailUrl = @"https://www.v2ex.com/t/353634#reply0";
}

#pragma mark -设置话题详情数据
- (void)setupTopicDetailData
{
    
    // 1、创建话题详情数据控制器
    WTTopicDetailTableViewController *topicVC = [WTTopicDetailTableViewController topicDetailTableViewController];
    topicVC.topicDetailUrl = self.topicDetailUrl;
    [self.normalView addSubview: topicVC.view];
    _tableView = topicVC.tableView;
    [self addChildViewController: topicVC];
    
    // 2、设置属性
    topicVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, WTToolBarHeight, 0);
    topicVC.tableView.separatorInset = topicVC.tableView.contentInset;
    
    // 3、设置布局
    [topicVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.normalView);
    }];
    
    // 4、操作帖子之后的操作
    __weak typeof(self) weakSelf = self;
    topicVC.updateTopicDetailComplection = ^(WTTopicDetailViewModel *topicDetailVM, NSError *error){
        
        // 请求到帖子详情的之后的操作
        [weakSelf updateUIWithTOpicDetailVM: topicDetailVM error: error];
        
    };
    
    // 5、tableView的offsetY值发生变化的Block
    topicVC.updateScrollViewOffsetComplecation = ^(CGFloat offset) {
      
        [weakSelf updateScrollViewOffset: offset];
    };

}


/**
 请求到帖子详情的之后的操作

 @param vm 帖子详情
 @param error 错误
 */
- (void)updateUIWithTOpicDetailVM:(WTTopicDetailViewModel *)vm error:(NSError *)error
{
    self.loadingView.hidden = YES;
    
    if (error != nil)
    {
        self.tipView.hidden = NO;
        return;
    }
    
//    // 更新头像
//    [self.avatarImageV sd_setImageWithURL: vm.iconURL placeholderImage: WTIconPlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//       
//        self.avatarImageV.image = [image roundImageWithCornerRadius: 3.0];
//        
//    }];
//    // 用户名
//    self.usernameLabel.text = vm.topicDetail.author;

    self.titleLabel.text = vm.topicDetail.title;
    
    self.tipView.hidden = YES;
    self.toolBarView.topicDetailVM = vm;
}


/**
　topicDetail tableView的offsetY值发生变化的Block

 @param offset offsetY
 */
- (void)updateScrollViewOffset:(CGFloat)offset
{
    if (offset > WTNavViewHeight)
    {
        [UIView animateWithDuration: 0.5 animations:^{
            self.navUserInfoContentView.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration: 0.5 animations:^{
            self.navUserInfoContentView.alpha = 0;
        }];
    }
}

#pragma mark - 懒加载
- (WTToolBarView *)toolBarView
{
    if (_toolBarView == nil)
    {
        // 1、创建工具栏View
        WTToolBarView *toolBarView = [WTToolBarView toolBarView];
        [self.normalView addSubview: toolBarView];
        _toolBarView = toolBarView;
        
        // 3、布局
        [toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.normalView);
            make.height.equalTo(@(WTToolBarHeight));
        }];
    }
    return _toolBarView;
}

#pragma mark - 事件
#pragma mark - 返回
- (IBAction)backBtnClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)goLoginVCBtnClick
{
    WTLoginViewController *loginVC = [WTLoginViewController new];
    loginVC.loginSuccessBlock = ^{
        WTTopicDetailTableViewController *vc = self.childViewControllers.firstObject;
        [vc setupData];
    };
    [self presentViewController: loginVC animated: YES completion: nil];
}

- (IBAction)shareItemClick
{
    NSString *url = [self.topicDetailUrl stringByReplacingOccurrencesOfString: @"https:/" withString: @""];
    
    NSString *text = [self.topicTitle stringByAppendingString: [NSString stringWithFormat: @"https://%@", url]];
    [WTShareSDKTool shareWithText: text url: url title: self.topicTitle];
}

- (void)dealloc
{
    WTLog(@"WTTopicDetailViewController dealloc")
}

@end
