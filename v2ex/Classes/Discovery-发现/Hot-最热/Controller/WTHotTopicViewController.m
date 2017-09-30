//
//  WTDiscoveryViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/7.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTHotTopicViewController.h"
#import "WTLoginViewController.h"
#import "WTRegisterViewController.h"
#import "WTTopicDetailViewController.h"
#import "WTTopicViewController.h"

#import "WTNoLoginView.h"
#import "WTSearchTopicCell.h"

#import "WTURLConst.h"
#import "WTAccountViewModel.h"
#import "WTHotTopicViewModel.h"

#import "UIViewController+Extension.h"

#import "WTProgressHUD.h"
#import "NSString+YYAdd.h"
#import "Masonry.h"

static NSString * const WTSearchTopicCellIdentifier = @"WTSearchTopicCellIdentifier";

static NSTimeInterval const WTSearchTopicAnimationDuration = 0.3f;

static CGFloat const WTSearchBarNormalMargin = 10;

@interface WTHotTopicViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>


/************************* 控件 *************************/
/** 最近话题tableView的ContentView */
@property (weak, nonatomic) IBOutlet UIView *topicContentView;
/** 加载的View */
@property (weak, nonatomic) IBOutlet UIView *loadingView;
/** 没有登陆的提示页面 */
@property (nonatomic, weak) WTNoLoginView *noLoginView;
/** 菊花 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
/** 搜索话题的tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 搜索栏 */
@property (nonatomic, weak) UISearchBar *searchBar;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancelBtn;

/************************* 控制器 *************************/
/** 话题控制器 */
@property (nonatomic, weak) WTTopicViewController *topicVC;

/************************* 数据源 *************************/
/** 搜索话题数组*/
@property (nonatomic, strong) NSMutableArray<WTSearchTopic *> *searchTopics;
/** 当前页数 */
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation WTHotTopicViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if (![WTAccountViewModel shareInstance].isLogin)
        [self.view bringSubviewToFront: self.noLoginView];
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1、初始化View
    [self initView];
    
    // 2、添加子控制器
    [self addChildViewControllers];
    
    // 3、注册通知
    [self initNoti];
}

#pragma mark - Private
#pragma mark 初始化View
- (void)initView
{
    // 1、初始化导航栏
    [self navView];
    
    // 2、添加搜索导航栏
    {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.tintColor = WTSelectedColor;
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        self.searchBar = searchBar;
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [self.nav_View addSubview: searchBar];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.offset(10);
            make.left.offset(WTSearchBarNormalMargin);
            make.right.offset(-WTSearchBarNormalMargin);
            
        }];
        
        // 添加searchBar换肤功能
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.dk_textColorPicker = DKColorPickerWithKey(WTSearchbarTextColor);
        
        UIButton *cancelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
        [cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        [cancelBtn setTitleColor: WTSelectedColor forState: UIControlStateNormal];
        [cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
        cancelBtn.alpha = 0;
        self.cancelBtn = cancelBtn;
        [self.nav_View addSubview: cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(40);
            make.height.offset(20);
            make.centerY.offset(10);
            make.right.offset(-10);
        }];
    }
    
    // 3、搜索话题的tableView
    {
        // 注册Cell
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTSearchTopicCell class])  bundle: nil] forCellReuseIdentifier: WTSearchTopicCellIdentifier];
        
        // 自动布局
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100;
        
        // 背景颜色
        self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
        
        // 下拉刷新
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf searchTopicWithKeywords: self.searchBar.text isShowLoadingView: NO];
        }];
    }
    
    self.currentPage = 0;
    
    self.loadingView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    self.activityView.dk_tintColorPicker = DKColorPickerWithKey(WTActivityIndicatorViewColor);
}


#pragma mark 添加子控制器
- (void)addChildViewControllers
{
    // 1、话题控制器
    WTTopicViewController *vc = [WTTopicViewController new];
    vc.urlString = [WTHTTPBaseUrl stringByAppendingString: @"/recent"];
    [self addChildViewController: vc];
    [self.topicContentView addSubview: vc.view];
    vc.view.frame = self.topicContentView.bounds;
    self.topicVC = vc;
}

#pragma mark 通知
- (void)initNoti
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loginStateChange) name: WTLoginStateChangeNotification object: nil];
}

