//
//  UITextField+Placeholder.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>
@implementation UITextField (Placeholder)

+ (void)load
{
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    
    Method wt_setPlaceholderMethod = class_getInstanceMethod(self, @selector(wt_placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, wt_setPlaceholderMethod);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *placeholderLabel = [self valueForKey: @"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

- (void)wt_placeholder:(NSString *)placeholder
{
    [self wt_placeholder: placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

@end
