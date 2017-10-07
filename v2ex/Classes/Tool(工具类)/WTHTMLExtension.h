//
//  WTHTMLExtension.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TFHpple;
@interface WTHTMLExtension : NSObject
/**
 *  判断是否有下一页
 *
 *  @param htmlNode body的HTMLNode
 *
 *  @return WTTopic
 */
//+ (WTTopic *)getIsNextPageWithData:(HTMLNode *)htmlNode;

/**
 *  获取用户的once的值
 *
 *  @param html html源码
 */
+ (NSString *)getOnceWithHtml:(NSString *)html;

/**
 *  获取验证码的Url
 *
 *  @param html html源码
 *
 */
+ (NSString *)getCodeUrlWithData:(NSData *)data;


/**
 *  是否有下一页
 *
 *  @param doc TFHpple
 *
 *  @return YES 有 NO 没有
 */
+ (BOOL)isNextPage:(TFHpple *)doc;

/**
 解析HTML　头像变成清晰的
 
 @param html 要解析html
 @return 解析后的html
 */
+ (NSString *)topicDetailParseAvatarWithHTML:(NSString *)html;


/**
 解析HTML　视频解析
 
 @param html 要解析html
 @return 解析生的html
 */
+ (NSString *)topicDetailParseVideoWithHTML:(NSString *)html;


/**
 　过滤垃圾数据
 
 @param html html
 @return 过滤之后的数据
 */
+ (NSString *)filterGarbageData:(NSString *)html;


/**
 解析未读节点
 
 @param doc 未读消息
 */
+ (void)parseUnreadWithDoc:(TFHpple *)doc;

/**
 解析头像和签到
 */
+ (void)parseAvatarAndPastWithData:(NSData *)data;

@end

