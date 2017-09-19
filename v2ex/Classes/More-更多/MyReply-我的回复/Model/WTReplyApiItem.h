//
//  WTReplyApiItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/5.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTReplyApiItem : NSObject

@property (nonatomic, strong) NSString          *name;

@property (nonatomic, strong) NSString          *title;

@property (nonatomic, strong) NSString          *detailUrl;

@property (nonatomic, strong) NSString          *content;

@property (nonatomic, strong) NSString          *author;

@property (nonatomic, strong) NSURL             *avatarURL;


+ (instancetype)shareInstance;

@end
