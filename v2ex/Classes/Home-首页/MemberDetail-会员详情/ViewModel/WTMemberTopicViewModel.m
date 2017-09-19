//
//  WTMemberTopicViewModel.m
//  v2ex
//
//  Created by gengjie on 16/8/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberTopicViewModel.h"

#import "WTURLConst.h"
#import "NetworkTool.h"
#import "WTParseTool.h"
#import "WTHTMLExtension.h"

#import "TFHpple.h"
#import "NSString+YYAdd.h"

@implementation WTMemberTopicViewModel

#pragma mark - Public Method
/**
 *  根据用户名获取发表的主题
 *
 *  @param username 用户名
 *  @param iconURL  头像URL
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)getMemberTopicsWithUsername:(NSString *)username iconURL:(NSURL *)iconURL success:(void(^)())success failure:(void(^)(NSError *error))failure;
{
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/member/%@/topics?p=%ld", username, self.page];
    
    [[NetworkTool shareInstance] GETFirefoxWithUrlString: urlString success:^(id data) {
        
        [self getMemberTopicsWithData: data iconURL: iconURL];
        
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
 *  根据用户名获取用户的信息
 *
 *  @param username 用户名
 *  @param success  请求成功的回调
 *  @param failure  请求失败的加高
 */
- (void)getMemberItemWithUsername:(NSString *)username success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlString = [NSString stringWithFormat: @"https://www.v2ex.com/member/%@", username];
    
    [[NetworkTool shareInstance] GETFirefoxWithUrlString: urlString success:^(id data) {
        
        [self getMemberItemWithData: data];
        
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
     <div class="cell item" style="">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
     
                <td width="auto" valign="middle">
                    <span class="item_title">
                        <a href="/t/299451#reply17">iOS 开发有什么办法防止录屏吗</a>
                    </span>
                    <div class="sep5"></div>
                    <span class="small fade">
                        <div class="votes"></div>
                        <a class="node" href="/go/qna">问与答</a> 
                        &nbsp;•&nbsp; 
                        <strong>
                            <a href="/member/misaka15">misaka15</a>
                        </strong> 
                        &nbsp;•&nbsp; 8 天前 &nbsp;•&nbsp; 最后回复来自 
                        <strong>
                            <a href="/member/misaka15">misaka15</a>
                        </strong>
                    </span>
                </td>
                <td width="70" align="right" valign="middle">
     
                    <a href="/t/299451#reply17" class="count_orange">17</a>
     
                </td>
            </tr>
        </table>
     </div>
 */
#pragma mark - Private Method
- (void)getMemberTopicsWithData:(NSData *)data iconURL:(NSURL *)iconURL
{
    NSMutableArray *topics = [NSMutableArray array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    // 检查是否有权限
    
    TFHppleElement *mainE = [doc searchWithXPathQuery: @"//div[@id='Main']"].firstObject;
    NSArray<TFHppleElement *> *cellItemEs = [mainE searchWithXPathQuery: @"//div[@class='cell item']"];
    
    for (TFHppleElement *cellItemE in cellItemEs)
    {
        @autoreleasepool {
            
            TFHppleElement *titleE = [cellItemE searchWithXPathQuery: @"//span[@class='item_title']//a"].firstObject;
            TFHppleElement *nodeE = [cellItemE searchWithXPathQuery: @"//a[@class='node']"].firstObject;
            
            NSArray<TFHppleElement *> *aEs = [cellItemE searchWithXPathQuery: @"//strong//a"];
            
            TFHppleElement *commentCountE = [cellItemE searchWithXPathQuery: @"//a[@class='count_orange']"].firstObject;
            
            WTTopic *topic = [WTTopic new];
            {
                topic.title = titleE.content;
                
                topic.detailUrl = [WTHTTPBaseUrl stringByAppendingPathComponent: [titleE objectForKey: @"href"]];
                
                topic.node = nodeE.content;
                
                topic.author = aEs.firstObject.content;
                
                topic.lastReplyPeople = aEs.lastObject.content;
                
                NSArray *points = [cellItemE.content componentsSeparatedByString: @"•"];
                if (points.count > 2)
                {
                    NSString *tempTime = points[2] ;
                    topic.lastReplyTime = [tempTime stringByTrim];
                }
                
                topic.iconURL = iconURL;
                
                topic.commentCount = commentCountE.content;
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
}

- (void)getMemberItemWithData:(NSData *)data
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    
    TFHppleElement *grayE = [doc peekAtSearchWithXPathQuery: @"//span[@class='gray']"];
    
    TFHppleElement *biggerE = [doc peekAtSearchWithXPathQuery: @"//span[@class='bigger']"];
    
    TFHppleElement *avatarE = [doc peekAtSearchWithXPathQuery: @"//img[@class='avatar']"];
    
    WTMemberItem *memberItem = [WTMemberItem new];
    
    memberItem.detail = [grayE.content stringByReplacingOccurrencesOfString: @"+08:00" withString: @""];
    if (biggerE)
    {
        memberItem.bio = biggerE.content;
    }
    
    NSString *avatar = [NSString stringWithFormat: @"%@%@", WTHTTP, [avatarE objectForKey: @"src"]];
    memberItem.avatarURL = [WTParseTool parseBigImageUrlWithSmallImageUrl: avatar];
    self.memberItem = memberItem;
}

@end
