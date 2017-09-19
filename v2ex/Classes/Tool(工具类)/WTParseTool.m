//
//  WTParseTool.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTParseTool.h"
#import "WTURLConst.h"
@implementation WTParseTool

#pragma mark - 把小图url解析成大图的Url
+ (NSURL *)parseBigImageUrlWithSmallImageUrl:(NSString *)smallImageUrl
{
    if (smallImageUrl.length == 0)
        return nil;
    
    // 1、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
    NSString *iconStr = smallImageUrl;
    if ([smallImageUrl containsString: @"normal.png"])
    {
        iconStr = [smallImageUrl stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
    }
    else if([smallImageUrl containsString: @"s=48"])
    {
        iconStr = [smallImageUrl stringByReplacingOccurrencesOfString: @"s=48" withString: @"s=96"];
    }
    return [NSURL URLWithString: [WTHTTP stringByAppendingString: iconStr]];
    
    return [self parseBigImageUrlWithSmallImageUrl: smallImageUrl isNormalPic: NO];
}
#pragma mark - 把小图url解析成大图的Url
+ (NSURL *)parseBigImageUrlWithSmallImageUrl: (NSString *)smallImageUrl isNormalPic:(BOOL)isNormalPic
{
    if (smallImageUrl.length == 0)
        return nil;
    
    // 1、头像 (由于v2ex抓下来的都不是清晰的头像，替换字符串转换成相对清晰的URL)
    NSString *iconStr = smallImageUrl;
    if ([smallImageUrl containsString: @"normal.png"])
    {
        iconStr = [smallImageUrl stringByReplacingOccurrencesOfString: @"normal.png" withString: @"large.png"];
    }
    else
    {
        if (isNormalPic)
        {
            iconStr = [smallImageUrl stringByReplacingOccurrencesOfString: @"s=36" withString: @"s=200"];
        }
        else
        {
            iconStr = [smallImageUrl stringByReplacingOccurrencesOfString: @"s=48" withString: @"s=96"];
        }
    }
    return [NSURL URLWithString: [WTHTTP stringByAppendingString: iconStr]];
}

#pragma mark - 把收藏的地址解析成喜欢的地址
+ (NSString *)parseThankUrlWithFavoriteUrl:(NSString *)favoriteUrl
{
    NSString *thankUrl = [favoriteUrl stringByReplacingOccurrencesOfString: @"unfavorite" withString: @"thank"];
    return [thankUrl stringByReplacingOccurrencesOfString: @"favorite" withString: @"thank"];
}

@end
