//
//  UIImage+Extension.h
//  WTNews
//
//  Created by 无头骑士 GJ on 15/12/8.
//  Copyright © 2015年 耿杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  加载原始图片，没有系统渲染
 *
 *  @param imageName 图片名称
 *
 *  @return 返回原始图片对象
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;


/**
 *  图片拉伸
 *
 *  @param imageName 图片名
 */
+ (UIImage *)resizingImageWithImageName:(NSString *)imageName;

// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  生成带边框的圆形图片
 *
 *  @param borderW 边框宽度
 *  @param color   边框颜色
 *  @param image   图片
 *
 *  @return 新的图片对象
 */
+ (UIImage *)imageWithBorderW:(CGFloat)borderW color:(UIColor *)color image:(UIImage *)image;


/**
 *  返回一个圆角图片
 *
 *  @return 圆角图片
 */
- (instancetype)roundImage;

/**
 *  根据cornerRadius返回圆角图片
 *
 *  @return 圆角图片
 */
- (instancetype)roundImageWithCornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
