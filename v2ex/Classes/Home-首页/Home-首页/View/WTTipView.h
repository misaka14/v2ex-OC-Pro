//
//  WTTipView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTipView : UIView
/** 提示标题 */
@property (nonatomic, strong) NSString          *tipTitle;


/**
 *  显示tipView
 *
 *  @param title 提示框文字
 */
- (void)showTipViewWithTitle:(NSString *)title;

/**
 *  显示错误信息
 *
 *  @param title 信息
 */
- (void)showErrorTitle:(NSString *)title;

/**
 *  显示成功的信息
 *
 *  @param title 信息
 */
- (void)showSuccessTitle:(NSString *)title;
@end
