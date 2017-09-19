//
//  WTHotNodeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  热门节点

#import "WTHotNodeViewController.h"
#import "WTNodeViewModel.h"
#import "WTHotNodeCell.h"
#import "WTHotNodeFlowLayout.h"
#import "WTHotNodeReusableView.h"
#import "WTTopicViewController.h"
#import "WTNodeTopicViewController.h"
#import "MJExtension.h"

static NSString *const ID = @"topicCell";

@interface WTHotNodeViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) WTNodeViewModel *nodeVM;

/** 热点节点的数组 */
@property (nonatomic, strong) NSMutableArray<WTNodeViewModel *> *nodeVMs;

@end

@implementation WTHotNodeViewController

static NSString * const reuseIdentifier = @"reuseIdentifier";

static NSString * const headerViewReuseIdentifier = @"headerViewReuseIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置View
    [self setupView];
    
    // 设置数据
    [self setupData];
}

/**
 *   设置View
 */
- (void)setupView
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(WTHotNodeCellSpacing, WTHotNodeSectionLeft, WTHotNodeCellSpacing, 0);
    layout.minimumInteritemSpacing = WTHotNodeMinimumInteritemSpacing;
    layout.minimumLineSpacing = WTHotNodeCellSpacing;
    
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    self.collectionView.bounces = NO;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerNib: [UINib nibWithNibName: @"WTHotNodeCell" bundle: nil] forCellWithReuseIdentifier: reuseIdentifier];

    [self.collectionView registerNib: [UINib nibWithNibName: @"WTHotNodeReusableView" bundle: nil] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: headerViewReuseIdentifier];
}

/**
 *  设置数据
 */
- (void)setupData
{
//    self.nodeVM = [WTNodeViewModel new];
    
    self.nodeVMs = [WTNodeViewModel mj_objectArrayWithFilename: @"hotNode.plist"];
    
    // 从网络上读取最热节点并，写入plist文件中
//    __weak typeof(self) weakSelf = self;
//    [self.nodeVM getNodeItemsWithSuccess:^(NSMutableArray<WTNodeViewModel *> *nodeVMs) {
//    
//        weakSelf.nodeVMs = nodeVMs;
//        
//
//        NSArray *arr = [WTNodeViewModel keyValuesArrayWithObjectArray: nodeVMs];
//        NSURL *fileUrl = [NSURL fileURLWithPath: @"/Users/wutouqishigj/Desktop/hotNode.plist"];
//        BOOL flag = [arr writeToURL: fileUrl atomically: NO];
//        if (flag)
//        {
//            WTLog(@"写入成功")
//        }
//        
//        [self.collectionView reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.nodeVMs.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.nodeVMs[section].nodeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WTHotNodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier forIndexPath: indexPath];
    
    cell.nodeItem = self.nodeVMs[indexPath.section].nodeItems[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WTHotNodeReusableView *hotNodeRView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier: headerViewReuseIdentifier forIndexPath: indexPath];

    hotNodeRView.title = self.nodeVMs[indexPath.section].title;
    
    return hotNodeRView;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTNodeItem *nodeItem = self.nodeVMs[indexPath.section].nodeItems[indexPath.row];
    WTNodeTopicViewController *nodeTopicVC = [WTNodeTopicViewController new];
    nodeTopicVC.nodeItem = nodeItem;
    [self.navigationController pushViewController: nodeTopicVC animated: YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.nodeVMs[indexPath.section].nodeItems[indexPath.row].width, 25);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 35);
}

@end
