//
//  SXNetworkState.m
//  网易新闻Demo
//
//  Created by 无头骑士 GJ on 15/11/27.
//  Copyright © 2015年 耿杰. All rights reserved.
//

#import "WTNetworkState.h"

@implementation WTNetworkState

+ (instancetype)shareNetworkState
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static WTNetworkState *networkState;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        networkState = [super allocWithZone: zone];
        
    });
    return networkState;
}

/**
 *  是否有网络
 *
 *  @return true 有网络 false 无网络
 */
- (BOOL)isNetwork
{
    return self.status != 0;
}

@end
