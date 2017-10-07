//
//  WTRegisterViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/4.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTRegisterViewController.h"
#import "NetworkTool.h"
#import "WTContinueRegisterReqItem.h"
#import "WTAccountViewModel.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "WTTipView.h"
#import "WTRegisterReqItem.h"
#import "NSString+YYAdd.h"
#import "WTPrivacyStatementViewController.h"

@interface WTRegisterViewController ()
/** 二维码图片 */
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *usernameTextF;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
/** 邮箱 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
/** 图片验证码 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
/** 登录 */
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;
/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phone_numberTextF;
/** 手机验证码 */
@property (weak, nonatomic) IBOutlet UITextField *phone_codeTextF;
@property (weak, nonatomic) IBOutlet UILabel *rightTipLabel;
/** 图片验证码TOPLayout约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeImageVTopLayoutCons;
/** 图片验证码的BGContentView */
@property (weak, nonatomic) IBOutlet UIView *codeImageVBgView;

/** 注册请求模型　*/
@property (nonatomic, strong) WTRegisterReqItem  *registerReqItem;
/** 提示框View */
@property (nonatomic, weak) WTTipView            *tipView;
/** leftView的leading约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewLeadingLayoutCons;
/** once */
@property (nonatomic, strong) NSString *once;
@end

@implementation WTRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // 1、加载请求参数
    [self loadResiterItemReq];
    
    // 2、设置view
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 自定义方法
#pragma mark 加载请求参数
- (void)loadResiterItemReq
{
    __weak typeof(self) weakSelf = self;
    [[WTAccountViewModel shareInstance] getRegisterReqItemWithSuccess:^(WTRegisterReqItem *item) {
        
        weakSelf.codeTextF.text = @"";
        weakSelf.registerReqItem = item;
        [weakSelf setupCodeImage];
        
    } failure:^(NSError *error) {
        
        if (error.code == 400 || error.code == -1011)
        {
            [weakSelf.tipView showErrorTitle: error.userInfo[@"errorInfo"]];
        }
        else
        {
            [weakSelf.tipView showErrorTitle: @"服务器异常，请稍候重试"];
        }
    }];
}

#pragma mark 设置验证码图片
- (void)setupCodeImage
{
    [[NetworkTool shareInstance] GETWithUrlString: self.registerReqItem.verificationCode success:^(NSData *data) {
        self.codeImageView.image = [UIImage imageWithData: data];

    } failure:^(NSError *error) {
        WTLog(@"getDataWithUrl Error:%@", error)
    }];
}

#pragma mark 设置View
- (void)setupView
{
    // 1、为 codeImageView 添加点击手势
    self.codeImageView.userInteractionEnabled = YES;
    [self.codeImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(imageViewClick)]];
    
    self.loginButton.layer.cornerRadius = 3;
}

- (void)startAnimation
{
    [UIView animateWithDuration: 0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 事件
#pragma mark 关闭按钮点击
- (IBAction)closeButtonClick
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark 登陆按钮点击
- (IBAction)loginButtonClick
{
    // 1、检验
    NSString *username = self.usernameTextF.text;
    NSString *password = self.passwordTextF.text;
    NSString *email = self.emailTextF.text;
    NSString *phone_number = self.phone_numberTextF.text;
    NSString *verificationCode = self.codeTextF.text;

    if ([username stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"用户名不能为空"];
        return;
    }
    
    if ([password stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"密码不能为空"];
        return;
    }
    
    if ([email stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"邮箱不能为空"];
        return;
    }
    
    if ([phone_number stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"手机号不能为空"];
        return;
    }
    
    if ([verificationCode stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"验证码不能为空"];
        return;
    }
    
    // 2、发起请求
    [SVProgressHUD show];

    self.registerReqItem.usernameValue = username;
    self.registerReqItem.passwordValue = password;
    self.registerReqItem.emailValue = email;
    self.registerReqItem.verificationCodeValue = verificationCode;
    self.registerReqItem.phone_numberValue = phone_number;
    
    __weak typeof(self) weakSelf = self;
    [[WTAccountViewModel shareInstance] registerWithRegisterReqItem: self.registerReqItem success:^(NSString *once) {
        
        weakSelf.once = once;
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        WTLog(@"error:%@", error)
        if (error.code == 400 || error.code == -1011)
        {
            [self.tipView showErrorTitle: error.userInfo[@"errorInfo"]];
        }
        else
        {
            [self.tipView showErrorTitle: @"服务器异常，请稍候重试"];
        }
        
        [self loadResiterItemReq];
    }];
    
}
#pragma mark - 继续按钮
- (IBAction)continueBtnClick
{
    NSString *code = self.phone_codeTextF.text;
    if ([code stringByTrim].length == 0)
    {
        [SVProgressHUD showErrorWithStatus: @"验证码不能为空"];
        return;
    }
    if (self.once == nil)
    {
        [SVProgressHUD showErrorWithStatus: @"服务器异常，请稍候重试"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    WTContinueRegisterReqItem *item = [[WTContinueRegisterReqItem alloc] initWithOnce: self.once code: code];
    [[WTAccountViewModel shareInstance] continueRegisterWithContinueRegisterReqItem: item success:^{
        
        [weakSelf.tipView showSuccessTitle: @"注册成功"];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error.code == 400 || error.code == -1011)
        {
            [self.tipView showErrorTitle: error.userInfo[@"errorInfo"]];
        }
        else
        {
            [self.tipView showErrorTitle: @"服务器异常，请稍候重试"];
        }
        
    }];
}
#pragma mark - 隐私按钮点击
- (IBAction)privacyButtonClick
{
    [self presentViewController: [WTPrivacyStatementViewController new] animated: YES  completion: nil];
}

#pragma mark 验证码图片点击
- (void)imageViewClick
{
    // 设置验证码图片
    [self setupCodeImage];
}
#pragma mark - 图片验证码开始编辑
- (IBAction)codeTextFEditingDidBegin
{
    self.codeImageVBgView.hidden = NO;
    self.codeImageVTopLayoutCons.constant = -120;
    [self startAnimation];
}

#pragma mark - 图片验证码结束编辑
- (IBAction)codeTextFEditingDidEnd:(id)sender
{
    self.codeImageVBgView.hidden = YES;
    self.codeImageVTopLayoutCons.constant = 20;
    [self startAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

#pragma mark - 懒加载
- (WTTipView *)tipView
{
    if (_tipView == nil)
    {
        WTTipView *tipView = [WTTipView wt_viewFromXib];
        //[self.navigationController.navigationBar insertSubview: tipView atIndex: 0];
        [[UIApplication sharedApplication].keyWindow addSubview: tipView];
        _tipView = tipView;
        
        tipView.frame = CGRectMake(0, -44, self.view.width, 44);
    }
    return _tipView;
}

#pragma mark - Setter
- (void)setOnce:(NSString *)once
{
    _once = once;
    self.rightTipLabel.text = [NSString stringWithFormat: @"我们向您刚刚提交的手机号码 +86 %@ 发送了验证码", self.phone_numberTextF.text];
    self.leftViewLeadingLayoutCons.constant = -WTScreenWidth;
    [self startAnimation];
}

@end
