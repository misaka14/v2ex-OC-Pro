//
//  WTTopicViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicViewModel.h"

#import "WTURLConst.h"
#import "WTParseTool.h"
#import "NetworkTool.h"
#import "WTTopicApiItem.h"
#import "WTHTMLExtension.h"
#import "WTAccountViewModel.h"

#import "TFHpple.h"
#import "NSString+YYAdd.h"
@implementation WTTopicViewModel

#pragma mark - Public Method

/**
 *  根据url和话题type获取节点话题
 *
 *  @param url       url
 *  @param topicType 话题type
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getNodeTopicWithUrlStr:(NSString *)url topicType:(WTTopicType)topicType success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    [self getNodeTopicWithUrlStr: url topicType: topicType avartorURL: nil success: success failure: failure];
}


/**
 *  根据url和话题type获取节点话题
 *
 *  @param url       url
 *  @param topicType 话题type
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getNodeTopicWithUrlStr:(NSString *)url topicType:(WTTopicType)topicType avartorURL:(NSURL *)avartorURL success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    if (![url containsString: @"/?"])
    {
        url = [NSString stringWithFormat: @"%@?p=%zd", url, self.page];
    }
    
    [[NetworkTool shareInstance] GETWithUrlString: url success:^(NSData *data) {
        
        [self nodeTopicsWithData: data topicType: topicType avartorURL: avartorURL];
        if (success)
        {
            success();
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
        
    }];
}

#pragma mark 根据data解析出节点话题数组
- (void)nodeTopicsWithData:(NSData *)data topicType:(WTTopicType)topicType avartorURL:(NSURL *)avartorURL 
{
    // 1、检查是否需要二次登录
    NSString *html = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    if ([html containsString: WTLogin2faUrl])
    {
        NSString *once = [WTHTMLExtension getOnceWithHtml: html];
        if (once) [[NSNotificationCenter defaultCenter] postNotificationName: WTTwoStepAuthNSNotification object: nil  userInfo: @{WTTwoStepAuthWithOnceKey : once}];
        return;
    }
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    NSArray *cellItemArray;
    
    if (topicType == WTTopicTypeNormal)
    {
        cellItemArray = [doc searchWithXPathQuery: @"//div[@class='cell item']"];
    }
    else if(topicType == WTTopicTypeHot)
    {
        cellItemArray = [doc searchWithXPathQuery: @"//div[@class='cell']"];
    }
    
    
    NSMutableArray *topics = [NSMutableArray array];
    for (TFHppleElement *cellItem in cellItemArray)
    {
        @autoreleasepool
        {
            // 1、匹配相对应的节点
            NSArray *nodeEs = [cellItem searchWithXPathQuery: @"//a[@class='node']"];
            TFHppleElement *nodeElement;
            if (nodeEs.count > 0)
            {
                nodeElement = [cellItem searchWithXPathQuery: @"//a[@class='node']"][0];
            }
            
            TFHppleElement *titleElement = [cellItem searchWithXPathQuery: @"//span[@class='item_title']//a"][0];
            TFHppleElement *authorElement = [cellItem searchWithXPathQuery: @"//strong"][0];
            NSArray<TFHppleElement *> *commentArray = [cellItem searchWithXPathQuery: @"//a[@class='count_livid']"];
            NSArray<TFHppleElement *> *smallFadeArray = [cellItem searchWithXPathQuery: @"//span[@class='small fade']"];
            NSArray<TFHppleElement *> *countOrangeArray = [cellItem searchWithXPathQuery: @"//a[@class='count_orange']"];
            NSArray<TFHppleElement *> *avatars = [cellItem searchWithXPathQuery: @"//img[@class='avatar']"];
            
            
            
            WTTopic *topic = [WTTopic new];
            
            // 1、节点
            topic.node = nodeElement.content;
            
            // 2、标题
            topic.title = titleElement.content;
            
            // 3、话题详情URL
            NSString *detailUrl = [titleElement objectForKey: @"href"];;
            topic.detailUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: detailUrl];
            
            // 4、作者
            topic.author = authorElement.content;
            
            // 5、评论数
            if (commentArray.count > 0)    // 首页话题控制器的评论数
            {
                topic.commentCount = commentArray.firstObject.content;
            }
            else        // 用户话题控制器的评论数
            {
                if (countOrangeArray.count > 0)
                    topic.commentCount = countOrangeArray.firstObject.content;
            }
            
            // 6、最后回复时间
            if (smallFadeArray.count > 1)        // 首页话题列表
            {
                topic.lastReplyTime = [[smallFadeArray[1].content componentsSeparatedByString: @"•"].firstObject stringByReplacingOccurrencesOfString: @" " withString: @""];
            }
            else                                // 用户收藏话题列表
            {
                NSString *content = smallFadeArray.firstObject.content;
                NSArray *contents = [content componentsSeparatedByString: @"•"];
                if (contents.count > 2)
                {
                    NSString *lastReplyTime = contents[2];
                    topic.lastReplyTime = [lastReplyTime stringByTrim];
                }
                
            }
            
            // 7、头像
            if (avartorURL != nil)
            {
                topic.iconURL = avartorURL;
            }
            else if (avatars.count > 0)
            {
                NSString *icon = [avatars.firstObject objectForKey: @"src"];
                
                // 头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
                if ([icon containsString: @"normal.png"])
                {
                    icon = [icon stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
                }
                else if([icon containsString: @"s=48"])
                {
                    icon = [icon stringByReplacingOccurrencesOfString: @"s=48" withString: @"s=96"];
                }
                topic.iconURL = [NSURL URLWithString: [WTHTTP stringByAppendingString: icon]];
            }
            
            
            [topics addObject: topic];
        }
    }
    self.nextPage = [WTHTMLExtension isNextPage: doc];
    
    if (self.page == 1)
    {
        self.topics = topics;
    }
    else
    {
        [self.topics addObjectsFromArray: topics];
    }

    // 10、未读的消息
    //[WTHTMLExtension parseUnreadWithDoc: doc];
    
    // 11、签到、头像
    [WTHTMLExtension parseAvatarAndPastWithData: data];
}


#pragma mark - 是否是下一页
+ (BOOL)isNeedNextPage:(NSString *)urlSuffix
{
    if ([urlSuffix containsString: @"recent"] || [urlSuffix containsString: @"my"] || [urlSuffix containsString: @"member"] || [urlSuffix containsString: @"/?tab=all"])
        return true;
    return false;
}


#pragma mark - 创建nodes.plist文件
+ (void)createNodesPlist
{
    NSDictionary *dict_0 = @{@"name" : @"最近", @"nodeURL" : @"/recent"};
    NSDictionary *dict0 = @{@"name" : @"技术", @"nodeURL" : @"/?tab=tech"};
    NSDictionary *dict1 = @{@"name" : @"创意", @"nodeURL" : @"/?tab=creative"};
    NSDictionary *dict2 = @{@"name" : @"好玩", @"nodeURL" : @"/?tab=play"};
    NSDictionary *dict3 = @{@"name" : @"Apple", @"nodeURL" : @"/?tab=apple"};
    NSDictionary *dict4 = @{@"name" : @"酷工作", @"nodeURL" : @"/?tab=jobs"};
    NSDictionary *dict5 = @{@"name" : @"交易", @"nodeURL" : @"/?tab=deals"};
    NSDictionary *dict6 = @{@"name" : @"城市", @"nodeURL" : @"/?tab=city"};
    NSDictionary *dict7 = @{@"name" : @"问与答", @"nodeURL" : @"/?tab=qna"};
    NSDictionary *dict8 = @{@"name" : @"最热", @"nodeURL" : @"/?tab=hot"};
    NSDictionary *dict9 = @{@"name" : @"全部", @"nodeURL" : @"/?tab=all"};
    NSDictionary *dict10 = @{@"name" : @"R2", @"nodeURL" : @"/?tab=r2"};
    NSArray *array = @[dict_0,dict0, dict1,dict2, dict3, dict4, dict5, dict6, dict7, dict8, dict9, dict10];
    BOOL flag = [array writeToFile: @"/Users/wutouqishigj/Desktop/nodes.plist" atomically: YES];
    if (flag)
    {
        WTLog(@"成功");
    }
    else
    {
        WTLog(@"失败");
    }
}

@end
