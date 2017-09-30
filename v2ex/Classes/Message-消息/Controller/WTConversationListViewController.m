//
//  WTConversationListViewController.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTConversationListViewController.h"
#import "WTConversationViewController.h"
#import "WTMemberDetailViewController.h"
#import "UIViewController+Extension.h"
@interface WTConversationListViewController ()

@end

@implementation WTConversationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    
    
    //设置需要显示哪些类型的会话
//    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
//    self.conversationListTableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    // 设置导航栏背景图片
    [self setNavBackgroundImage];
}
//
///*!
// 点击Cell头像的回调
// 
// @param model   会话Cell的数据模型
// */
//- (void)didTapCellPortrait:(RCConversationModel *)model
//{
//    WTMemberDetailViewController *memberInfoVC = [[WTMemberDetailViewController alloc] initWithUsername: model.conversationTitle];
//    [self.navigationController pushViewController: memberInfoVC animated: YES];
//}
//
////重写RCConversationListViewController的onSelectedTableRow事件
//- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
//{
//    WTConversationViewController  *conversationVC = [[WTConversationViewController alloc] initWithConversationType: model.conversationType targetId: model.targetId];
//    conversationVC.title = model.conversationTitle;
//    [self.navigationController pushViewController:conversationVC animated:YES];
//}

@end
