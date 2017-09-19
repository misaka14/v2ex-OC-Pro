//
//  WTAdvertiseItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTAdvertiseItem : NSObject

@property (nonatomic, strong) NSURL *icon;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSURL *detailUrl;

+ (instancetype)advertiseItem:(NSURL *)icon title:(NSString *)title content:(NSString *)content detailUrl:(NSURL *)detailUrl;

@end
