//
//  WTTopicDetailViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetailViewModel.h"
#import "TFHpple.h"
#import "WTURLConst.h"
#import "WTParseTool.h"
#import "NSString+Regex.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "WTHTMLExtension.h"
@implementation WTTopicDetailViewModel

#pragma mark - 根据data解析出话题数组
+ (NSMutableArray<WTTopicDetailViewModel *> *)topicDetailsWithData:(NSData *)data
{
//    NSString *html = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSMutableArray<WTTopicDetailViewModel *> *topics = [NSMutableArray array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    // 1、有些主题必须要登陆才能查看
    TFHppleElement *messageElement = [doc peekAtSearchWithXPathQuery: @"//div[@class='message']"];
    if (messageElement != nil)
    {
        return nil;
    }
    
    //[self parseHTMLWithDoc: doc];
    [topics addObject: [self parseTopicDetailWithDoc: doc]];
    
    [topics addObjectsFromArray: [self parseTopicCommentWithDoc: doc]];
    
    return topics;
}

+ (WTTopicDetailViewModel *)topicDetailWithData:(NSData *)data
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    // 1、有些主题必须要登陆才能查看
    TFHppleElement *messageElement = [doc peekAtSearchWithXPathQuery: @"//div[@class='message']"];
    if (messageElement != nil)
    {
        return nil;
    }
    
    return [self parseHTMLWithDoc: doc];
}



+ (WTTopicDetailViewModel *)parseHTMLWithDoc:(TFHpple *)doc
{
    WTTopicDetailViewModel *topicDetailVM = [WTTopicDetailViewModel new];
    
    // 1、时间数组
    NSArray<TFHppleElement *> *timeArray = [doc searchWithXPathQuery: @"//small[@class='gray']"];
    
    TFHppleElement *headerElement = [doc peekAtSearchWithXPathQuery: @"//div[@class='header']"];
    // 2、头像
    TFHppleElement *iconElement = [headerElement searchWithXPathQuery: @"//img[@class='avatar']"].firstObject;
    // 3、作者
    TFHppleElement *authorElement = [headerElement searchWithXPathQuery: @"//small[@class='gray']//a"].firstObject;
    
    // 4、标题
    TFHppleElement *titleElement = [headerElement searchWithXPathQuery: @"//h1"].firstObject;
    
    // 5、节点
    TFHppleElement *nodeElement = [headerElement searchWithXPathQuery: @"//a"][2];
    
    // 7、楼层
    TFHppleElement *floorElement = [doc searchWithXPathQuery: @"//span[@class='no']"].firstObject;
    
    // 8、操作
    NSArray<TFHppleElement *> *operations = [doc searchWithXPathQuery: @"//a[@class='op']"];
    
    // 9、once
    TFHppleElement *onceElement = [doc searchWithXPathQuery: @"//input[@name='once']"].firstObject;
    
    // 10、thank 喜欢
    TFHppleElement *topicThankE = [doc peekAtSearchWithXPathQuery: @"//div[@id='topic_thank']"];
    
    // 11、当前的页数
    TFHppleElement *currentPageE = [doc peekAtSearchWithXPathQuery: @"//span[@class='page_current']"];
    
    {
        WTTopicDetail *topicDetail = [WTTopicDetail new];
        // 1、创建时间
        topicDetail.createTime = timeArray.firstObject.content;
        
        
        
        // 2、头像
        topicDetail.icon = [iconElement objectForKey: @"src"];
        
        // 3、作者
        topicDetail.author = authorElement.content;
        
        // 4、标题
        topicDetail.title = titleElement.content;
        
        // 5、节点
        topicDetail.node = nodeElement.content;
        
        
        topicDetailVM.topicDetail = topicDetail;
        
        // 1、节点
        topicDetailVM.nodeText = [NSString stringWithFormat: @" %@  ", topicDetail.node];
        
        // 2、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
        topicDetailVM.iconURL = [WTParseTool parseBigImageUrlWithSmallImageUrl: topicDetail.icon];
        
        // 3、创建时间
        topicDetailVM.createTimeText = [NSString subStringFromIndexWithStr: @"at " string: topicDetail.createTime];
        
        // 4、感谢、收藏、忽略
        if (operations.count > 0)
        {
            topicDetailVM.collectionUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: [operations.firstObject objectForKey: @"href"]];
        }
        
        // 5、once
        topicDetailVM.once = [onceElement objectForKey: @"value"];
        
        // 6、感谢
        topicDetailVM.thankType = WTThankTypeUnknown;     // 未知原因
        if (topicThankE != nil)
        {
            NSString *topicThankContent = topicThankE.content;
            topicDetailVM.thankType = WTThankTypeAlready; // 已经感谢过
            if ([topicThankContent isEqualToString: @"感谢"])
            {
                topicDetailVM.thankUrl = [WTParseTool parseThankUrlWithFavoriteUrl: topicDetailVM.collectionUrl];
                topicDetailVM.thankType = WTThankTypeNotYet;                     // 未感谢
            }
        }
        
        // 7、页数
        topicDetailVM.currentPage = [currentPageE.content integerValue];
        
        // 8、楼层
        topicDetailVM.floorText = floorElement.content;
    }
    
    
    // 1、正文
    TFHppleElement *wrapperE = [doc peekAtSearchWithXPathQuery: @"//div[@id='Wrapper']"];
    TFHppleElement *rootE = [wrapperE searchWithXPathQuery: @"//div[@class='content']"].firstObject;
    
    NSArray<TFHppleElement *> *boxEs = [rootE searchWithXPathQuery: @"//div[@class='box']"];
    
    TFHppleElement *contentE = boxEs.firstObject;
    contentE = [contentE searchWithXPathQuery: @"//div[@class='cell']"].firstObject;
    NSMutableString *contentHTML = [[NSMutableString alloc] init];
    if (contentE.raw != nil)
    {
        [contentHTML appendString: contentE.raw];
    }
    else
    {
        [contentHTML appendFormat: @"<div class=\"cell\"><div class=\"topic_content\"><div class=\"markdown_body\"><pre><code>未发表内容</code></pre></div></div></div>"];
    }
    
    // 2、正文附加内容
    NSArray *subtleEs = [boxEs.firstObject searchWithXPathQuery: @"//div[@class='subtle']"];
    for (TFHppleElement *e in subtleEs)
    {
        NSString *subtleHTML = [e.raw stringByReplacingOccurrencesOfString: @"<div class=\"sep5\"/>" withString: @""];
        [contentHTML appendString: subtleHTML];
    }
    
    //
