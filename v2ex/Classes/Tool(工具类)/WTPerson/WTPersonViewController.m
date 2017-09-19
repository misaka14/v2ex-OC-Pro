//
//  WTPersonViewController.m
//  个人详情控制器
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTPersonViewController.h"
#import "Masonry.h"
#import "WTPersonTableViewController.h"


#define WTClickBtnObjcKey @"clickBtnObjc"
#define WTClickBtnNote @"clickBtn"

#define WTTabBarSelectedViewWidth 100
#define WTTabBarSelectedViewHeight 2

@interface WTPersonViewController ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *tabBar;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewCons;

@property (nonatomic, weak) UIView *tabBarSelectedView;


// 个人明信片控件
@property (weak, nonatomic) IBOutlet UIImageView *personCardView;

/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation WTPersonViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:@"WTPersonViewController" bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 不自动添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 接收按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserverForName: WTClickBtnNote object: nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
       
        UIButton *clickBtnObjc = note.userInfo[WTClickBtnObjcKey];
        
        [self btnClick: clickBtnObjc];
    }];
}

// 设置导航条
- (void)setUpNav
{
    // 导航条背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条中间view
    UILabel *label = [[UILabel alloc] init];
    
    self.titleLabel = label;
    
    label.font = [UIFont  boldSystemFontOfSize: 18];
    
    label.text = self.title;
    
//    [label setTextColor:[UIColor colorWithWhite: 1 alpha: 0]];
    label.textColor = [UIColor blackColor];
    
    [label sizeToFit];
    label.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = label;
}

// 设置子控制器
- (void)setUpChildControlller
{
    for (WTPersonTableViewController *personChildVc in self.childViewControllers) {
        
        //self.personIconView.image = self.personIconImage;
        
        self.personCardView.image = self.personCardImage;
        
        self.usernameLabel.text = self.personName;
        
        // 传递tabBar，用来判断点击了哪个按钮
        personChildVc.tabBar = self.tabBar;
        
        // 传递高度约束，用来移动头部视图
        personChildVc.headHCons = self.headViewCons;
        
        // 传递标题控件，设置文字透明
        personChildVc.titleLabel = self.titleLabel;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setUpNav];
        
        // 设置子控制器
        [self setUpChildControlller];
        
        // 设置tabBar
        [self setUpTabBar];
    });
    
}

 // 设置tabBar
- (void)setUpTabBar
{
    [self.tabBar.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    // 遍历子控制器
    for (UIViewController *childVc in self.childViewControllers) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = self.tabBar.subviews.count;
        
        btn.titleLabel.font = [UIFont systemFontOfSize: 14];
        
        [btn setTitle: childVc.title forState: UIControlStateNormal];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btn.tag == 0) {
            [self btnClick:btn];
        }
        
        [self.tabBar addSubview:btn];
    }
    
    // 创建正在选中的按钮绿色的View
    UIView *tabBarSelectedView = [UIView new];
    tabBarSelectedView.backgroundColor = [UIColor orangeColor];
    [self.tabBar addSubview: tabBarSelectedView];
    self.tabBarSelectedView = tabBarSelectedView;
    
//    UIButton *firstBtn = self.tabBar.subviews[0];
//    [self.tabBarSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@2);
//        make.bottom.equalTo(self.tabBar.mas_bottom).offset(-1);
//        make.width.equalTo(@60);
//        make.centerX.equalTo(firstBtn.mas_centerX);
//    }];
}

- (void)btnClick:(UIButton *)btn
{
    
    if (btn == self.selectedBtn)
        return;
    
    //NSLog(@"contentView:%@", self.contentView.subviews);
    
    // 将上一次选中的控制器的view移除内容视图
    
    UITableView *lastVcView = (UITableView *)[self.childViewControllers[self.selectedBtn.tag] view];
    
    CGFloat lastVcViewOffsetY = lastVcView.contentOffset.y;
    
    [lastVcView removeFromSuperview];
    
    // 选中按钮
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;

    // 切换内容视图显示
    UITableViewController *vc = self.childViewControllers[btn.tag];
    
    vc.view.frame = self.contentView.bounds;
    
    [self.contentView addSubview:vc.view];
    
    // 模仿新浪微博，计算对应的contentOffset
    CGFloat maxY = WTHeadViewMinH + WTTabBarH;
    if (lastVcViewOffsetY > maxY)
    {
        if (vc.tableView.contentOffset.y < maxY)
        {
            vc.tableView.contentOffset = CGPointMake(vc.tableView.contentOffset.x, maxY);
        }
    }
    else
    {
        vc.tableView.contentOffset = lastVcView.contentOffset;
    }
    
    // 调整绿色的View的位置
//    [self.tabBarSelectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@2);
//        make.bottom.equalTo(self.tabBar.mas_bottom).offset(-1);
//        make.width.equalTo(@60);
//        make.centerX.equalTo(btn.mas_centerX);
//    }];
//    
//    [UIView animateWithDuration: 0.5 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
    [UIView animateWithDuration: 0.5 animations:^{
       
        self.tabBarSelectedView.centerX = btn.centerX;
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    // 布局tabBar子控件位置
    NSUInteger count = self.tabBar.subviews.count;
    
    CGFloat btnW = self.view.bounds.size.width / (count - 1);
    
    CGFloat btnH = self.tabBar.bounds.size.height;
    
    CGFloat btnX = 0;
    
    CGFloat btnY = 0;
    
    for (int i = 0; i < count; i++) {
        
        if ([self.tabBar.subviews[i] isMemberOfClass: [UIButton class]])
        {
            btnX = i * btnW;
            
            UIView *childV = self.tabBar.subviews[i];
            
            childV.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
    
    self.tabBarSelectedView.width = WTTabBarSelectedViewWidth;
    self.tabBarSelectedView.height = WTTabBarSelectedViewHeight;
    self.tabBarSelectedView.y = self.tabBar.height - WTTabBarSelectedViewHeight;
}
@end
