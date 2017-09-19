//
//  WTHTMLExtension.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTHTMLExtension.h"
//#import "HTMLParser.h"
//#import "HTMLNode.h"
#import "WTURLConst.h"
#import "TFHpple.h"

@implementation WTHTMLExtension

///**
// *  判断是否有下一页
// *
// *  @param htmlNode body的HTMLNode
// *
// *  @return WTTopic
// */
//+ (WTTopic *)getIsNextPageWithData:(HTMLNode *)htmlNode
//{
//    HTMLNode *buttonNode = [htmlNode findChildOfClass: @"super normal button"];
//    
//    NSString *buttonValue = [buttonNode getAttributeNamed: @"value"];
//    
//    WTTopic *topic = [WTTopic new];
//    
//    {
//        topic.hasNextPage = [buttonValue containsString: @"下一页"];
//    }
//    return topic;
//}


/**
 *  获取用户的once的值
 *
 *  @param html html源码
 */
+ (NSString *)getOnceWithHtml:(NSString *)html
{
    NSRange range = [html rangeOfString: @"/signout?once="];
    return [html substringWithRange: NSMakeRange(range.location + range.length, 5)];
}

/**
 *  获取验证码的Url
 *
 *  @param html html源码
 *
 */
+ (NSString *)getCodeUrlWithData:(NSData *)data
{
//    HTMLParser *parser = [[HTMLParser alloc] initWithData: data error: nil];
//    
//    // 1、把 html 当中的body部分取出来
//    HTMLNode *bodyNode = [parser body];
//    
//    // 2、获取 action = '/signup'的form节点
//    HTMLNode *formNode = [bodyNode findChildWithAttribute: @"action" matchingName: @"/signup" allowPartial: YES];
//
//    // 3、获取所有tr标签
//    NSArray *trNodes = [formNode findChildTags: @"tr"];
//    
//    // 4、获取 codeUrl
//    NSString *codeUrl = nil;
//    if (trNodes.count > 4)
//    {
//        HTMLNode *imgNode = [trNodes[3] findChildTag: @"img"];
//        codeUrl = [imgNode getAttributeNamed: @"src"];
//    }
//    
    return nil;
}

+ (BOOL)isNextPage:(TFHpple *)doc
{
    // 电脑端
    TFHppleElement *noNextPageWeb = [doc peekAtSearchWithXPathQuery: @"//td[@class='super normal_page_right button disable_now']"];
    // 手机端
    TFHppleElement *noNextPageMobile = [doc searchWithXPathQuery: @"//input[@class='super normal button']"].lastObject;
    
    NSString *noNextPageMobileValue = [noNextPageMobile objectForKey: @"value"];
    if (noNextPageWeb ||  [noNextPageMobileValue containsString: @"下一页"])
        return true;
    return false;
}

#pragma mark - 解析未读节点
+ (void)parseUnreadWithDoc:(TFHpple *)doc
{
    return;
    // 1、判断是否有未读数据
    TFHppleElement *unreadE = [doc peekAtSearchWithXPathQuery: @"//input[@class='super special button']"];
    NSString *value = nil;
    if (unreadE)
        value = [unreadE objectForKey: @"value"];
    
    // 2、有未读数据
    if (value)
    {
        NSInteger unread = 0;
        NSArray *values = [value componentsSeparatedByString: @" "];
        if (values.count > 0)
            unread = [[values objectAtIndex: 0] integerValue];
        
        // 3、发送未读通知
        if (unread > 0)
            [[NSNotificationCenter defaultCenter] postNotificationName: WTUnReadNotificationNotification object: nil userInfo: @{WTUnReadNumKey : @(unread)}];
    }
}


/**
 解析HTML　头像变成清晰的

 @param html 要解析html
 @return 解析后的html
 */
+ (NSMutableString *)topicDetailParseAvatarWithHTML:(NSMutableString *)html
{
    NSString *newHTML =  [html stringByReplacingOccurrencesOfString: @"max-width: 24px; max-height: 24px;" withString: @"max-width: 35px; max-height: 35px;"];
    
    newHTML = [newHTML stringByReplacingOccurrencesOfString: @"width=\"24\"" withString: @"width=\"35\""];
    
    newHTML = [newHTML stringByReplacingOccurrencesOfString: @"s=24" withString: @"s=44"];
    
    newHTML = [newHTML stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
    
    return [[NSMutableString alloc] initWithString: newHTML];
}


/**
 解析HTML　视频解析
 
 @param html 要解析html
 @return 解析生的html
 */
+ (NSString *)topicDetailParseVideoWithHTML:(NSString *)html
{
    return nil;
}


/**
　过滤垃圾数据

 @param html html
 @return 过滤之后的数据
 */
+ (NSString *)filterGarbageData:(NSString *)html
{
    // 特殊情况1
    
        // https://www.v2ex.com/t/369999#reply2
    html = [html stringByReplacingOccurrencesOfString: @"<div class=\"badge_mod\"/>" withString: @""];
    
    // 特殊情况2
    
    html = [html stringByReplacingOccurrencesOfString: @"<div class=\"sep3\"/>" withString: @"<div class=\"sep3\"></div>"];
    
    // 特殊情况3
    
    html = [html stringByReplacingOccurrencesOfString: @"<div class=\"sep5\"/>" withString: @"<div class=\"sep5\"></div>"];
    
    
    
    html = [html stringByReplacingOccurrencesOfString: @"<td width=\"10\" valign=\"top\"/>" withString: @"<td width=\"14\" valign=\"top\"></td>"];
    
    
    
    html = [html stringByReplacingOccurrencesOfString: @"class=\"inner\"" withString: @"class=\"cell\""];

    
    
    return [html stringByReplacingOccurrencesOfString: @"<img src=\"/static/img/reply@2x.png\" width=\"20\" height=\"16\" align=\"absmiddle\" border=\"0\" alt=\"Reply\"/>" withString: @""];
}
@end
