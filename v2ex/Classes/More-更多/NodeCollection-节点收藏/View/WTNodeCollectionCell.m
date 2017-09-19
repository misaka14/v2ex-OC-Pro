//
//  WTNodeCollectionCell.m
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNodeCollectionCell.h"

#import "WTNodeItem.h"

#import "UIImageView+WebCache.h"

@interface WTNodeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WTNodeCollectionCell

- (void)setNodeItem:(WTNodeItem *)nodeItem
{
    _nodeItem = nodeItem;
    
    [self.iconImageV sd_setImageWithURL: nodeItem.avatar_large placeholderImage: nil];
    self.titleLabel.text = nodeItem.title;
}

@end
