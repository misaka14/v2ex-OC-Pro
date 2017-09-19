//
//  TodayCell.m
//  v2ex
//
//  Created by gengjie on 2016/10/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "TodayCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "WTTopicApiItem.h"
#import "WTMemberAPIItem.h"
#define HTTPS @"https:"
@class WTTopicApiItem;
@interface TodayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TodayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageV.layer.cornerRadius = 1;
    self.avatarImageV.layer.masksToBounds = YES;
}

-(void)setTopicApiItem:(WTTopicApiItem *)topicApiItem
{
    _topicApiItem = topicApiItem;
    
    NSURL *avatarURL = [NSURL URLWithString: [HTTPS stringByAppendingString: topicApiItem.member.avatar_large]];
    [self.avatarImageV sd_setImageWithURL: avatarURL placeholderImage: [UIImage imageNamed: @"topic_avatar_normal"]];
    
    self.titleLabel.text = topicApiItem.title;
}

@end
