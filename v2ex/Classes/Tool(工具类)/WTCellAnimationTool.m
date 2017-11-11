//
//  WTCellAnimationTool.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/28.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTCellAnimationTool.h"

@implementation WTCellAnimationTool


+ (void)animation01WithCell:(UITableViewCell *)cell
{
    CATransform3D  transform;
    transform = CATransform3DMakeRotation((CGFloat)((90.0 * M_PI) / 180.0), 0.0, 0.7, 0.4);
    transform.m34 = 1.0/-600;
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = transform;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);//锚点
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

+ (void)animation02WithCell:(UITableViewCell *)cell
{
    //以下是动画内容，自定义
    cell.transform=CGAffineTransformMakeTranslation(cell.bounds.size.width, 1);
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform=CGAffineTransformMakeTranslation(0, 1);
    }];
}

+ (void)animation03WithCell:(UITableViewCell *)cell
{
    cell.alpha = 0;
    [UIView animateWithDuration: 0.5 animations:^{
        cell.alpha = 1;
    }];
}

@end
