//
//  WTMoreUserInfoCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2018/3/13.
//  Copyright © 2018年 无头骑士 GJ. All rights reserved.
//

#import "WTMoreUserInfoCell.h"

#import "WTSettingItem.h"

#import "UIImageView+WebCache.h"

@interface WTMoreUserInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *title_label;

@end
@implementation WTMoreUserInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.width * 0.5;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setItem:(WTSettingItem *)item
{
    _item = item;
    
    self.title_label.text = item.title;
    [self.iconImageView sd_setImageWithURL: item.imageUrl placeholderImage: item.image];
}

@end
