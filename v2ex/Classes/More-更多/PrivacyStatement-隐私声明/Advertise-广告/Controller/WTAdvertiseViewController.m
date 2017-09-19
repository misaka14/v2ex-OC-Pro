//
//  WTAdvertiseViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  鸣谢控制器

#import "WTAdvertiseViewController.h"
#import "WTAdvertiseViewModel.h"
#import "WTRefreshNormalHeader.h"
#import "WTAdvertiseCell.h"
#import "WTWebViewController.h"
#import "MJExtension.h"

NSString * const advertiseCellIdentifier = @"advertiseCellIdentifier";

@interface WTAdvertiseViewController ()
@property (nonatomic, strong) NSMutableArray<WTAdvertiseItem *> *advertiseItems;
@end

@implementation WTAdvertiseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 加载View
    [self setupView];
}

// 加载View
- (void)setupView
{
    self.title = @"广告中心";
    
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib: [UINib nibWithNibName: @"WTAdvertiseCell" bundle: nil] forCellReuseIdentifier: advertiseCellIdentifier];
    
    self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
    
    [self.tableView.mj_header beginRefreshing];
}

// 加载最新的数据
- (void)loadNewData
{
    
    // 由于这里的数据基本上只要请求一次就行了，所以事先直接把广告的数据写入到plist中读取
    [WTAdvertiseViewModel loadAdvertiseItemsFromNetworkWithSuccess:^(NSMutableArray<WTAdvertiseItem *> *advertiseItems) {
        
        self.advertiseItems = advertiseItems;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        WTLog(@"error:%@", error)
        [self.tableView.mj_header endRefreshing];
        
    }];
    self.advertiseItems = [WTAdvertiseItem mj_objectArrayWithFilename: @""];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.advertiseItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTAdvertiseCell *cell = [tableView dequeueReusableCellWithIdentifier: advertiseCellIdentifier];
    
    cell.advertiseItem = self.advertiseItems[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转至自定义的网页浏览器
    WTWebViewController *webViewVC = [WTWebViewController new];
    webViewVC.url = self.advertiseItems[indexPath.row].detailUrl;
    [self.navigationController pushViewController: webViewVC animated: nil];
}

@end
