//
//  WTMyFollowingViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/9.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMyFollowingViewModel.h"

#import "NetworkTool.h"
#import "WTURLConst.h"
#import "WTHTMLExtension.h"

#import "NSString+YYAdd.h"
#import "TFHpple.h"

@implementation WTMyFollowingViewModel
/**
 *  获取我的关注
 *
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getMyFollowingItemsWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/my/following?p=%ld", self.page];
    
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
/**
  *  根据二进制文件解析出 ”我的关注“ 数组
  *
  *  @param data 二进制
  */
- (void)getMyFollowingItemsWithData:(NSData *)data
{
    NSMutableArray *myFollowingItems = [NSMutableArray array];
    
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
            
            WTMyFollowingItem *myFollowingItem = [WTMyFollowingItem new];
            {
                
                
                // 1、节点
                myFollowingItem.node = nodeElement.content;
                
                // 2、标题
                myFollowingItem.title = titleElement.content;
                
                // 3、话题详情URL
                myFollowingItem.detailUrl = [titleElement objectForKey: @"href"];
                
                // 4、作者
                myFollowingItem.author = authorElement.content;
                
                // 5、评论数
                if (commentArray.count > 0)    // 首页话题控制器的评论数
                {
                    myFollowingItem.commentCount = commentArray.firstObject.content;
                }
                else        // 用户话题控制器的评论数
                {
                    myFollowingItem.commentCount = countOrangeArray.firstObject.content;
                }
                
                // 6、最后回复时间
                if (smallFadeArray.count > 1)        // 首页话题列表
                {
                    myFollowingItem.lastReplyTime = [[smallFadeArray[1].content componentsSeparatedByString: @"•"].firstObject stringByReplacingOccurrencesOfString: @" " withString: @""];
                }
                else                                // 用户收藏话题列表
                {
                    NSString *content = smallFadeArray[0].content;
                    NSArray *contents = [content componentsSeparatedByString: @"•"];
                    if (contents.count > 2)
                    {
                        NSString *lastReplyTime = contents[2];
                        myFollowingItem.lastReplyTime = [lastReplyTime stringByTrim];
                    }
                    
                }
                
                // 7、头像
                if (avatars.count > 0)
                {
                    myFollowingItem.icon = [avatars.firstObject objectForKey: @"src"];
                }
            
                
                // 1、http://www.v2ex.com + /member/hunau 拼接成完整的地址
                myFollowingItem.detailUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: myFollowingItem.detailUrl];
                
                // 2、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
                if (myFollowingItem.icon)
                {
                    NSString *iconStr = myFollowingItem.icon;
                    if ([myFollowingItem.icon containsString: @"normal.png"])
                    {
                        iconStr = [myFollowingItem.icon stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
                    }
                    else if([myFollowingItem.icon containsString: @"s=48"])
                    {
                        iconStr = [myFollowingItem.icon stringByReplacingOccurrencesOfString: @"s=48" withString: @"s=96"];
                    }
                    myFollowingItem.avatarURL = [NSURL URLWithString: [WTHTTP stringByAppendingString: iconStr]];
                }
//                else if(iconURL)
//                {
//                    topicViewModel.iconURL = iconURL;
//                }
            }
            
            [myFollowingItems addObject: myFollowingItem];
        }
    }
    
    self.nextPage = [WTHTMLExtension isNextPage: doc];
    
    if (self.page == 1)
    {
        self.myFollowingItems = myFollowingItems;
    }
    else
    {
        [self.myFollowingItems addObjectsFromArray: myFollowingItems];
    }
}
@end
