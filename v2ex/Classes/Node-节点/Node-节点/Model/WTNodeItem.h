//
//  WTNode.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "id" : 1,
 "name" : "babel",
 "url" : "http://www.v2ex.com/go/babel",
 "title" : "Project Babel",
 "title_alternative" : "Project Babel",
 "topics" : 1102,
 "header" : "Project Babel \u002D 帮助你在云平台上搭建自己的社区",
 "footer" : "V2EX 基于 Project Babel 驱动。Project Babel 是用 Python 语言写成的，运行于 Google App Engine 云计算平台上的社区软件。Project Babel 当前开发分支 2.5。最新版本可以从 \u003Ca href\u003D\u0022http://github.com/livid/v2ex\u0022 target\u003D\u0022_blank\u0022\u003EGitHub\u003C/a\u003E 获取。",
 "created" : 1272206882
 */
@interface WTNodeItem : NSObject

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *title_alternative;

@property (nonatomic, assign) NSUInteger topics;

@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, assign) NSTimeInterval created;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) NSUInteger stars;

@property (nonatomic, strong) NSURL *avatar_large;
@end
