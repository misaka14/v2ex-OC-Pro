//
//  WTLoginViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTTipView.h"

#import "WTAccountViewModel.h"
#import "UIImage+Extension.h"

@interface WTLoginViewController ()
/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView    *bgImageV;
/** 用户名或邮箱 */
@property (weak, nonatomic) IBOutlet UIView *loginBgView;
@property (weak, nonatomic) IBOutlet UITextField    *usernameOrEmailTextField;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField    *passwordTextField;
/** 登陆按钮 */
@property (weak, nonatomic) IBOutlet UIButton       *loginButton;
/** 提示框View */
@property (nonatomic, weak) WTTipView               *tipView;

@property (nonatomic, strong) NSTimer               *timer;

@end

@implementation WTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 测试代码
    self.loginButton.userInteractionEnabled = YES;

    // 1、添加圆角
    self.loginButton.layer.cornerRadius = 3;
    
    // 2、添加正在编辑监听事件
    [self.usernameOrEmailTextField addTarget: self action: @selector(textFieldEditingChanged) forControlEvents: UIControlEventEditingChanged];
    [self.passwordTextField addTarget: self action: @selector(textFieldEditingChanged) forControlEvents: UIControlEventEditingChanged];
    
    self.title = @"帐号登录";
    
    self.loginBgView.layer.cornerRadius = 3;
    self.loginBgView.layer.masksToBounds = YES;
    
    // 3、为背景图片添加动画
    [self setBgImageVAnimation];
    
    [self timer];
}

/**
 *  为背景图片添加动画
 */
- (void)setBgImageVAnimation
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration: 15 delay: 0 options: 0 animations:^{
            
            self.bgImageV.transform = CGAffineTransformMakeScale(1.35, 1.35);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration: 15 delay: 1 options: 0 animations:^{
               
                self.bgImageV.transform = CGAffineTransformIdentity;
                
            } completion: nil];
            
        }];
        
    });
}

- (void)stopTimer
{
    [self.timer invalidate];
}

#pragma mark - 事件
#pragma mark 登陆
- (IBAction)loginButton:(UIButton *)sender
{
    [self.view endEditing: YES];
    [self.loginButton setTitle: @"登陆中..." forState: UIControlStateNormal];

    NSString *username = self.usernameOrEmailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[WTAccountViewModel shareInstance] getOnceWithUsername: username password: password success:^{
        
        [self closeButtonClick];
        
        if (self.loginSuccessBlock)
        {
            self.loginSuccessBlock();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName: WTLoginStateChangeNotification object: nil];
        
    } failure:^(NSError *error) {
        [self.loginButton setTitle: @"登陆" forState: UIControlStateNormal];
        if (error.code == 400 || error.code == -1011)
        {
            [self.tipView showErrorTitle: error.userInfo[@"message"]];
            return;
        }
        [self.tipView showErrorTitle: @"服务器异常，请稍候重试"];
    }];

}
#pragma mark 关闭
- (IBAction)closeButtonClick
{
    [self stopTimer];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)textFieldEditingChanged
{
    if (self.usernameOrEmailTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        self.loginButton.userInteractionEnabled = YES;
    }
    else
    {
        self.loginButton.userInteractionEnabled = NO;
    }
}

#pragma mark textFieldEditingChanged
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

#pragma mark - 懒加载
#pragma mark tipView
- (WTTipView *)tipView
{
    if (_tipView == nil)
    {
        WTTipView *tipView = [WTTipView wt_viewFromXib];
        [self.view addSubview: tipView];
        _tipView = tipView;
        
        tipView.frame = CGRectMake(0, -44, self.view.width, 44);
    }
    return _tipView;
}

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 31 target: self selector: @selector(setBgImageVAnimation) userInfo: nil repeats: YES];
    }
    return _timer;
}


- (void)dealloc
{
    WTLog(@"WTLoginViewController dealloc")
}
@end