//    NSString *newContentHTML = [contentHTML stringByReplacingOccurrencesOfString: @"<p><img" withString: @"<p style=\"padding: 0;\"><img"];
    NSString *newContentHTML = contentHTML;
    newContentHTML = [newContentHTML stringByReplacingOccurrencesOfString: @"<script><![CDATA[<![CDATA[<![CDATA[<![CDATA[hljs.initHighlightingOnLoad();]]]]]]]]><![CDATA[><![CDATA[><![CDATA[>]]]]]]><![CDATA[><![CDATA[>]]]]><![CDATA[>]]></script>" withString: @"<script>hljs.initHighlightingOnLoad();</script>"];
    
    
    // 2、加载评论
    NSArray<TFHppleElement *> *commentCellEs;
    NSArray<TFHppleElement *> *commentInnerEs;
    // 可能一条评论没有
    if (boxEs.count > 1)
    {
        TFHppleElement *commentRootEs = [boxEs objectAtIndex: 1];
        commentCellEs = [commentRootEs searchWithXPathQuery: @"//div[@class='cell']"];
        commentInnerEs = [commentRootEs searchWithXPathQuery: @"//div[@class='inner']"];
    }
    
    
    
    // 3、加载JS、CSS
    NSString *cssPath;
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: DKThemeVersionNormal])
    {
        cssPath = [[NSBundle mainBundle] pathForResource: @"light.css" ofType: nil];
        
    }
    else
    {
        cssPath = [[NSBundle mainBundle] pathForResource: @"night.css" ofType: nil];
    }
    NSString *css = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
    
    
    NSString *jsPath = [[NSBundle mainBundle] pathForResource: @"v2ex.js" ofType: nil];
    NSString *js = [NSString stringWithContentsOfFile: jsPath encoding: NSUTF8StringEncoding error: nil];
    
    NSString *fastClickJsPath = [[NSBundle mainBundle] pathForResource: @"fastclick.js" ofType: nil];
    NSString *fastClickJs = [NSString stringWithContentsOfFile: fastClickJsPath encoding: NSUTF8StringEncoding error: nil];
    
    NSString *highlightJsPath = [[NSBundle mainBundle] pathForResource: @"highlight.js" ofType: nil];
    NSString *highlightJs = [NSString stringWithContentsOfFile: highlightJsPath encoding: NSUTF8StringEncoding error: nil];
    
    // 4、拼接成新的HTML
    NSMutableString *html = [NSMutableString string];
    
    [html appendString: @"<!DOCTYPE html><html><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\"><head><title></title>"];
    
    [html appendString: css];
    
    [html appendString: highlightJs];
    
    [html appendString: fastClickJs];
     
    [html appendString: @"</head><body>"];
    
    [html appendString: newContentHTML];
    
    NSUInteger tempI = 0;
    for (TFHppleElement *e in commentCellEs)
    {
        if([e objectForKey: @"id"])
        {
            // 把视频过滤掉，暂时方法，有BUG
            if ([e.raw containsString: @"embedded_video_wrapper"])
            {
                continue;
            
            }
            
            NSString *raw = [WTHTMLExtension filterGarbageData: e.raw];
            
            if (tempI==0)
                raw = [raw stringByReplacingOccurrencesOfString: @"class=\"cell\"" withString: @"class=\"cell\"  style=\"padding-top:10px\""];
            
            [html appendString: raw];
            
            tempI++;
        }
        
    }
    
    for (TFHppleElement *e in commentInnerEs)
    {
        if([e objectForKey: @"id"])
        {
            NSString *raw = [WTHTMLExtension filterGarbageData: e.raw];
            
            if (tempI == 0)
                raw = [raw stringByReplacingOccurrencesOfString: @"class=\"cell\"" withString: @"class=\"cell\"  style=\"padding-top:10px\""];
            
            [html appendString: raw];
        }
    }
    
    //html = [WTHTMLExtension topicDetailParseAvatarWithHTML: html];
    
    [html appendString: js];
    
    
    
    [html appendString: @"</body></html>"];
    
    topicDetailVM.contentHTML = html;
    
    WTLog(@"html:%@", html)
    
    return topicDetailVM;
}

