//
//  WTLocationTool.h
//  v2ex
//
//  Created by gengjie on 2016/10/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)();

@interface WTLocationTool : NSObject

+ (instancetype)shareInstance;

- (void)getCurrentLocation:(ResultBlock)resultBlock;

@end
