//
//  NSString+Extension.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  汉字转拼音
 *
 *  @param chinese 中文字符串
 *
 *  @return 拼音
 */
+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString: chinese];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //返回小写拼音
    return [str lowercaseString];
}

@end
