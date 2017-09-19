//
//  WTMoreNotLoginHeaderView.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/27.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMoreNotLoginHeaderView.h"
#import "WTConst.h"
@interface WTMoreNotLoginHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *registerBtn; /** 注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;    /** 登录按钮 */

@end
@implementation WTMoreNotLoginHeaderView

#pragma mark - init
+ (instancetype)moreNotLoginHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed: @"WTMoreNotLoginHeaderView" owner: nil options: nil].lastObject;
}

#pragma mark - LifeCycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    [self.registerBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.registerBtn.backgroundColor = [UIColor colorWithHexString: @"#FAFAFA" alpha: 0.2];
    self.registerBtn.layer.cornerRadius = 3;
    
    [self.loginBtn setTitleColor: [UIColor colorWithHexString: WTAppLightColor] forState: UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    self.loginBtn.layer.cornerRadius = 3;
    
}

#pragma mark - 事件
#pragma mark 注册
- (IBAction)registerBtnClick
{
    if ([self.delegate respondsToSelector: @selector(moreNotLoginHeaderViewDidClickedRegisterBtn:)])
    {
        [self.delegate moreNotLoginHeaderViewDidClickedRegisterBtn: self];
    }
}
#pragma mark 登录
- (IBAction)loginBtnClick
{
    if ([self.delegate respondsToSelector: @selector(moreNotLoginHeaderViewDidClickedLoginBtn:)])
    {
        [self.delegate moreNotLoginHeaderViewDidClickedLoginBtn: self];
    }
}

@end
