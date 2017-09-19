//
//  NSString+Regex.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "NSString+Regex.h"
#import "NSString+YYAdd.h"
@implementation NSString (Regex)


/**
 *  根据正则表达式来验证字符串是否符合规则
 *
 *  @param regex  正则表达式
 *  @param string 需要验证的字符串
 *
 *  @return YES 是 NO 否
 */
+ (BOOL)isAccordWithRegex:(NSString *)regex string:(NSString *)string
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject: string])
        return YES;
    return NO;
}

/**
 *  验证字符串是否包含中文
 *
 *  @param string 要验证码的字符串
 *
 *  @return YES 是 NO 否
 */
+ (BOOL)isChineseCharactersWithString:(NSString *)string
{
    return [self isAccordWithRegex: @"^[\u4E00-\u9FA5]*$" string: string];
}

/**
 *  从字符串中获取数字
 *
 *  @param string 字符串
 *
 *  @return 数据
 */
+ (NSInteger)getNumberWithString:(NSString *)string
{
    // 字符串中扫描指定的字符
    NSScanner *scanner = [NSScanner scannerWithString: string];
    
    // 从scan中扫描出set之外的数据放入value
    [scanner scanUpToCharactersFromSet: [NSCharacterSet decimalDigitCharacterSet] intoString: nil];
    
    // 接收查找的数字
    NSInteger number;
    
    //是否找到一个十进制 NSInteger
    [scanner scanInteger: &number];
    
    return number;
}

/**
 *  根据正则截取字符串
 *
 *  @param regex  正则
 *  @param string 要截取字符串
 *
 *  以什么开头，以什么结束 例 "a=123456aa6789" -> ".*(?<=a=)(.*)(?=aa).*" 
 *
 *  @return 匹配的字符串
 */
+ (NSString *)subStringWithRegex:(NSString *)regex string:(NSString *)string
{
    NSMutableString *str = [NSMutableString string];
    [string enumerateRegexMatches: regex options: NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
        [str appendString: match];
    }];
    
    return str;
}

/**
 *  根据正则截取字符串
 *
 *  @param regex 正则
 *
 *  @return 要截取字符串
 */
- (NSString *)subStringWithRegex:(NSString *)regex
{
    NSMutableString *str = [NSMutableString string];
    [self enumerateRegexMatches: regex options: NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
        [str appendString: match];
    }];
    
    return str;
}

/**
 *  根据正则截取字符串
 *
 *  @param regex 正则
 *
 *  @return 要截取字符串
 */
- (NSString *)subStringWithRegex2:(NSString *)regex
{
    NSMutableString *str = [NSMutableString string];
    [self enumerateRegexMatches: regex options: NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
        [str appendString: match];
    }];
    
    return [str stringByReplacingOccurrencesOfString: [regex substringWithRange: NSMakeRange(regex.length-1, 1)] withString: @""];
}

/**
 *  截取到str之前的字符串
 *
 *  @param string 要截取字符串
 *
 *  @return 截取之后的字符串
 */
+ (NSString *)subStringToIndexWithStr:(NSString *)str string:(NSString *)string
{
    NSRange range = [string rangeOfString: str];
    return [string substringToIndex: range.location];
}

/**
 *  截取到str之后的字符串
 *
 *  @param string 要截取字符串
 *
 *  @return 截取之后的字符串
 */
+ (NSString *)subStringFromIndexWithStr:(NSString *)str string:(NSString *)string
{
    if (![string containsString: str])
        return string;
    
    NSRange range = [string rangeOfString: str];
    return [string substringFromIndex: range.location + range.length];
}

/**
 *  去除前面和后面空格
 *
 */
- (NSString *)removeStartAndEndSpace
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



@end
