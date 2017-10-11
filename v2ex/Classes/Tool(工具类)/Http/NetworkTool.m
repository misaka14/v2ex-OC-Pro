//
//  NetworkTool.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/3.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "NetworkTool.h"
#import "WTURLConst.h"
#import "WTProgressHUD.h"

@implementation NetworkTool

static NetworkTool *_instance;

static NSString *_userAgentMobile;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NetworkTool manager];
        
        // 1、设置请求头
       // UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectZero];
//        _userAgentMobile = [webView stringByEvaluatingJavaScriptFromString: @"navigator.userAgent"];
        _userAgentMobile = @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Mobile/14E304";
        [_instance.requestSerializer setValue: _userAgentMobile forHTTPHeaderField: @"User-Agent"];
//        [_instance.requestSerializer setValue: @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0" forHTTPHeaderField: @"User-Agent"];
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/png",nil];
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

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1、成功的回调
    void (^successBlock)(id responseObject) = ^(id responseObject){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
    };
    
    // 2、失败的回调
    void (^failureBlock)(NSError *error) = ^(NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showErrorMessageWithError: error];
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

/**
 *  发起请求 返回值为JSON
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestJSONWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
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
        [self showErrorMessageWithError: error];
        failure(error);
    };
    
    [_instance.requestSerializer setValue: url forHTTPHeaderField: @"Referer"];
    _instance.responseSerializer = [AFJSONResponseSerializer serializer];
    
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

/**
 *  发起请求
 *
 *  @param method  请求方法
 *  @param url     url地址
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)requestFirefoxWithMethod:(HTTPMethodType)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
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
        [self showErrorMessageWithError: error];
        failure(error);
    };
    
    _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/png",nil];
    // 1、设置请求头
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectZero];
    //    NSString *userAgentMobile = [webView stringByEvaluatingJavaScriptFromString: @"navigator.userAgent"];
    [_instance.requestSerializer setValue: @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0" forHTTPHeaderField: @"User-Agent"];
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

/**
 *  获取html源码
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)GETWithUrlString:(NSString *)urlString success:(void (^)(id data))success failure:(void(^)(NSError *error))failure
{
//    _instance = [NetworkTool manager];
    [_instance.requestSerializer setValue: _userAgentMobile forHTTPHeaderField: @"User-Agent"];
    _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/png",nil];
    // 1、设置请求头
//    UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectZero];
//    NSString *userAgentMobile = [webView stringByEvaluatingJavaScriptFromString: @"navigator.userAgent"];
//    [_instance.requestSerializer setValue: @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0" forHTTPHeaderField: @"User-Agent"];
    
    _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_instance GET: urlString parameters: nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorMessageWithError: error];
        if (failure)
        {
            failure(error);
        }
    }];
}


/**
 *  模拟火狐获取html源码
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)GETFirefoxWithUrlString:(NSString *)urlString success:(void (^)(id data))success failure:(void(^)(NSError *error))failure
{
    //    _instance = [NetworkTool manager];
    _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/png",nil];
    // 1、设置请求头
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectZero];
    //    NSString *userAgentMobile = [webView stringByEvaluatingJavaScriptFromString: @"navigator.userAgent"];
    [_instance.requestSerializer setValue: @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0" forHTTPHeaderField: @"User-Agent"];
    
    _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_instance GET: urlString parameters: nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorMessageWithError: error];
        if (failure)
        {
            failure(error);
        }
    }];
}

/**
 *  获取html源码
 *
 *  @param urlString url
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)postHtmlCodeWithUrlString:(NSString *)urlString success:(void (^)(NSData *data))success failure:(void(^)(NSError *error))failure
{
    [_instance POST: urlString parameters: nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showErrorMessageWithError: error];
        
        if (failure)
        {
            failure(error);
        }
        
    }];
}


/**
 *  登陆
 *
 *  @param param   参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)loginWithParam:(NSDictionary *)param success:(void (^)())success failure:(void (^)(NSError *error))failure;
{
    // 1、请求地址
    NSString *urlString = [WTHTTPBaseUrl stringByAppendingPathComponent: WTLoginUrl];
    
    // 4、发起请求
    [_instance requestWithMethod: HTTPMethodTypePOST url: urlString param: param success:^(id responseObject) {
        
        NSString *html = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
        
        WTLog(@"html:%@", html)
        
    } failure:^(NSError *error) {
        
        
    }];
}

/**
 *  上传单张图片
 *
 *  @param urlString url地址
 *  @param image     图片对象
 *  @param progress  进度条的回调
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)uploadImageWithUrlString:(NSString *)urlString image:(UIImage *)image progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1、成功的回调
    void (^successBlock)(id responseObject) = ^(id responseObject){
        success(responseObject);
    };
    
    // 2、失败的回调
    void (^failureBlock)(NSError *error) = ^(NSError *error){
        failure(error);
    };
    
    // 3、上传进度的回调
    void (^progressBlock)(NSProgress *uploadProgress) = ^(NSProgress *uploadProgress){
        progress(uploadProgress);
    };
    
    _instance.responseSerializer = [AFJSONResponseSerializer serializer];
    _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/png",nil];
    
    // 5、发起请求
    [_instance POST: urlString parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image,0.5);
        [formData appendPartWithFileData: data name: @"file" fileName: @"photo.png" mimeType: @"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progressBlock(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        
    }];
}

/**
 *  回复别人的帖子
 *
 *  @param urlString url地址
 *  @param once      回复帖子必须属性
 *  @param content   回复的正文内容
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)replyTopicWithUrlString:(NSString *)urlString once:(NSString *)once content:(NSString *)content success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1、拼接参数
    NSDictionary *param = @{@"once" : once, @"content" : content};
    
    _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 2、发起请求
    [_instance requestWithMethod: HTTPMethodTypePOST url: urlString param: param success:^(id responseObject) {
        WTLog(@"responseObject:%@", [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding])
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
        
    }];
}

- (void)showErrorMessageWithError:(NSError *)error
{
    NSString *message = [[NSString alloc] initWithData: [error.userInfo objectForKey: @"com.alamofire.serialization.response.error.data"] encoding: NSUTF8StringEncoding];
    if ([message containsString: @"Access Denied"])
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"您的IP暂时已被禁用"];
    WTLog(@"error:%@", error)
}

@end
