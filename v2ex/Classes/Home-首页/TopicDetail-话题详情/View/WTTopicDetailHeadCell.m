//
//  WTTopicDetailHeadCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetailHeadCell.h"
#import "UIImageView+WebCache.h"
#import "WTTopicDetailViewModel.h"
#import "WTConst.h"
@interface WTTopicDetailHeadCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;
/** 作者 */
@property (weak, nonatomic) IBOutlet UILabel        *authorLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel        *createTimeLabel;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;
/** 节点 */
@property (weak, nonatomic) IBOutlet UILabel        *nodeLabel;

@end
@implementation WTTopicDetailHeadCell

- (void)awakeFromNib
{
    [super awakeFromNib];
  //  self.contentView.backgroundColor = [UIColor colorWithHexString: WTAppLightColor];
    
    self.authorLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    
    self.createTimeLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicCellLabelColor);
    
//    self.authorLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    
    // 圆角
//    self.nodeLabel.layer.cornerRadius = 3;
//    self.nodeLabel.layer.masksToBounds = YES;
    
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    // 取消点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(iconImageViewClick)]];
}

- (void)setTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    _topicDetailVM = topicDetailVM;
    // 头像
    [self.iconImageView sd_setImageWithURL: topicDetailVM.iconURL placeholderImage: WTIconPlaceholderImage];
    
    // 作者
    self.authorLabel.text = topicDetailVM.topicDetail.author;
    
    // 创建时间
    self.createTimeLabel.text = topicDetailVM.createTimeText;
    
    // 标题
    self.titleLabel.text = topicDetailVM.topicDetail.title;
    
    // 节点
    self.nodeLabel.text = topicDetailVM.nodeText;
}

#pragma mark - 事件
- (void)iconImageViewClick
{
    if ([self.delegate respondsToSelector: @selector(topicDetailHeadCell:didClickiconImageViewWithTopicDetailVM:)])
    {
        [self.delegate topicDetailHeadCell: self didClickiconImageViewWithTopicDetailVM: self.topicDetailVM];
    }
}

@end
