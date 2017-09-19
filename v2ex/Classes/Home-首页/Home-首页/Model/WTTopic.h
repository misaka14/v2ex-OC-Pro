//
//  WTTopicNew.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  HTML解析话题模型

#import <Foundation/Foundation.h>

@interface WTTopic : NSObject

/** 头像*/
@property (nonatomic, strong) NSURL             *iconURL;
/** 作者*/
@property (nonatomic, strong) NSString          *author;
/** 标题 */
@property (nonatomic, strong) NSString          *title;
/** 节点名称 */
@property (nonatomic, strong) NSString          *node;
/** 内容 */
@property (nonatomic, strong) NSString          *content;
/** 详情链接 */
@property (nonatomic, strong) NSString          *detailUrl;
/** 被评论数 */
@property (nonatomic, strong) NSString          *commentCount;
/** 帖子最后回复时间 */
@property (nonatomic, strong) NSString          *lastReplyTime;
/** 最后回复人 */
@property (nonatomic, strong) NSString          *lastReplyPeople;

@end
