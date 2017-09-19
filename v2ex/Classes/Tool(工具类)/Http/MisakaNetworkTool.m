//
//  MisakaNetworkTool.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "MisakaNetworkTool.h"

@implementation MisakaNetworkTool

static MisakaNetworkTool *_instance;


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [MisakaNetworkTool manager];
        _instance.responseSerializer = [AFJSONResponseSerializer serializer];
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
- (void)requestWithMethod:(MisakaHTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1、成功的回调
    void (^successBlock)(id responseObject) = ^(id responseObject){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
    };
    
    // 2、失败的回调
    void (^failureBlock)(NSError *error) = ^(NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    };
    
    [_instance.requestSerializer setValue: url forHTTPHeaderField: @"Referer"];
    
    // 3、发起请求
    if (method == MisakaHTTPMethodTypeGET)            // GET请求
    {
        [_instance GET: url parameters: param progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
    }
    else if(method == MisakaHTTPMethodTypePOST)       // POST请求
    {
        [_instance POST: url parameters: param progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
    
}
@end
