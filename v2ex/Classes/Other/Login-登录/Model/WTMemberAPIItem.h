//
//  WTMemberAPIItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "status" : "found",
 "id" : 16147,
 "url" : "http://www.v2ex.com/member/djyde",
 "username" : "djyde",
 "website" : "https://djyde.github.io",
 "twitter" : "",
 "location" : "",
 "tagline" : "",
 "bio" : "喜欢摄影和写作的程序员。",
 "avatar_mini" : "//cdn.v2ex.com/avatar/ed4c/1b66/16147_mini.png?m=1329639748",
 "avatar_normal" : "//cdn.v2ex.com/avatar/ed4c/1b66/16147_normal.png?m=1329639748",
 "avatar_large" : "//cdn.v2ex.com/avatar/ed4c/1b66/16147_large.png?m=1329639748",
 "created" : 1328075793
 }
 */
@interface WTMemberAPIItem : NSObject

@property (nonatomic, strong) NSString *status;

@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *website;

@property (nonatomic, strong) NSString *twitter;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *tagline;

@property (nonatomic, strong) NSString *bio;

@property (nonatomic, strong) NSString *avatar_mini;

@property (nonatomic, strong) NSString *avatar_normal;

@property (nonatomic, strong) NSString *avatar_large;

@property (nonatomic, strong) NSString *created;

@end
