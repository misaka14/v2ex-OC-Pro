//
//  WTMoreViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  更多控制器

#import "WTWebViewController.h"
#import "WTMoreViewController.h"
#import "WTLoginViewController.h"
#import "WTThemeViewController.h"
#import "WTTopicViewController.h"
#import "WTMyTopicViewController.h"
#import "WTMyReplyViewController.h"
#import "WTV2GroupViewController.h"
#import "WTRegisterViewController.h"
#import "WTMyFollowingViewController.h"
#import "WTNodeCollectionViewController.h"
#import "WTTopicCollectionViewController.h"
#import "WTPrivacyStatementViewController.h"

#import "WTMoreCell.h"
#import "WTMoreLoginHeaderView.h"
#import "WTMoreNotLoginHeaderView.h"

#import "WTConst.h"
#import "WTSettingItem.h"
#import "WTAccountViewModel.h"


NSString * const moreCellIdentifier = @"moreCellIdentifier";

CGFloat const moreHeaderViewH = 150;

@interface WTMoreViewController () <UITableViewDataSource, UITableViewDelegate, WTMoreNotLoginHeaderViewDelegate>

@property (nonatomic, weak) UIView                      *headerContentView;
@property (nonatomic, weak) UIView                      *footerContentView;
@property (nonatomic, weak) UITableView                 *tableView;
@property (nonatomic, weak) WTMoreLoginHeaderView       *moreLoginHeaderView;
@property (nonatomic, weak) WTMoreNotLoginHeaderView    *moreNotLoginHeaderView;
@property (nonatomic, strong) UIAlertController         *loginC;                        // 退出登录的对话框

@property (nonatomic, strong) NSMutableArray            *datas;
@property (nonatomic, strong) NSMutableArray            *titles;

@property (nonatomic, assign) CGFloat                   endY;                           // 记录scrollView的contentOff的Y值

@end

@implementation WTMoreViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置View
    [self setupView];
}

// 设置View
- (void)setupView
{
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    [self headerContentView];
    
    // 1、UITableView
    UITableView *tableView = [UITableView new];
    
    {
        self.footerContentView.height = WTScreenHeight -  moreHeaderViewH - WTTabBarHeight;
        tableView.frame = self.footerContentView.bounds;
        [self.footerContentView addSubview: tableView];
        self.tableView = tableView;
        
        tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 234;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 10;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        
        [tableView registerClass: [WTMoreCell class] forCellReuseIdentifier: moreCellIdentifier];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    // 4、判断是否登录，添加不同的headerView
    if ([[WTAccountViewModel shareInstance] isLogin])
    {
        self.moreLoginHeaderView.hidden = NO;
        self.moreNotLoginHeaderView.hidden = YES;
        self.moreLoginHeaderView.account = [WTAccountViewModel shareInstance].account;
    }
    else
    {
        self.moreLoginHeaderView.hidden = YES;
        self.moreNotLoginHeaderView.hidden = NO;
    }
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WTMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier: moreCellIdentifier];
    
    moreCell.settingItems = self.datas[indexPath.row];
    
    moreCell.title = self.titles[indexPath.row];
    
    return moreCell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        [UIView animateWithDuration: 0.1 animations:^{
            
            
            self.endY += (-scrollView.contentOffset.y) * 0.3;
            self.footerContentView.y = moreHeaderViewH + self.endY;
            
        }];
        
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration: 0.3 animations:^{
        
        self.footerContentView.y = moreHeaderViewH;
        self.endY = 0;
    }];
}

#pragma mark - WTMoreNotLoginHeaderViewDelegate
#pragma mark 登录按钮点击
- (void)moreNotLoginHeaderViewDidClickedLoginBtn:(WTMoreNotLoginHeaderView *)moreNotLoginHeaderView
{
    WTLoginViewController *loginVC = [WTLoginViewController new];
    
    loginVC.loginSuccessBlock = ^{
    
    };
    [self presentViewController: [WTLoginViewController new] animated: YES completion: nil];
}

