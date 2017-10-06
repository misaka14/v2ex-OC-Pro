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
@property (weak, nonatomic) IBOutlet UIImageView *reply_arrowImageV;        // 小图标

@end
@implementation WTReplyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    self.authorLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    self.replyTimeLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    self.replyContentLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
    self.replyContentBgView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    self.replyContentBgView.layer.cornerRadius = 3;
    self.reply_arrowImageV.dk_imagePicker = DKImagePickerWithNames(@"reply_arrow", @"reply_arrow_night");
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
