//
//  YZPersonTableViewController.h
//  个人详情控制器
//
//  Created by yz on 15/8/13.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNoDataView.h"
#import "WTRefreshView.h"
@interface YZPersonTableViewController : UITableViewController

@property (nonatomic, weak)   UIView *tabBar;

@property (nonatomic, weak)  NSLayoutConstraint *headHCons;

@property (nonatomic, weak) UILabel *titleLabel;

/** 没有数据的View */
@property (nonatomic, strong) WTNoDataView           *noDataView;
/** 正在加载的View */
@property (nonatomic, strong) WTRefreshView          *refreshView;

@property (nonatomic, assign) WTTableViewType        tableViewType;
@end
