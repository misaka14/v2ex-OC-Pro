//
//  WTTopicCollectionCell.m
//  v2ex
//
//  Created by gengjie on 16/8/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicCollectionCell.h"

#import "WTTopicCollectionItem.h"

#import "UILabel+StringFrame.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"

#import "UIImageView+WebCache.h"

@interface WTTopicCollectionCell()
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView            *iconImageV;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel                *titleLabel;
/** 节点 */
@property (weak, nonatomic) IBOutlet UIButton               *nodeBtn;
/** 最后回复时间 */
@property (weak, nonatomic) IBOutlet UILabel                *lastReplyTimeLabel;
/** 作者 */
@property (weak, nonatomic) IBOutlet UILabel                *authorLabel;
/** 回复数 */
@property (weak, nonatomic) IBOutlet UIImageView            *commentCountImageView;
/** 回复数 */
@property (weak, nonatomic) IBOutlet UILabel                *commentCountLabel;
@end
@implementation WTTopicCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 2、节点
    self.nodeBtn.layer.cornerRadius = 1.5;
    self.iconImageV.layer.cornerRadius = 5;
    self.iconImageV.layer.masksToBounds = YES;
    
    self.contentView.dk_backgroundColorPicker =  DKColorPickerWithKey(UITableViewBackgroundColor);

    
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    
    self.authorLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
    self.lastReplyTimeLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
    [self.nodeBtn dk_setTitleColorPicker: DKColorPickerWithKey(WTTopicCellLabelColor) forState: UIControlStateNormal];
    
    self.commentCountLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
}

- (void)setTopicCollectionItem:(WTTopicCollectionItem *)topicCollectionItem
{
    _topicCollectionItem = topicCollectionItem;
    
    // 1、头像
    [self.iconImageV sd_setImageWithURL: topicCollectionItem.avatarURL placeholderImage: WTIconPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconImageV.image = [image roundImageWithCornerRadius: 3];
        self.iconImageV.image = image;
    }];
    
    // 2、标题
    self.titleLabel.text = topicCollectionItem.title;
    
    // 3、节点
    if (topicCollectionItem.node.length > 0)
    {
        //self.nodeBtn.hidden = NO;
        NSString *node = topicCollectionItem.node;
        // 判断是否包含中文字符串
        if ([NSString isChineseCharactersWithString: node] || node.length > 4)
        {
            //NSLog(@"中文:%@", _blog.node);
            node = [NSString stringWithFormat: @" %@ ", topicCollectionItem.node];
        }
        [self.nodeBtn setTitle: node forState: UIControlStateNormal];
    }
    else
    {
        //self.nodeBtn.hidden = YES;
        [self.nodeBtn setTitle: @"" forState: UIControlStateNormal];
    }
    
    // 4、最后回复时间
    self.lastReplyTimeLabel.text = topicCollectionItem.lastReplyTime;
    
    // 6、作者
    self.authorLabel.text = topicCollectionItem.author;
    
    // 7、评论数
    self.commentCountLabel.text = topicCollectionItem.commentCount;
    self.commentCountImageView.hidden = !(topicCollectionItem.commentCount.length > 0);
}

@end
