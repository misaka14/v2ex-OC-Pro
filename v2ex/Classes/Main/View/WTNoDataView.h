//
//  WTNoDataView.h
//  v2ex
//
//  Created by gengjie on 16/8/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNoDataView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipTitleLabel;

+ (instancetype)noDataView;

@end