#pragma mark 注册按钮点击
- (void)moreNotLoginHeaderViewDidClickedRegisterBtn:(WTMoreNotLoginHeaderView *)moreNotLoginHeaderView
{
    [self presentViewController: [WTRegisterViewController new] animated: YES completion: nil];
}

#pragma mark - Private Method
// 判断是否登陆，如果登录正常跳转转，否则跳转至登陆页面
- (void)checkIsLoginWithViewController:(UIViewController *)vc
{
    if ([WTAccountViewModel shareInstance].isLogin)
    {
        [self.navigationController pushViewController: vc animated: YES];
    }
    else
    {
        [self presentViewController: [WTLoginViewController new] animated: YES completion: nil];
    }
}

#pragma mark - Lazy Method
- (NSMutableArray<NSArray *> *)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray array];
    
        __weak typeof(self) weakSelf = self;
        
        [_datas addObject: @[
                             
                             
                                [WTSettingItem settingItemWithTitle: @"节点收藏" image: [UIImage imageNamed: @"mine_favourite"] operationBlock: ^{
            
            
                                    [weakSelf checkIsLoginWithViewController: [WTNodeCollectionViewController new]];
                                }],
            
                                [WTSettingItem settingItemWithTitle: @"特别关注" image: [UIImage imageNamed: @"mine_follow"] operationBlock: ^{
            
                                    [weakSelf checkIsLoginWithViewController: [WTMyFollowingViewController new]];
                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"话题收藏" image: [UIImage imageNamed: @"more_collection"] operationBlock: ^{
            
                                    [weakSelf checkIsLoginWithViewController: [WTTopicCollectionViewController new]];
                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"我的话题" image: [UIImage imageNamed: @"mine_topic"] operationBlock: ^{
                                    WTMyTopicViewController *myTopicVC = [WTMyTopicViewController new];
            
                                    [weakSelf checkIsLoginWithViewController: myTopicVC];
                                }],
            
                                [WTSettingItem settingItemWithTitle: @"我的回复" image: [UIImage imageNamed: @"more_systemnoti"] operationBlock: ^{
            
                                    [weakSelf checkIsLoginWithViewController: [WTMyReplyViewController new]];
                                }],
                                
//                                [WTSettingItem settingItemWithTitle: @"我的回复" image: [UIImage imageNamed: @"more_systemnoti"] operationBlock: ^{
//            
//                                    [weakSelf checkIsLoginWithViewController: [WTMyReplyViewController new]];
//                                }],
                                
#if Test == 0
                                [WTSettingItem settingItemWithTitle: @"v2小组" image: [UIImage imageNamed: @"more_group"] operationBlock: ^{
            
                                    [weakSelf checkIsLoginWithViewController: [WTV2GroupViewController new]];
                                }],
#else
#endif
                            ]];
        
        [_datas addObject: @[
//                             [WTSettingItem settingItemWithTitle: @"主题" image: [UIImage imageNamed: @"mine_theme"] operationBlock:^{
//                                    [weakSelf.navigationController pushViewController: [[WTThemeViewController alloc] initWithCollectionViewLayout: [UICollectionViewFlowLayout new]] animated: YES];
//                                }],
                             
                                [WTSettingItem settingItemWithTitle: @"隐私声明" image: [UIImage imageNamed: @"more_privacystatement"] operationBlock: ^{
            
                                    [weakSelf.navigationController pushViewController: [WTPrivacyStatementViewController new] animated: YES];
                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"评分" image: [UIImage imageNamed: @"more_pingfen"] operationBlock: ^{
            
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/v2ex-%E5%88%9B%E5%BB%BA%E5%B7%A5%E4%BD%9C%E8%80%85%E4%BB%AC%E7%9A%84%E7%A4%BE%E5%8C%BA%E5%AE%A2%E6%88%B7%E7%AB%AF/id1091339486?mt=8"]];

                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"项目源码" image: [UIImage imageNamed: @"more_project"] operationBlock: ^{
        
                                    WTWebViewController *webVC = [WTWebViewController new];
                                    webVC.url = [NSURL URLWithString: @"https://github.com/misaka14/v2ex-OC"];
                                    [weakSelf.navigationController pushViewController: webVC animated: YES];
                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"关于V2EX" image: [UIImage imageNamed: @"more_about"] operationBlock: ^{
                                        WTWebViewController *webVC = [WTWebViewController new];
                                        webVC.url = [NSURL URLWithString: @"https://www.v2ex.com/about"];
                                        [weakSelf.navigationController pushViewController: webVC animated: YES];
                                }],
                                
                                [WTSettingItem settingItemWithTitle: @"退出帐号" image: [UIImage imageNamed: @"more_logout"] operationBlock: ^{
        
                                    [weakSelf presentViewController: weakSelf.loginC animated: YES completion: nil];
                                }],
                                
                            ]];
    }
    return _datas;
}

- (NSMutableArray *)titles
{
    if (_titles == nil)
    {
        _titles = [NSMutableArray array];
        
        [_titles addObjectsFromArray: @[@"个人中心", @"设置"]];
    }
    return _titles;
}

- (UIView *)headerContentView
{
    if (_headerContentView == nil)
    {
        // 1、headerView
        UIView *headerContentView = [UIView new];
        headerContentView.frame = CGRectMake(0, 0, WTScreenWidth, WTScreenHeight - WTTabBarHeight);
        [self.view addSubview: headerContentView];
        
        headerContentView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
        
        _headerContentView = headerContentView;
    }
    return _headerContentView;
}

- (UIView *)footerContentView
{
    if(_footerContentView == nil)
    {
        // 2、footerView
        UIView *footerContentView = [UIView new];
        footerContentView.layer.cornerRadius = 5;
        footerContentView.layer.masksToBounds = YES;
        footerContentView.frame = CGRectMake(0, moreHeaderViewH, WTScreenWidth, WTScreenHeight - moreHeaderViewH - WTTabBarHeight);
        [self.view addSubview: footerContentView];
        _footerContentView = footerContentView;
    }
    return _footerContentView;
}

- (WTMoreLoginHeaderView *)moreLoginHeaderView
{
    if (_moreLoginHeaderView == nil)
    {
        WTMoreLoginHeaderView *moreLoginHeaderView = [WTMoreLoginHeaderView moreLoginHeaderView];
        [self.headerContentView addSubview: moreLoginHeaderView];
        _moreLoginHeaderView = moreLoginHeaderView;
        moreLoginHeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(WTMoreHeaderViewBackgroundColor);
        moreLoginHeaderView.frame = CGRectMake(0, 0, WTScreenWidth, moreHeaderViewH);
    }
    return _moreLoginHeaderView;
}

- (WTMoreNotLoginHeaderView *)moreNotLoginHeaderView
{
    if (_moreNotLoginHeaderView == nil)
    {
        WTMoreNotLoginHeaderView *moreNotLoginHeaderView = [WTMoreNotLoginHeaderView moreNotLoginHeaderView];
        moreNotLoginHeaderView.frame = CGRectMake(0, 0, WTScreenWidth, moreHeaderViewH);
        [self.headerContentView addSubview: moreNotLoginHeaderView];
        moreNotLoginHeaderView.delegate = self;
        moreNotLoginHeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(WTMoreHeaderViewBackgroundColor);
        _moreNotLoginHeaderView = moreNotLoginHeaderView;
    }
    return _moreNotLoginHeaderView;
}

- (UIAlertController *)loginC
{
    if (_loginC == nil)
    {
        
        UIAlertController *loginC = [UIAlertController alertControllerWithTitle: @"提示" message: @"您确定要退出吗?" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle: @"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName: WTLoginStateChangeNotification object: nil];
            // 清除帐号
            [[WTAccountViewModel shareInstance] loginOut];
            [self viewWillAppear: YES];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"手滑了" style: UIAlertActionStyleCancel handler: nil];
        
        [loginC addAction: sureAction];
        [loginC addAction: cancelAction];

        _loginC = loginC;
    }
    return _loginC;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
