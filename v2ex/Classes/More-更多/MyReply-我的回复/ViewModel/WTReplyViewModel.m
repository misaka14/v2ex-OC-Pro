//
//  WTReplyViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/2.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTReplyViewModel.h"

#import "WTHTMLExtension.h"
#import "NetworkTool.h"
#import "WTURLConst.h"

#import "TFHpple.h"
#import "NSString+YYAdd.h"

@implementation WTReplyViewModel
/**
 *  根据用户名获取某个的回复
 *
 *  @param username  用户名
 *  @param avatarURL 头像
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)getReplyItemsWithUsername:(NSString *)username avatarURL:(NSURL *)avatarURL success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/member/%@/replies?p=%ld", username, self.page];
    
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(id data) {
        
        [self getReplyItemsWithData: data avatarURL: avatarURL];
        
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
 *  根据二进制文件解析出 ”回复“ 数组
 *
 *  @param data 二进制
 */
- (void)getReplyItemsWithData:(NSData *)data avatarURL:(NSURL *)avatarURL
{
    NSMutableArray *replyItems = [NSMutableArray array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    TFHppleElement *mainE = [doc searchWithXPathQuery: @"//div[@id='Wrapper']"].firstObject;
    NSArray<TFHppleElement *> *dockAreaEs = [mainE searchWithXPathQuery: @"//div[@class='dock_area']"];
    NSArray<TFHppleElement *> *innerEs = [mainE searchWithXPathQuery: @"//div[@class='inner']"];
    
    NSUInteger dockAreaEsCount = dockAreaEs.count;
    NSUInteger innerEsCount = innerEs.count;
    
    for (NSUInteger i = 0; i < dockAreaEsCount; i++)
    {
        @autoreleasepool {
            
            TFHppleElement *dockAreaE = dockAreaEs[i];
            TFHppleElement *innerE;
            
            if (innerEsCount == dockAreaEsCount && i == dockAreaEs.count - 1)
            {
                NSArray<TFHppleElement *> *cellEs = [mainE searchWithXPathQuery: @"//div[@class='cell']"];
//                if (cellEs.count > 2) {
                
                    innerE = cellEs[0];
//                }
                
            }
            else
            {
                innerE = innerEs[i];
            }
            
            TFHppleElement *grayE = [dockAreaE searchWithXPathQuery: @"//span[@class='gray']"].firstObject;
            TFHppleElement *fadeE = [dockAreaE searchWithXPathQuery: @"//span[@class='fade']"].firstObject;
            
            TFHppleElement *grayaE = [grayE searchWithXPathQuery: @"//a"].firstObject;
            
            WTReplyItem *replyItem = [WTReplyItem new];
            {
                
                
                NSString *grayContent = grayE.content;
                NSString *grayAContent = grayaE.content;
                
                // 标题
                replyItem.title = [grayAContent stringByTrim];
                
                // 话题详情
                replyItem.detailUrl = grayaE[@"href"];
                
                // 回复内容
                replyItem.replyContent = [innerE.content stringByTrim];
                
                // 最后回复时间
                replyItem.replyTime = [fadeE.content stringByTrim];
                
                // 作者
                NSString *grayContents = [grayContent stringByReplacingOccurrencesOfString: grayAContent withString: @""];
                replyItem.author = [grayContents componentsSeparatedByString: @" "][1];
                
                
                // 1、话题详情Url
                if (replyItem.detailUrl)
                {
                    replyItem.detailUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: replyItem.detailUrl];
                }
                
                replyItem.avatarURL = avatarURL;
            }
            [replyItems addObject: replyItem];
        }
    }
    
    
    self.nextPage = [WTHTMLExtension isNextPage: doc];
    
    if (self.page == 1)
    {
        self.replyItems = replyItems;
    }
    else
    {
        [self.replyItems addObjectsFromArray: replyItems];
    }
}
@end
