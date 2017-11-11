//
//  WTBlogDetailViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/17.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTopicDetailViewController : UIViewController
/** 帖子URL */
@property (nonatomic, strong) NSString *topicDetailUrl;
/** 帖子标题 */
@property (nonatomic, strong) NSString *topicTitle;
/** 是否展示导航 */
@property (nonatomic, assign, getter=isHideNav) BOOL hideNav;
/** 忽略主题的BLock */
@property (nonatomic, strong) void(^ignoreTopicBlock)(void);

/**
 *  更新页数的Block
 */
@property (nonatomic, strong) void(^updatePageBlock)(NSUInteger index);

+ (instancetype)topicDetailViewController;

@end
