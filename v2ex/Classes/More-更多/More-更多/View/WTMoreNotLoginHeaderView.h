//
//  WTMoreNotLoginHeaderView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/27.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMoreNotLoginHeaderView;

@protocol WTMoreNotLoginHeaderViewDelegate <NSObject>

- (void)moreNotLoginHeaderViewDidClickedLoginBtn:(WTMoreNotLoginHeaderView *)moreNotLoginHeaderView;

- (void)moreNotLoginHeaderViewDidClickedRegisterBtn:(WTMoreNotLoginHeaderView *)moreNotLoginHeaderView;

@end

@interface WTMoreNotLoginHeaderView : UIView

@property (nonatomic, weak) id<WTMoreNotLoginHeaderViewDelegate> delegate;

#pragma mark - init
+ (instancetype)moreNotLoginHeaderView;

@end
