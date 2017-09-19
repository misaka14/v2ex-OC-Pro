//
//  WTBaseSlidingViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/28.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTBaseSlidingViewController : UIViewController

@property (nonatomic, weak) UIView *headerContentView;
@property (nonatomic, weak) UIView *footerContentView;
@property (nonatomic, assign) CGFloat headerViewH;

@property (nonatomic, assign, getter=isShowTabBarFlag) BOOL showTabBarFlag;

@end
