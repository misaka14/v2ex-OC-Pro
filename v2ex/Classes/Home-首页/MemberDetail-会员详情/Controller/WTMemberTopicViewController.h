//
//  WTMemberTopicViewController.h
//  v2ex
//
//  Created by gengjie on 16/8/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "YZPersonTableViewController.h"

@interface WTMemberTopicViewController : YZPersonTableViewController

@property (nonatomic, strong) NSString *author;

@property (nonatomic, strong) NSURL    *iconURL;


/**
 刷新头像
 */
- (void)reloadAvatar;

@end
