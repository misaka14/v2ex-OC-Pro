//
//  WTRefreshNormalHeader.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/18.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTRefreshNormalHeader.h"

@implementation WTRefreshNormalHeader

- (void)prepare
{
    [super prepare];
    
    // 自动透明度
    self.automaticallyChangeAlpha = YES;
    // 隐藏最后更新时间
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
