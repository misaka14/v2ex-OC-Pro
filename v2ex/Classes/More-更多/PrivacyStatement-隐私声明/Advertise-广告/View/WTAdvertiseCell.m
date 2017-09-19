//
//  WTAdvertiseCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTAdvertiseCell.h"
#import "UIImageView+WebCache.h"

@interface WTAdvertiseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageVHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation WTAdvertiseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageVHeightCons.constant = self.width / 500 * 120;
}

- (void)setAdvertiseItem:(WTAdvertiseItem *)advertiseItem
{
    _advertiseItem = advertiseItem;
    
    [self.iconImageV sd_setImageWithURL: advertiseItem.icon];
    
    self.titleLabel.text = advertiseItem.title;
    
    self.contentLabel.text = advertiseItem.content;
}

@end
