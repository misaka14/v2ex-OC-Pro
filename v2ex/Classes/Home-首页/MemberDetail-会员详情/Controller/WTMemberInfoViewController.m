//
//  WTTMemberInfoViewController.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberInfoViewController.h"
#import "WTConversationViewController.h"
#import "WTMemberInfoTableViewController.h"

#import "WTMemberItem.h"
#import "WTUserItem.h"

#import "UIViewController+Extension.h"


@interface WTMemberInfoViewController ()

@property (nonatomic, strong) WTMemberItem *memberItem;
@property (nonatomic, strong) WTUserItem *userItem;
/** 发送按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end

@implementation WTMemberInfoViewController

#pragma mark - Init
+ (instancetype)memberInfoVC
{
    return [UIStoryboard storyboardWithName: NSStringFromClass([WTMemberInfoViewController class]) bundle: nil].instantiateInitialViewController;
}

/**
 快速创建的类方法
 
 @param memberItem v2ex用户信息
 @param userItem   misaka14用户信息
 
 @return    WTTMemberInfoViewController
 */
- (instancetype)initWithMemberItem:(WTMemberItem *)memberItem userItem:(WTUserItem *)userItem
{
    WTMemberInfoViewController *memberInfoVC = [WTMemberInfoViewController memberInfoVC];
    memberInfoVC.memberItem = memberItem;
    memberInfoVC.userItem = userItem;
    return memberInfoVC;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
}

- (void)initView
{
    // 设置导航栏的View
    [self setTempNavImageView];
    
    self.title = @"详细资料";
    
    // 如果用户并没有用v2ex客户端登陆过，那就不能聊天
    if (!self.userItem.uid)
    {
        self.sendBtn.hidden = YES;
    }
    
    // 用户信息的tableView
    WTMemberInfoTableViewController *memberInfoTableVC = [[WTMemberInfoTableViewController alloc] initWithMemberItem: self.memberItem userItem: self.userItem];
    [self addChildViewController: memberInfoTableVC];
    memberInfoTableVC.view.frame = self.view.bounds;
    [self.view insertSubview: memberInfoTableVC.view atIndex: 0];
    
    self.sendBtn.backgroundColor = WTLightColor;
}

#pragma mark - 事件
// 发送消息
- (IBAction)sendBtnClick
{
//    WTConversationViewController *conversationVC = [[WTConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat: @"%lu", self.userItem.uid]];
//    conversationVC.title = self.userItem.username;
//    [self.navigationController pushViewController: conversationVC animated: YES];
}

@end
