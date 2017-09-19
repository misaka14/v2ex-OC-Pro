//
//  WTLocationTool.m
//  v2ex
//
//  Created by gengjie on 2016/10/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTLocationTool.h"

@implementation WTLocationTool

static WTLocationTool *_locationTool;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationTool = [WTLocationTool new];
    });
    return _locationTool;
}

@end
