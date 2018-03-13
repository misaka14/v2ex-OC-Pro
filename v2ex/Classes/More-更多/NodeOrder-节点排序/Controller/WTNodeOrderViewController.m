//
//  WTNodeOrderViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2018/3/13.
//  Copyright © 2018年 无头骑士 GJ. All rights reserved.
//

#import "WTNodeOrderViewController.h"

#import "WTNode.h"

#import "MJExtension.h"

@interface WTNodeOrderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView                            *tableView;
/** WTNode数组*/
@property (nonatomic, strong) NSMutableArray<WTNode *>                     *nodes;

@end

@implementation WTNodeOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)initView
{
    self.tableView.editing = YES;
}

- (void)initData
{
    
}

#pragma mark - Lazy
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStyleGrouped];
        tableView.y = WTNavigationBarMaxY;
        [self.view addSubview: tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark nodes
- (NSMutableArray<WTNode *> *)nodes
{
    if (_nodes == nil)
    {
        _nodes = [WTNode mj_objectArrayWithFilename: @"nodes.plist"];
    }
    return _nodes;
}

@end
