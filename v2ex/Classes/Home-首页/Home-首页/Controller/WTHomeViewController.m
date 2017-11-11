//
//  LBBHomeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  首页控制器

#import "WTHomeViewController.h"
#import "WTTopicDetailViewController.h"
#import "WTLoginViewController.h"

#import "WTAccountViewModel.h"
#import "WTLogin2FARequestItem.h"

#import "WTURLConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+Extension.h"

#import "MJExtension.h"

@interface WTHomeViewController ()  
/** WTNode数组*/
@property (nonatomic, strong) NSArray<WTNode *>             *nodes;
@end

@implementation WTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // 添加子控制器
    [self setupAllChildViewControllers];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    // 注册通知
    [self initNoti];
}

#pragma mark 添加子控制器
- (void)setupAllChildViewControllers
{
    for (WTNode *node in self.nodes)
    {
        WTTopicViewController *topicVC = [WTTopicViewController new];
        topicVC.title = node.name;
        topicVC.urlString = [WTHTTPBaseUrl stringByAppendingString: node.nodeURL];
        [self addChildViewController: topicVC];
    }
}
#pragma mark 注册通知
- (void)initNoti
{
    // 1、二次登录的通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(twoStepAuth:) name: WTTwoStepAuthNSNotification object: nil];
}

#pragma mark 事件
- (void)twoStepAuth:(NSNotification *)noti
{
    NSString *once = [noti.userInfo objectForKey: WTTwoStepAuthWithOnceKey];
    
    WTLoginViewController *loginVC = [WTLoginViewController new];
    
    // 两次登录的请求参数
    WTAccount *account = [WTAccountViewModel shareInstance].account;
    WTLogin2FARequestItem *item = [[WTLogin2FARequestItem alloc] initWithOnce: once usernameOrEmail: account.usernameOrEmail password: account.password];
    loginVC.twoFArequestItem = item;
    // 请求成功Block
    __weak typeof (self) weakSelf = self;
    loginVC.loginSuccessBlock = ^{
        [weakSelf reloadSelectedVCData];
    };
    [self presentViewController: loginVC animated: YES completion: nil];
}


#pragma mark - Lazy method
#pragma mark nodes
- (NSArray<WTNode *> *)nodes
{
    if (_nodes == nil)
    {
        _nodes = [WTNode mj_objectArrayWithFilename: @"nodes.plist"];
    }
    return _nodes;
}

@end
