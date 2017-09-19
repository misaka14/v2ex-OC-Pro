//
//  WTReplyCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/2.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTReplyItem;
@interface WTReplyCell : UITableViewCell

@property (nonatomic, strong) WTReplyItem *replyItem;   /** 我的回复模型 */

@end