#pragma mark - 发送收藏请求
//+ (void)collectionWithUrlString:(NSString *)urlString topicDetailUrl:(NSString *)topicDetailUrl completion:(void(^)(WTTopicDetailViewModel *topicDetailVM, NSError *error))completion;
//{
//    
//    [[NetworkTool shareInstance] getHtmlCodeWithUrlString: urlString success:^(NSData *data) {
//       
//        [self topicDetailWithUrlString: topicDetailUrl completion:^(WTTopicDetailViewModel *topicDetailVM, NSError *error) {
//           
//            if (completion)
//            {
//                completion(topicDetailVM, error);
//            }
//            
//        }];
//        
//    } failure:^(NSError *error) {
//        
//        if (completion)
//        {
//            completion(nil, error);
//        }
//    }];
//}

#pragma mark - 操作帖子请求的方法
+ (void)topicOperationWithMethod:(HTTPMethodType)method urlString:(NSString *)urlString topicDetailUrl:(NSString *)topicDetailUrl completion:(void(^)(WTTopicDetailViewModel *topicDetailVM, NSError *error))completion;
{
    void (^successBlock)(NSData *data) = ^(NSData *data){
        
        [self topicDetailWithUrlString: topicDetailUrl completion:^(WTTopicDetailViewModel *topicDetailVM, NSError *error) {
            
            if (completion)
            {
                completion(topicDetailVM, error);
            }
            
        }];
    };
    
    void (^errorBlock)(NSError *error) = ^(NSError *error){
        if (completion)
        {
            completion(nil, error);
        }
    };

    if (method == HTTPMethodTypeGET)
    {
        [[NetworkTool shareInstance] GETWithUrlString: urlString success: successBlock failure: errorBlock];
    }
    else
    {
        [[NetworkTool shareInstance] postHtmlCodeWithUrlString: urlString success: successBlock failure: errorBlock];
    }
}

