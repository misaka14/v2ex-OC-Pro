//
//  WTV2GroupViewController.m
//  v2ex
//
//  Created by gengjie on 2016/10/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTV2GroupViewController.h"
#import "NetworkTool.h"
#import "WTURLConst.h"
#import "WTUserItem.h"
#import "MJExtension.h"

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface WTV2GroupViewController ()


@property (nonatomic, strong) UIButton *gpsButton;

@property (nonatomic, strong) NSMutableArray<WTUserItem *> *userItems;
@end

@implementation WTV2GroupViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initView];
//    
//    [self initData];
}


@end
