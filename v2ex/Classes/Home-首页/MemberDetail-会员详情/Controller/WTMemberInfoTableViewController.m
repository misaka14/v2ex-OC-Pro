//
//  WTMemberInfoTableViewController.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberInfoTableViewController.h"
#import "WTMemberItem.h"
#import "WTUserItem.h"
#import "UIImageView+WebCache.h"
@interface WTMemberInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (nonatomic, strong) WTMemberItem *memberItem;
@property (nonatomic, strong) WTUserItem *userItem;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageV;
@end

@implementation WTMemberInfoTableViewController
#pragma mark - Init
- (instancetype)init
{
    return [UIStoryboard storyboardWithName: NSStringFromClass([WTMemberInfoTableViewController class]) bundle: nil].instantiateInitialViewController;
}

/**
 快速创建的类方法
 
 @param memberItem v2ex用户信息
 @param userItem   misaka14用户信息
 
 @return    WTTMemberInfoViewController
 */
- (instancetype)initWithMemberItem:(WTMemberItem *)memberItem userItem:(WTUserItem *)userItem
{
    WTMemberInfoTableViewController *memberInfoVC = [WTMemberInfoTableViewController new];
    memberInfoVC.memberItem = memberItem;
    memberInfoVC.userItem = userItem;
    return memberInfoVC;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.avatarImageV sd_setImageWithURL: self.memberItem.avatarURL placeholderImage: WTIconPlaceholderImage];
    
    self.usernameLabel.text = self.memberItem.username;
    
    self.noteNameLabel.text = self.userItem.noteName;
    
    self.bioLabel.text = self.memberItem.bio;
    
    self.vipImageV.hidden = !self.userItem.isVip;
}

@end
