//
//  UILabel+StringFrame.h
//  LQEachonline
//
//  Created by heji on 15/7/31.
//  Copyright (c) 2015年 luyongan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;

/**
 *  根据label内容长度的多少，设置label字体大小
 */
-(void) adjustFontSizeToFillItsContents;
@end
