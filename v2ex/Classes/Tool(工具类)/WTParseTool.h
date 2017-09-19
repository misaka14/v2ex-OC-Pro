//
//  WTParseTool.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTParseTool : NSObject

/**
 *  把小图url解析成大图的Url
 *
 *  @param smallImageUrl 小图的Url
 *
 *  @return 大图的URL
 */
+ (NSURL *)parseBigImageUrlWithSmallImageUrl:(NSString *)smallImageUrl;

/**
 *  把小图url解析成大图的Url
 *
 *  @param smallImageUrl 小图的Url
 *  @param isNormalPic   是否使用默认大图
 *
 *  @return 大图的URL
 */
+ (NSURL *)parseBigImageUrlWithSmallImageUrl:(NSString *)smallImageUrl isNormalPic:(BOOL)isNormalPic;
/**
 *  把收藏的地址解析成喜欢的地址
 *
 *  @param favoriteUrl 收藏的地址
 *
 *  @return 喜欢的地址
 */
+ (NSString *)parseThankUrlWithFavoriteUrl:(NSString *)favoriteUrl;

@end
