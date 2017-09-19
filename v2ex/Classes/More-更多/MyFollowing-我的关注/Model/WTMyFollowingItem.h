//
//  WTMyFollowingItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/9.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTMyFollowingItem : NSObject

/** 回复时间 */
@property (nonatomic, strong) NSString *lastReplyTime;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 头像URL */
@property (nonatomic, strong) NSURL *avatarURL;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 详情 */
@property (nonatomic, strong) NSString *detailUrl;
/** 节点*/
@property (nonatomic, strong) NSString *node;
/** 回复数*/
@property (nonatomic, strong) NSString *commentCount;

@property (nonatomic, strong) NSString *icon;

@end
