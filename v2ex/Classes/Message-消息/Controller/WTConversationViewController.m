//
//  WTConversationViewController.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTConversationViewController.h"
#import "UIViewController+Extension.h"

#import "IQKeyboardManager.h"
@interface WTConversationViewController ()

@end

@implementation WTConversationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // 解决:融云与IQKeyboardManager的BUG
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    // 解决:融云与IQKeyboardManager的BUG
//    [IQKeyboardManager sharedManager].enable = NO;
//    [self setNavBackgroundImage];
}

@end
