//
//  UIButton+Extension.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/8.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/**
 *  创建一个按钮
 *
 *  @param color  背景颜色
 *  @param target 调用者
 *  @param action 调用方法
 *  @param title  标题
 *
 *  @return 按钮
 */
+ (instancetype)buttonWithBackgroundColor:(UIColor *)color addTarget:(id)target action:(SEL)action title:(NSString *)title;
@end
