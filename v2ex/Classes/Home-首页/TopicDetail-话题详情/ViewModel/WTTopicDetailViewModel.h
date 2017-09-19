//
//  WTTopicDetailViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTTopicDetail.h"
#import "NetworkTool.h"

typedef NS_ENUM(NSUInteger, WTThankType){
    WTThankTypeNotYet,     //   还未感谢
    WTThankTypeAlready,     //   感谢已发送
    WTThankTypeUnknown     //   未知原因
};



@interface WTTopicDetailViewModel : NSObject
/** 话题详情模型 */
@property (nonatomic, strong) WTTopicDetail    *topicDetail;
/** 头像 */
@property (nonatomic, strong) NSURL            *iconURL;
/** 正文HTML版 */
@property (nonatomic, strong) NSString         *contentHTML;
/** 楼层 */
@property (nonatomic, strong) NSString         *floorText;
/** 节点 */
@property (nonatomic, strong) NSString         *nodeText;
/** 收藏地址 */
@property (nonatomic, strong) NSString         *collectionUrl;
/** 喜欢、收藏 必须要提交的字段与值 */
@property (nonatomic, strong) NSString         *once;
/** 创建时间Text */
@property (nonatomic, strong) NSString         *createTimeText;
/** 喜欢地址 */
@property (nonatomic, strong) NSString         *thankUrl;
/** 喜欢的状态 */
@property (nonatomic, assign) WTThankType      thankType;
/** 当前的页数 */
@property (nonatomic, assign) NSUInteger       currentPage;
/**
 *  根据data解析出话题数组
 *
 *  @param data data
 *
 *  @return 话题数组
 */
+ (NSMutableArray<WTTopicDetailViewModel *> *)topicDetailsWithData:(NSData *)data;

+ (WTTopicDetailViewModel *)topicDetailWithData:(NSData *)data;


/**
 *  帖子操作
 *
 *  @param urlString  请求地址
 *  @param completion 完成block
 */
+ (void)topicOperationWithMethod:(HTTPMethodType)method urlString:(NSString *)urlString topicDetailUrl:(NSString *)topicDetailUrl completion:(void(^)(WTTopicDetailViewModel *topicDetailVM, NSError *error))completion;

@end