#pragma mark 搜索话题
- (void)searchTopicWithKeywords:(NSString *)keywords isShowLoadingView:(BOOL)isShowLoadingView
{
    if (isShowLoadingView)
        [self bringSubviewToFront: self.loadingView];
 
    __weak typeof(self) weakSelf = self;
    void (^successBlock)(NSMutableArray<WTSearchTopic *> *searchTopics) = ^(NSMutableArray<WTSearchTopic *> *searchTopics){
    
        weakSelf.currentPage++;
        
        if (isShowLoadingView)
            weakSelf.searchTopics = searchTopics;
        else
            [weakSelf.searchTopics addObjectsFromArray: searchTopics];
        
        [weakSelf bringSubviewToFront: weakSelf.tableView];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_footer endRefreshing];
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error){
        
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"服务器异常"];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    };
    
    WTSearchTopicReq *req = [WTSearchTopicReq new];
    req.keywords = keywords;
    req.currentPage = self.currentPage;
    [WTHotTopicViewModel searchTopicWithSearchTopicReq: req success: successBlock failure: failureBlock];
}

- (void)bringSubviewToFront:(UIView *)view
{
    [self.view bringSubviewToFront: view];
    [self.view bringSubviewToFront: self.nav_View];
}

#pragma mark - 事件
- (void)loginStateChange
{
    if ([WTAccountViewModel shareInstance].isLogin)
    {
        [self bringSubviewToFront: self.topicContentView];
        [self.topicVC loadNewData];
    }
    else
    {
        [self.view bringSubviewToFront: self.noLoginView];
    }
}

- (void)cancelBtnClick
{
    [self.view endEditing: YES];
    
    [self bringSubviewToFront: self.topicContentView];
    
    self.searchBar.text = @"";
    
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-WTSearchBarNormalMargin);
    }];
    
    [UIView animateWithDuration: WTSearchTopicAnimationDuration animations:^{
        
        [self.view layoutIfNeeded];
        
        self.cancelBtn.alpha = 0;
    }];
}
- (IBAction)buttonBtnClick
{
    __weak typeof(self) weakSelf = self;
    WTLoginViewController *vc = [WTLoginViewController new];
    vc.loginSuccessBlock = ^(){
        [weakSelf.topicVC loadNewData];
    };
    [self presentViewController: vc animated: YES completion: nil];
}
- (IBAction)registerBtnClick
{
    [self presentViewController: [WTRegisterViewController new] animated: YES completion: nil];
}

#pragma mark - UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keywords = self.searchBar.text;
    if ([[keywords stringByTrim] isEqualToString: @""]) return;
    
    [self.view endEditing: YES];
    
    // 搜索话题
    self.currentPage = 0;
    [self searchTopicWithKeywords: keywords isShowLoadingView: YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-50);
    }];
    
    [UIView animateWithDuration: WTSearchTopicAnimationDuration animations:^{
        
        [self.view layoutIfNeeded];
        
        self.cancelBtn.alpha = 1;
    }];
    
    return YES;
}



#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchTopics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTSearchTopicCell *cell = [tableView dequeueReusableCellWithIdentifier: WTSearchTopicCellIdentifier];
    
    cell.keywords = self.searchBar.text;
    cell.searchTopic = [self.searchTopics objectAtIndex: indexPath.row];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTSearchTopic *searchTopic = [self.searchTopics objectAtIndex: indexPath.row];

    WTTopicDetailViewController *detailVC = [WTTopicDetailViewController topicDetailViewController];
    detailVC.topicDetailUrl = searchTopic.link;
    detailVC.topicTitle = searchTopic.title;
    [self.navigationController pushViewController: detailVC animated: YES];
}

#pragma mark - Lazy 
- (WTNoLoginView *)noLoginView
{
    if (_noLoginView == nil)
    {
        WTNoLoginView *noLoginView = [WTNoLoginView wt_viewFromXib];
        noLoginView.frame = self.view.bounds;
        [self.view addSubview: noLoginView];
        _noLoginView = noLoginView;
        
        noLoginView.title = @"登录后，可以使用搜索功能，查看全部的v2ex的帖子";
        __weak typeof(self) weakSelf = self;
        noLoginView.loginSuccessBlock = ^{
            
            [weakSelf.topicVC loadNewData];
            
            [weakSelf bringSubviewToFront: weakSelf.topicContentView];
            
        };
    }
    return _noLoginView;
}

@end
