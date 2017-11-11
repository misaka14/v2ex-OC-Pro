//
//  WTTopicDetailContentCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetailContentCell.h"
#import "WTTopicDetailViewModel.h"
#import <WebKit/WebKit.h>
#import "NSString+Regex.h"
#import "WTURLConst.h"
#import "Masonry.h"

/** 用户名点击*/
static NSString *const WTUsernameDidClickAppName = @"WTUsernameDidClickAppName";

/** 图像点击*/
static NSString *const WTImagesDidClickAppName = @"WTImagesDidClickAppName";

/** Cell点击*/
static NSString *const WTItemCellDidClickAppName = @"WTItemCellDidClickAppName";

@interface WTTopicDetailContentCell() <UIWebViewDelegate, WKScriptMessageHandler, WKNavigationDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, strong) NSString *lightHTML;

@property (nonatomic, strong) NSString *nightHTML;

@end
@implementation WTTopicDetailContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewCellBgViewBackgroundColor);
    self.webView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewCellBgViewBackgroundColor);
    
    
//    self.webView.UIDelegate = self;
    // 取消反弹
    self.webView.scrollView.bounces = NO;

}

- (void)setTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    _topicDetailVM = topicDetailVM;

    
    
    // 1、加载网页
    [self.webView loadHTMLString: topicDetailVM.contentHTML baseURL: [NSURL URLWithString: WTHTTP]];
    
    // 2、更新cell的高度
    self.cellHeight = self.webView.scrollView.contentSize.height;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    WTLog(@"url:%@", url)
    
    // 第一次加载
    if (([url containsString: @"about:blank"] || [url isEqualToString: @"https:"] | [url isEqualToString: @"http:/"] || [url isEqualToString: @"https:/"]) && ![url containsString: @"jpg"])
    {
        return YES;
    }
    
    // 邮箱
    if ([NSString isAccordWithRegex: @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.4e-]+\\.[A-Za-z]{2,4}" string: url])
    {
        [[UIApplication sharedApplication] openURL: request.URL];
        return NO;
    }
    
    if ([url containsString: @"www.youtube.com"]) return NO;
    
    if ([url containsString: @"itunes.apple.com"]) [[UIApplication sharedApplication] openURL: request.URL];
    
    
    // 网址
    if ([self.delegate respondsToSelector: @selector(topicDetailContentCell:didClickedWithLinkURL:)])
        [self.delegate topicDetailContentCell: self didClickedWithLinkURL: request.URL];
    
    
    return NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        CGRect webFrame = webView.frame;
        webFrame.size.height = height;
        webView.frame = webFrame;
//        webView.height = height;
        
        weakSelf.cellHeight = height;
        if (weakSelf.updateCellHeightBlock)
            weakSelf.updateCellHeightBlock(height);
    }];
    
}

/**
 改变皮肤
 */
- (void)themeChangingNotification
{
    NSString *contentHTML = self.topicDetailVM.contentHTML;
    
    NSRange startRange = [contentHTML rangeOfString: @"<style type="];
    NSRange endRange = [contentHTML rangeOfString: @"</style>"];
    
    NSString *oldCss = [[contentHTML substringWithRange: NSMakeRange(startRange.location, endRange.location + endRange.length)] stringByReplacingOccurrencesOfString: @"<script type=\"text/javascript\">\n/*! highlight.js v9.2.0 | BSD3 License | git.io/hljslicense */\n!function(e){var n=\"object\"==typeof windinitHighlight" withString: @""];
    
    NSString *newHTML = nil;
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: DKThemeVersionNight]) // 说明是夜间皮肤
    {
        if (self.nightHTML != nil)
        {
            newHTML = self.nightHTML;
        }
        else
        {
            NSString *cssPath = [[NSBundle mainBundle] pathForResource: @"night.css" ofType: nil];
            NSString *newCss = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
            self.lightHTML = contentHTML;
            
            self.nightHTML = [contentHTML stringByReplacingOccurrencesOfString: oldCss withString: newCss];
            newHTML = self.nightHTML;
        }
    }
    else
    {
        if (self.lightHTML != nil)
        {
            newHTML = self.lightHTML;
        }
        else
        {
            NSString *cssPath = [[NSBundle mainBundle] pathForResource: @"light.css" ofType: nil];
            NSString *newCss = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
            
            self.nightHTML = contentHTML;
            
            self.lightHTML = [contentHTML stringByReplacingOccurrencesOfString: oldCss withString: newCss];
            newHTML = self.lightHTML;
        }
    }
    
    [self.webView loadHTMLString: newHTML baseURL: [NSURL URLWithString: WTHTTP]];
}

    
- (NSString *)parseImageUrl:(NSString *)url
{
    if ([url containsString: @"https//"]) {
        url = [url stringByReplacingOccurrencesOfString: @"https" withString: @"https:"];
    }
    else if([url containsString: @"http//"])
    {
        url = [url stringByReplacingOccurrencesOfString: @"http" withString: @"http:"];
    }
    return url;
}

#pragma mark - Lazy
- (WKWebView *)webView
{
    if (_webView == nil)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler: self name: WTUsernameDidClickAppName];
        [config.userContentController addScriptMessageHandler: self name: WTImagesDidClickAppName];
        [config.userContentController addScriptMessageHandler: self name: WTItemCellDidClickAppName];
        
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame: CGRectZero configuration: config];
        [self.contentView addSubview: webView];
        webView.navigationDelegate = self;
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        
        
        _webView = webView;
    }
    return _webView;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString: WTUsernameDidClickAppName])
        
        [self parseUsernameWithBody: message.body];
    
    else if([message.name isEqualToString: WTImagesDidClickAppName])
        
        [self parseImagesWithBody: message.body];
    
    else if([message.name isEqualToString: WTItemCellDidClickAppName])
        
        [self parseCellItemWithBody: message.body];
}

- (void)parseUsernameWithBody:(NSString *)body
{
    if ([self.delegate respondsToSelector: @selector(topicDetailContentCell:didClickedWithCommentAvatar:)])
        [self.delegate topicDetailContentCell: self didClickedWithCommentAvatar: body];
}

- (void)parseImagesWithBody:(NSString *)body
{
    NSMutableArray *images = [NSMutableArray array];
    NSUInteger currentIndex = 0;
    NSString *currentImage = [[body componentsSeparatedByString: @"--"] objectAtIndex: 1];
    NSArray *allImages = [body componentsSeparatedByString: @"::"];
    
    for (NSUInteger i = 0; i < allImages.count; i++)
    {
        NSString *image = [allImages objectAtIndex: i];
        if ([image containsString: currentImage])
        {
            currentIndex = i;
            currentImage = [self parseImageUrl: currentImage];
            [images addObject: [NSURL URLWithString: currentImage]];
            continue;
        }
        
        image = [self parseImageUrl: image];
        
        if ([image containsString: @"http"])
            [images addObject: [NSURL URLWithString: image]];
        
    }
    
    if ([self.delegate respondsToSelector: @selector(topicDetailContentCell:didClickedWithContentImages:currentIndex:)])
        [self.delegate topicDetailContentCell: self didClickedWithContentImages: images currentIndex: currentIndex - 1];
}

- (void)parseCellItemWithBody:(NSString *)body
{
    if ([self.delegate respondsToSelector: @selector(topicDetailContentCell:didClickedCellWithParam:)])
        [self.delegate topicDetailContentCell: self didClickedCellWithParam: body];
}

@end
