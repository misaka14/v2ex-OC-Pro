//
//  WTUserItem.h
//  v2ex
//
//  Created by gengjie on 2016/10/19.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 private Integer id;
	private String useranme;
	private String createTime;
	private String lng;
	private String lat;
	private String avatarUrl;
 */
@interface WTUserItem : NSObject

@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *lng;

@property (nonatomic, strong) NSString *lat;

@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic, strong) NSString *rongToken;

@property (nonatomic, assign, getter=isVip) BOOL vip;

@property (nonatomic, strong) NSString *noteName;

@end