#pragma mark - 请求作者话题的详情
+ (void)topicDetailWithUrlString:(NSString *)urlString completion:(void(^)(WTTopicDetailViewModel *topicDetailVM, NSError *error))completion
{
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(NSData *data) {
        
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
        
        WTTopicDetailViewModel *topicDetailVM = [self parseTopicDetailWithDoc: doc];
        
        if (completion)
        {
            completion(topicDetailVM, nil);
        }
        
    } failure:^(NSError *error) {
        if (completion)
        {
            completion(nil, error);
        }
    }];
}

#pragma mark - 根据doc解析话题正文内容
+ (WTTopicDetailViewModel *)parseTopicDetailWithDoc:(TFHpple *)doc
{
    // 1、正文
    TFHppleElement *topicContentElement = [doc peekAtSearchWithXPathQuery: @"//div[@class='topic_content']"];
    
    // 2、时间数组
    NSArray<TFHppleElement *> *timeArray = [doc searchWithXPathQuery: @"//small[@class='gray']"];
    
    TFHppleElement *headerElement = [doc peekAtSearchWithXPathQuery: @"//div[@class='header']"];
    // 3、头像
    TFHppleElement *iconElement = [headerElement searchWithXPathQuery: @"//img[@class='avatar']"][0];
    // 4、作者
    TFHppleElement *authorElement = [headerElement searchWithXPathQuery: @"//small[@class='gray']//a"][0];
    
    // 5、标题
    TFHppleElement *titleElement = [headerElement searchWithXPathQuery: @"//h1"].firstObject;
    
    // 6、节点
    TFHppleElement *nodeElement = [headerElement searchWithXPathQuery: @"//a"][2];
    
    // 7、楼层
    TFHppleElement *floorElement = [doc searchWithXPathQuery: @"//span[@class='no']"].firstObject;
    
    // 8、操作
    NSArray<TFHppleElement *> *operations = [doc searchWithXPathQuery: @"//a[@class='op']"];
    
    // 9、once
    TFHppleElement *onceElement = [doc searchWithXPathQuery: @"//input[@name='once']"].firstObject;
    
    // 10、thank 喜欢
    TFHppleElement *topicThankE = [doc peekAtSearchWithXPathQuery: @"//div[@id='topic_thank']"];
    
    // 11、当前的页数
    TFHppleElement *currentPageE = [doc peekAtSearchWithXPathQuery: @"//span[@class='page_current']"];
    
    WTTopicDetailViewModel *topicDetailVM = [WTTopicDetailViewModel new];
    {
        WTTopicDetail *topicDetail = [WTTopicDetail new];
        // 正文
        topicDetail.content = topicContentElement.raw;
    
        // 创建时间
        topicDetail.createTime = timeArray.firstObject.content;
        
        // 头像
        topicDetail.icon = [iconElement objectForKey: @"src"];
        
        // 作者
        topicDetail.author = authorElement.content;
        
        // 标题
        topicDetail.title = titleElement.content;
        
        // 节点
        topicDetail.node = nodeElement.content;
      
        topicDetailVM.topicDetail = topicDetail;
        
        // 1、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
        topicDetailVM.iconURL = [WTParseTool parseBigImageUrlWithSmallImageUrl: topicDetail.icon];
        
        
        // 2、拼接HTML正文内容
        NSString *cssPath = [[NSBundle mainBundle] pathForResource: @"light.css" ofType: nil];
        NSString *cssStr = [NSString stringWithContentsOfFile: cssPath encoding: NSUTF8StringEncoding error: nil];
        topicDetailVM.contentHTML = [NSString stringWithFormat: @"<!DOCTYPE HTML><html><meta content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0' name='viewport'><head>%@</head><body>%@</body></html>", cssStr, topicDetail.content];

        // 3、节点
        topicDetailVM.nodeText = [NSString stringWithFormat: @" %@  ", topicDetail.node];
        
        // 4、楼层
        topicDetailVM.floorText = floorElement.content;
        
        // 5、感谢、收藏、忽略
        if (operations.count > 0)
        {
            topicDetailVM.collectionUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: [operations.firstObject objectForKey: @"href"]];
        }
        
        // 6、once
        topicDetailVM.once = [onceElement objectForKey: @"value"];
        
        // 7、创建时间
        topicDetailVM.createTimeText = [NSString subStringFromIndexWithStr: @"at " string: topicDetail.createTime];
        
        // 8、感谢
        topicDetailVM.thankType = WTThankTypeUnknown;     // 未知原因
        if (topicThankE != nil)
        {
            NSString *topicThankContent = topicThankE.content;
            topicDetailVM.thankType = WTThankTypeAlready; // 已经感谢过
            if ([topicThankContent isEqualToString: @"感谢"])
            {
                topicDetailVM.thankUrl = [WTParseTool parseThankUrlWithFavoriteUrl: topicDetailVM.collectionUrl];
                topicDetailVM.thankType = WTThankTypeNotYet;                     // 未感谢
            }
        }
        
        // 9、页数
        topicDetailVM.currentPage = [currentPageE.content integerValue];
        
        // 10、未读的消息
        [WTHTMLExtension parseUnreadWithDoc: doc];
    }
    
    
    
    return topicDetailVM;
}




