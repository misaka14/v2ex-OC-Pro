//
//  WTNotificationViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/31.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNotificationViewModel.h"

#import "NetworkTool.h"
#import "WTURLConst.h"
#import "WTParseTool.h"
#import "NSString+Regex.h"

#import "TFHpple.h"

@implementation WTNotificationViewModel

/**
 *  获取通知
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getUserNotificationsSuccess:(void(^)())success failure:(void(^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/notifications?p=%zd", self.page];
    
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(NSData *data) {
        
        [self userNotificationsWithData: data];
        
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

#pragma mark - 根据data解析出用户通知
- (void)userNotificationsWithData:(NSData *)data;
{
    NSMutableArray *notifications = [NSMutableArray array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    NSArray<TFHppleElement *> *cellEs = [doc searchWithXPathQuery: @"//div[@class='cell']"];
    
    for (TFHppleElement *cellE in cellEs)
    {
        @autoreleasepool {
            
            NSArray<TFHppleElement *> *avatarEs = [cellE searchWithXPathQuery: @"//img[@class='avatar']"];
            
            NSArray<TFHppleElement *> *aEs = [cellE searchWithXPathQuery: @"//a"];
            
            NSArray<TFHppleElement *> *snowEs = [cellE searchWithXPathQuery: @"//span[@class='snow']"];
            
            NSArray<TFHppleElement *> *payloadEs = [cellE searchWithXPathQuery: @"//div[@class='payload']"];
            
            NSArray<TFHppleElement *> *nodeEs = [cellE searchWithXPathQuery: @"//a[@class='node']"];
            
            WTNotificationItem *notificationItem = [WTNotificationItem new];
            {

                // 1、头像
                NSString *icon = [avatarEs.firstObject objectForKey: @"src"];
                // 2、作者
                if (aEs.count > 0) {
                    notificationItem.author = aEs[0].content;
                }
                
                // 3、标题
                if (aEs.count > 2)
                {
                    notificationItem.title = aEs[2].content;
                    NSString *detailUrl = [aEs[2] objectForKey: @"href"];
                    notificationItem.detailUrl = [WTHTTPBaseUrl stringByAppendingString: detailUrl];
                }
                // 4、最后回复时间
                notificationItem.lastReplyTime = snowEs.firstObject.content;
                // 5、回复内容
                notificationItem.content = payloadEs.firstObject.content;
                
                // 6、uid
                TFHppleElement *nodeE = nodeEs.firstObject;
                NSString *onclickValue = [nodeE objectForKey: @"onclick"];
                NSArray *onClickValues = [onclickValue componentsSeparatedByString: @","];
                notificationItem.uid = [[onClickValues.firstObject subStringWithRegex: @"\\d"] integerValue];
                
                
                // 7、once
                notificationItem.once = [[onClickValues.lastObject subStringWithRegex: @"\\d"] integerValue];
        
                // 1、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
                notificationItem.iconURL = [WTParseTool parseBigImageUrlWithSmallImageUrl: icon];
                
            }
            
            [notifications addObject: notificationItem];
        }
        
        TFHppleElement *noNextPage = [doc peekAtSearchWithXPathQuery: @"super normal_page_right button disable_now"];
        if (noNextPage.content.length > 0)
        {
            self.nextPage = NO;
        }
        else
        {
            self.nextPage = YES;
        }
    }
    if (self.page == 1)
    {
        self.notificationItems = notifications;
    }
    else
    {
        [self.notificationItems addObjectsFromArray: notifications];
    }
    
    
}

/**
 *  根据NoticationItem删除通知
 *
 *  @param notificationItem notificationItem
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)deleteNotificationByNoticationItem:(WTNotificationItem *)notificationItem success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/delete/notification/%zd?once=%ld", notificationItem.uid, notificationItem.once];

    [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypePOST url: urlString param: nil success:^(id responseObject) {
        
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
@end
