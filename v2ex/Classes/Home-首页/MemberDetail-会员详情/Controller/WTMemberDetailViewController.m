//
//  WTMemberDetailViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  会员详情控制器

#import "WTMemberDetailViewController.h"
#import "WTMemberTopicViewController.h"
#import "WTMemberReplyViewController.h"
#import "WTMemberInfoViewController.h"

#import "WTAccountViewModel.h"
#import "WTMemberTopicViewModel.h"
#import "WTTopicDetailViewModel.h"

#import "UIImage+Extension.h"

#import "UIImageView+WebCache.h"
#import "POP.h"

@interface WTMemberDetailViewController ()

@property (nonatomic, strong) WTMemberTopicViewModel *memberTopicVM;

@property (nonatomic, weak) WTMemberTopicViewController *memberTopicVC;
@property (nonatomic, weak) WTMemberReplyViewController *memberReplyVC;

@property (nonatomic, strong) WTUserItem *userItem;

@property (nonatomic, strong) NSString *author;

@property (nonatomic, strong) NSURL    *iconURL;

/** 放大缩小动画 */
@property (nonatomic, strong) POPSpringAnimation *scaleAnim;
/** 透明动画 */
@property (nonatomic, strong) POPBasicAnimation *alphaAnim;

@property (nonatomic, weak) UIButton *personIconBtn;

@end

@implementation WTMemberDetailViewController

#pragma mark - init
- (instancetype)initWithtopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    WTMemberDetailViewController *memeberDetailVC = [WTMemberDetailViewController new];
    memeberDetailVC.author = topicDetailVM.topicDetail.author;
    memeberDetailVC.iconURL = topicDetailVM.iconURL;
    return memeberDetailVC;
}

- (instancetype)initWithTopic:(WTTopic *)topic
{
    WTMemberDetailViewController *memeberDetailVC = [WTMemberDetailViewController new];
    memeberDetailVC.author = topic.author;
    memeberDetailVC.iconURL = topic.iconURL;
    return memeberDetailVC;
}

- (instancetype)initWithUsername:(NSString *)username
{
    WTMemberDetailViewController *memeberDetailVC = [WTMemberDetailViewController new];
    memeberDetailVC.author = username;
    return memeberDetailVC;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.personIconBtn.frame = self.personIconView.frame;
}

