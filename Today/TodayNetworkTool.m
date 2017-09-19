//
//  TodayNetworkTool.m
//  v2ex
//
//  Created by gengjie on 2016/10/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "TodayNetworkTool.h"

static TodayNetworkTool *_instance;

static NSString *_userAgentMobile;


@implementation TodayNetworkTool

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [TodayNetworkTool manager];
        
    });
    return _instance;
}
/**
 *  发起请求
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{

    
    // 1、成功的回调
    void (^successBlock)(id responseObject) = ^(id responseObject){

        success(responseObject);
    };
    
    // 2、失败的回调
    void (^failureBlock)(NSError *error) = ^(NSError *error){
        failure(error);
    };
    
    [_instance.requestSerializer setValue: url forHTTPHeaderField: @"Referer"];
    
    // 3、发起请求
    if (method == HTTPMethodTypeGET)            // GET请求
    {
        [_instance GET: url parameters: param progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
    }
    else if(method == HTTPMethodTypePOST)       // POST请求
    {
        [_instance POST: url parameters: param progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
}

@end
