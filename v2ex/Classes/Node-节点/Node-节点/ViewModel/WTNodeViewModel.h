//
//  WTNodeViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNodeItem.h"

@interface WTNodeViewModel : NSObject

@property (nonatomic, strong) NSArray<WTNodeItem *> *nodeItems;

@property (nonatomic, strong) NSString *title;

/**
 *  加载节点数据
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getNodeItemsWithSuccess:(void (^)(NSMutableArray<WTNodeViewModel *> *nodeVMs))success failure:(void(^)(NSError *error))failure;

/**
 *  加载所有节点数据
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)loadAllNodeItemsWithSuccess:(void (^)(NSMutableArray<WTNodeViewModel *> *nodeVMs))success failure:(void(^)(NSError *error))failure;

/**
 *  查询出所有节点信息
 *
 *  @return 节点信息数组
 */
+ (NSMutableArray *)queryAllNodeItemsFromCache;

/**
 *  根据节点name查询出节点的信息
 *
 *  @param nodeName 节点name
 *
 *  @return 节点的信息
 */
+ (WTNodeItem *)queryNodeItemsWithNodeName:(NSString *)nodeName;

/**
 *  根据节点ID获取节点详情信息
 *
 *  @param nodeName  nodeName
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)getNodeItemWithNodeId:(NSString *)nodeId success:(void(^)(WTNodeItem *nodeItem))success failure:(void(^)(NSError *error))failure;

/**
 *  获取我的节点收藏
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)getMyNodeCollectionItemsWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
