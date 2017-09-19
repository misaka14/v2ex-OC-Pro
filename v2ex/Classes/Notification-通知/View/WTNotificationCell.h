//
//  WTNotificationCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTNotificationItem,WTNotificationCell;

@protocol WTNotificationCellDelegate <NSObject>

- (void)notificationCell:(WTNotificationCell *)notificationCell didClickWithNoticationItem:(WTNotificationItem *)noticationItem;

@end

@interface WTNotificationCell : UITableViewCell

@property (nonatomic, weak) id<WTNotificationCellDelegate> delegate;
/** 回复消息模型 */
@property (nonatomic, strong) WTNotificationItem *noticationItem;

@end
