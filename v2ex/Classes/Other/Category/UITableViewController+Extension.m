//
//  UITableViewController+Extension.m
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "UITableViewController+Extension.h"
#import "UIImage+Extension.h"
@implementation UITableViewController (Extension)

+ (void)load
{
    // 1、交换ViewDidLoad方法
    [self exchangeViewDidLoad];
    
}

+ (void)exchangeViewDidLoad
{
    Method t_viewWillAppear = class_getInstanceMethod(self, @selector(t_viewWillAppear:));
    
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    method_exchangeImplementations(t_viewWillAppear, viewWillAppear);
}

- (void)t_viewWillAppear:(BOOL)animated
{
    [self t_viewWillAppear: animated];
    
    if ([self isKindOfClass: NSClassFromString(@"YZPersonTableViewController")])
        return;
    
    //声明tableView的位置 添加下面代码
    if (@available(iOS 11.0, *))
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(WTNavigationBarMaxY, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHexString: @"#F2F3F5"];
    headerView.width = WTScreenWidth;
    headerView.height = 10;
    self.tableView.tableHeaderView = headerView;
}

@end
