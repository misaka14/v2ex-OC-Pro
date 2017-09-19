//
//  WTSettingItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTSettingItem : NSObject

/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 图片 */
@property (nonatomic, strong) UIImage *image;
/** 操作 */
@property (nonatomic, strong) void(^operationBlock)();
/** 操作 */
@property (nonatomic, strong) void(^operationReturnBlock)(UIButton *);

/**
 *  快速创建的方法
 *
 *  @param title          标题
 *  @param image          图片
 *  @param operationBlock 点击的操作
 *
 *  @return WTSettingItem
 */
+ (instancetype)settingItemWithTitle:(NSString *)title image:(UIImage *)image operationBlock:(void(^)())operationBlock;

/**
 *  快速创建的方法
 *
 *  @param title          标题
 *  @param image          图片
 *  @param operationBlock 点击的操作
 *
 *  @return WTSettingItem
 */
+ (instancetype)settingItemWithTitle:(NSString *)title image:(UIImage *)image operationBlock:(void(^)())operationBlock;

@end
