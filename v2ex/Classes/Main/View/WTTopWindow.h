//
//  WTTopWindow.h
//  监听状态栏区域的点击
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTopWindow : UIWindow

/**
 *  显示顶层window
 *
 *  @param block 这个block会在状态栏区域被点击的时候调用
 */
+ (void)showWithStatusBarClickBlock:(void (^)())block;

@end


//int a = 20;
//@property (nonatomic, assign) int a;
//- (void)setA:(int)a
//{
//
//}
//
//
//void (^block)(int, int) = ^(int a, int b) {
//    return a + b;
//};
//@property (nonatomic, copy) void (^block)(int, int);
//- (void)setBlock:(void (^)(int, int))block
//{
//
//}
