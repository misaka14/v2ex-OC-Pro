//
//  WTMoreButton.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/27.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMoreButton.h"
#import "UIFont+Extension.h"

CGFloat const WTMoreButtonH = 90;

CGFloat const imageViewWH = 25;

@implementation WTMoreButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        self.titleLabel.font = [UIFont QiHeiforSize: 14];
        
        
        // 添加边框线条
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        
        {
            
            lineLayer.frame = self.bounds;
            UIBezierPath *linePath = [[UIBezierPath alloc] init];
            [linePath moveToPoint: CGPointZero];
            [linePath addLineToPoint: CGPointMake(WTMoreButtonW, 0)];
            [linePath addLineToPoint: CGPointMake(WTMoreButtonW, WTMoreButtonH)];
            
            lineLayer.path = linePath.CGPath;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            lineLayer.strokeColor = [UIColor colorWithHexString: @"#666666" alpha: 0.1].CGColor;
            [self.layer addSublayer: lineLayer];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewX = (self.width - imageViewWH) * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, 25, imageViewWH, imageViewWH);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.titleLabel sizeToFit];
    CGFloat titleLabelX = (self.width - self.titleLabel.width) * 0.5;
    self.titleLabel.x = titleLabelX;
    self.titleLabel.y = 60;
}

@end
