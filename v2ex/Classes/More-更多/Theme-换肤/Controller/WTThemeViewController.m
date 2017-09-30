//
//  WTThemeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/19.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTThemeViewController.h"
#import "UIViewController+Extension.h"

#import "WTThemeCell.h"

#import "WTThemeItem.h"

@interface WTThemeViewController ()
/** 主题数组 */
@property (nonatomic, strong) NSMutableArray<WTThemeItem *> *themeItems;
/** 上一次选中的主题 */
@property (nonatomic, weak) WTThemeItem *prevThemeItem;
@end

@implementation WTThemeViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、初始化View
    [self initView];
    
    // 2、初始化数据
    [self initData];
}

#pragma mark - Private 
- (void)initView
{
    // 1、设置layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 2、注册
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([WTThemeCell class]) bundle: nil] forCellWithReuseIdentifier: reuseIdentifier];
    
    // 3、导航标题
    [self navViewWithTitle: @"主题"];
    
    // 4、背景色
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)initData
{
    self.themeItems = [NSMutableArray array];
    
    WTThemeItem *item0 = [WTThemeItem initWithTitle: @"经典白" iconImage: [UIImage imageNamed: @"theme_normal.PNG"] themeVersion: DKThemeVersionNormal selected: NO];
    
    WTThemeItem *item1 = [WTThemeItem initWithTitle: @"质感黑" iconImage: [UIImage imageNamed: @"theme_night.PNG"] themeVersion: DKThemeVersionNight selected: NO];
    
    [self.themeItems addObjectsFromArray: @[item0, item1]];
    
    for (NSUInteger i = 0; i < self.themeItems.count; i++)
    {
        WTThemeItem *themeItem = self.themeItems[i];
        if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: themeItem.themeVersion])
        {
            themeItem.selected = YES;
            self.prevThemeItem = themeItem;
            break;
        }
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.themeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WTThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.themeItem = self.themeItems[indexPath.row];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.prevThemeItem = self.themeItems[indexPath.row];
}

#pragma mark - Setter
- (void)setPrevThemeItem:(WTThemeItem *)prevThemeItem
{
    _prevThemeItem.selected = NO;
    _prevThemeItem = prevThemeItem;
    _prevThemeItem.selected = YES;
    
    NSInteger index = [self.themeItems indexOfObject: prevThemeItem];
    
    [DKNightVersionManager sharedManager].themeVersion = prevThemeItem.themeVersion;
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: index inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
}
@end
