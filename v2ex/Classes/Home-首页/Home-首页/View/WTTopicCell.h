//
//  WTBlogCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTTopic,WTTopicCell;

@protocol WTTopicCellDelegate <NSObject>

/**
 *  用户详情点击
 *
 *  @param topicCell topicCell
 *  @param topic     topic
 */
- (void)topicCell:(WTTopicCell *)topicCell didClickMemberDetailAreaWithTopic:(WTTopic *)topic;

@end

@interface WTTopicCell : UITableViewCell

@property (nonatomic, strong) WTTopic                     *topic;

@property (nonatomic, weak) id<WTTopicCellDelegate>       delegate;

@end
