//
//  NSString+Regex.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)


/**
 *  根据正则表达式来验证字符串是否符合规则
 *
 *  @param regex  正则表达式
 *  @param string 需要验证的字符串
 *
 *  @return YES 是 NO 否
 */
+ (BOOL)isAccordWithRegex:(NSString *)regex string:(NSString *)string;

/**
 *  验证字符串是否包含中文
 *
 *  @param string 要验证码的字符串
 *
 *  @return YES 是 NO 否
 */
+ (BOOL)isChineseCharactersWithString:(NSString *)string;

/**
 *  从字符串中获取数字
 *
 *  @param string 字符串
 *
 *  @return 数据
 */
+ (NSInteger)getNumberWithString:(NSString *)string;

/**
 *  根据正则截取字符串
 *
 *  @param regex  正则
 *  @param string 要截取字符串
 *
 *  @return 匹配的字符串
 */
+ (NSString *)subStringWithRegex:(NSString *)regex string:(NSString *)string;

/**
 *  根据正则截取字符串
 *
 *  @param regex 正则
 *
 *  @return 要截取字符串
 */
- (NSString *)subStringWithRegex:(NSString *)regex;

/**
 *  根据正则截取字符串
 *
 *  @param regex 正则
 *
 *  @return 要截取字符串
 */
- (NSString *)subStringWithRegex2:(NSString *)regex;
/**
 *  截取到str之前的字符串
 *
 *  @param string 要截取字符串
 *
 *  @return 截取之后的字符串
 */
+ (NSString *)subStringToIndexWithStr:(NSString *)str string:(NSString *)string;

/**
 *  截取到str之后的字符串
 *
 *  @param string 要截取字符串
 *
 *  @return 截取之后的字符串
 */
+ (NSString *)subStringFromIndexWithStr:(NSString *)str string:(NSString *)string;

/**
 *  去除前面和后面空格
 *
 */
- (NSString *)removeStartAndEndSpace;

@end
