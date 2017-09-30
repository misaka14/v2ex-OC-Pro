//
//  UIViewController+Extension.h
//  v2ex
//
//  Created by gengjie on 16/8/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

@interface UIViewController (Extension)

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *nav_View;

/** 设置导航栏的背景图片 */
- (void)setNavBackgroundImage;


/** 添加导航栏 */
- (void)navView;

/** 添加导航栏 */
- (void)navViewWithTitle:(NSString *)title;


/**
 添加导航栏

 @param title 标题
 @param hideBack 是否隐藏返回按钮
 */
- (void)navViewWithTitle:(NSString *)title hideBack:(BOOL)hideBack;


/**
 获取栈顶控制器
 */
+ (UIViewController *)topVC;
@end
