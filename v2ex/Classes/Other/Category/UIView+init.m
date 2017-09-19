//
//  UIView+init.m
//  BaiDeJie
//
//  Created by 无头骑士 GJ on 16/2/18.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "UIView+init.h"

@implementation UIView (init)
/**
 *  快速创建的类方法
 *
 */
+ (instancetype)wt_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed: NSStringFromClass(self) owner: nil options: nil].firstObject;
}
@end
