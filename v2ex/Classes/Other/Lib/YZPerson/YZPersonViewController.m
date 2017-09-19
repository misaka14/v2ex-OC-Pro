//
//  YZPersonViewController.m
//  个人详情控制器
//
//  Created by yz on 15/8/13.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "YZPersonViewController.h"

#import "YZPersonTableViewController.h"

#define YZClickBtnObjcKey @"clickBtnObjc"
#define YZClickBtnNote @"clickBtn"
@interface YZPersonViewController ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *tabBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak) UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarHeightLayoutCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewCons;

/** 各种控制器的offSet的值 */
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDict;

@property (nonatomic, assign, getter=isFirstStart) BOOL firstStart;


@end

@implementation YZPersonViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:@"YZPersonViewController" bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 不自动添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 接收按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserverForName:YZClickBtnNote object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
       
        UIButton *clickBtnObjc = note.userInfo[YZClickBtnObjcKey];
        
        [self btnClick:clickBtnObjc];
        
        
    }];
    
    
    self.personIconView.layer.cornerRadius = 73 * 0.5;
    self.personIconView.layer.masksToBounds = YES;
    self.contentOffsetDict = [NSMutableDictionary dictionary];
}
// 设置导航条
- (void)setUpNav
{
    // 导航条背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条中间view
    UILabel *label = [[UILabel alloc] init];
    
    _titleLabel = label;
    
    label.font = [UIFont  boldSystemFontOfSize:18];
    
    label.text = self.title;
    
    [label setTextColor:[UIColor colorWithWhite:1 alpha:0]];
    
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
}

// 设置子控制器
- (void)setUpChildControlller
{
    for (YZPersonTableViewController *personChildVc in self.childViewControllers) {
        
        // 传递tabBar，用来判断点击了哪个按钮
        personChildVc.tabBar = _tabBar;
        
        // 传递高度约束，用来移动头部视图
        personChildVc.headHCons = _headViewCons;
        
        // 传递标题控件，设置文字透明
        personChildVc.titleLabel = _titleLabel;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 即将显示的时候做一次初始化操作
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    if (!self.isFirstStart) {
        self.firstStart = YES;
        
        
        // 设置子控制器
        [self setUpChildControlller];
        
        // 设置tabBar
        [self setUpTabBar];
    }
    [self setUpNav];
    
//    });
    
}


 // 设置tabBar
- (void)setUpTabBar
{
    // 遍历子控制器

    for (UIViewController *childVc in self.childViewControllers) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = _tabBar.subviews.count;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitle:childVc.title forState:UIControlStateNormal];
        
        [btn setTitleColor: WTColor(111, 111, 111) forState:UIControlStateNormal];
        
        [btn setTitleColor: WTSelectedColor forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btn.tag == 0) {
            [self btnClick:btn];
        }
        
        [_tabBar addSubview:btn];
        
        
    }
    
}

- (void)btnClick:(UIButton *)btn
{
    
    if (btn == _selectedBtn) {
        return;
    }
    
    // 将上一次选中的控制器的view移除内容视图
    
    UITableView *lastVcView = (UITableView *)[self.childViewControllers[_selectedBtn.tag] view];
    
    [lastVcView removeFromSuperview];
    
    self.contentOffsetDict[@(self.selectedBtn.tag)] = @(lastVcView.contentOffset.y);
    
    
    // 选中按钮
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;

    // 切换内容视图显示
    UITableViewController *vc = self.childViewControllers[btn.tag];
    
    vc.view.frame = _contentView.bounds;
    
    [_contentView addSubview:vc.view];
    
    // 调整各个tableView的offSet值
//    CGFloat tabBarHeight = self.tabBarHeightLayoutCons.constant;
//    if (lastVcView.contentOffset.y < -tabBarHeight)
//    {
//        vc.tableView.contentOffset = lastVcView.contentOffset;
//        WTLog(@"height:%lf", vc.tableView.contentSize.height);
//        
//
//            vc.tableView.contentOffset = lastVcView.contentOffset;
//        
//    }
//    else
//    {
//        NSInteger currentViewContentOffsetY = [self.contentOffsetDict[@(btn.tag)] integerValue];
//        
//        if (currentViewContentOffsetY > -tabBarHeight)
//        {
//            vc.tableView.contentOffset = CGPointMake(0, currentViewContentOffsetY);
//        }
//        else
//        {
//            //if (vc.tableView.contentSize.height ) {
//            WTLog(@"height:%lf", vc.tableView.contentSize.height);
////            }
//            if (vc.tableView.contentSize.height < vc.tableView.height)
//            {
//                vc.tableView.contentOffset = CGPointMake(0, -244);
//            }
//            else
//            {
//                vc.tableView.contentOffset = CGPointMake(0, -44);
//            }
//        }
//    }
    WTLog(@"offsetY:%zd", [self.contentOffsetDict[@(btn.tag)] integerValue])
    NSNumber *currentViewOffsetY = self.contentOffsetDict[@(btn.tag)];
    CGPoint currentPoint = (currentViewOffsetY == nil) ? CGPointMake(0, -244) : CGPointMake(0, [currentViewOffsetY integerValue]);
    [vc.tableView setContentOffset: currentPoint animated: YES];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    // 布局tabBar子控件位置
    NSUInteger count = _tabBar.subviews.count;
    
    CGFloat btnW = self.view.bounds.size.width / count;
    
    CGFloat btnH = _tabBar.bounds.size.height;
    
    CGFloat btnX = 0;
    
    CGFloat btnY = 0;
    
    for (int i = 0; i < count; i++) {
        
        btnX = i * btnW;
        
        UIView *childV = _tabBar.subviews[i];
        
        childV.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];


}

- (IBAction)personCardViewGes:(UITapGestureRecognizer *)sender {
}
@end
