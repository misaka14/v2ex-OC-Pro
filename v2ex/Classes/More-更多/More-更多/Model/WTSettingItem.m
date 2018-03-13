//
//  WTSettingItem.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTSettingItem.h"

@implementation WTSettingItem

/**
 *  快速创建的方法
 *
 *  @param title          标题
 *  @param image          图片
 *  @param operationBlock 点击的操作
 *
 *  @return WTSettingItem
 */
+ (instancetype)settingItemWithTitle:(NSString *)title image:(UIImage *)image operationBlock:(void(^)())operationBlock
{
    WTSettingItem *item = [WTSettingItem new];
    
    item.title = title;
    item.image = image;
    item.operationBlock = operationBlock;
    
    return item;
}

/**
 *  快速创建的方法
 *
 *  @param title          标题
 *  @param imageUrl       图片url
 *  @param operationBlock 点击的操作
 *
 *  @return WTSettingItem
 */
+ (instancetype)settingItemWithTitle:(NSString *)title image:(UIImage *)image imageUrl:(NSURL *)imageUrl operationBlock:(void(^)(void))operationBlock
{
    WTSettingItem *item = [WTSettingItem new];
    
    item.title = title;
    item.image = image;
    item.imageUrl = imageUrl;
    item.operationBlock = operationBlock;
    
    return item;
}

@end
