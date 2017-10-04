//
//  WTNodeCollectionViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  节点收藏控制器

#import "WTNodeCollectionViewController.h"
#import "UIViewController+Extension.h"

#import "WTNodeCollectionCell.h"

#import "WTNodeViewModel.h"

#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"


NSString * const WTNodeCollectionCellIdentifier = @"WTNodeCollectionCellIdentifier";

@interface WTNodeCollectionViewController ()

@property (nonatomic, strong) WTNodeViewModel *nodeVM;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WTNodeCollectionViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.nodeVM = [WTNodeViewModel new];
    
    [self setupView];
}

- (void)setupView
{
    [self navViewWithTitle: @"节点收藏"];
        
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([WTNodeCollectionCell class]) bundle: nil] forCellWithReuseIdentifier: WTNodeCollectionCellIdentifier];
    
    // 添加下拉刷新、上拉刷新
    self.collectionView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
    self.collectionView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
    
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{

    [self.nodeVM getMyNodeCollectionItemsWithSuccess:^{
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    [self.nodeVM getMyNodeCollectionItemsWithSuccess:^{
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
    

}

#pragma mark - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nodeVM.nodeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTNodeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: WTNodeCollectionCellIdentifier forIndexPath: indexPath];
    
    cell.nodeItem = self.nodeVM.nodeItems[indexPath.row];
    
    return cell;
}
@end
