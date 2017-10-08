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
    
    [self.registerBtn dk_setTitleColorPicker: DKColorPickerWithKey(WTMoreRegisterTextColor) forState: UIControlStateNormal];
    self.registerBtn.dk_backgroundColorPicker =  DKColorPickerWithKey(WTMoreRegisterBackgroundColor);
    self.registerBtn.layer.cornerRadius = 3;
    
    [self.loginBtn dk_setTitleColorPicker: DKColorPickerWithKey(WTMoreLoginTextColor) forState: UIControlStateNormal];
    self.loginBtn.dk_backgroundColorPicker =  DKColorPickerWithKey(WTMoreLoginBackgroundColor);
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
