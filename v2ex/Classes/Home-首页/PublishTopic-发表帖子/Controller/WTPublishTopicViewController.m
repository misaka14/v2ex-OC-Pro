//
//  WTPublishTopicViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTPublishTopicViewController.h"
#import "WTTopicDetailViewController.h"
#import "WTAllNodeViewController.h"

#import <WebKit/WebKit.h>

#import "WTNodeItem.h"
#import "WTPublishTopicViewModel.h"

#import "WTURLConst.h"
#import "NetworkTool.h"

#import "NSString+YYAdd.h"

#import "WTProgressHUD.h"
#import "UITextView+Placeholder.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+Extension.h"

#import "Masonry.h"

static NSString *const WTLeftBarBtnItemWithEdit = @"编辑器";

static NSString *const WTLeftBarBtnItemWithPreview = @"实时预览";

static NSString *const WTPreviewAppName = @"WTPreviewAppName";

static NSString *const WTPublishTopicAppName = @"WTPublishTopicAppName";

static CGFloat const WTContentWebViewTopLayoutCons = 84;

@interface WTPublishTopicViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
/** 标题 */
@property (weak, nonatomic) IBOutlet UITextField *titleTextF;
/** 正文 */
@property (weak, nonatomic) WKWebView *contentWebView;
/** 预览 */
@property (weak, nonatomic) WKWebView *previewWebView;
/** 实时预览、编辑器按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarBtnItem;
/** 选择节点按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectNodeBtn;
/** 当前选择的模型 */
@property (nonatomic, strong) WTNodeItem *nodeItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectNodeBtnTopLayoutCons;
@property (weak, nonatomic) IBOutlet UITextField *topicTitleTextF;
@end

@implementation WTPublishTopicViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    // 1、移除handlers
    [self.contentWebView.configuration.userContentController removeScriptMessageHandlerForName: WTPreviewAppName];
}

#pragma mark - Private
- (void)initView
{
    self.selectNodeBtnTopLayoutCons.constant = WTNavigationBarMaxY + 8;
    
    // 1、contentWebView
    {
        // 0、配置config
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler: self name: WTPreviewAppName];
        [config.userContentController addScriptMessageHandler: self name: WTPublishTopicAppName];
        
        // 1、初始化
        WKWebView *webView = [[WKWebView alloc] initWithFrame: CGRectZero configuration: config];
        [self.view addSubview: webView];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(WTNavigationBarMaxY + WTContentWebViewTopLayoutCons);
            make.bottom.offset(-50);
        }];
        
        self.contentWebView = webView;
        
        // 2、加载网页
        [self.contentWebView loadHTMLString: [self publishTopicHTML] baseURL: [NSURL URLWithString: WTHTTP]];
    }
    
    // 2、previewWebView
    {
        WKWebView *webView = [[WKWebView alloc] init];
        [self.view addSubview: webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.equalTo(self.contentWebView).offset(0);
            make.top.equalTo(self.view.mas_bottom).offset(0);
        }];
        
        self.previewWebView = webView;
    }
    
    // 3、标题
    [self navViewWithTitle: @"发表帖子"];
}

#pragma mark 发表帖子
- (NSString *)publishTopicHTML
{
    NSString *publishTopicHTMLPath = [[NSBundle mainBundle] pathForResource: @"publishtopic.html" ofType: nil];
    return [NSString stringWithContentsOfFile: publishTopicHTMLPath encoding: NSUTF8StringEncoding error: nil];
}

#pragma mark JS->OC 预览
- (void)JSToOCPreviewWithMarkdown:(NSString *)markdown
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"md" : markdown};
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        WTLog(@"cookie:%@", cookie)
        
    }
    [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypePOST url: @"https://www.v2ex.com/preview/markdown" param: param success:^(id responseObject) {

        [weakSelf sendMarkdownSuccessBlockWithResponseObject: responseObject];

    } failure:^(NSError *error) {

    }];
}


