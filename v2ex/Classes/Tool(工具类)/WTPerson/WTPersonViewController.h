//
//  WTPersonViewController.h
//  个人详情控制器
//
//  Created by 无头骑士 GJ on 16/3/10.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTPersonViewController : UIViewController

// 个人头像控件
@property (weak, nonatomic) IBOutlet UIImageView *personIconView;

/** 个人头像控件 */
@property (strong, nonatomic)  UIImage *personIconImage;

/** 个人明信片控件 */
@property (strong, nonatomic)  UIImage *personCardImage;

/** 用户名 */
@property (strong, nonatomic)  NSString *personName;

// 设置导航条
- (void)setUpNav;
@end
