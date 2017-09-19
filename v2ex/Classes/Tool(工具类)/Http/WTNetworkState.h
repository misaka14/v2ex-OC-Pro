//
//  SXNetworkState.h
//  网易新闻Demo
//
//  Created by 无头骑士 GJ on 15/11/27.
//  Copyright © 2015年 耿杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNetworkState : NSObject

@property (nonatomic, assign)NSInteger status;

+ (instancetype)shareNetworkState;

/**
 *  是否有网络
 *
 *  @return true 有网络 false 无网络
 */
- (BOOL)isNetwork;

@end
