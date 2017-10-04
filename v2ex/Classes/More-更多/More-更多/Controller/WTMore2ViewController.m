//
//  WTMore2ViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/30.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTMore2ViewController.h"

#import "WTSettingItem.h"

@interface WTMore2ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WTMore2ViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // 1、初始化数据
    [self initData];
}

- (void)initData
{
    
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

@end
