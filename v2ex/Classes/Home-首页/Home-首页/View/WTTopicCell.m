//
//  WTBlogCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicCell.h"

#import "WTTopic.h"

#import "UILabel+StringFrame.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"

#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTTopicCell ()
@property (weak, nonatomic) IBOutlet UIView                 *bgView;

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
/** 节点宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *nodeBtnWidthLayoutCons;
/** 最后回复时间的leading距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *lastReplyTimeLabelLeadingLayoutCons;

@end
@implementation WTTopicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.dk_backgroundColorPicker =  DKColorPickerWithKey(UITableViewBackgroundColor);
    self.bgView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewCellBgViewBackgroundColor);
    
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
//    self.titleLabel.textColor = [UIColor blackColor];
    
    self.authorLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
    self.lastReplyTimeLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
    [self.nodeBtn dk_setTitleColorPicker: DKColorPickerWithKey(WTTopicCellLabelColor) forState: UIControlStateNormal];
    
    self.commentCountLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);

    
    // 2、节点
    self.nodeBtn.layer.cornerRadius = 1.5;
    self.iconImageV.layer.cornerRadius = 5;
    self.iconImageV.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 3、阴影和圆角
    self.bgView.layer.cornerRadius = 3;
//    self.bgView.layer.shadowOpacity = 0.5;
//    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.bgView.layer.shadowRadius = 3;
//    self.bgView.layer.shadowOffset = CGSizeMake(3, 3);
    
}

- (void)setTopic:(WTTopic *)topic
{
    _topic = topic;
    
    // 1、头像
    [self.iconImageV sd_setImageWithURL: topic.iconURL placeholderImage: WTIconPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconImageV.image = [image roundImageWithCornerRadius: 3];
    }];
    
    // 2、标题
    self.titleLabel.text = topic.title;
    
    // 3、节点
    if (topic.node.length > 0)
    {
        [self.nodeBtn setTitle: topic.node forState: UIControlStateNormal];
        self.lastReplyTimeLabelLeadingLayoutCons.constant = 8;
        [self.nodeBtn sizeToFit];
    }
    else
    {
        self.nodeBtnWidthLayoutCons.constant = 0;
        self.lastReplyTimeLabelLeadingLayoutCons.constant = 0;
        [self.nodeBtn setTitle: @"" forState: UIControlStateNormal];
    }
    
    // 4、最后回复时间
    self.lastReplyTimeLabel.text = topic.lastReplyTime ? topic.lastReplyTime :  @" ";
    
    // 6、作者
    self.authorLabel.text = topic.author;
    
    // 7、评论数
    self.commentCountLabel.text = topic.commentCount;
    self.commentCountImageView.hidden = !(topic.commentCount.length > 0);
}

#pragma mark - 事件
#pragma mark 用户详情点击事件
- (IBAction)memeberDetailBtnClick
{
    if ([self.delegate respondsToSelector: @selector(topicCell:didClickMemberDetailAreaWithTopic:)])
    {
        [self.delegate topicCell: self didClickMemberDetailAreaWithTopic: self.topic];
    }
}


@end
NS_ASSUME_NONNULL_END
