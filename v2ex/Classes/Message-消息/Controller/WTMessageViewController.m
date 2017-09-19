//
//  WTMessageViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMessageViewController.h"
#import "WTConversationListViewController.h"
#import "WTLoginViewController.h"
#import "WTMemberDetailViewController.h"
#import "WTProgressHUD.h"

#import "WTAccountViewModel.h"
#import "NSString+YYAdd.h"
@interface WTMessageViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak) WTConversationListViewController *conversationListVC;
@end

@implementation WTMessageViewController

- (instancetype)init
{
    return [UIStoryboard storyboardWithName: NSStringFromClass([WTMessageViewController class]) bundle: nil].instantiateInitialViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if ([WTAccountViewModel shareInstance].isMasakaLogin)
    {
        [self showMessageView];
    }
    else
    {
        self.emptyView.hidden = NO;
        self.contentView.hidden = YES;
    }
}

- (void)initView
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 10, WTScreenWidth - 20, 40)];
    searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    [searchBar setValue:[UIColor greenColor] forKeyPath:@"_searchField._placeholderLabel.textColor"];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入用户昵称";
    self.navigationItem.titleView = searchBar;
    
}

- (void)showMessageView
{
    [self conversationListVC];
    self.contentView.hidden = NO;
    self.emptyView.hidden = YES;
}

#pragma mark - 事件
- (IBAction)loginBtnClick:(id)sender
{
    __weak typeof (self) weakSelf = self;
    WTLoginViewController *loginVC = [WTLoginViewController new];
    loginVC.loginSuccessBlock = ^{
        [weakSelf showMessageView];
        [weakSelf dismissViewControllerAnimated: YES completion: nil];
    };
    [self presentViewController: loginVC animated: YES completion: nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *username = [searchBar.text stringByTrim];
    
    // 检验-> 不允许用户输入中文
    if (![username matchesRegex: @"^[A-Za-z0-9]" options: NSRegularExpressionCaseInsensitive])
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"只能输入英文和数字"];
        return;
    }
    
    
    if (username.length == 0) {
        return;
    }
    
    WTMemberDetailViewController *memberDetailVC = [[WTMemberDetailViewController alloc] initWithUsername: username];
    [self.navigationController pushViewController: memberDetailVC animated: YES];
}

- (void)rightBarButtonItemClick
{
    [self presentViewController: [UIViewController new] animated: YES completion: nil];
}

#pragma mark - Lazy Method
- (WTConversationListViewController *)conversationListVC
{
    if (_conversationListVC == nil) {
        WTConversationListViewController *conversationListVC = [WTConversationListViewController new];
        conversationListVC.view.frame = self.contentView.bounds;
        [self addChildViewController: conversationListVC];
        [self.contentView addSubview: conversationListVC.view];
        
        _conversationListVC = conversationListVC;
    }
    return _conversationListVC;
}

@end
