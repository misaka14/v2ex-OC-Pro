//
//  WTThemeItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/19.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTThemeItem : NSObject
/** 名称 */
@property (nonatomic, strong) NSString *title;
/** 截图 */
@property (nonatomic, strong) UIImage *iconImage;
/** 是否选中 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/** 主题名称 */
@property (nonatomic, strong) NSString *themeVersion;

/**
 快速创建

 @param title 名称
 @param iconImage 截图
 @param themeVersion 主题名称
 @param selected 是否选中
 @return WTThemeItem
 */
+ (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage themeVersion:(NSString *)themeVersion selected:(BOOL)selected;
@end
