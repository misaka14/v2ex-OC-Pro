//
//  WTNodeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  节点控制器

#import "WTNodeViewController.h"
#import "WTNodeViewModel.h"
#import "WTHotNodeViewController.h"
#import "WTHotNodeFlowLayout.h"
#import "WTAllNodeViewController.h"
#import "WTConst.h"
#import "NetworkTool.h"

@interface WTNodeViewController ()
/** 热门节点View */
@property (nonatomic, weak) UICollectionView *hotNodeCollectionView;
/** 所有节点View */
@property (nonatomic, weak) UITableView *allNodeTableView;
/** 导航栏 */
@property (weak, nonatomic) IBOutlet UIView *navView;
/** 导航栏线条 */
@property (weak, nonatomic) IBOutlet UIView *navLineView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation WTNodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置View
    [self setupView];
    
    // 加载数据
    [self setupData];
}

/**
 *  设置View
 */
- (void)setupView
{
    self.navView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    
    self.navLineView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarLineViewBackgroundColor);
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 0、设置nav的titleView
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems: @[@"最热", @"全部"]];
    control.selectedSegmentIndex = 0;
    control.width = 150;
    control.x = (WTScreenWidth - control.width) * 0.5;
    control.y = (WTTitleViewHeight - control.height) * 0.5 + 10;
    control.tintColor = WTSelectedColor;
    
    [control setTitleTextAttributes: @{NSForegroundColorAttributeName : WTSelectedColor} forState: UIControlStateNormal];
    [control setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    
    [control addTarget: self action: @selector(segmentedControlValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    
    [self.navView addSubview: control];
    
    // 1、添加热点节点控制器
    WTHotNodeViewController *hotNodeVC = [[WTHotNodeViewController alloc] initWithCollectionViewLayout: [WTHotNodeFlowLayout new]];
    [self addChildViewController: hotNodeVC];
    self.hotNodeCollectionView = hotNodeVC.collectionView;
    [self.contentView addSubview: self.hotNodeCollectionView];
    self.hotNodeCollectionView.frame = self.contentView.bounds;
}

/**
 *  加载数据
 */
- (void)setupData
{
    
}

#pragma mark - 事件
/**
 *  segmentedControl 事件
 *
 *  @param control segmentedControl
 */
- (void)segmentedControlValueChanged:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0)
    {
        [self.allNodeTableView removeFromSuperview];
        [self.contentView addSubview: self.hotNodeCollectionView];
    }
    else
    {
        [self.hotNodeCollectionView removeFromSuperview];
        [self.contentView addSubview: self.allNodeTableView];

    }
}

#pragma mark - Layz Method
- (UITableView *)allNodeTableView
{
    if (_allNodeTableView == nil)
    {
        WTAllNodeViewController *allNodeVC = [[WTAllNodeViewController alloc] init];
        [self addChildViewController: allNodeVC];
        
        _allNodeTableView = allNodeVC.tableView;
        _allNodeTableView.frame = self.contentView.bounds;
        [self.contentView addSubview: _allNodeTableView];
    }
    return _allNodeTableView;
}
@end
