//
//  WTNodeTopicCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTNodeTopicAPIItem, WTNodeTopicCell;


@interface WTNodeTopicCell : UITableViewCell

/** 节点话题 */
@property (nonatomic, strong) WTNodeTopicAPIItem *nodeTopicAPIItem;


@end
