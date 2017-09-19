//
//  WTMemberItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/29.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTMemberItem : NSObject

@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSURL *avatarURL;

@property (nonatomic, strong) NSString *joinTime;

@property (nonatomic, strong) NSString *github;

@property (nonatomic, strong) NSString *website;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) NSString *bio;

@end
