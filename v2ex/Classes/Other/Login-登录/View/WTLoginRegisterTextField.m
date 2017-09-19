//
//  WTLoginRegisterTextField.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTLoginRegisterTextField.h"
#import "UITextField+Placeholder.h"
@implementation WTLoginRegisterTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 光标设置为白色
    self.tintColor = [UIColor whiteColor];
    
    self.placeholderColor = [UIColor lightGrayColor];
    
    [self addTarget: self action: @selector(beginEditing) forControlEvents: UIControlEventEditingDidBegin];
    
    [self addTarget: self action: @selector(endEditing) forControlEvents: UIControlEventEditingDidEnd];
}

// 开始编辑
- (void)beginEditing
{
    self.placeholderColor = [UIColor whiteColor];
}

// 结束编辑 
- (void)endEditing
{
    self.placeholderColor = [UIColor lightGrayColor];
}

@end
