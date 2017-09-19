//
//  WTTopicDetailHeadCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  帖子标题

#import <UIKit/UIKit.h>
@class WTTopicDetailViewModel, WTTopicDetailHeadCell;

@protocol WTTopicDetailHeadCellDelegate <NSObject>

- (void)topicDetailHeadCell:(WTTopicDetailHeadCell *)topDetailHeadCell didClickiconImageViewWithTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM;

@end

@interface WTTopicDetailHeadCell : UITableViewCell

@property (nonatomic, strong) WTTopicDetailViewModel *topicDetailVM;

@property (nonatomic, weak) id<WTTopicDetailHeadCellDelegate> delegate;

@end
