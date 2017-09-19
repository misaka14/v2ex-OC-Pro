//
//  WTPublishTopicViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTPublishTopicViewController.h"
#import "UITextView+Placeholder.h"
//#import "NSString+GHMarkdownParser.h"
#import "UIBarButtonItem+Extension.h"
#import "NetworkTool.h"
@interface WTPublishTopicViewController ()
/** 标题 */
@property (weak, nonatomic) IBOutlet UITextField *titleTextF;
/** 正文　*/
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopLayoutCons;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WTPublishTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentTextView.placeholder = @"请输入正文";
        
}

#pragma mark - 事件
#pragma mark 预览
- (IBAction)previewItemClick:(id)sender
{
    if (self.webViewTopLayoutCons.constant == 0)
    {
        NSString *markdown = self.contentTextView.text;
        
        markdown = @"# 1312 ## 1231";
        
        NSString *cssPath = [[NSBundle mainBundle] pathForResource: @"light.css" ofType: nil];
        NSString *css = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
        

        NSString *highlightJsPath = [[NSBundle mainBundle] pathForResource: @"highlight.js" ofType: nil];
        NSString *highlightJs = [NSString stringWithContentsOfFile: highlightJsPath encoding: NSUTF8StringEncoding error: nil];
        
        NSMutableString *html = [[NSMutableString alloc] init];
        
        [html appendString: @"<!DOCTYPE html><html><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\"><head><title></title>"];
        
        [html appendString: css];
        
        [html appendString: highlightJs];
        
        
        [html appendString: @"</head><body>"];
        
        
        
        
        NSDictionary *param = @{@"md" : markdown};
        [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypePOST url: @"https://www.v2ex.com/preview/markdown" param: param success:^(id responseObject) {
            
            
            NSString *content = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
            
            
            [html appendString: content];
            [html appendString: @"<script>hljs.initHighlightingOnLoad();</script>"];
            
            [html appendString: @"</body></html>"];
            
            self.webViewTopLayoutCons.constant = WTScreenHeight - 20;
            [self.view layoutIfNeeded];
            
            [self.webView loadHTMLString: html baseURL: nil];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    else
    {
        self.webViewTopLayoutCons.constant = 0;
    }
}
#pragma mark 发表
- (IBAction)publishBtnClick:(UIBarButtonItem *)sender
{

}


@end
