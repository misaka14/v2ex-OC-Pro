//
//  WTPublishTopic.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 ntent
 # 一级标题
 
 ## 二级标题
 once
 41329
 syntax
 0
 title
 测试数据2
 */
@interface WTPublishTopicItem : NSObject

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *once;

@property (nonatomic, strong) NSString *syntax;

@property (nonatomic, strong) NSString *title;

@end

