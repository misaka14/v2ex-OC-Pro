//
//  WTAllNodeViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTNodeItem;
@interface WTAllNodeViewController : UIViewController
/** 点击标题的Block */
@property (nonatomic, strong) void(^didClickTitleBlock)(WTNodeItem *nodeItem);

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