#pragma mark 发送markdown预览请求成功的回调
- (void)sendMarkdownSuccessBlockWithResponseObject:(id)responseObject
{
    NSString *cssPath = [[NSBundle mainBundle] pathForResource: @"light.css" ofType: nil];
    NSString *css = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
    NSString *highlightJsPath = [[NSBundle mainBundle] pathForResource: @"highlight.js" ofType: nil];
    NSString *highlightJs = [NSString stringWithContentsOfFile: highlightJsPath encoding: NSUTF8StringEncoding error: nil];
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString: @"<!DOCTYPE html><html><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\"><head><title></title>"];
    [html appendString: css];
    [html appendString: highlightJs];
    [html appendString: @"</head><body><div class=\"cell\"><div class=\"topic_content\"><div class=\"markdown_body\">"];
    NSString *content = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
    [html appendString: content];
    [html appendString: @"</div></div><script>hljs.initHighlightingOnLoad();</script></div>"];
    [html appendString: @"</body></html>"];
    [self.previewWebView loadHTMLString: html baseURL: nil];
    
    
    [self.previewWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentWebView).offset(0);
    }];
    
    [self.view layoutIfNeeded];
    
    self.leftBarBtnItem.title = WTLeftBarBtnItemWithEdit;
    
}

- (void)JSToOCPubliskTopicWithMarkdown:(NSString *)markdown
{
    if ([markdown stringByTrim].length == 0)
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"请输入正文"];
        return;
    }
    
    if (self.nodeItem == nil)
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"请选择节点"];
        return;
    }
    
    NSString *title = self.topicTitleTextF.text;

    
    __weak typeof (self) weakSelf = self;
    void(^successBlock)(NSString *) = ^(NSString *topicDetailUrl){
        [weakSelf.navigationController popViewControllerAnimated: NO];
        WTTopicDetailViewController *vc = [WTTopicDetailViewController topicDetailViewController];
        vc.topicDetailUrl =@"https://www.v2ex.com/t/395994";
        [[UIViewController topVC].navigationController pushViewController: vc animated: YES];
    };
    
    void(^failureBlock)(NSError *) = ^(NSError *error){
        
    };
    
    [WTPublishTopicViewModel publishTopicWithNodeItem: self.nodeItem title: title content: markdown success: successBlock failure: failureBlock];
}

#pragma mark - 事件
#pragma mark 预览
- (IBAction)previewItemClick:(id)sender
{
    if ([self.leftBarBtnItem.title isEqualToString: WTLeftBarBtnItemWithPreview]) // 实时预览
    {
        NSString *js = [NSString stringWithFormat: @"window.webkit.messageHandlers.%@.postMessage(document.getElementById('topic_content\').value);", WTPreviewAppName];
        [self.contentWebView evaluateJavaScript: js completionHandler:^(id _Nullable script, NSError * _Nullable error) {
            WTLog(@"error:%@", error)
        }];
    }
    else
    {
        [self.previewWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-50);
        }];
        
        [self.view layoutIfNeeded];
        
        self.leftBarBtnItem.title = WTLeftBarBtnItemWithPreview;
    }
}
#pragma mark 发表
- (IBAction)publishBtnClick:(UIBarButtonItem *)sender
{
    NSString *title = self.topicTitleTextF.text;
    if ([title stringByTrim].length == 0)
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"请输入标题"];
        return;
    }
    if (title.length >= 144)
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"标题不能超过144个字符"];
        return;
    }
    
    NSString *js = [NSString stringWithFormat: @"window.webkit.messageHandlers.%@.postMessage(document.getElementById('topic_content\').value);", WTPublishTopicAppName];
    [self.contentWebView evaluateJavaScript: js completionHandler:^(id _Nullable script, NSError * _Nullable error) {
        WTLog(@"error:%@", error)
    }];
}
#pragma mark - 选择节点
- (IBAction)selectNodeBtnClick
{
    WTAllNodeViewController *vc = [WTAllNodeViewController new];
    __weak typeof(self) weakSelf = self;
    vc.didClickTitleBlock = ^(WTNodeItem *nodeItem){
        weakSelf.nodeItem = nodeItem;
    };
    [self presentViewController: vc animated: YES completion: nil];
    
   
}

#pragma mark - WKNavigationDelegate

#pragma mark - WKUIDelegate

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString: WTPreviewAppName])
    {
        [self JSToOCPreviewWithMarkdown: message.body];
    }
    else if([message.name isEqualToString: WTPublishTopicAppName])
    {
        [self JSToOCPubliskTopicWithMarkdown: message.body];
    }
}

#pragma mark - Setter
- (void)setNodeItem:(WTNodeItem *)nodeItem
{
    _nodeItem = nodeItem;
    
    [self.selectNodeBtn setTitle: nodeItem.title forState: UIControlStateNormal];
}
@end
