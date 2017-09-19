//
//  WTShareSDKTool.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/17.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTShareSDKTool : NSObject
/**
 *  初始化shareSDK
 */
+ (void)initShareSDK;

/**
 *  分享
 *
 *  @param text  正文
 *  @param url   要跳转的URL
 *  @param title 标题
 */
+ (void)shareWithText:(NSString *)text url:(NSString *)url title:(NSString *)title;
@end
