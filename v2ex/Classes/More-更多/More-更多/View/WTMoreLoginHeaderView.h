//
//  WTMoreLoginHeaderView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/27.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTAccount;
@interface WTMoreLoginHeaderView : UIView

@property (nonatomic, strong) WTAccount *account;

+ (instancetype)moreLoginHeaderView;

@end
