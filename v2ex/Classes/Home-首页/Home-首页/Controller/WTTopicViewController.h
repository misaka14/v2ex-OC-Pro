//
//  WTBlogViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTBaseTableViewController.h"

@class WTNode;
@interface WTTopicViewController : WTBaseTableViewController
/** url地址 */
@property (nonatomic, strong) NSString          *urlString;

/** 加载最新的数据 */
- (void)loadNewData;
@end
