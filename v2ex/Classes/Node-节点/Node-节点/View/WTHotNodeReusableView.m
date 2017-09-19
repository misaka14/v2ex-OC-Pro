//
//  WTHotNodeReusableView.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTHotNodeReusableView.h"
@interface WTHotNodeReusableView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation WTHotNodeReusableView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewCellBgViewBackgroundColor);
    
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

@end
