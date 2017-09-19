//
//  TodayNetworkTool.h
//  v2ex
//
//  Created by gengjie on 2016/10/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger, HTTPMethodType)
{
    HTTPMethodTypeGET,      // GET请求
    HTTPMethodTypePOST,     // POST请求
};
@interface TodayNetworkTool : AFHTTPSessionManager

/**
 *  单例
 *
 */
+ (instancetype)shareInstance;

/**
 *  发起请求
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