- (void)initView
{
    if (self.iconURL)
    {
        // 设置个人头像
        [self.personIconView sd_setImageWithURL: self.iconURL placeholderImage: WTIconPlaceholderImage];
    }
    
    self.tabBar.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    
    self.usernameLabel.text = self.author;
    self.detailLabel.alpha = 0;
    self.personIconView.alpha = 0;
    self.usernameLabel.alpha = 0;
    [self.personIconBtn addTarget: self action: @selector(personIconBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    // 1、添加主题控制器
    WTMemberTopicViewController *memberTopicVC = [[WTMemberTopicViewController alloc] init];
    memberTopicVC.title = @"主题";
    memberTopicVC.author = self.author;
    memberTopicVC.iconURL = self.iconURL;
    self.memberTopicVC = memberTopicVC;
    [self addChildViewController: memberTopicVC];
    
    // 2、添加回复控制器
    WTMemberReplyViewController *memberReplyVC = [[WTMemberReplyViewController alloc] init];
    memberReplyVC.title = @"回复";
    memberReplyVC.author = self.author;
    self.memberReplyVC = memberReplyVC;
    [self addChildViewController: memberReplyVC];
    
}

- (void)initData
{
    self.memberTopicVM = [WTMemberTopicViewModel new];
    
    __weak typeof(self) weakSelf = self;
    [self.memberTopicVM getMemberItemWithUsername: self.author success:^{
        
        [weakSelf setMemberDetailInfo];
        
    } failure:^(NSError *error) {
        if (error.code == -1011)
        {
            [weakSelf setNoExistsMemberInfo];
        }
    }];
    
    WTUserItem *userItem = [WTUserItem new];
    userItem.username = @"misaka15";
    [WTAccountViewModel getUserInfoFromMisaka14WithUserItem: userItem success:^(WTUserItem *resultUserItem){
        
        [weakSelf setVipWithUserItem: resultUserItem];
        
    } failure:^(NSError *error) {
        
    }];
}

// 设置用户详细信息
- (void)setMemberDetailInfo
{
    if (!self.iconURL) {
        // 设置个人头像
        [self.personIconView sd_setImageWithURL: self.memberTopicVM.memberItem.avatarURL placeholderImage: WTIconPlaceholderImage];
        self.memberTopicVC.iconURL = self.memberTopicVM.memberItem.avatarURL;
        [self.memberTopicVC reloadAvatar];
    
    }
    
//    self.memberTopicVM.memberItem.avatarURL = self.iconURL;
//    self.memberTopicVM.memberItem.username = self.author;
    self.detailLabel.text = self.memberTopicVM.memberItem.detail;
    [self.detailLabel sizeToFit];
    
    [self startAnim];
}

// 设置不存在的用户信息
- (void)setNoExistsMemberInfo
{
    self.usernameLabel.text = WTNoExistMemberTip;
    self.detailLabel.hidden = YES;
    self.personIconBtn.userInteractionEnabled = NO;
    
 
    [self startAnim];
}

// 开始动画
- (void)startAnim
{
    [self.detailLabel pop_addAnimation: self.scaleAnim forKey: kPOPViewScaleXY];
    [self.detailLabel pop_addAnimation: self.alphaAnim forKey: kPOPViewAlpha];
    
    [self.usernameLabel pop_addAnimation: self.scaleAnim forKey:kPOPViewScaleXY];
    [self.usernameLabel pop_addAnimation: self.alphaAnim forKey: kPOPViewAlpha];
    
    [self.personIconView pop_addAnimation: self.scaleAnim forKey: kPOPViewScaleXY];
    [self.personIconView pop_addAnimation: self.alphaAnim forKey: kPOPViewAlpha];
}

// 设置用户Vip信息
- (void)setVipWithUserItem:(WTUserItem *)userItem
{
    self.userItem = userItem;
    
    // 是VIP
    if (userItem.isVip)
    {
        self.vipImageV.hidden = NO;
        [self.vipImageV pop_addAnimation: self.scaleAnim forKey: kPOPViewScaleXY];
        [self.vipImageV pop_addAnimation: self.alphaAnim forKey: kPOPViewAlpha];
        self.memberReplyVC.author = WTNoExistMemberTip;
    }
}

#pragma mark - 事件
- (void)personIconBtnClick
{
    WTMemberInfoViewController *memberInfoVC = [[WTMemberInfoViewController alloc] initWithMemberItem: self.memberTopicVM.memberItem userItem: self.userItem];
    [self.navigationController pushViewController: memberInfoVC animated: YES];
}


#pragma mark - Lazy Method
- (POPSpringAnimation *)scaleAnim
{
    if (_scaleAnim == nil)
    {
        POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed: kPOPViewScaleXY];
        scaleAnim.springSpeed = 5;
        scaleAnim.springBounciness = 10;
        scaleAnim.fromValue = [NSValue valueWithCGPoint: CGPointMake(1.5, 1.5)];
        scaleAnim.toValue = [NSValue valueWithCGPoint: CGPointMake(1.0, 1.0)];
        
        _scaleAnim = scaleAnim;
    }
    return _scaleAnim;
}

- (POPBasicAnimation *)alphaAnim
{
    if (_alphaAnim == nil)
    {
        POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
        alphaAnim.duration = 0.5;
        alphaAnim.toValue = @1.0;
        
        _alphaAnim = alphaAnim;
    }
    return _alphaAnim;
}

- (UIButton *)personIconBtn
{
    if (_personIconBtn == nil)
    {
        UIButton *personIconBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        
        [self.headerView addSubview: personIconBtn];
        _personIconBtn = personIconBtn;
    }
    return _personIconBtn;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
