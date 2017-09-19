//
//  WTPersonTableViewController.h
//  个人详情控制器
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WTHeadViewH 200

#define WTHeadViewMinH 64

#define WTTabBarH 44

@interface WTPersonTableViewController : UITableViewController

@property (nonatomic, weak) UIView *tabBar;

@property (nonatomic, weak) NSLayoutConstraint *headHCons;

@property (nonatomic, weak) UILabel *titleLabel;

@end
