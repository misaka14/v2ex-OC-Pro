//
//  WTTipView.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTipView.h"
@interface WTTipView()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

@end
@implementation WTTipView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString: @"#11cd6e"];
}

- (void)setTipTitle:(NSString *)tipTitle
{
    _tipTitle = tipTitle;
    self.tipLabel.text = tipTitle;
}

/**
 *  显示tipView
 *
 *  @param title 提示框文字
 */
- (void)showTipViewWithTitle:(NSString *)title
{
    CGRect frame = self.frame;
    self.tipTitle = title;
    [UIView animateWithDuration: 1.5 animations:^{
        
        self.frame = CGRectMake(0, 44, frame.size.width, frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration: 1.0 delay: 1.0 options: UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.frame = frame;
            
        } completion: nil];
        
    }];
}

/**
 *  显示错误信息
 *
 *  @param title 信息
 */
- (void)showErrorTitle:(NSString *)title
{
    self.tipTitle = title;
    self.tipImageView.image = [UIImage imageNamed:@"nav_close_white_normal"];
    self.backgroundColor = WTColor(208, 59, 59);
    [self startAnimate];
}

/**
 *  显示成功的信息
 *
 *  @param title 信息
 */
- (void)showSuccessTitle:(NSString *)title
{
    self.tipTitle = title;
    self.tipImageView.image = [UIImage imageNamed:@"tip_success_normal"];
    self.backgroundColor = [UIColor colorWithHexString: @"#11cd6e"];
    [self startAnimate];
}

/**
 *  开始动画
 */
- (void)startAnimate
{
    CGRect frame = self.frame;

    self.hidden = NO;
    [UIView animateWithDuration: 1.5 animations:^{
        
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration: 1.0 delay: 1.0 options: UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.frame = frame;
            
            
        } completion: ^(BOOL finished) {
            
            self.hidden = YES;
            
        }];
    }];
}

@end
