//
//  WTNotificationItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/1.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNotificationItem : NSObject
/** 头像*/
@property (nonatomic, strong) NSURL             *iconURL;
/** 作者*/
@property (nonatomic, strong) NSString          *author;
/** 标题 */
@property (nonatomic, strong) NSString          *title;
/** 内容 */
@property (nonatomic, strong) NSString          *content;
/** 详情链接 */
@property (nonatomic, strong) NSString          *detailUrl;
/** 帖子最后回复时间 */
@property (nonatomic, strong) NSString          *lastReplyTime;

@property (nonatomic, assign) NSUInteger        once;

@property (nonatomic, assign) NSUInteger        uid;

@end
