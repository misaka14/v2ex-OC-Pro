//
//  YZPersonViewController.h
//  个人详情控制器
//
//  Created by yz on 15/8/13.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZPersonViewController : UIViewController

// 个人头像控件
@property (weak, nonatomic) IBOutlet UIImageView *personIconView;

// 个人明信片控件
@property (weak, nonatomic) IBOutlet UIImageView *personCardView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageV;

@property (weak, nonatomic) IBOutlet UIView *tabBar;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
