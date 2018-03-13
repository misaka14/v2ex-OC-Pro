//
//  WTToolBarButton.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2018/3/12.
//  Copyright © 2018年 无头骑士 GJ. All rights reserved.
//

#import "WTToolBarButton.h"

static CGFloat const WTToolBarButtonImageWH = 20;

@implementation WTToolBarButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.titleLabel.font = [UIFont systemFontOfSize: 10];
    [self setTitleColor: [UIColor colorWithHexString: @"#999999"] forState: UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewX = (self.width - WTToolBarButtonImageWH) * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, 0, WTToolBarButtonImageWH, WTToolBarButtonImageWH);
    
    
    [self.titleLabel sizeToFit];
    CGFloat titleLabelX = (self.width - self.titleLabel.width) * 0.5;
    self.titleLabel.x = titleLabelX;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 2;
}

@end
