//
//  WTPrivacyStatementViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  隐私声明 

#import "WTPrivacyStatementViewController.h"
#import "UIViewController+Extension.h"
#import "SVProgressHUD.h"
@interface WTPrivacyStatementViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation WTPrivacyStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1、导航栏
    [self navViewWithTitle: @"隐私说明"];
    
    // 2、加载网页
    NSURL *url = [NSURL URLWithString: @"http://www.misaka14.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
    
    // 3、判断是否隐藏关闭按钮
    if (self.navigationController)
    {
        self.closeButton.hidden = YES;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

#pragma mark - 事件
- (IBAction)closeButtonClick
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
}
@end
