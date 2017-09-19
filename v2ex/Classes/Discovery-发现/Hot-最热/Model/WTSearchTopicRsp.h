//
//  WTSearchTopicRsp.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSearchTopic.h"
@interface WTSearchTopicRsp : NSObject

@property (nonatomic, strong) NSMutableArray<WTSearchTopic *> *items;

@end
