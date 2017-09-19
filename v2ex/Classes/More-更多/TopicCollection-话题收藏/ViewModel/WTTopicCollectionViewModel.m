//
//  WTTopicCollectionViewModel.m
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicCollectionViewModel.h"

#import "NetworkTool.h"
#import "WTURLConst.h"
#import "WTHTMLExtension.h"

#import "TFHpple.h"
#import "NSString+YYAdd.h"

@implementation WTTopicCollectionViewModel

/**
 *  获取话题收藏
 *
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getTopicCollectionItemsWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/my/topics?p=%ld", self.page];
    
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(id data) {
        
        [self getMyFollowingItemsWithData: data];
        
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

- (void)getMyFollowingItemsWithData:(NSData *)data
{
    WTLog(@"data:%@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
    NSMutableArray *topicCollectionItems = [NSMutableArray array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    NSArray *cellItemArray = [doc searchWithXPathQuery: @"//div[@class='cell item']"];
    
    for (TFHppleElement *cellItem in cellItemArray)
    {
        @autoreleasepool
        {
            // 1、匹配相对应的节点
            TFHppleElement *nodeElement = [cellItem searchWithXPathQuery: @"//a[@class='node']"][0];
            TFHppleElement *titleElement = [cellItem searchWithXPathQuery: @"//span[@class='item_title']//a"][0];
            TFHppleElement *authorElement = [cellItem searchWithXPathQuery: @"//strong"][0];
            NSArray<TFHppleElement *> *commentArray = [cellItem searchWithXPathQuery: @"//a[@class='count_livid']"];
            NSArray<TFHppleElement *> *smallFadeArray = [cellItem searchWithXPathQuery: @"//span[@class='small fade']"];
            NSArray<TFHppleElement *> *countOrangeArray = [cellItem searchWithXPathQuery: @"//a[@class='count_orange']"];
            NSArray<TFHppleElement *> *avatars = [cellItem searchWithXPathQuery: @"//img[@class='avatar']"];
            
            WTTopicCollectionItem *topicCollectionItem = [WTTopicCollectionItem new];
            {
            
                // 1、节点
                topicCollectionItem.node = nodeElement.content;
                
                // 2、标题
                topicCollectionItem.title = titleElement.content;
                
                // 3、话题详情URL
                topicCollectionItem.detailUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: [titleElement objectForKey: @"href"]];
                
                // 4、作者
                topicCollectionItem.author = authorElement.content;
                
                // 5、评论数
                if (commentArray.count > 0)    // 首页话题控制器的评论数
                {
                    topicCollectionItem.commentCount = commentArray.firstObject.content;
                }
                else        // 用户话题控制器的评论数
                {
                    topicCollectionItem.commentCount = countOrangeArray.firstObject.content;
                }
                
                // 6、最后回复时间
                if (smallFadeArray.count > 1)        // 首页话题列表
                {
                    topicCollectionItem.lastReplyTime = [[smallFadeArray[1].content componentsSeparatedByString: @"•"].firstObject stringByReplacingOccurrencesOfString: @" " withString: @""];
                }
                else                                // 用户收藏话题列表
                {
                    NSString *content = smallFadeArray[0].content;
                    NSArray *contents = [content componentsSeparatedByString: @"•"];
                    if (contents.count > 2)
                    {
                        NSString *lastReplyTime = contents[2];
                        topicCollectionItem.lastReplyTime = [lastReplyTime stringByTrim];
                    }
                    
                }
                
                // 7、头像
                if (avatars.count > 0)
                {
                    topicCollectionItem.icon = [avatars.firstObject objectForKey: @"src"];
                }
                
    
                // 2、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
                if (topicCollectionItem.icon)
                {
                    NSString *iconStr = topicCollectionItem.icon;
                    if ([topicCollectionItem.icon containsString: @"normal.png"])
                    {
                        iconStr = [topicCollectionItem.icon stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
                    }
                    else if([topicCollectionItem.icon containsString: @"s=48"])
                    {
                        iconStr = [topicCollectionItem.icon stringByReplacingOccurrencesOfString: @"s=48" withString: @"s=96"];
                    }
                    topicCollectionItem.avatarURL = [NSURL URLWithString: [WTHTTP stringByAppendingString: iconStr]];
                }
            }
            
            [topicCollectionItems addObject: topicCollectionItem];
        }
    }
    self.nextPage = [WTHTMLExtension isNextPage: doc];
    
    if (self.page == 1)
    {
        self.topicCollectionItems = topicCollectionItems;
    }
    else
    {
        [self.topicCollectionItems addObjectsFromArray: topicCollectionItems];
    }
}
@end
