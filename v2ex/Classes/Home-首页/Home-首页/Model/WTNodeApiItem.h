//
//  WTNodeApiItem.h
//  v2ex
//
//  Created by gengjie on 16/10/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "id" : 12,
 "name" : "qna",
 "title" : "问与答",
 "title_alternative" : "Questions and Answers",
 "url" : "http://www.v2ex.com/go/qna",
 "topics" : 77141,
 "avatar_mini" : "//cdn.v2ex.co/navatar/c20a/d4d7/12_mini.png?m=1476268824",
 "avatar_normal" : "//cdn.v2ex.co/navatar/c20a/d4d7/12_normal.png?m=1476268824",
 "avatar_large" : "//cdn.v2ex.co/navatar/c20a/d4d7/12_large.png?m=1476268824"
 */
@interface WTNodeApiItem : NSObject
@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *title_alternative;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) NSUInteger topics;

@property (nonatomic, strong) NSString *avatar_mini;

@property (nonatomic, strong) NSString *avatar_normal;

@property (nonatomic, strong) NSString *avatar_large;
@end
