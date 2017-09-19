//
//  WTTopicDetailCommentCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  帖子回复

#import <UIKit/UIKit.h>
@class WTTopicDetailViewModel, WTTopicDetailCommentCell;

@protocol WTTopicDetailCommentCellDelegate <NSObject>

// 用户头像点击
- (void)topicDetailCommentCell:(WTTopicDetailCommentCell *)cell iconImageViewClickWithTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM;

@end

@interface WTTopicDetailCommentCell : UITableViewCell

@property (nonatomic, strong) WTTopicDetailViewModel *topicDetailVM;

@property (nonatomic, weak) id<WTTopicDetailCommentCellDelegate> delegate;

@end
