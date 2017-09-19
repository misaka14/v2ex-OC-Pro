//
//  NSString+Extension.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  汉字转拼音
 *
 *  @param chinese 中文字符串
 *
 *  @return 拼音
 */
+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese;

@end
