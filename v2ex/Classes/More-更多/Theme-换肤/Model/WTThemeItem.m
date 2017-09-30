//
//  WTThemeItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/19.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTThemeItem.h"

@implementation WTThemeItem
/**
 快速创建
 
 @param title 名称
 @param iconImage 截图
 @param themeVersion 主题名称
 @param selected 是否选中
 @return WTThemeItem
 */
+ (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage themeVersion:(NSString *)themeVersion selected:(BOOL)selected
{
    WTThemeItem *item = [WTThemeItem new];
    item.title = title;
    item.themeVersion = themeVersion;
    item.iconImage = iconImage;
    item.selected = selected;
    return item;
}
@end
