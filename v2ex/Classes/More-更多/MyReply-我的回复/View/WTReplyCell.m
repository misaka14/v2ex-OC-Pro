//
//  WTReplyCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/2.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  我的回复Cell

#import "WTReplyCell.h"
#import "WTReplyItem.h"

#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"

@interface WTReplyCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;             // 头像
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;                  // 作者
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;                   // 标题
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;               // 回复时间
@property (weak, nonatomic) IBOutlet UIView *replyContentBgView;            // 回复内容背景的View
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;            // 回复内容 

@end
@implementation WTReplyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.authorLabel.textColor = [UIColor colorWithHexString: WTTopicCellMainColor];
    
    self.titleLabel.textColor = [UIColor colorWithHexString: WTTopicCellMainColor];
    
    self.replyTimeLabel.textColor = [UIColor colorWithHexString: @"#737373"];
    self.replyContentBgView.backgroundColor = [UIColor colorWithHexString: @"#F3F3F5"];
    self.replyContentBgView.layer.cornerRadius = 3;
//    self.avatarImageV.layer.cornerRadius = self.avatarImageV.width * 0.5;
//    self.avatarImageV.layer.masksToBounds = YES;
}

- (void)setReplyItem:(WTReplyItem *)replyItem
{
    _replyItem = replyItem;
    
    self.authorLabel.text = replyItem.author;
    
    self.titleLabel.text = replyItem.title;
    
    self.replyTimeLabel.text = replyItem.replyTime;
    
    self.replyContentLabel.text = replyItem.replyContent;
    
    
    if (replyItem.avatarURL != nil)
    {
        [self.avatarImageV sd_setImageWithURL: replyItem.avatarURL placeholderImage: WTIconPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.avatarImageV.image = [image roundImageWithCornerRadius: 3];
        }];
    }  
}

@end
