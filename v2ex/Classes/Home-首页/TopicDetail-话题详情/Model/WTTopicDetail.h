//
//  WTTopicDetailNew.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTTopicDetail : NSObject
/** 头像*/
@property (nonatomic, strong) NSString          *icon;
/** 作者*/
@property (nonatomic, strong) NSString          *author;
/** 标题 */
@property (nonatomic, strong) NSString          *title;
/** 节点名称 */
@property (nonatomic, strong) NSString          *node;
/** 创建时间 */
@property (nonatomic, strong) NSString          *createTime;
/** 内容 */
@property (nonatomic, strong) NSString          *content;
/** 楼层 */
@property (nonatomic, strong) NSString          *floor;
/** 博客被查看次数 */
@property (nonatomic, assign) NSUInteger        seeCount;
@end
