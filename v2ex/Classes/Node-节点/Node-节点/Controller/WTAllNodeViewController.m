//
//  WTAllNodeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  所有节点的控制器

#import "WTAllNodeViewController.h"
#import "WTNodeViewModel.h"
#import "WTNodeTopicViewController.h"

NSString * const reuseIdentifier = @"reuseIdentifier";

@interface WTAllNodeViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation WTAllNodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 加载View
    [self setupView];
    
    // 加载数据
    [self setupData];
}

// 加载View
- (void)setupView
{
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: reuseIdentifier];
    
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = 22;
    
    self.tableView.bounces = NO;
}

// 加载数据
- (void)setupData
{
    self.datas = [WTNodeViewModel queryAllNodeItemsFromCache];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *nodeItems = self.datas[section];
    return nodeItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    
    NSArray<WTNodeItem *> *nodeItems = self.datas[indexPath.section];
    cell.textLabel.text = nodeItems[indexPath.row].title;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    
    label.text = WTIndexTitle[section];
    
    label.frame = CGRectMake(0, 0, WTScreenWidth, 20);
    
    label.backgroundColor = WTColor(242, 242, 242);
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTNodeTopicViewController *nodeTopicVC = [WTNodeTopicViewController new];
    NSArray<WTNodeItem *> *nodeItems = self.datas[indexPath.section];
    nodeTopicVC.nodeItem = nodeItems[indexPath.row];
    [self.navigationController pushViewController: nodeTopicVC animated: YES];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return WTIndexTitle;
}


@end
