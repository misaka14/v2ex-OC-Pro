//
//  WTWebViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/15.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTWebViewController.h"
#import <WebKit/WebKit.h>
#import "WTShareSDKTool.h"
#import "UIBarButtonItem+Extension.h"
#import "MarqueeLabel.h"
#import "Masonry.h"

#define WTEstimatedProgress @"estimatedProgress"
#define WTCanGoBack @"canGoBack"
#define WTCanGoForward @"canGoForward"
#define WTTitle @"title"

@interface WTWebViewController ()
@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) MarqueeLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
@implementation WTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、创建webView
    [self setupWebView];
    
    self.prevBtn.enabled = NO;
    self.nextBtn.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createShareItemWithTarget: self action: @selector(shareClick)];
}


#pragma mark - 创建webView
- (void)setupWebView
{
    WKWebView *webView = [[WKWebView alloc] init];
    
    [self.contentView addSubview: webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    self.webView = webView;
    
    // 2、加载请求
    [webView loadRequest: [NSURLRequest requestWithURL: self.url]];
    
    // 3、为进度条、是否可以返回、是否可以前进、标题 添加通知
    [webView addObserver: self forKeyPath: WTEstimatedProgress options: NSKeyValueObservingOptionNew context: nil];
    [webView addObserver: self forKeyPath: WTCanGoBack options: NSKeyValueObservingOptionNew context: nil];
    [webView addObserver: self forKeyPath: WTCanGoForward options: NSKeyValueObservingOptionNew context: nil];
    [webView addObserver: self forKeyPath: WTTitle options: NSKeyValueObservingOptionNew context: nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString: WTEstimatedProgress])
    {
    
        self.progressView.progress = self.webView.estimatedProgress;
        self.progressView.hidden = self.webView.estimatedProgress >= 1.0;
    }
    else if([keyPath isEqualToString: WTCanGoBack])
    {
        self.prevBtn.enabled = self.webView.canGoBack;
    }
    else if([keyPath isEqualToString: WTCanGoForward])
    {
        self.nextBtn.enabled = self.webView.canGoForward;
    }
    else if([keyPath isEqualToString: WTTitle])
    {
        self.titleLabel.text = self.webView.title;
    }
}
#pragma mark - 事件
- (IBAction)refreshBtnClick
{
    [self.webView reload];
}
- (IBAction)prevBtnClick
{
    [self.webView goBack];
    self.nextBtn.enabled = YES;
}
- (IBAction)nextBtnClick
{
    [self.webView goForward];
    self.prevBtn.enabled = YES;
}
- (void)shareClick
{
    [WTShareSDKTool shareWithText: @"" url: self.url.absoluteString title: @""];
}

- (void)dealloc
{
    WTLog(@"WTWebViewViewController dealloc")
    [self.webView removeObserver: self forKeyPath: WTEstimatedProgress];
    [self.webView removeObserver: self forKeyPath: WTCanGoBack];
    [self.webView removeObserver: self forKeyPath: WTCanGoForward];
    [self.webView removeObserver: self forKeyPath: WTTitle];
}

#pragma mark - Lazy Method
- (MarqueeLabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        MarqueeLabel *titleLabel = [[MarqueeLabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.scrollDuration = 15;
        titleLabel.fadeLength = 30;
        titleLabel.width = WTScreenWidth - 100;
        titleLabel.height = 30;
        _titleLabel = titleLabel;
        self.navigationItem.titleView = titleLabel;
    }
    return _titleLabel;
}
@end
