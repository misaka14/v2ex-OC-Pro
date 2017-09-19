//
//  WTTopicDetailCommentCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetailCommentCell.h"
#import "UIImageView+WebCache.h"
#import "WTTopicDetailViewModel.h"
@interface WTTopicDetailCommentCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 作者 */
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 正文内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 楼层*/
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

@end

@implementation WTTopicDetailCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    
    // 头像点击手势添加
    [self.iconImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(iconImageViewClick)]];
    self.iconImageView.userInteractionEnabled = YES;
}

- (void)setTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    _topicDetailVM = topicDetailVM;
    
    // 头像
    [self.iconImageView sd_setImageWithURL: topicDetailVM.iconURL placeholderImage: WTIconPlaceholderImage];
    
    // 作者
    self.authorLabel.text = topicDetailVM.topicDetail.author;
    
    // 创建时间
    self.createTimeLabel.text = topicDetailVM.topicDetail.createTime;
    
    // 正文内容
    self.contentLabel.text = topicDetailVM.topicDetail.content;
    
    // 楼层
    self.floorLabel.text = topicDetailVM.floorText;
}

#pragma mark - 事件
- (void)iconImageViewClick
{
    if ([self.delegate respondsToSelector: @selector(topicDetailCommentCell:iconImageViewClickWithTopicDetailVM:)])
    {
        [self.delegate topicDetailCommentCell: self iconImageViewClickWithTopicDetailVM: self.topicDetailVM];
    }
}

@end
