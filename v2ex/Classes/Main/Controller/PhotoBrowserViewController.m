//
//  PhotoBrowserViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/8.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "TYImageCache.h"
#import "PhotoBrowserCell.h"
#import "Masonry.h"
#import "UIButton+Extension.h"
#import "SVProgressHUD.h"
static NSString * const ID = @"photoCell";

@interface PhotoBrowserViewController () <UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView   *collectionView;

@property (nonatomic, weak) UIButton           *saveButton;

@property (nonatomic, weak) UIButton           *closeButton;
@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册cell
    [self.collectionView registerClass: [PhotoBrowserCell class] forCellWithReuseIdentifier: ID];
    
    // 移动到指定cell位置
    NSUInteger index = [self.imageUrls indexOfObject: self.clickImageUrl];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem: index inSection: 0];
    [self.collectionView scrollToItemAtIndexPath: indexPath atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
    
    // 1、添加保存按钮
    [self saveButton];
    // 2、添加关闭按钮
    [self closeButton];
}


#pragma mark - 事件
#pragma mark 关闭按钮点击
- (void)closeButtonClick
{
    [self dismissViewControllerAnimated: YES completion: nil];
}
#pragma mark 保存按钮点击
- (void)saveButtonClick
{
    PhotoBrowserCell *cell = self.collectionView.visibleCells.firstObject;
    UIImage *image = cell.imageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != nil)
    {
        [SVProgressHUD showErrorWithStatus: @"保存失败"];
        return;
    }
    [SVProgressHUD showSuccessWithStatus: @"保存成功"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: ID forIndexPath: indexPath];
    
    cell.imageUrl = self.imageUrls[indexPath.item];
    
    return cell;
}

#pragma mark - 懒加载
#pragma mark collectionView
- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        // 1、创建布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = self.view.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        // 2、创建collectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout: layout];
        [self.view addSubview: collectionView];
        _collectionView = collectionView;
        
        // 3、设置属性
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark 保存按钮
- (UIButton *)saveButton
{
    if (_saveButton == nil)
    {
        // 1、添加保存按钮
        UIButton *saveButton = [UIButton buttonWithBackgroundColor: [UIColor darkGrayColor] addTarget: self action:@selector(saveButtonClick) title: @"保存"];
        _saveButton = saveButton;
        [self.view addSubview: saveButton];
        
        // 2、布局
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-8));
            make.bottom.equalTo(@(-8));
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return _saveButton;
}
#pragma mark 关闭按钮
- (UIButton *)closeButton
{
    if (_closeButton == nil)
    {
        // 1、添加保存按钮
        UIButton *closeButton = [UIButton buttonWithBackgroundColor: [UIColor darkGrayColor] addTarget: self action: @selector(closeButtonClick) title: @"关闭"];
        _closeButton = closeButton;
        [self.view addSubview: closeButton];
        
        // 2、布局
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(8));
            make.top.equalTo(@(28));
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return _closeButton;
}


@end
