//
//  WTNodeTopicAPIItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
     "id": 294342,
     "title": "[主板漏电] 是因为日常什么不正当使用方式造成呢？",
     "url": "http://www.v2ex.com/t/294342",
     "content": "老早手机就出现电池不耐用的情况，以前我不懂会是因为主板也能造成这一问题，直到上周屏幕也出问题，去了趟直营店天才吧返修告知这两个情况，才了解原来还有这情况，然后就办理了返厂检修了。\r\n\r\n然后就在想，平常充电器也都是使用官方原装座充（充电时倒是偶尔感觉很烫，一般也是估计正常发热范围）。\r\n——那还有什么原因会造成主板漏电呢？\r\n\r\n如果说只是产品品控的问题，这样作为消费者感觉好亏，一年的质保，如果问题没在一年内出现，那么更换主板的代价估计不菲，不像是更换电池就 600 元（官方）。\r\n\r\n看来 applecare 还是很有必要买的咯，毕竟 700 元多一年质保？ 还有什么其他方式",
     "content_rendered": "<p>老早手机就出现电池不耐用的情况，以前我不懂会是因为主板也能造成这一问题，直到上周屏幕也出问题，去了趟直营店天才吧返修告知这两个情况，才了解原来还有这情况，然后就办理了返厂检修了。</p>\n<p>然后就在想，平常充电器也都是使用官方原装座充（充电时倒是偶尔感觉很烫，一般也是估计正常发热范围）。\n——那还有什么原因会造成主板漏电呢？</p>\n<p>如果说只是产品品控的问题，这样作为消费者感觉好亏，一年的质保，如果问题没在一年内出现，那么更换主板的代价估计不菲，不像是更换电池就 600 元（官方）。</p>\n<p>看来 applecare 还是很有必要买的咯，毕竟 700 元多一年质保？ 还有什么其他方式</p>\n",
     "replies": 0,
     "member": {
     "id": 162097,
     "username": "xib2013",
     "tagline": "None",
     "avatar_mini": "//cdn.v2ex.co/gravatar/db64ccf958660b670019da9679de9ad7?s=24&d=retro",
     "avatar_normal": "//cdn.v2ex.co/gravatar/db64ccf958660b670019da9679de9ad7?s=48&d=retro",
     "avatar_large": "//cdn.v2ex.co/gravatar/db64ccf958660b670019da9679de9ad7?s=73&d=retro"
    },
    "node": {
         "id": 8,
         "name": "iphone",
         "title": "iPhone",
         "title_alternative": "iPhone",
         "url": "http://www.v2ex.com/go/iphone",
         "topics": 3617,
         "avatar_mini": "//cdn.v2ex.co/navatar/c9f0/f895/8_mini.png?m=1467364893",
         "avatar_normal": "//cdn.v2ex.co/navatar/c9f0/f895/8_normal.png?m=1467364893",
         "avatar_large": "//cdn.v2ex.co/navatar/c9f0/f895/8_large.png?m=1467364893"
         },
         "created": 1469231646,
         "last_modified": 1469231646,
         "last_touched": 1469231466
 }
 */

#import "WTMemberAPIItem.h"

@interface WTNodeTopicAPIItem : NSObject

@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSUInteger replies;

@property (nonatomic, strong) WTMemberAPIItem *member;

@property (nonatomic, strong) NSString *avatar_mini;

@property (nonatomic, strong) NSString *avatar_normal;

@property (nonatomic, strong) NSString *avatar_large;

@property (nonatomic, assign) NSUInteger stars;

@end
