//
//  WTHotTopicViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTHotTopicViewModel.h"

#import "WTSearchTopicRsp.h"

#import "WTURLConst.h"
#import "NetworkTool.h"

#import "MJExtension.h"

@implementation WTHotTopicViewModel


/**
 搜索帖子
 
 @param searchTopicRsp 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)searchTopicWithSearchTopicReq:(WTSearchTopicReq *)searchTopicReq success:(void(^)(NSMutableArray<WTSearchTopic *> *searchTopics))success failure:(void(^)(NSError *error))failure
{
    void (^successBlock)(id responseObject) = ^(id responseObject){
        WTSearchTopicRsp *rsp = [WTSearchTopicRsp mj_objectWithKeyValues: responseObject];
        
        NSMutableArray<WTSearchTopic *> *searchTopics = rsp.items;
        
        if (success) success(searchTopics);
    };
    
    void (^failureBlock)(NSError *error) = ^(NSError *error){
        if (failure) failure(error);
    };
    
    NSString *url = [WTMisaka14Domain stringByAppendingPathComponent: WTSearchTopicUrl];
    
    [[NetworkTool shareInstance] requestJSONWithMethod: HTTPMethodTypeGET url: url param: searchTopicReq.mj_keyValues success: successBlock failure: failureBlock];
}

@end
