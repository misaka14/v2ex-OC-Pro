//
//  WTTopicDetailContentCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  帖子详情

#import <UIKit/UIKit.h>
@class WTTopicDetailViewModel, WTTopicDetailContentCell;

@protocol WTTopicDetailContentCellDelegate <NSObject>

// 点击帖子详情的链接
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithLinkURL:(NSURL *)linkURL;

// 帖子详情的图片点击
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithContentImages:(NSMutableArray *)images currentIndex:(NSUInteger)currentIndex;

// 评论人的头像点击
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithCommentAvatar:(NSString *)userName;

// 整个cell的点击
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedCellWithUsername:(NSString *)userName;
@end

@interface WTTopicDetailContentCell : UITableViewCell

@property (nonatomic, strong) WTTopicDetailViewModel *topicDetailVM;

/** cell的高度 */
@property (nonatomic, assign) CGFloat                cellHeight;

@property (nonatomic, weak) id<WTTopicDetailContentCellDelegate> delegate;
/** webView加载完成的block */
@property (nonatomic, copy) void(^updateCellHeightBlock)(CGFloat height);
@end
