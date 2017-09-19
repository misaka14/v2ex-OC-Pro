//
//  WTNodeTopicCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNodeTopicCell.h"
#import "WTNodeTopicAPIItem.h"
#import "UIImageView+WebCache.h"
#import "WTURLConst.h"

@interface WTNodeTopicCell()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (weak, nonatomic) IBOutlet UILabel *title_Label;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
@implementation WTNodeTopicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
}

- (void)setNodeTopicAPIItem:(WTNodeTopicAPIItem *)nodeTopicAPIItem
{
    _nodeTopicAPIItem = nodeTopicAPIItem;
    
    self.usernameLabel.text = nodeTopicAPIItem.member.username;
    
    [self.avatarImageV sd_setImageWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", WTHTTP, nodeTopicAPIItem.member.avatar_mini]]];
    
    self.title_Label.text = nodeTopicAPIItem.title;
    
    self.contentLabel.text = nodeTopicAPIItem.content;
}

@end
