//
//  WTAdvertiseViewModel.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTAdvertiseItem.h"
@interface WTAdvertiseViewModel : NSObject

/**
 *  从网络中加载广告
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)loadAdvertiseItemsFromNetworkWithSuccess:(void(^)(NSMutableArray<WTAdvertiseItem *> *advertiseItems))success failure:(void(^)(NSError *error))failure;


@end