#pragma mark - 解析评论数组
+ (NSMutableArray<WTTopicDetailViewModel *> *)parseTopicCommentWithDoc:(TFHpple *)doc
{
    TFHppleElement *boxElement = [[doc searchWithXPathQuery: @"//div[@class='box']"] objectAtIndex: 1];
    
    NSMutableArray<WTTopicDetailViewModel *> *topicDetailVMs = [NSMutableArray array];
    
    NSArray<TFHppleElement *> *cellArr = [boxElement searchWithXPathQuery: @"//table"];
    
    for (TFHppleElement *cell in cellArr)
    {
        TFHppleElement *contentE = [cell searchWithXPathQuery: @"//div[@class='reply_content']"].firstObject;
        if (contentE == nil)
        {
            continue;
        }
        
        TFHppleElement *iconE = [cell searchWithXPathQuery: @"//img[@class='avatar']"].firstObject;
        
        TFHppleElement *authorE = [cell searchWithXPathQuery: @"//a[@class='dark']"].firstObject;
        
        TFHppleElement *timeE = [cell searchWithXPathQuery: @"//span[@class='fade small']"].firstObject;
        
        TFHppleElement *floorE = [cell searchWithXPathQuery: @"//span[@class='no']"].firstObject;
        
        WTTopicDetailViewModel *topicDetailVM = [WTTopicDetailViewModel new];
        {
            WTTopicDetail *topicDetail = [WTTopicDetail new];
            
            topicDetail.content = contentE.content;
            
            topicDetail.icon = [iconE objectForKey: @"src"];
            
            topicDetail.author = authorE.content;
            
            topicDetail.createTime = timeE.content;
            
            topicDetail.floor = floorE.content;
            
            topicDetailVM.topicDetail = topicDetail;
            
            
            // 1、楼层
            topicDetailVM.floorText = [NSString stringWithFormat: @"#%@", topicDetail.floor];
            
            // 2、高清头像
            topicDetailVM.iconURL = [WTParseTool parseBigImageUrlWithSmallImageUrl: topicDetail.icon];
        }
        [topicDetailVMs addObject: topicDetailVM];
    }
    return topicDetailVMs;
}

@end
