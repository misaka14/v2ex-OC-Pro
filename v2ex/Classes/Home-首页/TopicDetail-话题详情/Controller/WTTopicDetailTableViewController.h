//
//  WTTopicDetailTableViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTTopicDetailViewModel.h"
#import "WTLoginViewController.h"
@interface WTTopicDetailTableViewController : UIViewController

/** 话题详情Url */
@property (nonatomic, strong) NSString *topicDetailUrl;

/** 话题数据更新完成的Block */
@property (nonatomic, strong) void(^updateTopicDetailComplection)(WTTopicDetailViewModel *topicDetailVM, NSError *error);
/** tableView滑动的Block */
@property (nonatomic, strong) void(^updateScrollViewOffsetComplecation)(CGFloat offset);

@property (weak, nonatomic) IBOutlet UITableView                       *tableView;

/** 忽略主题的BLock */
@property (nonatomic, strong) void(^ignoreTopicBlock)(void);

+ (instancetype)topicDetailTableViewController;

- (void)setupData;
@end
