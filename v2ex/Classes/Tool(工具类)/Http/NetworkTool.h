//
//  NetworkTool.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/3.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  网络工具类

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, HTTPMethodType)
{
    HTTPMethodTypeGET,      // GET请求
    HTTPMethodTypePOST,     // POST请求
};

@interface NetworkTool : AFHTTPSessionManager

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


/**
 *  发起请求 返回值为JSON
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestJSONWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  发起请求
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestFirefoxWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  获取html源码 GET
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)GETWithUrlString:(NSString *)urlString success:(void (^)(id data))success failure:(void(^)(NSError *error))failure;

/**
 *  模拟火狐获取html源码
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)GETFirefoxWithUrlString:(NSString *)urlString success:(void (^)(id data))success failure:(void(^)(NSError *error))failure;

/**
 *  获取html源码 POST
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)postHtmlCodeWithUrlString:(NSString *)urlString success:(void (^)(NSData *data))success failure:(void(^)(NSError *error))failure;

/**
 *  登陆
 *
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)loginWithParam:(NSDictionary *)param success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  上传单张图片
 *
 *  @param urlString url地址
 *  @param image     图片对象
 *  @param progress  进度条的回调
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)uploadImageWithUrlString:(NSString *)urlString image:(UIImage *)image progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  回复别人的帖子
 *
 *  @param urlString url地址
 *  @param once      回复帖子必须属性
 *  @param content   回复的正文内容
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)replyTopicWithUrlString:(NSString *)urlString once:(NSString *)once content:(NSString *)content success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
