//
//  WTReplyItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/2.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTReplyItem : NSObject

/** 回复时间 */
@property (nonatomic, strong) NSString *replyTime;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 头像URL */
@property (nonatomic, strong) NSURL *avatarURL;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 回复内容 */
@property (nonatomic, strong) NSString *replyContent;
/** 详情 */
@property (nonatomic, strong) NSString *detailUrl;

@end
