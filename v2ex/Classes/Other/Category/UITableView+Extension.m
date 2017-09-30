//
//  UITableView+Extension.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/20.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

+ (void)load
{
    // 1、交换ViewDidLoad方法
    [self exchangeViewDidLoad];
    
}

+ (void)exchangeViewDidLoad
{
    Method t_awakeFromNib = class_getInstanceMethod(self, @selector(t_awakeFromNib));
    
    Method awakeFromNib = class_getInstanceMethod(self, @selector(awakeFromNib));
    
    method_exchangeImplementations(t_awakeFromNib, awakeFromNib);
}

- (void)t_awakeFromNib
{
    if (![self isKindOfClass: [UITableView class]])
    {
        return;
    }
    [self t_awakeFromNib];
    
    //声明tableView的位置 添加下面代码
    if (@available(iOS 11.0, *))
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    self.contentInset = UIEdgeInsetsMake(WTNavigationBarMaxY, 0, 0, 0);
    self.scrollIndicatorInsets = self.contentInset;
    
    self.backgroundColor = [UIColor colorWithHexString: @"#F2F3F5"];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = self.backgroundColor;
    headerView.width = WTScreenWidth;
    headerView.height = 10;
    self.tableHeaderView = headerView;
}

@end
