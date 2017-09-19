//
//  WTHotNodeCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTHotNodeCell.h"
#import "WTNodeItem.h"
#import "UIFont+Extension.h"

@interface WTHotNodeCell()
/** 标题Label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation WTHotNodeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.backgroundColor = WTRandomColor;
    self.titleLabel.font = [UIFont QiHeiforSize: 15];
    
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
}

- (void)setNodeItem:(WTNodeItem *)nodeItem
{
    _nodeItem = nodeItem;
    
    self.titleLabel.text = nodeItem.title;
}

@end
