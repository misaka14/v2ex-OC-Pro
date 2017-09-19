//
//  WTNoDataView.m
//  v2ex
//
//  Created by gengjie on 16/8/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNoDataView.h"

@implementation WTNoDataView

+ (instancetype)noDataView
{
    return [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([WTNoDataView class]) owner: nil options: nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
    self.tipTitleLabel.textColor = WTColor(219, 218, 232);
}

@end
