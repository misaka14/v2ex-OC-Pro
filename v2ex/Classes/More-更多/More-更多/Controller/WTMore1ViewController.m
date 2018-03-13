//
//  WTMore1ViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2018/3/13.
//  Copyright © 2018年 无头骑士 GJ. All rights reserved.
//

#import "WTMore1ViewController.h"

#import "WTWebViewController.h"
#import "WTLoginViewController.h"
#import "WTThemeViewController.h"
#import "WTTopicViewController.h"
#import "WTMyTopicViewController.h"
#import "WTMyReplyViewController.h"
#import "WTV2GroupViewController.h"
#import "WTRegisterViewController.h"
#import "WTMyFollowingViewController.h"
#import "WTPublishTopicViewController.h"
#import "WTNodeCollectionViewController.h"
#import "WTTopicCollectionViewController.h"
#import "WTPrivacyStatementViewController.h"

#import "UIViewController+Extension.h"

#import "WTMoreUserInfoCell.h"

#import "WTSettingItem.h"
#import "WTAccountViewModel.h"

static NSString * const WTMoreUserInfoCellIdentifier = @"WTMoreUserInfoCellIdentifier";
static NSString * const WTDefaultMoreCellIdentifier = @"WTDefaultMoreCellIdentifier";

@interface WTMore1ViewController () <UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic, weak) UITableView                            *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray *>            *datas;

@property (nonatomic, strong) WTSettingItem                        *userInfoSettingItem;

@end

@implementation WTMore1ViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
    
    [self initData];
    
    [self initNoti];
}


#pragma mark - Private Method
- (void)initView
{
    [self navViewWithTitle: @"更多" hideBack: YES];
    
    self.tableView.sectionHeaderHeight = 3;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: WTDefaultMoreCellIdentifier];
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTMoreUserInfoCell class]) bundle: nil] forCellReuseIdentifier: WTMoreUserInfoCellIdentifier];
}

- (void)initData
{
    [self.tableView reloadData];
}



- (void)initNoti
{
    // 1、登陆状态变更通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loadData) name: WTLoginStateChangeNotification object: nil];
}

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

// 返回用户信息的设置模型
- (WTSettingItem *)userInfoSettingItems
{
    // 4、判断是否登录，添加不同的headerView
    __weak typeof(self) weakSelf = self;
    if ([[WTAccountViewModel shareInstance] isLogin])
    {
        WTAccount *account = [WTAccountViewModel shareInstance].account;
        
        self.userInfoSettingItem = [WTSettingItem settingItemWithTitle: account.usernameOrEmail image: WTIconPlaceholderImage imageUrl: account.avatarURL operationBlock:^{
            
        }];
    }
    else
    {
        self.userInfoSettingItem = [WTSettingItem settingItemWithTitle: @"登录" image: WTIconPlaceholderImage operationBlock:^{
            [weakSelf presentViewController: [WTLoginViewController new] animated: YES completion: nil];
        }];
    
    }
    return self.userInfoSettingItem;
}

- (void)loadData
{
    // 更新用户的cell的信息
    [self userInfoSettingItems];
    
    // 刷新用户的cell的信息
    [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMoreUserInfoCell *cell = nil;
    WTSettingItem *item = self.datas[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: WTMoreUserInfoCellIdentifier];
        cell.item = item;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier: WTDefaultMoreCellIdentifier];
        
        cell.imageView.image = item.image;
        
        cell.textLabel.text = item.title;
        
        cell.textLabel.textColor = [UIColor colorWithHexString: @"#444444"];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 80 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTSettingItem *item = self.datas[indexPath.section][indexPath.row];
    if (item.operationBlock) item.operationBlock();
}


#pragma mark - Lazy
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStyleGrouped];
        tableView.y = WTNavigationBarMaxY;
        [self.view addSubview: tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray<NSArray *> *)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray array];
        
        __weak typeof(self) weakSelf = self;
        
        [_datas addObject: @[
                                [self userInfoSettingItems]
                            ]
         ];
        
        [_datas addObject: @[
                             [WTSettingItem settingItemWithTitle: @"发表帖子" image: [UIImage imageNamed: @"more_publishTopic"] operationBlock: ^{
            
            
                                [weakSelf checkIsLoginWithViewController: [WTPublishTopicViewController new]];
                            }],
                             
                             
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
                             [WTSettingItem settingItemWithTitle: @"设置" image: [UIImage imageNamed: @"more_system"] operationBlock: ^{
            
            
                                }],
                             
                             [WTSettingItem settingItemWithTitle: @"关于" image: [UIImage imageNamed: @"more_about"] operationBlock: ^{

                                }],

                             
                             ]];
    }
    return _datas;
}

@end
